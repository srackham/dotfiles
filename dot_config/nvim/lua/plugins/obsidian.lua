return {
  -- "srackham/obsidian.nvim",
  -- branch = "case_insensitive_tag_picker",

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
          -- Notes (main vault)
          name = "notes",
          path = "~/share/notes",
        },
        {
          -- Legacy and non-PKM-related documents
          name = "doc",
          path = "~/share/doc",
        },
        {
          -- For Obsidian experimentation and testing
          name = "experimentation",
          path = "~/projects/obsidian-experimentation",
          overrides = {
            templates = {
              folder = vim.NIL,
            },
          },
        },
        {
          -- For Obsidian experimentation and testing on local (non-NFS) drive
          name = "local-experimentation",
          path = "~/local/obsidian-experimentation",
          overrides = {
            templates = {
              folder = vim.NIL,
            },
          },
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
        date_format = "%Y-%m-%d",
        time_format = "%H:%M",
      },
      completion = {
        blink = true,  -- Enables completion using blink.cmp
        min_chars = 0, -- Completion trigger length
      },
      daily_notes = {
        folder = "journal",
        date_format = "journal-%Y-%m-%d",
        workdays_only = false,
        template = "journal.md",
        default_tags = {}, -- The default tags are in the template
      },
      note_id_func = function(title)
        Obsidian = Obsidian -- Kudge to suppress spurious LSP "Undefined global `Obsidian`" warning in next statement
        local dir = Obsidian.dir.filename
        local id = Utils.slugify(title or "untitled", dir, ".md")
        return id
      end,
      picker = {
        -- Set preferred picker. Can be one of 'telescope.nvim' (default), 'fzf-lua', 'mini.pick' or 'snacks.pick'.
        name = "telescope.nvim",
      },
      legacy_commands = false,
      footer = { enabled = false, },
      checkbox = { create_new = false }, -- Don't create checkbox on list item when Enter is pressed (https://github.com/orgs/obsidian-nvim/discussions/228#discussioncomment-14798465)
    }

    vim.api.nvim_create_autocmd("FileType", {
      pattern = "markdown",
      callback = function()
        vim.keymap.set('n', '<Leader>os', "<Cmd>Obsidian toc<CR>", { desc = "Obsidian section headers picker" })
        vim.keymap.set('n', '<Leader>ot', "<Cmd>Obsidian tomorrow<CR>", { desc = "Open/create tomorrow's journal note" })
        vim.keymap.set('n', '<Leader>oj', "<Cmd>Obsidian dailies<CR>", { desc = "Open/create daily journal note" })
        vim.keymap.set('n', '<Leader>oi', "<Cmd>Obsidian paste_img<CR>", { desc = "Insert image from clipboard" })
        vim.keymap.set('n', '<Leader>on', "<Cmd>Obsidian new<CR>", { desc = "New note" })
        vim.keymap.set('n', '<Leader>oN', "<Cmd>Obsidian new_from_template<CR>", { desc = "New note from template" })
        vim.keymap.set('n', '<Leader>oT', "<Cmd>Obsidian template<CR>", { desc = "Insert template" })
        vim.keymap.set('n', '<Leader>oo', "<Cmd>Obsidian open<CR>", { desc = "Open note in Obsidian application" })
        vim.keymap.set('n', '<Leader>of', "<Cmd>Obsidian quick_switch<CR>", { desc = "Notes file picker" })
        vim.keymap.set('n', '<Leader>og', "<Cmd>Obsidian search<CR>", { desc = "Search notes files with ripgrep" })
        vim.keymap.set('n', '<Leader>oR', "<Cmd>Obsidian rename<CR>",
          { desc = "Rename current note or the note referenced under the cursor" })
        vim.keymap.set('n', '<Leader>ot', "<Cmd>Obsidian tags<CR>", { desc = "Search for tagged notes" })
        -- Link related commands
        vim.keymap.set('n', ']l', [[/\vhttp(s?):\/\/\S+|[[..{-}\]\]|[..{-}\]\(..{-}\)<CR>]],
          { desc = "Jump to next link" })     -- URL, Markdown link, Wiki link
        vim.keymap.set('n', '[l', [[?\vhttp(s\?)://\S+|[[..{-}\]\]|[..{-}\]\(..{-}\)<CR>]],
          { desc = "Jump to previous link" }) -- URL, Markdown link, Wiki link
        vim.keymap.set('n', '<Leader>ol', "<Cmd>Obsidian links<CR>", { desc = "Links picker" })
        vim.keymap.set('n', '<Leader>ob', "<Cmd>Obsidian backlinks<CR>", { desc = "Backlinks picker" })
        vim.keymap.set('v', '<Leader>oe', ":Obsidian link<CR>",
          { desc = "Replace selected note ID, path or alias with a link to an existing note" })
        vim.keymap.set('v', '<Leader>oL', ":Obsidian link_new<CR>",
          { desc = "Replace selected note title of with a link to a new note" })
      end,
      once = true
    })
  end,
}
