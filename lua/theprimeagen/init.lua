require("theprimeagen.set")
require("theprimeagen.remap")
require("theprimeagen.terminal").setup()
require("theprimeagen.lazy_init")

-- DO.not
-- DO NOT INCLUDE THIS

-- If i want to keep doing lsp debugging
-- function restart_htmx_lsp()
--     require("lsp-debug-tools").restart({ expected = {}, name = "htmx-lsp", cmd = { "htmx-lsp", "--level", "DEBUG" }, root_dir = vim.loop.cwd(), });
-- end

-- DO NOT INCLUDE THIS
-- DO.not

local augroup = vim.api.nvim_create_augroup
local ThePrimeagenGroup = augroup('ThePrimeagen', {})

local autocmd = vim.api.nvim_create_autocmd
local yank_group = augroup('HighlightYank', {})

-- Disable terminal flow control (XON/XOFF) so Ctrl+S and Ctrl+Q work properly
-- This prevents the terminal from intercepting Ctrl+S as XOFF which causes view jumping
autocmd('VimEnter', {
    group = ThePrimeagenGroup,
    callback = function()
        if vim.fn.has("unix") == 1 then
            vim.cmd("silent !stty -ixon")
        end
    end,
})

function R(name)
    require("plenary.reload").reload_module(name)
end

vim.filetype.add({
    extension = {
        templ = 'templ',
    }
})

autocmd('TextYankPost', {
    group = yank_group,
    pattern = '*',
    callback = function()
        vim.highlight.on_yank({
            higroup = 'IncSearch',
            timeout = 40,
        })
    end,
})

autocmd({"BufWritePre"}, {
    group = ThePrimeagenGroup,
    pattern = "*",
    command = [[%s/\s\+$//e]],
})

autocmd('BufEnter', {
    group = ThePrimeagenGroup,
    callback = function()
        if vim.bo.filetype == "zig" then
 --         vim.cmd.colorscheme("tokyonight-night")
        else
         --   vim.cmd.colorscheme("rose-pine-moon")
        end
    end
})

autocmd("BufWritePost", {
    callback = function()
        -- local file_name = vim.fn.expand("%:p") -- Get the full file path
        -- vim.notify("File saved: " .. file_name, "info", {
        --     title = "File Save Notification",
        --     timeout = 2000, -- Optional: Override default timeout
        -- })
    end,
})


autocmd('LspAttach', {
    group = ThePrimeagenGroup,
    callback = function(e)
        local opts = { buffer = e.buf }
        vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
        vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
        vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
        vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
        vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
        vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
        vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
        vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
        vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
        vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
    end
})


vim.api.nvim_create_autocmd("CursorHold", {
    callback = function()
        vim.diagnostic.open_float(nil, { focus = false, scope = "cursor" })
    end,
})


vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25

local toggle_numbers = function()
    vim.opt.relativenumber = false
    vim.opt.number = true
end

local toggle_numberszen = function()
    vim.opt.relativenumber = false
    vim.opt.number = false
end

vim.keymap.set("n", "<space>lz", toggle_numberszen, {})



vim.api.nvim_create_user_command("UseNumbers", toggle_numbers, {})
vim.keymap.set("n", "<space>ln", toggle_numbers, {})


local toggle_relativenumbers = function()
    vim.opt.relativenumber = true
    vim.opt.number = false
end

vim.keymap.set("n", "<space>lr", toggle_relativenumbers, {})


local current_command = ""
vim.keymap.set("n", "<space>te", function()
  current_command = vim.fn.input("Command: ")
end)

-- Note: <space>tr is now used for right terminal in terminal.lua
