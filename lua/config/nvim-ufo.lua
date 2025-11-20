-- Basic global folding settings
vim.o.foldcolumn = "1"        -- Show fold column
vim.o.foldlevel = 99          -- Do not close folds by default
vim.o.foldlevelstart = 99
vim.o.foldenable = true

-- Use Treesitter as fold expr (fallback when LSP/indent not used)
vim.o.foldmethod = "expr"
vim.o.foldexpr = "nvim_treesitter#foldexpr()"

-- Custom virtual text handler for folded lines
local handler = function(virtText, lnum, endLnum, width, truncate)
    local newVirtText = {}
    local suffix = (' 󰁂 %d '):format(endLnum - lnum)
    local sufWidth = vim.fn.strdisplaywidth(suffix)
    local targetWidth = width - sufWidth
    local curWidth = 0

    for _, chunk in ipairs(virtText) do
        local chunkText = chunk[1]
        local chunkWidth = vim.fn.strdisplaywidth(chunkText)

        if targetWidth > curWidth + chunkWidth then
            table.insert(newVirtText, chunk)
        else
            chunkText = truncate(chunkText, targetWidth - curWidth)
            local hlGroup = chunk[2]
            table.insert(newVirtText, { chunkText, hlGroup })
            chunkWidth = vim.fn.strdisplaywidth(chunkText)

            -- Padding if needed
            if curWidth + chunkWidth < targetWidth then
                suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
            end
            break
        end

        curWidth = curWidth + chunkWidth
    end

    table.insert(newVirtText, { suffix, 'MoreMsg' })
    return newVirtText
end

-- Filetype → provider mapping
local ftMap = {
    vim = 'indent',
    python = { 'indent' },
    git = '',
}

local ok, ufo = pcall(require, "ufo")
if not ok then
    return
end

ufo.setup({
    fold_virt_text_handler = handler,
    open_fold_hl_timeout = 150,

    -- Auto close some kinds of folds for specific filetypes
    close_fold_kinds_for_ft = {
        default = { 'imports', 'comment' },
        json = { 'array' },
        c = { 'comment', 'region' },
    },

    -- Whether to close folds on current line for specific filetypes
    close_fold_current_line_for_ft = {
        default = true,
        c = false,
    },

    preview = {
        win_config = {
            border = { '', '─', '', '', '', '─', '', '' },
            winhighlight = 'Normal:Folded',
            winblend = 0,
        },
        mappings = {
            scrollU = '<C-u>',
            scrollD = '<C-d>',
            jumpTop = '[',
            jumpBot = ']',
        },
    },

    -- Choose provider per filetype
    provider_selector = function(bufnr, filetype, buftype)
        local provider = ftMap[filetype]
        if provider ~= nil and provider ~= '' then
            return provider
        end
        -- Fallback: use LSP → Treesitter → indent
        return { 'lsp', 'treesitter', 'indent' }
    end,
})

-- Keymaps
local map = vim.keymap.set

-- Open/close folds
map('n', 'zR', ufo.openAllFolds, { desc = 'Open all folds' })
map('n', 'zM', ufo.closeAllFolds, { desc = 'Close all folds' })
map('n', 'zr', ufo.openFoldsExceptKinds, { desc = 'Open folds except some kinds' })
map('n', 'zm', ufo.closeFoldsWith, { desc = 'Close folds with level' }) -- closeAllFolds == closeFoldsWith(0)

-- Peek folded lines / hover
map('n', 'K', function()
    local winid = ufo.peekFoldedLinesUnderCursor()
    if not winid then
        -- Use Coc hover if available, otherwise use built-in LSP hover
        if vim.fn.exists(':CocActionAsync') == 1 then
            vim.fn.CocActionAsync('definitionHover')
        else
            vim.lsp.buf.hover()
        end
    end
end, { desc = 'Peek fold or hover' })
