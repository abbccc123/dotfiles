#!/usr/bin/env nvim -l

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.o.mouse = ''
vim.schedule(function() vim.o.clipboard = 'unnamedplus' end)
vim.o.undofile = true
vim.o.inccommand = "split"

vim.opt.number = true
vim.opt.termguicolors = true
vim.opt.wildmenu = true
vim.opt.cindent = true
vim.opt.expandtab = true
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.showcmd = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.cursorline = true
vim.opt.showmatch = true
vim.opt.list = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.confirm = true

vim.opt.wrap = false
vim.opt.cursorcolumn = false
vim.opt.hidden = false

vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.scrolloff = 99
vim.opt.conceallevel = 0
vim.opt.laststatus = 2

vim.opt.guifont = 'Source Code Pro Medium 13'
vim.opt.background = 'dark'

vim.opt.completeopt:append({ 'menuone' })
vim.opt.path:append({ '/usr/include/**' })

vim.opt.shortmess:remove({ 'S' })
vim.opt.listchars = "tab:>-,trail:-,nbsp:+"

vim.keymap.set('', '<F3>', '<C-C>:update<CR>')
vim.keymap.set('n', 'j', 'gj')
vim.keymap.set('n', 'k', 'gk')
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

vim.keymap.set('n', '<F7>', '<cmd>nohlsearch<CR>')
vim.keymap.set('n', '<C-G>', '2<C-G>')
vim.keymap.set('n', '<tab>', '<C-W>')
vim.keymap.set('n', '<space>l', '<cmd>vertical terminal<CR><C-W>L<cmd>startinsert<CR>')
vim.keymap.set('n', '<space>h', '<cmd>vertical terminal<CR><C-W>H<cmd>startinsert<CR>')
vim.keymap.set('n', '<space>k', '<cmd>vertical terminal<CR><C-W>K<cmd>startinsert<CR>')
vim.keymap.set('n', '<space>j', '<cmd>vertical terminal<CR><C-W>J<cmd>startinsert<CR>')
vim.keymap.set('n', '<space><space>', '<cmd>horizontal terminal<CR><cmd>startinsert<CR>')
vim.keymap.set('n', '<Esc>u', '<C-u>')
vim.keymap.set('n', '<Esc>d', '<C-d>')
vim.keymap.set('n', 'K', 'k')
vim.keymap.set('n', '<C-p>', '<C-i>')
vim.keymap.set('n', '<Esc>c', '<cmd>tabnew<CR>')
vim.keymap.set('n', '<Esc>h', '<cmd>tabprev<CR>')
vim.keymap.set('n', '<Esc>l', '<cmd>tabnext<CR>')
vim.keymap.set('n', '<F2>', '<cmd>ls<CR>')

-- vim.keymap.set('i', '<C-c>', '<C-c>:update<CR>')
vim.keymap.set('i', '<Esc>', '<C-c>:update<CR>')

vim.keymap.set('t', '<tab><tab>', '<C-\\><C-n>', { desc = "Exit terminal mode" })
vim.keymap.set('t', '<tab>h', '<tab><tab><C-w>h', { remap = true })
vim.keymap.set('t', '<tab>j', '<tab><tab><C-w>j', { remap = true })
vim.keymap.set('t', '<tab>k', '<tab><tab><C-w>k', { remap = true })
vim.keymap.set('t', '<tab>l', '<tab><tab><C-w>l', { remap = true })
vim.keymap.set('t', '<tab>q', '<C-d>')
vim.keymap.set('t', '<tab>t', '<cmd>horizontal terminal<CR>')

vim.api.nvim_create_autocmd("BufEnter", {
    -- group = vim.api.nvim_create_augroup("term_win_eve", { clear = true }),
    callback = function(arg)
        if string.match(arg.file, '^term://') then -- A terminal
            vim.cmd("startinsert")
        end
    end,
})

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function() vim.hl.on_yank() end,
})

-- Setup plugins

--- Load a module and run its setup() method without arguments(plain init), if any.
---@param mod_name: string
---@param config?: table
function load_and_setup_if_exists(mod_name, config)
    local status, mod = pcall(require, mod_name)
    if status and mod.setup then mod.setup(config or {}) end
end

function load_gitsigns_and_setup()
    local status, mod = pcall(require, "gitsigns")
    if status then
        mod.setup({
            signs = {
                add={text="+"},change={text="~"},delete={text='_'},topdelete={text='‾'},changedelete={text='~'},
            }
        })
    end
end

load_and_setup_if_exists "lualine"
load_and_setup_if_exists("nvim-tree", {
    on_attach = function(bufnr)
        local api = require "nvim-tree.api"
        api.map.on_attach.default(bufnr)
        vim.keymap.del("n", "<tab>", { buffer = bufnr })
    end,
    filters = {
        dotfiles = true
    },
    sync_root_with_cwd = true,
})
vim.keymap.set("n", "<leader>t", "<cmd>NvimTreeToggle<CR>")
load_and_setup_if_exists "mini.starter"
load_and_setup_if_exists "mini.icons"
load_gitsigns_and_setup()

vim.cmd.colorscheme "kanagawa-wave"

-- mapping Telescope, if installed
status, builtin = pcall(require, "telescope.builtin")
if status then
    vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
    vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
    vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
    vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
    vim.keymap.set({'n','v'}, '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
    vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
    vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
    vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
    vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
    vim.keymap.set('n', '<leader>sc', builtin.commands, { desc = '[S]earch [C]ommands' })
    vim.keymap.set('n', '<leader>sb', builtin.buffers, { desc = '[ ] Find existing buffers' })
    vim.keymap.set('n', '<leader>/', function()
        -- You can pass additional configuration to Telescope to change the theme, layout, etc.
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
            winblend = 20,
            previewer = false,
        })
    end, { desc = '[/] Fuzzily search in current buffer' })
end

vim.api.nvim_create_autocmd("FileType", {
    pattern = { "python" },
    callback = function(args)
        local lang = vim.bo[args.buf].filetype
        -- 检查解析器是否存在
        local success, _ = pcall(vim.treesitter.get_parser, args.buf, lang)
        if success then
            vim.treesitter.start(args.buf, lang)
        end
    end,
})
