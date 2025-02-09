return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local harpoon = require("harpoon")

    -- REQUIRED
    harpoon:setup()
    -- REQUIRED

    -- Add file to Harpoon list
    vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)

    -- Toggle quick menu
    vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

    -- Navigate to specific files
    vim.keymap.set("n", "<F2>", function() harpoon:list():select(1) end)
    vim.keymap.set("n", "<F3>", function() harpoon:list():select(2) end)
    vim.keymap.set("n", "<F4>", function() harpoon:list():select(3) end)
    vim.keymap.set("n", "<F5>", function() harpoon:list():select(4) end)
    vim.keymap.set("n", "<F6>", function() harpoon:list():select(5) end)
    vim.keymap.set("n", "<F7>", function() harpoon:list():select(6) end)

    -- Toggle previous & next buffers stored within Harpoon list
    vim.keymap.set("n", "<C-S-P>", function() harpoon:list():prev() end)
    vim.keymap.set("n", "<C-S-N>", function() harpoon:list():next() end)
  end,
}

