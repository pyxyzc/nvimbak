-- Hint: use `:h <option>` to figure out the meaning if needed

-----------------------------------------------------------------
-- common设置
-----------------------------------------------------------------

-- 复制粘贴相关设置
vim.opt.clipboard = "unnamedplus" -- use system clipboard

-- 自动补全不被自动选中
vim.opt.completeopt = { "menu", "menuone", "noselect" }

-- 允许在nvim中使用鼠标
vim.opt.mouse = "a" -- allow the mouse to be used in Nvim

-- scroll相关设置
vim.opt.scrolloff = 10 -- no less than 10 lines even if you keep scrolling down
vim.opt.sidescrolloff = 10

-- 禁止创建备份文件
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false -- no .swp file

-- 当文件被外部程序修改时，自动加载
vim.opt.autoread = true

-- 过滤 vim.deprecated 信息
vim.deprecate = function() end

-----------------------------------------------------------------
-- 缩进相关设置
-----------------------------------------------------------------

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "py", "lua" },
	callback = function()
		vim.opt.tabstop = 4 -- the number of visual spaces per TAB
		vim.opt.softtabstop = 4 -- number of spaces in tab when editing
		vim.opt.shiftwidth = 4 -- insert 4 spaces on a tab
		vim.opt.expandtab = true -- tabs are spaces, mainly because of Python
	end,
})
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "c", "cpp", "ocaml" },
	callback = function()
		vim.opt.tabstop = 2 -- the number of visual spaces per TAB
		vim.opt.softtabstop = 2 -- number of spacesin tab when editing
		vim.opt.shiftwidth = 2 -- insert 2 spaces on a tab
		vim.opt.expandtab = true -- tabs are spaces, mainly because of python
	end,
})

-----------------------------------------------------------------
-- UI config
-----------------------------------------------------------------

-- 使用相对行号
vim.opt.number = true -- show absolute number
vim.opt.relativenumber = true -- add numbers to each line on the left side

-- 高亮所在行
vim.opt.cursorline = true -- highlight cursor line underneath the cursor horizontally

-- split window时从下方和右方出现
vim.opt.splitbelow = true -- open new vertical split bottom
vim.opt.splitright = true -- open new horizontal splits right
vim.opt.termguicolors = true -- enable 24-bit RGB color in the TUI

-- 使用增强状态栏后不再显示vim的模式提示
vim.opt.showmode = false -- we are experienced, and we don't need the "-- INSERT --" mode hint
vim.opt.winborder = "rounded" -- add rounded border for floating window

-----------------------------------------------------------------
-- 搜索相关设置
-----------------------------------------------------------------

-- 边输入边搜索
vim.opt.incsearch = true -- search as characters are entered
-- 不高亮搜索
vim.opt.hlsearch = false -- do not highlight matches
-- 搜索大小不敏感，除非包含大写
vim.opt.ignorecase = true -- ignore case in searches by default
vim.opt.smartcase = true -- but make it case sensitive if an uppercase is entered
