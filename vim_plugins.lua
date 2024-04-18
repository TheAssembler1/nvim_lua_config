require"log"

log_trace("loading plugins")

require"lazy".setup({
  -- rust lsp
  {
    "rust-lang/rust.vim"
  },
  -- color theme
  {
    "ful1e5/onedark.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      log_trace("onedark config")
      vim.cmd([[colorscheme onedark]])
    end,
  },
  -- zen mode
  {
    "folke/zen-mode.nvim"
  },
  -- file selector bar
  {
    "vim-airline/vim-airline",
    config = function()
      log_trace("vim-airline config")
      vim.cmd([[
        let g:airline#extensions#tabline#enabled = 1
        let g:airline#extensions#tabline#buffer_idx_mode = 1
        nmap <leader>1 <Plug>AirlineSelectTab1
        nmap <leader>2 <Plug>AirlineSelectTab2
        nmap <leader>3 <Plug>AirlineSelectTab3
        nmap <leader>4 <Plug>AirlineSelectTab4
        nmap <leader>5 <Plug>AirlineSelectTab5
        nmap <leader>6 <Plug>AirlineSelectTab6
        nmap <leader>7 <Plug>AirlineSelectTab7
        nmap <leader>8 <Plug>AirlineSelectTab8
        nmap <leader>9 <Plug>AirlineSelectTab9
        nmap <leader>0 <Plug>AirlineSelectTab0
        nmap <leader>- <Plug>AirlineSelectPrevTab
        nmap <leader>+ <Plug>AirlineSelectNextTab
      ]])
    end,
  },
  -- syntax highlighting
  {
    "neoclide/coc.nvim",
    branch = "release",
    config = function()
        vim.opt.backup = false
        vim.opt.writebackup = false
        vim.opt.updatetime = 300
        vim.opt.signcolumn = "yes"
        local keyset = vim.keymap.set
        function _G.check_back_space()
            local col = vim.fn.col('.') - 1
            return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
        end
        local opts = {silent = true, noremap = true, expr = true, replace_keycodes = false}
        keyset("i", "<TAB>", 'coc#pum#visible() ? coc#pum#next(1) : v:lua.check_back_space() ? "<TAB>" : coc#refresh()', opts)
        keyset("i", "<S-TAB>", [[coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"]], opts)
        keyset("i", "<cr>", [[coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]], opts)
        keyset("i", "<c-j>", "<Plug>(coc-snippets-expand-jump)")
        keyset("i", "<c-space>", "coc#refresh()", {silent = true, expr = true})
    end
  },
  -- smooth scrolling
  {
    "karb94/neoscroll.nvim"
  },
  -- better syntax highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    config = function()
      log_trace("nvim-treesitter config")
      ensure_installed = {"c", "lua", "vim", "rust", "cpp"}
      sync_install = true
      auto_install = true
    end
  },
  -- required for telescope
  {
    "nvim-lua/plenary.nvim",
    tag = "0.1.1",
  },
  -- grepping files and words
  {
    "nvim-telescope/telescope.nvim",
    config = function()
      vim.cmd([[
        nnoremap <leader>ff <cmd>Telescope find_files<cr>
        nnoremap <leader>fg <cmd>Telescope live_grep<cr>
      ]])  
    end
  }
})
