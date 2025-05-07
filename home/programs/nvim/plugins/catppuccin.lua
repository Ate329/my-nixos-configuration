-- File: home/programs/nvim/plugins/catppuccin.lua
require("catppuccin").setup({
    flavour = "frappe", -- Or "latte", "macchiato", "mocha"
    background = { -- :h background
        light = "latte",
        dark = "mocha",
    },
    transparent_background = false,
    show_end_of_buffer = false, -- shows a '~' character after the end of buffers
    term_colors = true, -- sets terminal colors (e.g. g:terminal_color_0)
    dim_inactive = {
        enabled = false,
        shade = "dark",
        percentage = 0.15,
    },
    no_italic = false, -- Force no italic
    no_bold = false, -- Force no bold
    no_underline = false, -- Force no underline
    styles = {
        comments = { "italic" },
        conditionals = { "italic" },
        loops = {},
        functions = {},
        keywords = {},
        strings = {},
        variables = {},
        numbers = {},
        booleans = {},
        properties = {},
        types = {},
        operators = {},
    },
    color_overrides = {},
    custom_highlights = function(colors)
        return {}
    end,
    integrations = {
        cmp = true,
        gitsigns = true,
        nvimtree = true,
        treesitter = true,
        notify = false,
        mini = {
            enabled = true,
            indentscope_color = "",
        },
        -- For more plugins integrations, see the Catppuccin/nvim documentation
        -- Ensure other plugins you use are enabled here if they have Catppuccin integrations
        telescope = true, -- Example: if you use telescope.nvim
        -- native_lsp = {
        --   enabled = true,
        --   underlines = {
        --     errors = { "undercurl" },
        --     hints = { "undercurl" },
        --     warnings = { "undercurl" },
        --     information = { "undercurl" },
        --   },
        -- },
    },
})

-- setup must be called before loading
vim.cmd.colorscheme "catppuccin"
