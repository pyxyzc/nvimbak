return {
    "akinsho/toggleterm.nvim",
    version = "*",
    opts = {
        shell = "/bin/bash",
        start_in_insert = true,
        direction = "horizontal",
        shade_terminals = true,
        shading_factor = 2,
    },
    config = function(_, opts)
        local toggleterm = require("toggleterm")
        toggleterm.setup(opts)

        local Terminal = require("toggleterm.terminal").Terminal
        local terms = {}

        -- Check if the terminal window is currently open (visible)
        local function is_open(term)
            local wins = vim.api.nvim_list_wins()
            for _, win in ipairs(wins) do
                if vim.api.nvim_win_get_buf(win) == term.bufnr then
                    return true
                end
            end
            return false
        end

        -- Toggle the terminal with a specific id
        local function toggle_term(id)
            if not terms[id] then
                terms[id] = Terminal:new({
                    direction = "horizontal",
                    count = id,
                })
            end
            terms[id]:toggle()
        end

        -- Toggle the last hidden terminal, or create a new one if all are visible
        local function toggle_last_hidden_or_new()
            for id, term in ipairs(terms) do
                if term and not is_open(term) then
                    term:toggle()
                    return
                end
            end
            -- All terminals are visible, create a new one
            local new_id = #terms + 1
            toggle_term(new_id)
        end

        -- Kill (close) all existing terminals
        local function kill_all_terms()
            for _, term in ipairs(terms) do
                if term then
                    term:close()
                end
            end
            -- Clear the terminals table
            terms = {}
            print("All terminals killed")
        end

        -- Show a popup listing all terminal IDs
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

            local msg = "Current terminal IDs: " .. table.concat(ids, ", ")
            -- Use vim.notify for popup message
            vim.notify(msg, vim.log.levels.INFO, { title = "ToggleTerm Info" })
        end

        -- Map <leader>1t through <leader>9t to toggle terminals 1-9
        for i = 1, 9 do
            vim.keymap.set("n", string.format("<leader>%dt", i), function()
                toggle_term(i)
            end, { desc = "Toggle terminal " .. i })
        end

        -- Map <leader>t to toggle the last hidden terminal or create a new one
        vim.keymap.set("n", "<leader>t", toggle_last_hidden_or_new, { desc = "Toggle last hidden or new terminal" })

        -- Map <leader>tk to kill all terminals
        vim.keymap.set("n", "<leader>tk", kill_all_terms, { desc = "Kill all terminals" })

        -- Map <leader>ti to show current terminal IDs popup
        vim.keymap.set("n", "<leader>ti", show_terminals_info, { desc = "Show terminal IDs info" })

        -- Map <Esc> in terminal mode to exit to normal mode
        vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { desc = "Exit terminal mode" })
    end,
}
