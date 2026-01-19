#!/bin/bash

# Dotfiles installer
# Compatible with Bash 3.x
# Installs dotfiles by creating appropriate symlinks and shell integration

set -euo pipefail
[[ ${TRACE-0} == "1" ]] && set -x

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DOTFILES_DIR="$SCRIPT_DIR"

# Lock file for concurrent execution protection
LOCK_FILE="$HOME/.dotfiles-install.lock"

# Backup directory name with current date and time
BACKUP_DIR="$HOME/.dotfiles-backup-$(date +%Y%m%d-%H%M%S)"

# Global flags
DRY_RUN=false

# Summary counters
LINKED_COUNT=0
SKIPPED_COUNT=0
BACKED_UP_COUNT=0
MISSING_SOURCE_COUNT=0
declare -a MANUAL_STEPS=()
declare -a MISSING_SOURCES=()

# File mapping configuration
# Format: "source_path:target_path:type"
# Types: config (goes to ~/.config/), home (goes to ~/), shell (special handling)
declare -a FILE_MAPPINGS=(
    "bat/config:bat/config:config"
    "git/config:git/config:config"
    "git/ignore:git/ignore:config"
    "lsd/colors.yml:lsd/colors.yml:config"
    "lsd/config.yml:lsd/config.yml:config"
    "dotfiles/ssh/config:dotfiles/ssh/config:config"
    "vim/vimrc:.vimrc:home"
    "screen/screenrc:.screenrc:home"
    "conda/condarc:.condarc:home"
    "tmux/tmux.conf:.tmux.conf:home"
    "inputrc/inputrc:.inputrc:home"
)

# Shell integration files
declare -a SHELL_MAPPINGS=(
    ".bashrc:shell/bash/bashrc:Bash configuration"
    ".zshrc:shell/zsh/zshrc:Zsh configuration"
    ".bash_profile:shell/bash/bash_profile:Bash profile"
)

######################################################################
# Print status message with blue color formatting.
# Globals:
#   BLUE, NC
# Arguments:
#   $1 - Message to print
# Returns:
#   None
######################################################################
print_status() {
    echo -e "${BLUE}INFO${NC}     $1"
}

######################################################################
# Print success message with green color formatting.
# Globals:
#   GREEN, NC
# Arguments:
#   $1 - Message to print
# Returns:
#   None
######################################################################
print_success() {
    echo -e "${GREEN}SUCCESS${NC}  $1"
}

######################################################################
# Print warning message with yellow color formatting.
# Globals:
#   YELLOW, NC
# Arguments:
#   $1 - Message to print
# Returns:
#   None
######################################################################
print_warning() {
    echo -e "${YELLOW}WARNING${NC}  $1"
}

######################################################################
# Print error message with red color formatting.
# Globals:
#   RED, NC
# Arguments:
#   $1 - Message to print
# Returns:
#   None
######################################################################
print_error() {
    echo -e "${RED}ERROR${NC}    $1"
}

######################################################################
# Summary helpers.
# Globals:
#   LINKED_COUNT, SKIPPED_COUNT, BACKED_UP_COUNT, MISSING_SOURCE_COUNT
#   MANUAL_STEPS, MISSING_SOURCES
######################################################################
record_linked() {
    LINKED_COUNT=$((LINKED_COUNT + 1))
}

record_skipped() {
    SKIPPED_COUNT=$((SKIPPED_COUNT + 1))
}

record_backup() {
    BACKED_UP_COUNT=$((BACKED_UP_COUNT + 1))
}

record_missing_source() {
    local source_path="$1"
    MISSING_SOURCE_COUNT=$((MISSING_SOURCE_COUNT + 1))
    MISSING_SOURCES+=("$source_path")
}

record_manual_step() {
    MANUAL_STEPS+=("$1")
}

######################################################################
# Display usage information and help text.
# Globals:
#   None
# Arguments:
#   None
# Returns:
#   None
######################################################################
show_usage() {
    cat << EOF
Dotfiles Installation Script

USAGE:
    $0 [OPTIONS]

OPTIONS:
    --help, -h      Show this help message
    --dry-run, -n   Show what would be done without making changes

DESCRIPTION:
    Installs dotfiles by creating symlinks for configuration files and 
    setting up shell integration. Backs up existing files when conflicts
    are detected.

EXAMPLES:
    $0              # Install dotfiles
    $0 --dry-run    # Preview what would be installed
    $0 --help       # Show this help

EOF
}

