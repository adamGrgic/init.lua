local M = {}

-- Terminal state for floating terminal
local state = {
  floating = {
    buf = -1,
    win = -1,
  },
  side_terminal = {
    buf = -1,
    win = -1,
  }
}

-- Create floating window function
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

-- Toggle floating terminal
local function toggle_floating_terminal()
  if not vim.api.nvim_win_is_valid(state.floating.win) then
    state.floating = create_floating_window { buf = state.floating.buf }
    if vim.bo[state.floating.buf].buftype ~= "terminal" then
      vim.cmd.terminal()
    end
  else
    vim.api.nvim_win_hide(state.floating.win)
  end
end

-- Open terminal on the right side
local function open_right_terminal()
  vim.cmd('rightbelow vsplit | terminal')
  vim.cmd('startinsert')
  
  -- Store terminal buffer and window info
  state.side_terminal.buf = vim.api.nvim_get_current_buf()
  state.side_terminal.win = vim.api.nvim_get_current_win()
end

-- Toggle side terminal visibility (simplified approach)
local function toggle_side_terminal()
  -- Check if we're currently in a terminal buffer
  if vim.bo.buftype == 'terminal' then
    -- We're in terminal, just close the current window
    vim.cmd('close')
  else
    -- We're not in terminal, open a new one
    open_right_terminal()
  end
end

-- Open terminal on the left side
local function open_left_terminal()
  vim.cmd('leftabove vsplit | terminal')
  vim.cmd('startinsert')
end

-- Open terminal at bottom
local function open_bottom_terminal()
  vim.cmd.vnew()
  vim.cmd.term()
  vim.cmd.wincmd("J")
  vim.api.nvim_win_set_height(0, 20)
  
  local job_id = vim.bo.channel
  -- Send 'clear' command and press Enter in the terminal
  vim.api.nvim_chan_send(job_id, "clear\n")
end

-- Setup terminal keybindings
function M.setup()
  -- Floating terminal
  vim.keymap.set("n", "<space>tf", toggle_floating_terminal, { desc = "Toggle floating terminal" })
  
  -- Right side terminal
  vim.keymap.set("n", "<space>tr", open_right_terminal, { desc = "Open terminal on right side" })
  
  -- Toggle side terminal visibility
  vim.keymap.set("n", "<space>tt", toggle_side_terminal, { desc = "Toggle side terminal visibility" })
  
  -- Left side terminal  
  vim.keymap.set("n", "<space>tl", open_left_terminal, { desc = "Open terminal on left side" })
  
  -- Bottom terminal
  vim.keymap.set("n", "<space>to", open_bottom_terminal, { desc = "Open terminal at bottom" })

  -- Buffer switching (when terminal is open)
  vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Switch to left buffer" })
  vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Switch to right buffer" })
  vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Switch to bottom buffer" })
  vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Switch to top buffer" })
  
  -- Terminal exit improvements
  vim.keymap.set("t", "<esc><esc>", "<c-\\><c-n>", { desc = "Exit terminal mode" })
  
  -- Terminal autocmd
  vim.api.nvim_create_autocmd("TermOpen", {
    callback = function()
      vim.opt.number = false
      vim.opt.relativenumber = false
    end,
  })
  
  -- Create user command for floating terminal
  vim.api.nvim_create_user_command("Floaterminal", toggle_floating_terminal, {})
end

return M
