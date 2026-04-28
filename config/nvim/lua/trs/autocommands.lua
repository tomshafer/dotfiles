-- Autocommands

-- From kickstart.nvim
-- See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
-- See `:help vim.hl.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight when yanking (copying) text",
    group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
    callback = function()
        vim.hl.on_yank()
    end,
})

-- Warn when not following git commit best practices
vim.api.nvim_create_autocmd("FileType", {
    pattern = "gitcommit",
    callback = function()
        -- Editing behavior
        vim.opt_local.textwidth = 72 -- wrap body at 72
        vim.opt_local.formatoptions:append "t" -- reflow text while typing
        vim.opt_local.spell = true -- optional; handy for commit messages

        -- Clear any old matches (avoids duplicates if you reopen)
        pcall(vim.fn.clearmatches)

        -- Define highlight (link to Error by default)
        vim.api.nvim_set_hl(0, "GitCommitOverflow", { link = "Error", default = true })

        -- Subject line (line 1) overflow past column 50
        vim.fn.matchadd("GitCommitOverflow", [[\%1l\%>50v.\+]], 10)

        -- Body (lines after the blank line) overflow past column 72
        vim.fn.matchadd("GitCommitOverflow", [[\%>1l\%>72v.\+]], 10)
    end,
})

-- FileType settings
local wrapping = vim.api.nvim_create_augroup("HardWrapByFiletype", { clear = true })
local widths = {
    markdown = 70,
    text = 70,
    python = 88,
    r = 88,
}

local spelling = vim.api.nvim_create_augroup("SpellByFiletype", { clear = true })
local spell_filetypes = { "markdown" }

local makefiles = vim.api.nvim_create_augroup("MakefileTabs", { clear = true })
local tabbed_filetypes = { "make" }

local indenting = vim.api.nvim_create_augroup("IndentByFiletype", { clear = true })
local indents = {
    json = { expandtab = true, shiftwidth = 2, tabstop = 2, softtabstop = 2 },
    jsonc = { expandtab = true, shiftwidth = 2, tabstop = 2, softtabstop = 2 },
    jsonl = { expandtab = true, shiftwidth = 2, tabstop = 2, softtabstop = 2 },
    sh = { expandtab = true, shiftwidth = 2, tabstop = 2, softtabstop = 2 },
    bash = { expandtab = true, shiftwidth = 2, tabstop = 2, softtabstop = 2 },
    zsh = { expandtab = true, shiftwidth = 2, tabstop = 2, softtabstop = 2 },
    ksh = { expandtab = true, shiftwidth = 2, tabstop = 2, softtabstop = 2 },
}

vim.api.nvim_create_autocmd("FileType", {
    group = wrapping,
    pattern = vim.tbl_keys(widths),
    callback = function(args)
        local tw = widths[vim.bo[args.buf].filetype]
        if tw then
            vim.opt_local.textwidth = tw
            vim.opt_local.formatoptions:append "t"
        end
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    group = spelling,
    pattern = spell_filetypes,
    callback = function()
        vim.opt_local.spell = true
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    group = makefiles,
    pattern = tabbed_filetypes,
    callback = function()
        vim.opt_local.expandtab = false
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    group = indenting,
    pattern = vim.tbl_keys(indents),
    callback = function(args)
        local indent = indents[vim.bo[args.buf].filetype]
        if indent then
            vim.opt_local.expandtab = indent.expandtab
            vim.opt_local.shiftwidth = indent.shiftwidth
            vim.opt_local.tabstop = indent.tabstop
            if indent.softtabstop ~= nil then
                vim.opt_local.softtabstop = indent.softtabstop
            end
        end
    end,
})

-- Give back the thin cursor when Neovim exits
vim.api.nvim_create_autocmd("VimLeave", {
    callback = function()
        vim.opt.guicursor = "a:ver25"
    end,
})
