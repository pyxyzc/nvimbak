local status, toggleterm = pcall(require, "toggleterm")
if not status then
    return
end

-- Detect system type to set appropriate shell
local uname = vim.loop.os_uname().system
local shell = "/bin/bash"

if uname == "Darwin" or vim.fn.has("macunix") == 1 then
    shell = "/bin/zsh"
elseif uname == "Windows_NT" or vim.fn.has("win32") == 1 then
    shell = "powershell.exe"
end

-- ToggleTerm basic options
local opts = {
    shell = shell,
    start_in_insert = true,
    direction = "horizontal",
    shade_terminals = true,
    shading_factor = 2,
}

local toggleterm = require("toggleterm")
toggleterm.setup(opts)

local Terminal = require("toggleterm.terminal").Terminal
local terms = {}
local default_height = math.floor(vim.o.lines * 0.35)
local maximized = false

-- Check if a terminal window is currently open
local function is_open(term)
    local wins = vim.api.nvim_list_wins()
    for _, win in ipairs(wins) do
        if vim.api.nvim_win_get_buf(win) == term.bufnr then
            return true
        end
    end
    return false
end

-- Toggle a specific terminal by ID
local function toggle_term(id)
    if not terms[id] then
        terms[id] = Terminal:new({
            direction = "horizontal",
            count = id,
        })
    end
    terms[id]:toggle()
end

-- Toggle the last hidden terminal or create a new one
local function toggle_last_hidden_or_new()
    for id, term in ipairs(terms) do
        if term and not is_open(term) then
            term:toggle()
            return
        end
    end
    toggle_term(#terms + 1)
end

-- Kill (close) all existing terminals
local function kill_all_terms()
    for _, term in ipairs(terms) do
        if term then
            term:close()
        end
    end
    terms = {}
    print("All terminals killed")
end

-- Show a list of all created terminal IDs
local function show_terminals_info()
    if vim.tbl_isempty(terms) then
        print("No terminals created yet")
        return
    end

    local ids = {}
    for id, _ in pairs(terms) do
        table.insert(ids, tostring(id))
    end
    table.sort(ids)
    vim.notify("Current terminal IDs: " .. table.concat(ids, ", "), vim.log.levels.INFO, { title = "ToggleTerm Info" })
end

-- Maximize all visible terminal windows
local function maximize_all_terms()
    local wins = vim.api.nvim_list_wins()
    local ui_height = vim.o.lines - vim.o.cmdheight - 2
    for _, win in ipairs(wins) do
        local buf = vim.api.nvim_win_get_buf(win)
        local buf_name = vim.api.nvim_buf_get_name(buf)
        if buf_name:match("term://") then
            vim.api.nvim_win_set_height(win, ui_height)
        end
    end
    maximized = true
    vim.notify("All terminal windows maximized", vim.log.levels.INFO, { title = "ToggleTerm" })
end

-- Restore terminal windows to their default height
local function restore_all_terms()
    local wins = vim.api.nvim_list_wins()
    for _, win in ipairs(wins) do
        local buf = vim.api.nvim_win_get_buf(win)
        local buf_name = vim.api.nvim_buf_get_name(buf)
        if buf_name:match("term://") then
            vim.api.nvim_win_set_height(win, default_height)
        end
    end
    maximized = false
    vim.notify("All terminal windows restored to default height", vim.log.levels.INFO, { title = "ToggleTerm" })
end

-- Hide all terminal windows (without deleting them)
local function hide_all_terms()
    local hidden_count = 0
    for _, term in ipairs(terms) do
        if term and is_open(term) then
            term:close()
            hidden_count = hidden_count + 1
        end
    end

    if hidden_count > 0 then
        vim.notify("All terminal windows hidden", vim.log.levels.INFO, { title = "ToggleTerm" })
    else
        vim.notify("No terminals are currently open", vim.log.levels.INFO, { title = "ToggleTerm" })
    end
end

-- ===========================
-- Keybinding Configuration
-- ===========================
local pluginKeys = {}

pluginKeys.toggletermList = {
    n = {
        ["<leader>t"]  = { toggle_last_hidden_or_new, "Toggle last hidden or create new terminal" },
        ["<leader>tk"] = { kill_all_terms, "Kill all terminals" },
        ["<leader>ti"] = { show_terminals_info, "Show terminal IDs" },
        ["<leader>tm"] = { maximize_all_terms, "Maximize all terminal windows" },
        ["<leader>tr"] = { restore_all_terms, "Restore all terminal heights" },
        ["<leader>th"] = { hide_all_terms, "Hide all terminal windows" },
    },

    -- Terminal mode mappings (buffer-local)
    t = {
        ["<Esc>"] = {
            function()
                local buf_name = vim.api.nvim_buf_get_name(0)
                -- If this is lazygit or another TUI app, do not intercept <Esc>
                if buf_name:match("lazygit") or buf_name:match("fzf") or buf_name:match("lazyman") then
                    return "<Esc>"
                end
                -- Otherwise, exit terminal mode
                return "<C-\\><C-n>"
            end,
            "Exit terminal mode safely",
            { expr = true, noremap = true, silent = true },
        },
    },
}

-- Dynamically generate <leader>1t to <leader>9t keymaps
for i = 1, 9 do
    pluginKeys.toggletermList.n[string.format("<leader>%dt", i)] = {
        function() toggle_term(i) end,
        "Toggle terminal " .. i,
    }
end

-- Register all normal-mode mappings
for mode, mappings in pairs(pluginKeys.toggletermList) do
    -- Skip terminal mode here, since it’s buffer-local
    if mode ~= "t" then
        for key, map in pairs(mappings) do
            vim.keymap.set(mode, key, map[1], { desc = map[2], noremap = true, silent = true })
        end
    end
end

-- Apply terminal-mode mappings when a terminal opens
vim.api.nvim_create_autocmd("TermOpen", {
    pattern = "term://*",
    callback = function()
        local term_mappings = pluginKeys.toggletermList.t or {}
        for key, map in pairs(term_mappings) do
            local opts = vim.tbl_extend("force", { buffer = 0 }, map[3] or {})
            vim.keymap.set("t", key, map[1], opts)
        end
    end,
})
