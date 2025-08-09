-- adding current dir to package path
local script_dir = debug.getinfo(1, "S").source:match("@?(.*/)")
if script_dir == nil then
    -- If the script is executed from the interactive prompt, use the current directory
    script_dir = ""
end
package.path = package.path .. ";" .. script_dir .. "?.lua"

require"log"

-- setting the log level
G_CURRENT_PRINT_MODE = G_PRINT_MODE.ERROR
log_trace("lua started")

require"vim_settings"

-- set font
vim.o.guifont = "JetBrains Mono:h14"

-- ensure lazy plugin manager is installed
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require"vim_plugins"
