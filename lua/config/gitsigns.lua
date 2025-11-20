local is_ok, gitsigns = pcall(require, 'gitsigns')
if not is_ok then
    return
end

gitsigns.setup({
    ---------------------------------------------------------------------------
    -- Signs displayed in the gutter
    ---------------------------------------------------------------------------
    signs = {
        add          = { text = '│' },
        change       = { text = '│' },
        delete       = { text = '_' },
        topdelete    = { text = '‾' },
        changedelete = { text = '~' },
        untracked    = { text = '┆' },
    },

    ---------------------------------------------------------------------------
    -- Visual appearance & general behavior
    ---------------------------------------------------------------------------
    signcolumn = true,       -- Toggle via :Gitsigns toggle_signs
    numhl = false,           -- Toggle via :Gitsigns toggle_numhl
    linehl = false,          -- Toggle via :Gitsigns toggle_linehl
    word_diff = false,       -- Toggle via :Gitsigns toggle_word_diff

    ---------------------------------------------------------------------------
    -- Performance & file watching
    ---------------------------------------------------------------------------
    watch_gitdir = { interval = 1000, follow_files = true },
    attach_to_untracked = true,
    sign_priority = 6,
    update_debounce = 100,
    max_file_length = 40000, -- Disable gitsigns for very large files (in lines)

    ---------------------------------------------------------------------------
    -- Current line blame settings
    ---------------------------------------------------------------------------
    current_line_blame = false, -- Toggle via :Gitsigns toggle_current_line_blame
    current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = 'eol',    -- 'eol' | 'overlay' | 'right_align'
        delay = 1000,
        ignore_whitespace = false,
    },
    current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',

    ---------------------------------------------------------------------------
    -- Preview window configuration
    ---------------------------------------------------------------------------
    preview_config = {
        border = 'single',
        style = 'minimal',
        relative = 'cursor',
        row = 0,
        col = 1,
    },

    ---------------------------------------------------------------------------
    -- Keybindings: buffer-local mappings set on attach
    ---------------------------------------------------------------------------
    on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        -- Helper function to simplify mappings and automatically set buffer scope
        local function map(mode, lhs, rhs, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, lhs, rhs, opts)
        end

        -------------------------------------------------------------------------
        -- Hunk navigation
        -- ]c / [c: jump to next/previous hunk
        -- Fall back to built-in diff mappings if in diff mode
        -------------------------------------------------------------------------
        map('n', ']c', function()
            if vim.wo.diff then
                vim.cmd.normal({ ']c', bang = true })
            else
                gs.nav_hunk('next')
            end
        end, { desc = 'Gitsigns: Next hunk' })

        map('n', '[c', function()
            if vim.wo.diff then
                vim.cmd.normal({ '[c', bang = true })
            else
                gs.nav_hunk('prev')
            end
        end, { desc = 'Gitsigns: Previous hunk' })

        -------------------------------------------------------------------------
        -- Hunk-level actions
        -------------------------------------------------------------------------
        map('n', '<leader>hs', gs.stage_hunk, { desc = 'Stage current hunk' })
        map('n', '<leader>hr', gs.reset_hunk, { desc = 'Reset current hunk' })

        -- Stage/Reset a visually selected range of lines
        map('v', '<leader>hs', function()
            gs.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
        end, { desc = 'Stage selected hunk' })

        map('v', '<leader>hr', function()
            gs.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
        end, { desc = 'Reset selected hunk' })

        -- Stage/Reset entire buffer
        map('n', '<leader>hS', gs.stage_buffer, { desc = 'Stage entire buffer' })
        map('n', '<leader>hR', gs.reset_buffer, { desc = 'Reset entire buffer' })

        -------------------------------------------------------------------------
        -- Hunk preview
        -------------------------------------------------------------------------
        map('n', '<leader>hp', gs.preview_hunk, { desc = 'Preview hunk (popup)' })
        map('n', '<leader>hi', gs.preview_hunk_inline, { desc = 'Inline hunk preview' })

        -------------------------------------------------------------------------
        -- Blame & Diff operations
        -------------------------------------------------------------------------
        map('n', '<leader>hb', function()
            gs.blame_line({ full = true })
        end, { desc = 'Show full blame info for current line' })

        map('n', '<leader>hd', gs.diffthis, { desc = 'Diff against index' })
        map('n', '<leader>hD', function()
            gs.diffthis('~')
        end, { desc = 'Diff against previous commit (HEAD~)' })

        -------------------------------------------------------------------------
        -- Quickfix lists
        -------------------------------------------------------------------------
        map('n', '<leader>hQ', function()
            gs.setqflist('all')
        end, { desc = 'Send all changes to quickfix list' })

        map('n', '<leader>hq', gs.setqflist, { desc = 'Send current file changes to quickfix list' })

        -------------------------------------------------------------------------
        -- Toggles
        -------------------------------------------------------------------------
        map('n', '<leader>tb', gs.toggle_current_line_blame, { desc = 'Toggle line blame' })
        map('n', '<leader>tw', gs.toggle_word_diff, { desc = 'Toggle word diff highlighting' })

        -------------------------------------------------------------------------
        -- Text object
        -- "ih" selects an entire hunk in operator/visual mode
        -- Example: "dih", "yih", "vih"
        -------------------------------------------------------------------------
        map({ 'o', 'x' }, 'ih', gs.select_hunk, { desc = 'Select hunk text object' })
    end,
})
