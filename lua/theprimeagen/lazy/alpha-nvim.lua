-- Lazy plugin setup for alpha-nvim
return {
    "goolord/alpha-nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        local alpha = require("alpha")
        local dashboard = require("alpha.themes.dashboard")

        vim.cmd [[
          highlight AlphaHeader guifg=#FF5733 ctermfg=Red
          highlight AlphaHeaderYellow guifg=#FFFF00 ctermfg=Yellow
        ]]
        -- vim.cmd [[
        --   highlight AlphaHeader guifg=#FF0000 ctermfg=Red
        -- ]]

        -- DOOM ASCII art
        local doom_ascii = {
                "=================     ===============     ===============   ========  ========",
                "\\ . . . . . . .\\   //. . . . . . .\\   //. . . . . . .\\  \\. . .\\// . . //",
                "||. . ._____. . .|| ||. . ._____. . .|| ||. . ._____. . .|| || . . \\/ . . .||",
                "|| . .||   ||. . || || . .||   ||. . || || . .||   ||. . || ||. . . . . . . ||",
                "||. . ||   || . .|| ||. . ||   || . .|| ||. . ||   || . .|| || . | . . . . .||",
                "|| . .||   ||. _-|| ||-_ .||   ||. . || || . .||   ||. _-|| ||-_.|\\ . . . .||",
                "||. . ||   ||-'  || ||  `-||   || . .|| ||. . ||   ||-'  || ||  `|_ |. .    ||",
                "|| . _||   ||    || ||    ||   ||_ . || || . _||   ||    || ||   |\\ `-_/| .||",
                "||_-' ||  .|/    || || \\ |.   || `-_|| ||_-' ||  .|/    || ||   |\\  / |-_.||",
                "||    ||_-'      || ||      `-_||    || ||    ||_-'      || ||   |\\  / |  `||",
                "||    `'         || ||         `'    || ||    `'         || ||   |\\  / |   ||",
                "||            .===' `===.         .==='.`===.         .===' /==. | \\/  |   ||",
                "||         .==' \\_|-_ `===. .==='   _|_   `===. .===' _-|/   `==  \\/  |   ||",
                "||      .=='    _-'    `-_  `='    _-'   `-_    `='  _-'   `-_  /|  \\/ |   ||",
                "||   .=='    _-'          '-__\\._-'         '-_./__-'         `' |. /| |   ||",
                "||.=='    _-'                                                     `' |  /==.||",
                "=='    _-'                        N E O V I M                        \\/   `==",
                "\\   _-'                                                                `-_   /",
                "                                                                                ",
        }

        dashboard.section.header.val = doom_ascii

        dashboard.section.header.opts.hl = "AlphaHeader"
        -- Footer
        dashboard.section.footer.val = "🔥 Welcome to DOOM 🔥"

        -- Buttons
        dashboard.section.buttons.val = {
            dashboard.button("e", "📄  New File", ":ene <BAR> startinsert <CR>"),
            dashboard.button("f", "🔍  Find File", ":Telescope find_files <CR>"),
            dashboard.button("q", "❌  Quit Neovim", ":qa<CR>"),
        }

        -- Simulating flames
        -- local flame_colors = { "red", "orange", "yellow" }
        -- local flame_timer = vim.loop.new_timer()

        -- flame_timer:start(0, 500, vim.schedule_wrap(function()
            -- Randomly pick flame colors
            -- local random_color = flame_colors[math.random(#flame_colors)]
            -- vim.api.nvim_set_hl(0, "AlphaHeader", { fg = random_color })

            -- Redraw
            -- vim.cmd("redraw")
        -- end))

        -- Setup alpha with the dashboard
        alpha.setup(dashboard.config)
        vim.defer_fn(function()
            -- Change the highlight group to yellow
        -- dashboard.section.header.val = "||         || "

            -- Refresh the Alpha dashboard to apply the new highlight
            alpha.redraw()
        end, 5000) -- 5000ms = 5 seconds
        -- Clean up timer on exit
        -- vim.api.nvim_create_autocmd("VimLeavePre", {
            -- callback = function()
                -- flame_timer:stop()
                -- flame_timer:close()
            -- end,
        -- })
        -- Timer to alternate colors
        local timer = vim.loop.new_timer()
        local toggle = true -- State toggle

        timer:start(0, 1500, vim.schedule_wrap(function()
            if toggle then
                -- Switch to yellow
                vim.cmd [[ highlight AlphaHeaderRed guifg=#FFFF00 ctermfg=Yellow ]]
                dashboard.section.header.opts.hl = "AlphaHeaderRed"
            else
                -- Switch back to red
                vim.cmd [[ highlight AlphaHeaderRed guifg=#FF5733 ctermfg=Red ]]
                dashboard.section.header.opts.hl = "AlphaHeaderRed"
            end

            -- Toggle the state
            toggle = not toggle

            -- Redraw the dashboard to apply changes
            alpha.redraw()
        end))

    end,
}

