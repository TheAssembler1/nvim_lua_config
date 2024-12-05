require"log"

log_trace("loading plugins")

require"lazy".setup({
  -- multicursor
  {
    "jake-stewart/multicursor.nvim",
    branch = "1.0",
    config = function()
        local mc = require("multicursor-nvim")

        mc.setup()

        local set = vim.keymap.set

        -- Add or skip cursor above/below the main cursor.
        set({"n", "v"}, "<up>",
            function() mc.lineAddCursor(-1) end)
        set({"n", "v"}, "<down>",
            function() mc.lineAddCursor(1) end)
        set({"n", "v"}, "<leader><up>",
            function() mc.lineSkipCursor(-1) end)
        set({"n", "v"}, "<leader><down>",
            function() mc.lineSkipCursor(1) end)

        -- Add or skip adding a new cursor by matching word/selection
        set({"n", "v"}, "<leader>n",
            function() mc.matchAddCursor(1) end)
        set({"n", "v"}, "<leader>s",
            function() mc.matchSkipCursor(1) end)
        set({"n", "v"}, "<leader>N",
            function() mc.matchAddCursor(-1) end)
        set({"n", "v"}, "<leader>S",
            function() mc.matchSkipCursor(-1) end)

        -- Add all matches in the document
        set({"n", "v"}, "<leader>A", mc.matchAllAddCursors)

        -- You can also add cursors with any motion you prefer:
        -- set("n", "<right>", function()
        --     mc.addCursor("w")
        -- end)
        -- set("n", "<leader><right>", function()
        --     mc.skipCursor("w")
        -- end)

        -- Rotate the main cursor.
        set({"n", "v"}, "<left>", mc.nextCursor)
        set({"n", "v"}, "<right>", mc.prevCursor)

        -- Delete the main cursor.
        set({"n", "v"}, "<leader>x", mc.deleteCursor)

        -- Add and remove cursors with control + left click.
        set("n", "<c-leftmouse>", mc.handleMouse)

        -- Easy way to add and remove cursors using the main cursor.
        set({"n", "v"}, "<c-q>", mc.toggleCursor)

        -- Clone every cursor and disable the originals.
        set({"n", "v"}, "<leader><c-q>", mc.duplicateCursors)

        set("n", "<esc>", function()
            if not mc.cursorsEnabled() then
                mc.enableCursors()
            elseif mc.hasCursors() then
                mc.clearCursors()
            else
                -- Default <esc> handler.
            end
        end)

        -- bring back cursors if you accidentally clear them
        set("n", "<leader>gv", mc.restoreCursors)

        -- Align cursor columns.
        set("n", "<leader>a", mc.alignCursors)

        -- Split visual selections by regex.
        set("v", "S", mc.splitCursors)

        -- Append/insert for each line of visual selections.
        set("v", "I", mc.insertVisual)
        set("v", "A", mc.appendVisual)

        -- match new cursors within visual selections by regex.
        set("v", "M", mc.matchCursors)

        -- Rotate visual selection contents.
        set("v", "<leader>t",
            function() mc.transposeCursors(1) end)
        set("v", "<leader>T",
            function() mc.transposeCursors(-1) end)

        -- Jumplist support
        set({"v", "n"}, "<c-i>", mc.jumpForward)
        set({"v", "n"}, "<c-o>", mc.jumpBackward)

        -- Customize how cursors look.
        local hl = vim.api.nvim_set_hl
        hl(0, "MultiCursorCursor", { link = "Cursor" })
        hl(0, "MultiCursorVisual", { link = "Visual" })
        hl(0, "MultiCursorSign", { link = "SignColumn"})
        hl(0, "MultiCursorDisabledCursor", { link = "Visual" })
        hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
        hl(0, "MultiCursorDisabledSign", { link = "SignColumn"})
    end
  },
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
    tag = "v0.1.1",
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
