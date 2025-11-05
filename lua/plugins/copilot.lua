return {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = "VeryLazy",
    opts = {
        window = {
            layout = "vertical",  -- 垂直分屏
            width  = 0.35,        -- 右侧占比或列宽
            border = "rounded",
        },
        start_in_insert = true,
        hide_system_prompt = true,
    },
    config = function(_, opts)
        require("config.copilot").setup(opts)
    end,
    keys = {
        -- 普通模式：g => 打开/关闭 Copilot 聊天窗口
        { "<leader>gg", "<cmd>CopilotChatToggle<cr>", mode = "n", desc = "Toggle CopilotChat window" },
    },
}
