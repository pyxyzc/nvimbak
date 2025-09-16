function my_paste(reg)
	return function(lines)
		-- Return the contents of the "" register, used as the paste source for the 'p' operator
		local content = vim.fn.getreg('"')
		return vim.split(content, "\n")
	end
end

-- Only enable copy functionality, paste will be handled by Ctrl+V in insert mode

-- Check environment variable to detect if it's a local environment
if os.getenv("SSH_TTY") == nil then
	-- Local environment (including WSL)
	vim.opt.clipboard:append("unnamedplus")
else
	vim.opt.clipboard:append("unnamedplus")
	-- Use OSC 52 protocol for clipboard transfer
	vim.g.clipboard = {
		name = "OSC 52",
		copy = {
			["+"] = require("vim.ui.clipboard.osc52").copy("+"),
			["*"] = require("vim.ui.clipboard.osc52").copy("*"),
		},
		paste = {
			-- Custom paste: avoid reading local clipboard via OSC 52
			-- Always return the contents of the "" register
			-- The parameter inside parentheses may be meaningless, 
			-- but keeping it as-is makes it look more consistent
			["+"] = my_paste("+"),
			["*"] = my_paste("*"),
		},
	}
end
