return {
'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('lualine').setup({
        options = {
          theme = 'iceberg_dark', -- Choose a theme
          icons_enabled = true,
          section_separators = '',
          component_separators = ''
        },
        sections = {
          lualine_a = {'mode'},
          lualine_b = {'branch'},
          lualine_c = {
            function()
                local filepath = vim.fn.expand('%:p')
                if filepath == '' then
                    return '[No Name]'
                end
                local parts = vim.split(filepath, '/')
                local len = #parts
                if len < 3 then
                    return filepath
                end
                return table.concat(parts, '/', len - 2, len)
            end
          },
          lualine_x = {'encoding', 'fileformat', 'filetype'},
          lualine_y = {'progress'},
          lualine_z = {'location'}
        }
      })
    end}
