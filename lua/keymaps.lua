-- Leader keys
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Default options for mappings
local opts = {
	noremap = true, -- non-recursive
	silent = true, -- do not show message
}


-- --------------------------------------------------
-- Normal Mode
-- --------------------------------------------------

-- Window navigation with Alt + h/j/k/l
vim.keymap.set("n", "<A-h>", "<C-w>h", opts)
vim.keymap.set("n", "<A-j>", "<C-w>j", opts)
vim.keymap.set("n", "<A-k>", "<C-w>k", opts)
vim.keymap.set("n", "<A-l>", "<C-w>l", opts)

-- Window resizing with arrow keys (delta = 2 lines)
vim.keymap.set("n", "<C-Up>", ":resize -2<CR>", opts)
vim.keymap.set("n", "<C-Down>", ":resize +2<CR>", opts)
vim.keymap.set("n", "<C-Left>", ":vertical resize -2<CR>", opts)
vim.keymap.set("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- --------------------------------------------------
-- Visual Mode
-- --------------------------------------------------

-- Hint: start visual mode with the same area as the previous area and the same mode
vim.keymap.set("v", "<", "<gv", opts)
vim.keymap.set("v", ">", ">gv", opts)

-- For nvim-treesitter
-- 1. Press `gss` to intialize selection. (ss = start selection)
-- 2. Now we are in the visual mode.
-- 3. Press `gsi` to increment selection by AST node. (si = selection incremental)
-- 4. Press `gsc` to increment selection by scope. (sc = scope)
-- 5. Press `gsd` to decrement selection. (sd = selection decrement)

-- Telescope
vim.keymap.set("n", "<C-p>", ":Telescope find_files<CR>", opts)
vim.keymap.set("n", "<C-f>", ":Telescope live_grep<CR>", opts)

-- nvim-tree
vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", opts)

-- ------------------------------------------------------------------
-- 插件快捷键
-- ------------------------------------------------------------------

local pluginKeys = {}

-- Telescope

pluginKeys.telescopeList = {
	i = {
		-- 上下移动
		["<C-j>"] = "move_selection_next",
		["<C-k>"] = "move_selection_previous",
		["<Down>"] = "move_selection_next",
		["<Up>"] = "move_selection_previous",
		-- 历史记录
		["<C-n>"] = "cycle_history_next",
		["<C-p>"] = "cycle_history_prev",
		-- 关闭窗口
		["<C-c>"] = "close",
		-- 预览窗口上下滚动
		["<C-u>"] = "preview_scrolling_up",
		["<C-d>"] = "preview_scrolling_down",
	},
}

-- Bufferline

-- Switch
vim.keymap.set("n", "<S-l>", "<cmd>BufferLineCycleNext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<S-h>", "<cmd>BufferLineCyclePrev<CR>", { desc = "Prev buffer" })
for i = 1, 9 do
  vim.keymap.set("n", string.format("<leader>%d", i),
    string.format("<cmd>BufferLineGoToBuffer %d<CR>", i),
    { desc = "Go to buffer " .. i }
  )
end

vim.keymap.set("n", "<leader>bp", "<cmd>BufferLinePick<CR>", { desc = "Pick buffer" })

-- Close
vim.keymap.set("n", "<leader>bc", "<cmd>bd#<CR>", { desc = "Close current buffer" })

-- nvim-tree

pluginKeys.nvimTreeList = {
	-- 打开文件或文件夹
	{ key = { "<CR>", "o", "<2-LeftMouse>" }, action = "edit" },
	-- 分屏打开文件
	{ key = "v", action = "vsplit" },
	{ key = "h", action = "split" },
	-- 显示隐藏文件
	{ key = "i", action = "toggle_custom" }, -- 对应 filters 中的 custom (node_modules)
	{ key = ".", action = "toggle_dotfiles" }, -- Hide (dotfiles)
	-- 文件操作
	{ key = "<F5>", action = "refresh" },
	{ key = "a", action = "create" },
	{ key = "d", action = "remove" },
	{ key = "r", action = "rename" },
	{ key = "x", action = "cut" },
	{ key = "c", action = "copy" },
	{ key = "p", action = "paste" },
	{ key = "s", action = "system_open" },
}

-- lsp
pluginKeys.mapLSP = function(mapbuf)
	--------------------------------------------------
	-- LSP 基础操作
	--------------------------------------------------
	-- 重命名符号
	mapbuf("n", "<leader>r", ":Lspsaga rename<CR>", opts)
	-- 代码操作（Code Action）
	mapbuf("n", "<leader>ca", ":Lspsaga code_action<CR>", opts)

	--------------------------------------------------
	-- 定位与跳转
	--------------------------------------------------
	-- 跳转到定义
	mapbuf("n", "gd", ":Lspsaga goto_definition<CR>", opts)
	-- 查看文档（Hover）
	mapbuf("n", "gh", ":Lspsaga hover_doc<CR>", opts)
	-- 查找定义和引用
	mapbuf("n", "gf", ":Lspsaga finder def+ref<CR>", opts)
	-- 跳转到声明
	mapbuf("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
	-- 跳转到实现
	mapbuf("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
	-- 跳转到引用
	mapbuf("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)

	--------------------------------------------------
	-- 诊断信息
	--------------------------------------------------
	-- 显示当前行的诊断信息
	mapbuf("n", "gp", "<cmd>Lspsaga show_line_diagnostics<CR>", opts)
	-- 上一个诊断
	mapbuf("n", "gk", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
	-- 下一个诊断
	mapbuf("n", "gj", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)

	--------------------------------------------------
	-- 其他辅助功能
	--------------------------------------------------
	-- 格式化代码
	mapbuf("n", "<leader>=", "<cmd>lua vim.lsp.buf.format { async = true }<CR>", opts)
	-- 把诊断信息放到 quickfix 列表
	mapbuf("n", "<leader>q", "<cmd>lua vim.diagnostic.setloclist()<CR>", opts)

	--------------------------------------------------
	-- 可选功能（需要时可以取消注释）
	--------------------------------------------------
	-- 签名帮助（函数参数提示）
	-- mapbuf("n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
	-- 添加工作区文件夹
	-- mapbuf('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
	-- 移除工作区文件夹
	-- mapbuf('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
	-- 列出所有工作区文件夹
	-- mapbuf('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
	-- 跳转到类型定义
	-- mapbuf('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
end

-- blink 补全
pluginKeys.blink = function(cmp)
	return {
		preset = "default",
		["<C-k>"] = { "select_prev", "fallback" },
		["<C-j>"] = { "select_next", "fallback" },
		["<CR>"] = { "accept", "fallback" },
		["<Tab>"] = { "accept", "fallback" },
	}
end

return pluginKeys
