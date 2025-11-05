local M = {}

-- 防止分屏扰动
vim.opt.splitkeep = "screen"

-- 把当前窗口移到最右，并固定宽度
local function pin_right(width_opt)
    local win = vim.api.nvim_get_current_win()
    vim.cmd("wincmd L")
    local width = width_opt
    if type(width_opt) == "number" and width_opt > 0 and width_opt < 1 then
        width = math.max(20, math.floor(vim.o.columns * width_opt))
    end
    if type(width) ~= "number" then width = 80 end
    pcall(vim.api.nvim_win_set_width, win, width)
    pcall(vim.api.nvim_set_option_value, "winfixwidth", true, { win = win })
end

function M.setup(opts)
    local chat = require("CopilotChat")
    chat.setup(opts or {})

    -- 当 CopilotChat 打开时固定到右侧
    vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("CopilotChatRight", { clear = true }),
        pattern = "copilot-chat",
        callback = function()
            local w = (opts and opts.window and opts.window.width) or 0.35
            pin_right(w)
        end,
    })
end

return M