######################################################################
# Parse command line arguments and set global flags.
# Globals:
#   DRY_RUN - Set to true if --dry-run flag is provided
# Arguments:
#   $@ - All command line arguments
# Returns:
#   0 on success
#   Exits with code 0 for --help and --version
#   Exits with code 1 for unknown options
######################################################################
parse_arguments() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            --help|-h)
                show_usage
                exit 0
                ;;
            --dry-run|-n)
                DRY_RUN=true
                print_status "DRY RUN MODE: No changes will be made"
                shift
                ;;
            *)
                print_error "Unknown option: $1"
                echo "Use --help for usage information"
                exit 1
                ;;
        esac
    done
}

######################################################################
# Create lock file to prevent concurrent script execution.
# Checks for existing lock file and validates if process is still running.
# Removes stale lock files from dead processes.
# Globals:
#   LOCK_FILE - Path to lock file
# Arguments:
#   None
# Returns:
#   0 on success
#   Exits with code 1 if another instance is running or lock creation fails
######################################################################
create_lock() {
    if [ -f "$LOCK_FILE" ]; then
        local lock_pid
        lock_pid=$(cat "$LOCK_FILE" 2>/dev/null)
        if [ -n "$lock_pid" ] && kill -0 "$lock_pid" 2>/dev/null; then
            print_error "Another instance is already running (PID: $lock_pid)"
            exit 1
        else
            print_warning "Stale lock file found, removing it"
            rm -f "$LOCK_FILE"
        fi
    fi
    
    if ! echo $$ > "$LOCK_FILE"; then
        print_error "Failed to create lock file: $LOCK_FILE"
        exit 1
    fi
}

######################################################################
# Remove lock file for cleanup on script exit.
# Globals:
#   LOCK_FILE - Path to lock file
# Arguments:
#   None
# Returns:
#   None
######################################################################
remove_lock() {
    if [ -f "$LOCK_FILE" ]; then
        rm -f "$LOCK_FILE"
    fi
}

######################################################################
# Ask user for yes/no confirmation.
# In dry-run mode, simulates user confirmation without prompting.
# Globals:
#   DRY_RUN - If true, simulates confirmation
# Arguments:
#   $1 - Prompt message to display
# Returns:
#   0 for yes, 1 for no
######################################################################
ask_confirmation() {
    local prompt="$1"
    
    # In dry run mode, assume yes but don't actually confirm
    if [ "$DRY_RUN" = true ]; then
        print_status "[DRY RUN] Would prompt: $prompt (y/n)"
        return 0
    fi
    
    local response
    while true; do
        echo -n "$prompt (y/n): "
        read -r response
        case "$response" in
            [Yy]* ) return 0 ;;
            [Nn]* ) return 1 ;;
            * ) echo "Please answer y or n." ;;
        esac
    done
}

######################################################################
# Ask user how to handle a conflicting file.
# In dry-run mode, simulates a skip without prompting.
# Globals:
#   DRY_RUN - If true, simulates a skip
# Arguments:
#   $1 - Prompt message to display
# Outputs:
#   Writes one of: skip, backup, overwrite
######################################################################
ask_conflict_action() {
    local prompt="$1"

    if [ "$DRY_RUN" = true ]; then
        print_status "[DRY RUN] Would prompt: $prompt (s/b/o)"
        echo "skip"
        return 0
    fi

    local response
    while true; do
        echo -n "$prompt (s=skip, b=backup, o=overwrite): "
        read -r response
        case "$response" in
            [Ss]*) echo "skip"; return 0 ;;
            [Bb]*) echo "backup"; return 0 ;;
            [Oo]*) echo "overwrite"; return 0 ;;
            * ) echo "Please answer s, b, or o." ;;
        esac
    done
}

######################################################################
# Safely execute commands with error handling and dry-run support.
# In dry-run mode, shows what would be executed without running it.
# Globals:
#   DRY_RUN - If true, simulates command execution
# Arguments:
#   $1 - Command to execute
#   $2 - Description of what the command does (for error messages)
# Returns:
#   0 on success, 1 on failure
######################################################################
safe_execute() {
    local cmd="$1"
    local description="$2"
    
    if [ "$DRY_RUN" = true ]; then
        print_status "[DRY RUN] Would execute: $cmd"
        return 0
    fi
    
    if ! eval "$cmd"; then
        print_error "Failed to $description"
        print_error "Command: $cmd"
        return 1
    fi
    return 0
}

