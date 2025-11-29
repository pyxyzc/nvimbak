return {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
        "MunifTanjim/nui.nvim",
        "rcarriga/nvim-notify",
    },
    config = function()
        -- 漂亮通知弹窗
        local notify = require("notify")
        notify.setup({
            stages = "fade_in_slide_out",
            timeout = 2000,
            render = "default",
            max_width = 60,
            max_height = 10,
        })
        vim.notify = notify

        require("noice").setup({
            -- 让 LSP / hover 的文档走 noice 的浮窗
            lsp = {
                progress = { enabled = true },
                override = {
                    ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                    ["vim.lsp.util.stylize_markdown"] = true,
                    ["cmp.entry.get_documentation"] = true,
                },
            },
            presets = {
                bottom_search = false,    -- 搜索框不固定底部（我们用 popup）
                command_palette = true,   -- 命令行放上方 palette 风格
                long_message_to_split = true,
                lsp_doc_border = true,    -- LSP 漂亮边框
            },
            views = {
                cmdline_popup = {
                    position = {
                        row = "35%",
                        col = "50%",
                    },
                    size = {
                        width = 60,
                        height = "auto",
                    },
                    border = {
                        style = "rounded",
                        padding = { 0, 1 },
                    },
                    win_options = {
                        winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
                    },
                },
                popupmenu = {
                    relative = "editor",
                    position = {
                        row = "35%",
                        col = "50%",
                    },
                    size = {
                        width = 60,
                        height = 10,
                    },
                    border = {
                        style = "rounded",
                        padding = { 0, 1 },
                    },
                    win_options = {
                        winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
                    },
                },
            },
            routes = {
                -- 可以过滤掉一些太吵的消息，比如写入成功之类
                {
                    filter = { event = "msg_show", kind = "", find = "written" },
                    opts = { skip = true },
                },
            },
        })
    end,
}
