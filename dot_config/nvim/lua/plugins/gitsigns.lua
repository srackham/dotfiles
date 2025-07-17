return {
  'lewis6991/gitsigns.nvim',
  config = function()
    local gitsigns = require('gitsigns')
    gitsigns.setup()

    -- Navigation
    vim.keymap.set('n', ']g', function()
      if vim.wo.diff then
        vim.cmd.normal({ ']g', bang = true })
      else
        gitsigns.nav_hunk('next')
      end
    end, { desc = "Next hunk" })

    vim.keymap.set('n', '[g', function()
      if vim.wo.diff then
        vim.cmd.normal({ '[g', bang = true })
      else
        gitsigns.nav_hunk('prev')
      end
    end, { desc = "Previous hunk" })

    -- Actions
    vim.keymap.set('n', '<Leader>gb', gitsigns.toggle_current_line_blame, { desc = "Toggle line blame" })
    vim.keymap.set('n', '<Leader>gd', gitsigns.toggle_deleted, { desc = "Toggle deleted lines" })
    vim.keymap.set('n', '<Leader>gp', gitsigns.preview_hunk, { desc = "Preview hunk" })
    vim.keymap.set('n', '<Leader>gR', gitsigns.reset_buffer, { desc = "Reset all hunks in current buffer" })
    vim.keymap.set('n', '<Leader>gr', gitsigns.reset_hunk, { desc = "Reset hunk" })
    vim.keymap.set('n', '<Leader>gS', gitsigns.stage_buffer, { desc = "Stage all hunks in current buffer" })
    vim.keymap.set('n', '<Leader>gs', gitsigns.stage_hunk, { desc = "Stage hunk" })
    vim.keymap.set('n', '<Leader>gt', function()
      local enabled = gitsigns.toggle_signs()
      local status = enabled and "enabled" or "disabled"
      vim.notify("Git signs " .. status)
    end, { desc = "Toggle Git signs" })
    vim.keymap.set('n', '<Leader>gu', gitsigns.undo_stage_hunk, { desc = "Undo staged hunk" })

    -- Git hunks picker
    local git_hunks = function()
      require("telescope.pickers").new({
        finder = require("telescope.finders").new_oneshot_job({ "git", "jump", "--stdout", "diff" }, {
          entry_maker = function(line)
            local filename, lnum_string = line:match("([^:]+):(%d+).*")
            if filename:match("^/dev/null") then return nil end
            return {
              value = filename,
              display = line,
              ordinal = line,
              filename = filename,
              lnum = tonumber(lnum_string),
            }
          end,
        }),
        sorter = require("telescope.sorters").get_generic_fuzzy_sorter(),
        previewer = require("telescope.config").values.grep_previewer({}),
        results_title = "Git hunks",
        prompt_title = "Git hunks",
        layout_strategy = "flex",
      }, {}):find()
    end
    vim.keymap.set("n", "<Leader>gh", git_hunks, { desc = "Git hunks picker" })

    vim.api.nvim_set_hl(0, 'GitSignsCurrentLineBlame', { fg = '#999999' })
    vim.api.nvim_set_hl(0, "DiffDelete", { bg = "#400000", fg = "#ffffff" })
  end,
}