######################################################################
# Create backup directory if it doesn't exist.
# In dry-run mode, shows what would be created without creating it.
# Globals:
#   BACKUP_DIR - Path to backup directory
#   DRY_RUN - If true, simulates directory creation
# Arguments:
#   None
# Returns:
#   0 on success, 1 on failure
######################################################################
create_backup_dir() {
    if [ ! -d "$BACKUP_DIR" ]; then
        if [ "$DRY_RUN" = true ]; then
            print_status "[DRY RUN] Would create backup directory: $BACKUP_DIR"
        else
            print_status "Creating backup directory: $BACKUP_DIR"
            if ! mkdir -p "$BACKUP_DIR"; then
                print_error "Failed to create backup directory: $BACKUP_DIR"
                return 1
            fi
        fi
    fi
}

######################################################################
# Backup a file to the backup directory, preserving relative path structure.
# Creates necessary subdirectories in backup location.
# In dry-run mode, shows what would be backed up without moving files.
# Globals:
#   BACKUP_DIR - Base backup directory path
#   HOME - User's home directory
#   DRY_RUN - If true, simulates backup operation
# Arguments:
#   $1 - Full path to file to backup
# Returns:
#   0 on success, 1 on failure
######################################################################
backup_file() {
    local source_file="$1"
    local relative_path="${source_file#"$HOME"/}"
    local backup_path="$BACKUP_DIR/$relative_path"
    local backup_dir
    backup_dir="$(dirname "$backup_path")"
    
    if ! create_backup_dir; then
        return 1
    fi
    
    if [ "$DRY_RUN" = true ]; then
        print_status "[DRY RUN] Would backup $source_file to $backup_path"
        record_backup
        return 0
    fi
    
    if [ ! -d "$backup_dir" ]; then
        if ! mkdir -p "$backup_dir"; then
            print_error "Failed to create backup subdirectory: $backup_dir"
            return 1
        fi
    fi
    
    print_status "Backing up $source_file to $backup_path"
    if ! mv "$source_file" "$backup_path"; then
        print_error "Failed to backup file: $source_file"
        return 1
    fi
    record_backup
}

######################################################################
# Check if a symlink already points to the correct target.
# Verifies both that the path is a symlink and points to expected target.
# Globals:
#   None
# Arguments:
#   $1 - Path to check (potential symlink)
#   $2 - Expected target path
# Returns:
#   0 if symlink exists and points to target, 1 otherwise
######################################################################
is_correct_symlink() {
    local link_path="$1"
    local target_path="$2"
    
    [ -L "$link_path" ] && [ "$(readlink "$link_path")" = "$target_path" ]
}

######################################################################
# Safely create a symlink with comprehensive error handling.
# Creates parent directories if needed, handles existing files/symlinks,
# and respects dry-run mode.
# Globals:
#   DRY_RUN - If true, simulates symlink creation
# Arguments:
#   $1 - Source file path (what symlink points to)
#   $2 - Target symlink path (where to create symlink)
# Returns:
#   0 on success, 1 on failure
######################################################################
create_symlink() {
    local source="$1"
    local target="$2"
    local target_dir
    target_dir="$(dirname "$target")"
    
    # Create target directory if it doesn't exist
    if [ ! -d "$target_dir" ]; then
        if [ "$DRY_RUN" = true ]; then
            print_status "[DRY RUN] Would create directory: $target_dir"
        else
            print_status "Creating directory: $target_dir"
            if ! mkdir -p "$target_dir"; then
                print_error "Failed to create directory: $target_dir"
                return 1
            fi
        fi
    fi
    
    # Check if target already exists and is correct
    if is_correct_symlink "$target" "$source"; then
        print_status "Symlink already exists and is correct: $target"
        record_skipped
        return 0
    fi
    
    # Handle existing file/symlink (including broken symlinks)
    if [ -e "$target" ] || [ -L "$target" ]; then
        local action
        action=$(ask_conflict_action "Conflict: $target exists")
        case "$action" in
            skip)
                print_status "Skipping: $target"
                record_skipped
                return 0
                ;;
            backup)
                if ! backup_file "$target"; then
                    return 1
                fi
                ;;
            overwrite)
                if [ -d "$target" ] && [ ! -L "$target" ]; then
                    print_warning "Skipping overwrite for directory: $target"
                    record_manual_step "Remove directory $target to replace it with a symlink"
                    record_skipped
                    return 0
                fi
                if [ "$DRY_RUN" = true ]; then
                    print_status "[DRY RUN] Would remove: $target"
                else
                    if ! rm -f "$target"; then
                        print_error "Failed to remove existing file: $target"
                        return 1
                    fi
                fi
                ;;
        esac
    fi
    
    # Create the symlink
    if [ "$DRY_RUN" = true ]; then
        print_status "[DRY RUN] Would create symlink: $target -> $source"
        record_linked
    else
        print_status "Creating symlink: $target -> $source"
        if ! ln -s "$source" "$target"; then
            print_error "Failed to create symlink: $target -> $source"
            return 1
        fi
        print_success "Created symlink: $target"
        record_linked
    fi
}

