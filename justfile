[private]
default:
    @just --list

lint:
    @command -v rg >/dev/null || { echo "rg not installed"; exit 1; }
    @command -v shellcheck >/dev/null || { echo "shellcheck not installed"; exit 1; }
    @shellcheck $(rg --files -g 'bin/*' -g 'shell/**' -g 'install.sh')

check: lint
