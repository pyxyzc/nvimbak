return {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
    opts = {
        input = {
            border = "rounded",
            win_options = {
                winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
            },
        },
        select = {
            backend = { "telescope", "builtin", "nui" }, -- 优先用 telescope
            builtin = {
                border = "rounded",
                win_options = {
                    winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
                },
            },
        },
    },
}
