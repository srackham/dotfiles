return {
  {
    "nvim-telescope/telescope.nvim",
    -- tag = '0.1.8',
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      local telescope = require "telescope"
      local builtin = require "telescope.builtin"

      telescope.setup {
        -- Default layout
        defaults = {
          layout_strategy = "horizontal",
          layout_config = {
            width = 0.95,
            height = 0.8,
            horizontal = {
              preview_cutoff = 100,
              prompt_position = "bottom",
              -- width = { padding = 0 },  -- Use full width
              -- height = { padding = 0 }, -- Use full height
              preview_width = 0.5, -- Preview width as a fraction of the total width
            },
            vertical = {
              -- width = { padding = 0 },
              -- height = { padding = 0 },
              preview_height = 0.5,
            },
          },
        },
      }

      -- Wrap text in the preview window
      vim.api.nvim_create_autocmd("User", {
        pattern = "TelescopePreviewerLoaded",
        callback = function(_)
          vim.wo.wrap = true
        end,
      })

      -- Key bindings
      local list_buffers = function()
        vim.cmd "OutlineFocusCode"
        builtin.buffers { sort_mru = true, ignore_current_buffer = true }
      end
      local list_oldfiles = function()
        vim.cmd "OutlineFocusCode"
        builtin.oldfiles { sort_mru = true, ignore_current_buffer = true }
      end
      local find_files = function()
        vim.cmd "OutlineFocusCode"
        builtin.find_files {
          find_command = { "rg", "--files", "--hidden", "--sortr", "modified" },
        }
      end
      local live_grep = function(additional_args)
        vim.cmd "OutlineFocusCode"
        vim.cmd "wa"
        vim.list_extend({ "--hidden" }, additional_args or {})
        builtin.live_grep {
          additional_args = additional_args,
        }
      end
      vim.keymap.set({ "n", "v" }, "<Leader>bb", list_buffers, { desc = "List buffers" })
      vim.keymap.set({ "n", "v" }, "<Leader>.", list_buffers, { desc = "List buffers" })
      vim.keymap.set({ "n", "v" }, "<Leader>fo", list_oldfiles, { desc = "List previously opened files" })
      vim.keymap.set({ "n", "v" }, "<Leader>ff", find_files, { desc = "Find files" })
      vim.keymap.set({ "n", "v" }, "<Leader>fF", function()
        builtin.find_files {
          hidden = true,
          no_ignore = true,
        }
      end, { desc = "Find all files (hidden and those in .gitignore)" })
      vim.keymap.set({ "n", "v" }, "<Leader>fg", live_grep, { desc = "Live-grep files (includes hidden files)" })
      vim.keymap.set({ "n", "v" }, "<Leader>fG", function()
        live_grep { "--no-ignore" }
      end, { desc = "Live-grep files (includes hidden and .gitignore files)" })

      vim.keymap.set({ "n", "v" }, "<Leader>fh", builtin.highlights, { desc = "List highlights" })
      vim.keymap.set({ "n", "v" }, "<Leader>fk", builtin.keymaps, { desc = "List normal mode key mappings" })
      vim.keymap.set({ "n", "v" }, "<Leader>fW", builtin.grep_string, { desc = "Search files for word or selection" })
      vim.keymap.set({ "n", "v" }, "<leader>fw", function()
        builtin.grep_string {
          word_match = "-w",
          additional_args = { "--case-sensitive" },
        }
      end, { desc = "Case sensitive search for whole word under cursor" })

      vim.keymap.set({ "n", "v" }, "<Leader>dl", function()
        builtin.diagnostics { bufnr = 0 }
      end, { desc = "List diagnostic messages in current buffer" })

      vim.keymap.set({ "n", "v" }, "<Leader>da", builtin.diagnostics, { desc = "List diagnostic messages in all files" })
      vim.keymap.set({ "n", "v" }, "<Leader>fr", builtin.resume, { desc = "Resume last Telescope picker" })
      vim.keymap.set({ "n", "v" }, "<Leader>hh", builtin.help_tags, { desc = "Search documentation" })
      vim.keymap.set({ "n", "v" }, "<Leader>fp", function()

        builtin.live_grep {
          cwd = vim.fn.stdpath "data" .. "/lazy/",
        }
      end, { desc = "Live-grep plugin files" })

      vim.keymap.set({ "n", "v" }, "<Leader>cr", function()
        vim.cmd "update" -- Write modified buffer
        builtin.lsp_references()
      end, { desc = "List references to word under cursor" })
      local symbols = {
        "function",
        "method",
        "constructor",
        "class",
        "interface",
        "struct",
        "enum",
        "constant",
        "type",
      }

      vim.keymap.set({ "n", "v" }, "<Leader>cs", function()
        require("telescope.builtin").lsp_document_symbols { symbols = symbols }
      end, { noremap = true, silent = true, desc = "List symbols" })

      vim.keymap.set({ "n", "v" }, "<Leader>cS", function()
        require("telescope.builtin").lsp_dynamic_workspace_symbols { symbols = symbols }
      end, { noremap = true, silent = true, desc = "Live-grep workspace symbols" })

      local function inject_file()
        -- local builtin = require "telescope.builtin"
        local actions = require "telescope.actions"
        local action_state = require "telescope.actions.state"

        -- Helper to check if a file is binary
        local function is_binary(path)
          local f = io.open(path, "rb")
          if not f then
            return false
          end
          local bytes = f:read(1024)
          f:close()
          return bytes and bytes:find "\0" ~= nil
        end

        builtin.find_files {
          prompt_title = "Inject Text File(s)",
          attach_mappings = function(picker_bufnr, map)
            -- Allow TAB to mark multiple files
            map("i", "<Tab>", actions.toggle_selection + actions.move_selection_next)
            map("n", "<Tab>", actions.toggle_selection + actions.move_selection_next)

            actions.select_default:replace(function()
              local picker = action_state.get_current_picker(picker_bufnr)
              local multi = picker:get_multi_selection()

              -- If no multi-selection, use the current entry
              if #multi == 0 then
                local single = action_state.get_selected_entry()
                if single then
                  table.insert(multi, single)
                end
              end

              actions.close(picker_bufnr)

              if #multi == 0 then
                return
              end

              for _, entry in ipairs(multi) do
                local injection = {}
                local file_path = entry.value

                if is_binary(file_path) then
                  vim.notify("Skipped binary file: " .. file_path, vim.log.levels.WARN)
                else
                  local file_ext = vim.fn.fnamemodify(file_path, ":e")
                  local lines = vim.fn.readfile(file_path)

                  table.insert(injection, "")
                  table.insert(injection, "`" .. file_path .. "`")
                  table.insert(injection, "")
                  table.insert(injection, "```" .. file_ext)

                  for _, line in ipairs(lines) do
                    table.insert(injection, line)
                  end

                  table.insert(injection, "```")
                  table.insert(injection, "")

                  local row, _ = unpack(vim.api.nvim_win_get_cursor(0))
                  vim.api.nvim_buf_set_lines(0, row, row, false, injection)

                  local new_row = row + #injection
                  vim.api.nvim_win_set_cursor(0, { new_row, 0 })
                end
              end
            end)

            return true
          end,
        }
      end
      vim.keymap.set({ "n", "v" }, "<Leader>fi", inject_file, { noremap = true, silent = true, desc = "Inject text files" })

    end,
  },

  -- Telescope extensions
  {
    "nvim-telescope/telescope-ui-select.nvim",
    config = function()
      local telescope = require "telescope"
      local actions = require "telescope.actions"
      telescope.setup {
        pickers = {
          find_files = {
            hidden = true,
          },
          highlights = {
            layout_strategy = "vertical",
          },
        },
        defaults = {
          file_ignore_patterns = { "^.git/", "^node_modules/" },
          mappings = {
            i = {
              ["<Esc>"] = actions.close,
            },
          },
        },
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown {},
          },
        },
      }
      require("telescope").load_extension "ui-select"
    end,
  },
  {
    "crispgm/telescope-heading.nvim",
    config = function()
      local telescope = require "telescope"
      telescope.setup {
        extensions = {
          heading = {
            treesitter = true,
            picker_opts = {
              layout_config = {
                preview_width = 0.6,
              },
              sorting_strategy = "ascending",
            },
          },
        },
      }
      telescope.load_extension "heading"
      vim.keymap.set({ "n", "v" }, "<Leader>ms", telescope.extensions.heading.heading, { desc = "Markdown section headers picker" })
    end,
  },
}
