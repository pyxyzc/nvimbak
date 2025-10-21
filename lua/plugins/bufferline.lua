return {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
        require('bufferline').setup{
            options = {
                close_command = "bdelete! %d",
                right_mouse_command = "bdelete! %d",
                indicator = {
                    icon = '▎',
                    style = 'underline',
                },
                buffer_close_icon = '󰅖',
                modified_icon = '●',
                close_icon = '',
                offsets = {
                    {
                        filetype = "NvimTree",
                        text = "File Explorer" ,
                        text_align = "left",
                        separator = true,
                    }
                },
            }
        }
        vim.opt.termguicolors = true
        vim.opt.showtabline = 2
    end
}
