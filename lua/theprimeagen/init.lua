require("theprimeagen.set")
require("theprimeagen.remap")
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
          vim.cmd.colorscheme("tokyonight-night")
        else
         --   vim.cmd.colorscheme("rose-pine-moon")
        end
    end
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

vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25

vim.opt.runtimepath:append("/mnt/c/repos/SandboxDotJs/FrontEndMasters")

local file_map = {
  Foo = "/mnt/c/repos/SandboxDotJs/FrontEndMasters/test.txt",
  Bar = "/path/to/bar.txt",
  Baz = "/path/to/baz.lua",
}

local function jump_to_file()
  print("jump_to_file executed")
  local word = vim.fn.expand("<cword>") -- Get the word under the cursor
  local filepath = file_map[word]

  if filepath then
    print("Opening file: " .. filepath)
    vim.cmd("edit " .. filepath) -- Open the file
  else
    print("No file mapped for: " .. word)
  end
end

-- Use vim.keymap.set for simplicity
vim.keymap.set("n", "<leader>gf", jump_to_file, { noremap = true, silent = true })

-- Define the highlight group
vim.api.nvim_set_hl(0, "HighlightFoo", { fg = "#00FF00" }) -- Green color

-- Create the autocommand group
vim.api.nvim_create_augroup("HighlightFoo", { clear = true })

-- Add autocommands for *.txt files
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = "HighlightFoo",
  pattern = "*.txt",
  callback = function()
    vim.cmd("syntax match FooWord /\\<Foo\\>/")
    vim.cmd("highlight link FooWord HighlightFoo")
  end,
})

