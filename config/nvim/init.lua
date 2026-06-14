vim.g.mapleader = " "
vim.g.maplocalleader = " "

local opt = vim.opt
opt.number = true
opt.relativenumber = true
opt.mouse = "a"
opt.ignorecase = true
opt.smartcase = true
opt.splitright = true
opt.splitbelow = true
opt.undofile = true
opt.signcolumn = "yes"
opt.cursorline = true
opt.scrolloff = 8
opt.sidescrolloff = 5
opt.wrap = false
opt.expandtab = true
opt.shiftwidth = 4
opt.tabstop = 4
opt.softtabstop = 4
opt.completeopt = { "menuone", "noselect" }
opt.list = true
opt.listchars = { tab = "> ", trail = ".", nbsp = "_" }
opt.termguicolors = true
opt.clipboard = "unnamedplus"

local map = vim.keymap.set
map("n", "<Esc>", "<cmd>nohlsearch<CR>")
map("n", "<leader>pv", vim.cmd.Ex, { desc = "Open file browser" })
map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("v", "J", ":m '>+1<CR>gv=gv")
map("v", "K", ":m '<-2<CR>gv=gv")
map({ "n", "v" }, "<leader>y", '"+y')
map({ "n", "v" }, "<leader>p", '"+p')
map({ "n", "v" }, "<leader>d", '"_d')
map("n", "<leader>bn", vim.cmd.bnext, { desc = "Next buffer" })
map("n", "<leader>bp", vim.cmd.bprevious, { desc = "Previous buffer" })
map("n", "<leader>bc", vim.cmd.bdelete, { desc = "Close buffer" })
map("t", "<Esc><Esc>", "<C-\\><C-n>")

vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight copied text",
    callback = function()
        vim.highlight.on_yank()
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = { "json", "jsonc", "jsonl", "sh", "bash", "zsh", "yaml" },
    callback = function()
        vim.opt_local.expandtab = true
        vim.opt_local.shiftwidth = 2
        vim.opt_local.tabstop = 2
        vim.opt_local.softtabstop = 2
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "make",
    callback = function()
        vim.opt_local.expandtab = false
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = { "gitcommit", "markdown", "text" },
    callback = function()
        vim.opt_local.spell = true
        vim.opt_local.textwidth = vim.bo.filetype == "gitcommit" and 72 or 70
    end,
})
