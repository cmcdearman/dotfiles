require('keymaps')
require('plugins')
require('impatient') --Uses impatient plugin to load faster
-- ========================================================================== --
-- ==                           EDITOR SETTINGS                            == --
-- ========================================================================== --
vim.g.mapleader = " "
vim.o.clipboard = "unnamedplus"
vim.opt.number = true
vim.opt.mouse = 'a'
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = false
vim.opt.wrap = true
vim.opt.breakindent = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.undodir = vim.fn.expand('~/.vim/undodir')
vim.opt.undofile = true
vim.wo.relativenumber = true

vim.g.copilot_no_tab_map = true
vim.api.nvim_set_keymap("i", "<C-J>", 'copilot#Accept("<CR>")', { silent = true, expr = true })
---
-- Old VIM Script Commands
--
vim.cmd([[
set spell
]])

---
-- Suppress errors in Windows
-- 

vim.notify = function (msg, log_level, _opts)
    if msg:match("exit code") then return end
    if log_level == vim.log.levels.ERROR then
        vim.api.nvim_err_writeln(msg)
    else
    vim.api.nvim_echo({{msg}}, true, {})
    end
  end

-- ========================================================================== --
-- ==                         PLUGIN CONFIGURATION                         == --
-- ========================================================================== --

---
-- Colorscheme
---
vim.opt.termguicolors = true
vim.cmd('colorscheme monokai-pro')

---
-- Titus Custom Markdown HUGO Image Insert
---
require'clipboard-image'.setup {
  markdown = {
   img_dir = {"content/images", "%:p:h:t", "%:t:r"},
   img_dir_txt = {"/images", "%:p:h:t", "%:t:r"},
   img_name = function ()
      vim.fn.inputsave()
      local name = vim.fn.input('Name: ')
      vim.fn.inputrestore()

      if name == nil or name == '' then
        return os.date('%y-%m-%d-%H-%M-%S')
      end
      return name
    end,
    img_handler = function ()
        return function (path)
            return os.execute(string.format('~/.scripts/tinypng -s -f %s &', path))
        end
    end
  }
}

-- LSP and Linting Config
require("mason").setup()
require("mason-lspconfig").setup({
	ensure_installed = {
    'luau_lsp',
  },
	automatic_installation = true,
})

-- Learn the keybindings, see :help lsp-zero-keybindings
-- Learn to configure LSP servers, see :help lsp-zero-api-showcase
local lsp = require('lsp-zero')
lsp.preset('recommended')

-- (Optional) Configure lua language server for neovim
lsp.nvim_workspace()

lsp.setup()

require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
  },
}

-- File Explorer nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require("nvim-tree").setup()

--Pretty Status bar
require('lualine').setup {
	options = {
		icons_enabled = true,
		theme = 'monokai-pro',
	},
}

-- Add Ctrl + X and initialize toggle term 
require("toggleterm").setup {
	open_mapping = [[<c-x>]],
	shade_terminals = false
}

-- Add projects capability to telescope
require('telescope').load_extension('projects')
require'telescope'.setup({
    defaults = {
        file_ignore_patterns = { "^./.git/", "^node_modules/", "^vendor/", "%.jpg", "%.png" },
    }
})

-- Smarter Indent setup
vim.opt.list = true
-- vim.opt.listchars:append "space:⋅"
-- vim.opt.listchars:append "eol:↴"

require("indent_blankline").setup {
    space_char_blankline = " ",
    show_current_context = true,
    show_current_context_start = true,
}


