local ok, codex = pcall(require, "codex")
if not ok then
  vim.notify("Codex plugin not found!", vim.log.levels.WARN)
  return
end

-- 快捷键配置
local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Normal 模式：切换 Codex 面板
map("n", "<leader>cc", function()
  codex.toggle()
end, vim.tbl_extend("force", opts, { desc = "Codex: Toggle" }))

-- Visual 模式：发送选中内容到 Codex
map("v", "<leader>cs", function()
  codex.actions.send_selection()
end, vim.tbl_extend("force", opts, { desc = "Codex: Send selection" }))

-- 可选：提示用户加载成功
vim.notify("Codex keymaps loaded.", vim.log.levels.INFO)
