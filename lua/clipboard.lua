function my_paste(reg)
	return function(lines)
		-- 返回 "" 寄存器的内容，用来作为 p 操作符的粘贴物
		local content = vim.fn.getreg('"')
		return vim.split(content, "\n")
	end
end

-- 只需要开启复制功能，不需要粘贴功能
-- 粘贴直接由 insert 模式下 Ctrl+V 实现

-- 通过环境变量检查是否是本地环境
if os.getenv("SSH_TTY") == nil then
	-- 当前环境为本地环境，包括 wsl
	vim.opt.clipboard:append("unnamedplus")
else
	vim.opt.clipboard:append("unnamedplus")
	-- 使用 OSC 52 协议传输剪贴板
	vim.g.clipboard = {
		name = "OSC 52",
		copy = {
			["+"] = require("vim.ui.clipboard.osc52").copy("+"),
			["*"] = require("vim.ui.clipboard.osc52").copy("*"),
		},
		paste = {
            -- 自定义 paste，规避 OSC 52 读取本地剪贴板的内容
            -- 直接返回 "" 寄存器的内容
			-- 小括号里面的内容可能是毫无意义的，但是保持原样可能看起来更好一点
			["+"] = my_paste("+"),
			["*"] = my_paste("*"),
		},
	}
end
