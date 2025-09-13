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

vim.opt.runtimepath:append("/mnt/c/repos/SandboxDotJs")

local file_map = {
  Foo = "/mnt/c/repos/SandboxDotJs/FrontEndMasters/test.txt",
  Bar = "/path/to/bar.txt",
  Baz = "/path/to/baz.lua",
}

vim.api.nvim_create_user_command(
    'DocTree',
    function(opts)
        print("Argument: " .. opts.args)
        if opts.args then
            -- after confirmed argument, check table for reference
            vim.cmd("edit /mnt/c/repos/SandboxDotJs/master-index.txt")
        end
    end,
    { nargs = 1 }
)



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


vim.keymap.set("t", "<esc><esc>", "<c-\\><c-n>")

local state = {
  floating = {
    buf = -1,
    win = -1,
  }
}

local function create_floating_window(opts)
  opts = opts or {}
  local width = opts.width or math.floor(vim.o.columns * 0.8)
  local height = opts.height or math.floor(vim.o.lines * 0.8)

  -- Calculate the position to center the window
  local col = math.floor((vim.o.columns - width) / 2)
  local row = math.floor((vim.o.lines - height) / 2)

  -- Create a buffer
  local buf = nil
  if vim.api.nvim_buf_is_valid(opts.buf) then
    buf = opts.buf
  else
    buf = vim.api.nvim_create_buf(false, true) -- No file, scratch buffer
  end

  -- Define window configuration
  local win_config = {
    relative = "editor",
    width = width,
    height = height,
    col = col,
    row = row,
    style = "minimal", -- No borders or extra UI elements
    border = "rounded",
  }

  -- Create the floating window
  local win = vim.api.nvim_open_win(buf, true, win_config)

  return { buf = buf, win = win }
end

local toggle_terminal = function()
  if not vim.api.nvim_win_is_valid(state.floating.win) then
    state.floating = create_floating_window { buf = state.floating.buf }
    if vim.bo[state.floating.buf].buftype ~= "terminal" then
      vim.cmd.terminal()
    end
  else
    vim.api.nvim_win_hide(state.floating.win)
  end
end

-- Example usage:
-- Create a floating window with default dimensions
vim.api.nvim_create_user_command("Floaterminal", toggle_terminal, {})

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

vim.api.nvim_create_autocmd("TermOpen", {
--  group = vim.api.nvim_create_augroup("custom-term-open", { clear = true }),
  callback = function()
    vim.opt.number = false
    vim.opt.relativenumber = false
  end,
})

local job_id = 0
vim.keymap.set("n", "<space>to", function()
  vim.cmd.vnew()
  vim.cmd.term()
  vim.cmd.wincmd("J")
  vim.api.nvim_win_set_height(0, 20)

  job_id = vim.bo.channel

    -- Send 'clear' command and press Enter in the terminal
  vim.api.nvim_chan_send(job_id, "clear\n")
end)

vim.keymap.set("n", "<space>th", function()
  local current_file_dir = vim.fn.expand('%:p:h') -- Get the directory of the current file

  vim.cmd.vnew()
  vim.cmd.term()
  vim.cmd.wincmd("L")

  job_id = vim.bo.channel


    -- Send 'clear' command and press Enter in the terminal
  vim.api.nvim_chan_send(job_id, "clear; cd ".. current_file_dir..";fmtz;cargo run;\n")
  vim.cmd('setlocal modifiable')
  vim.api.nvim_feedkeys('i', 'n', false)

end)

vim.keymap.set("n", "<space>tf", ":Floaterminal<CR>")

local current_command = ""
vim.keymap.set("n", "<space>te", function()
  current_command = vim.fn.input("Command: ")
end)

vim.keymap.set("n", "<space>tr", function()
  if current_command == "" then
    current_command = vim.fn.input("Command: ")
  end

  vim.fn.chansend(job_id, { current_command .. "\r\n" })
end)
