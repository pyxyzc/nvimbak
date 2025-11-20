-- lua/plugins/nvim-ufo.lua
return {
    "kevinhwang91/nvim-ufo",
    event = "BufReadPost",
    dependencies = {
        "kevinhwang91/promise-async",
    },
}
