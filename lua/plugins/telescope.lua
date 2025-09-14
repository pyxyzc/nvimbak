return {
    "nvim-telescope/telescope.nvim",
    lazy = true,
    init = function()
        local status, telescope = pcall(require, "telescope")
        if not status then
            vim.notify("No plugin named telescope")
            return 
        end

        telescope.setup({
            defaults = {
                -- 打开弹窗后进入的初始模式
                initial_mode = "insert",
                -- 窗口内的快捷键设置
                mappings = require("keymaps").telescopeList,
            },
            pickers = {
                -- 内置pickers设置
                find_files = {
                    -- 皮肤：dropdown | cursor | ivy
                    -- theme = "dropdown"
                },
            },
            extensions = {
                -- 扩展插件设置
            },
        })

        pcall(telescope.load_extension, "env")
    end,
}