######################################################################
# Resolve the full target path based on file type.
# Maps file types to their appropriate installation directories.
# Globals:
#   HOME - User's home directory
# Arguments:
#   $1 - Source path (unused, kept for compatibility)
#   $2 - Target path relative to type directory
#   $3 - File type ("config" or "home")
# Returns:
#   0 on success, 1 for unknown type
# Outputs:
#   Full resolved path to stdout
######################################################################
resolve_target_path() {
    local source_path="$1"
    local target_path="$2"
    local type="$3"
    
    case "$type" in
        "config")
            echo "$HOME/.config/$target_path"
            ;;
        "home")
            echo "$HOME/$target_path"
            ;;
        *)
            print_error "Unknown file type: $type"
            return 1
            ;;
    esac
}

######################################################################
# Install configuration files by creating symlinks.
# Processes all files defined in FILE_MAPPINGS array with progress tracking.
# Creates symlinks from dotfiles to appropriate system locations.
# Globals:
#   FILE_MAPPINGS - Array of config file mappings
#   DOTFILES_DIR - Source directory for dotfiles
# Arguments:
#   None
# Returns:
#   None (errors are logged but don't stop processing)
######################################################################
install_config_files() {
    print_status "Installing configuration files..."
    
    local total=${#FILE_MAPPINGS[@]}
    local count=0
    
    # Process all file mappings
    for mapping in "${FILE_MAPPINGS[@]}"; do
        count=$((count + 1))
        local source_path="${mapping%%:*}"
        local rest="${mapping#*:}"
        local target_path="${rest%%:*}"
        local type="${rest##*:}"
        
        local source_file="$DOTFILES_DIR/config/$source_path"
        local target_file
        target_file=$(resolve_target_path "$source_path" "$target_path" "$type")
        
        print_status "Processing ($count/$total): $source_path"
        
        if [ -f "$source_file" ]; then
            if ! create_symlink "$source_file" "$target_file"; then
                print_error "Failed to create symlink for $source_path"
            fi
        else
            print_warning "Source file not found: $source_file"
            record_missing_source "$source_file"
        fi
    done
    
    print_success "Configuration files installation complete"
}

######################################################################
# Safely create shell integration file with source line.
# Checks for existing correct configuration, handles conflicts,
# and creates new file with proper source line for dotfiles integration.
# Globals:
#   DRY_RUN - If true, simulates file creation
# Arguments:
#   $1 - Target file path (e.g., ~/.bashrc)
#   $2 - Source line to write (e.g., source "/path/to/bashrc")
#   $3 - Description for logging (e.g., "Bash configuration")
# Returns:
#   0 on success, 1 on failure
######################################################################
create_shell_file() {
    local target_file="$1"
    local source_line="$2"
    local description="$3"
    
    # Check if file exists and already has the correct content
    if [ -f "$target_file" ]; then
        if grep -Fxq "$source_line" "$target_file"; then
            print_status "$description already configured in $target_file"
            record_skipped
            return 0
        fi
    fi

    if [ -e "$target_file" ] || [ -L "$target_file" ]; then
        local action
        action=$(ask_conflict_action "Conflict: $target_file exists for $description")
        case "$action" in
            skip)
                print_status "Skipping $target_file - you may need to manually add: $source_line"
                record_manual_step "Add to $target_file: $source_line"
                record_skipped
                return 0
                ;;
            backup)
                if ! backup_file "$target_file"; then
                    return 1
                fi
                ;;
            overwrite)
                if [ -d "$target_file" ] && [ ! -L "$target_file" ]; then
                    print_warning "Skipping overwrite for directory: $target_file"
                    record_manual_step "Remove directory $target_file to replace it with a shell config"
                    record_skipped
                    return 0
                fi
                if [ "$DRY_RUN" = true ]; then
                    print_status "[DRY RUN] Would remove: $target_file"
                else
                    if ! rm -f "$target_file"; then
                        print_error "Failed to remove existing file: $target_file"
                        return 1
                    fi
                fi
                ;;
        esac
    fi
    
    if [ "$DRY_RUN" = true ]; then
        print_status "[DRY RUN] Would create $target_file with content: $source_line"
    else
        print_status "Creating $target_file"
        if ! echo "$source_line" > "$target_file"; then
            print_error "Failed to create $target_file"
            return 1
        fi
        print_success "Created $target_file"
    fi
    record_linked
}

