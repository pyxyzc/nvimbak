return {
	cmd = { "pyright-langserver", "--stdio" }, -- 启动命令
	filetypes = { "python" }, -- 只对 Python 文件生效
	root_markers = {
		"pyproject.toml",
		"setup.py",
		"setup.cfg",
		"requirements.txt",
		"tox.ini",
		".python-version",
		".git",
    },
}
