-- Set the preferred colorscheme
local colorscheme = "bamboo"

-- Try to apply the colorscheme safely
local status, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)

if not status then
	-- If the colorscheme is not found, show a notification
	vim.notify("colorscheme " .. colorscheme .. " not found!")
	return
end
