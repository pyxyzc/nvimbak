return {
    "tzachar/cmp-fuzzy-buffer",
    dependencies = {
        "hrsh7th/nvim-cmp",
        {
            "tzachar/fuzzy.nvim",         -- ✅ 一定要是这个
            dependencies = {
                { "nvim-telescope/telescope-fzf-native.nvim", build = "make" }, -- 用 fzf 后端
                -- 或者用 fzy 后端：
                -- { "romgrk/fzy-lua-native", build = "make" },
            },
        },
    },
}
