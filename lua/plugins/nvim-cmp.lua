return {
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter", "CmdlineEnter" },

    dependencies = {
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
    },

    config = function()
        local cmp = require("cmp")

        -- ======================
        -- 插入模式补全
        -- ======================
        -- cmp.setup({
        --     snippet = {
        --         expand = function() end, -- 若没 Snippet，可空
        --     },
        --     mapping = cmp.mapping.preset.insert({
        --         ["<CR>"] = cmp.mapping.confirm({ select = true }),
        --         ["<Tab>"] = cmp.mapping.select_next_item(),
        --         ["<S-Tab>"] = cmp.mapping.select_prev_item(),
        --     }),
        --     sources = cmp.config.sources({
        --         { name = "buffer" },
        --         { name = "path" },
        --     }),
        -- })

        -- ======================
        -- `/` 搜索补全
        -- ======================
        cmp.setup.cmdline("/", {
            mapping = cmp.mapping.preset.cmdline(),
            sources = {
                { name = "buffer" },
            },
        })

        -- ======================
        -- `:` 命令补全
        -- ======================
        cmp.setup.cmdline(":", {
            mapping = cmp.mapping.preset.cmdline(),
            sources = cmp.config.sources({
                { name = "path" },
            }, {
                    { name = "cmdline" },
                }),
        })
    end,
}
