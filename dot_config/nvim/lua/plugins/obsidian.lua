return {
  -- "srackham/obsidian.nvim",
  "obsidian-nvim/obsidian.nvim", -- A community fork of epwalsh/obsidian.nvim
  -- version = "*",                 -- Use latest release instead of latest commit
  lazy = true,
  ft = "markdown",
  dependencies = {
    "nvim-lua/plenary.nvim",
    'nvim-telescope/telescope.nvim',
  },
  config = function()
    local obsidian = require 'obsidian'
    obsidian.setup {
      workspaces = {
        {
          -- PKM notes
          name = "notes",
          path = "~/share/notes",
        },
        {
          -- Legacy and non-PKM-related documents
          name = "doc",
          path = "~/share/doc",
        },
      },
      attachments = {
        img_folder = "images",
        img_name_func = function()
          return "" -- No default file name
        end,
        -- FIX: Leave path separators in encoded paths (see https://github.com/obsidian-nvim/obsidian.nvim/issues/119)
        img_text_func = function(client, path)
          path = client:vault_relative_path(path) or path
          local caption = vim.fs.basename(tostring(path))
          caption = caption:match("^(.*)%.([^%.]*)$") or caption -- Strip file name extension
          local encoded_path = vim.uri_from_fname(tostring(path))
          encoded_path = encoded_path:match("^file://(.*)")      -- Strip leading 'file://'
          return string.format("![%s](%s)", caption, encoded_path)
        end,
      },
      templates = {
        folder = "templates",
        date_format = "%Y-%m-%d-%a",
        time_format = "%H:%M",
      },
      completion = {
        blink = true,  -- Enables completion using blink.cmp
        min_chars = 0, -- Completion trigger length
      },
      daily_notes = {
        folder = "journal",
        workdays_only = false,
      },
      note_id_func = function(title)
        local current_dir = vim.fn.getcwd() -- Assume the new note will reside in Neovim's current working directory
        local id = Utils.slugify(title or "untitled", current_dir, ".md")
        return id
      end,
      picker = {
        -- Set preferred picker. Can be one of 'telescope.nvim' (default), 'fzf-lua', 'mini.pick' or 'snacks.pick'.
        name = "telescope.nvim",
      },
    }
    vim.keymap.set('n', '<Leader>os', "<Cmd>ObsidianTOC<CR>", { desc = "Markdown section headers picker" })
    vim.keymap.set('n', '<Leader>oj', "<Cmd>ObsidianToday<CR>", { desc = "Open today's journal note" })
    vim.keymap.set('n', '<Leader>oi', "<Cmd>ObsidianPasteImg<CR>", { desc = "Insert image from clipboard" })
    vim.keymap.set('n', '<Leader>on', "<Cmd>ObsidianNew<CR>", { desc = "New note" })
    vim.keymap.set('n', '<Leader>oN', "<Cmd>ObsidianTemplate<CR>", { desc = "New note from template" })
    vim.keymap.set('n', '<Leader>oo', "<Cmd>ObsidianOpen<CR>", { desc = "Open note in Obsidian application" })
    vim.keymap.set('n', '<Leader>of', "<Cmd>ObsidianQuickSwitch<CR>", { desc = "Notes file picker" })
    vim.keymap.set('n', '<Leader>og', "<Cmd>ObsidianSearch<CR>", { desc = "Search notes files with ripgrep" })
    vim.keymap.set('n', '<Leader>ot', "<Cmd>ObsidianTags<CR>", { desc = "Search for tagged notes" })
    -- Links related commands
    vim.keymap.set('n', ']l', [[/\vhttp(s?):\/\/\S+|[[..{-}\]\]|[..{-}\]\(..{-}\)<CR>]],
      { desc = "Jump to next link" })     -- URL, Markdown link, Wiki link
    vim.keymap.set('n', '[l', [[?\vhttp(s\?)://\S+|[[..{-}\]\]|[..{-}\]\(..{-}\)<CR>]],
      { desc = "Jump to previous link" }) -- URL, Markdown link, Wiki link
    vim.keymap.set('n', '<Leader>ll', "<Cmd>ObsidianLinks<CR>", { desc = "Links picker" })
    vim.keymap.set('n', '<Leader>lb', "<Cmd>ObsidianBacklinks<CR>", { desc = "Backlinks picker" })
    vim.keymap.set('v', '<Leader>le', ":ObsidianLink<CR>",
      { desc = "Replace selected note ID, path or alias with a link to an existing note" })
    vim.keymap.set('v', '<Leader>ln', ":ObsidianLinkNew<CR>",
      { desc = "Replace selected note title of with a link to a new note" })
  end,
}