######################################################################
# Install shell integration by creating source files.
# Processes all shell files defined in SHELL_MAPPINGS array with progress tracking.
# Creates shell configuration files that source the dotfiles equivalents.
# Globals:
#   SHELL_MAPPINGS - Array of shell integration mappings
#   HOME - User's home directory
#   DOTFILES_DIR - Source directory for dotfiles
# Arguments:
#   None
# Returns:
#   None (errors are logged but don't stop processing)
######################################################################
install_shell_integration() {
    print_status "Installing shell integration..."
    
    local total=${#SHELL_MAPPINGS[@]}
    local count=0
    
    # Process all shell mappings
    for mapping in "${SHELL_MAPPINGS[@]}"; do
        count=$((count + 1))
        local target_file_name="${mapping%%:*}"
        local rest="${mapping#*:}"
        local source_path="${rest%%:*}"
        local description="${rest##*:}"
        
        local target_file="$HOME/$target_file_name"
        local source_line="source \"$DOTFILES_DIR/$source_path\""
        
        print_status "Processing ($count/$total): $target_file_name"
        
        if ! create_shell_file "$target_file" "$source_line" "$description"; then
            print_error "Failed to setup $description"
        fi
    done
    
    print_success "Shell integration installation complete"
}

######################################################################
# Main installation function that orchestrates the entire process.
# Handles argument parsing, validation, and installation.
# Sets up proper cleanup and provides user feedback throughout the process.
# Globals:
#   DRY_RUN - If true, simulates installation without making changes
#   DOTFILES_DIR - Source directory for dotfiles
#   BACKUP_DIR - Directory where backups are stored
# Arguments:
#   $@ - All command line arguments
# Returns:
#   0 on success
#   Exits with code 1 on various error conditions
######################################################################
main() {
    # Parse command line arguments
    parse_arguments "$@"
    
    print_status "Dotfiles Installation Script"
    print_status "=============================="
    
    # Create lock file to prevent concurrent execution
    if [ "$DRY_RUN" != true ]; then
        create_lock
        trap remove_lock EXIT INT TERM
    fi
    
    # Check if we're in the right directory
    if [ ! -d "$DOTFILES_DIR/config" ] || [ ! -d "$DOTFILES_DIR/shell" ]; then
        print_error "This script must be run from the dotfiles directory"
        print_error "Expected to find 'config' and 'shell' directories"
        exit 1
    fi
    
    # Install configuration files
    install_config_files
    
    echo ""
    
    # Install shell integration
    install_shell_integration
    
    echo ""
    print_success "Dotfiles installation complete!"

    print_status "Summary:"
    echo "  Linked: $LINKED_COUNT"
    echo "  Skipped: $SKIPPED_COUNT"
    echo "  Backed up: $BACKED_UP_COUNT"
    echo "  Missing sources: $MISSING_SOURCE_COUNT"

    if [ ${#MISSING_SOURCES[@]} -gt 0 ]; then
        print_warning "Missing source files:"
        for source_file in "${MISSING_SOURCES[@]}"; do
            echo "  - $source_file"
        done
        unset source_file
    fi

    if [ ${#MANUAL_STEPS[@]} -gt 0 ]; then
        print_warning "Manual steps required:"
        for step in "${MANUAL_STEPS[@]}"; do
            echo "  - $step"
        done
        unset step
    fi
    
    # Show backup information if backup directory was created
    if [ -d "$BACKUP_DIR" ]; then
        print_status "Backup files saved to: $BACKUP_DIR"
    fi
    
    if [ "$DRY_RUN" != true ]; then
        print_status "You may need to restart your shell or source your shell configuration files"
        print_status "For bash: source ~/.bashrc"
        print_status "For zsh: source ~/.zshrc"
    else
        print_status "[DRY RUN] No actual changes were made"
    fi
}

# Run main function
main "$@"
