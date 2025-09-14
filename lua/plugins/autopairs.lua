return {
    "windwp/nvim-autopairs",
    event = "InsertEnter", -- 按需加载：进入插入模式时再激活
    init = function()
        require("nvim-autopairs").setup({
            map_cr = true,
        })
    end,
}
