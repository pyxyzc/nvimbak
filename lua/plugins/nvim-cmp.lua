return {
    "hrsh7th/nvim-cmp",
    dependencies = {
        "tzachar/fuzzy.nvim",
        "tzachar/cmp-fuzzy-buffer",
        "tzachar/cmp-fuzzy-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
    },
    config = function()
        local cmp = require("cmp")

        cmp.setup({
            snippet = { expand = function() end },
            mapping = cmp.mapping.preset.insert({
                ["<CR>"]   = cmp.mapping.confirm({ select = true }),
                ["<Tab>"]  = cmp.mapping.select_next_item(),
                ["<S-Tab>"]= cmp.mapping.select_prev_item(),
            }),
            sources = cmp.config.sources({
                { name = "nvim_lsp" },
                { name = "fuzzy_buffer" },
                { name = "fuzzy_path" },
            }),
        })

        -- `/` 搜索使用 fuzzy_buffer
        cmp.setup.cmdline("/", {
            mapping = cmp.mapping.preset.cmdline(),
            sources = {
                { name = "fuzzy_buffer" },
            },
        })

        -- `:` 命令行
        cmp.setup.cmdline(":", {
            mapping = cmp.mapping.preset.cmdline(),
            sources = cmp.config.sources({
                { name = "fuzzy_path" },
            }, {
                    { name = "cmdline" },
                }),
        })
    end,
}
