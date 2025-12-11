-- WezTerm configuration (see https://wezterm.org/config/files.html)

-- Pull in the wezterm API
local wezterm = require 'wezterm'
local act = wezterm.action
local config = wezterm.config_builder()

-- Differentiate active pane
-- As of 02-Dec-2025 the is no way to set the active pane border color, only the HSB value
config.inactive_pane_hsb = {
  saturation = 0.5,
  brightness = 0.5,
}

-- config.window_decorations = "RESIZE" -- FIXME: does not work on Wayland (wezterm 0-unstable-2025-05-18)

-- Fonts
config.font = wezterm.font_with_fallback({
  "JetBrainsMono Nerd Font",
  "Symbols Nerd Font",
  "Noto Color Emoji",
})
config.font_size = 11.0
config.harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' } -- Disable ligatures (https://wezterm.org/config/font-shaping.html)

-- config.color_scheme = 'Argonaut (Gogh)'
config.color_scheme = 'catppuccin-mocha'
config.initial_rows = 50
config.initial_cols = 120
config.audible_bell = 'Disabled'

-- Palette commands are accumulated to this table and then installed at the end of the module.
local palette_commands = {}

-- Utility functions --

-- Return the pane in the active tab with topological index (zero-based) or nil if it does not exist.
local function pane_at_index(window, index)
  local tab = window:active_tab()
  local panes = tab:panes_with_info()
  local target_pane = nil

  for _, pane_info in ipairs(panes) do
    if pane_info.index == index then
      target_pane = pane_info.pane
      break
    end
  end
  return target_pane
end

-- Key bindings
config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 5000 }
config.keys = {
  -- Split horizontally (left/right)
  { key = "s", mods = "LEADER",     action = wezterm.action { SplitHorizontal = { domain = "CurrentPaneDomain" } } },

  -- Split vertically (top/bottom)
  { key = "v", mods = "LEADER",     action = wezterm.action { SplitVertical = { domain = "CurrentPaneDomain" } } },

  -- Open workspace picker
  { key = 's', mods = 'CTRL|SHIFT', action = act.ShowLauncherArgs { flags = 'WORKSPACES' } },

  -- Cycle tabs forward / backward
  { key = ']', mods = 'ALT',        action = act.ActivateTabRelative(1) },
  { key = '[', mods = 'ALT',        action = act.ActivateTabRelative(-1) },

  -- Cycle panes forward / backward (by ordinal in pane tree)
  { key = 'l', mods = 'ALT',        action = act.ActivatePaneDirection('Next') },
  { key = 'h', mods = 'ALT',        action = act.ActivatePaneDirection('Prev') },

  -- Alt+1..Alt+4: select panes 1..4
  { key = '1', mods = 'ALT',        action = act.ActivatePaneByIndex(0) },
  { key = '2', mods = 'ALT',        action = act.ActivatePaneByIndex(1) },
  { key = '3', mods = 'ALT',        action = act.ActivatePaneByIndex(2) },
  { key = '4', mods = 'ALT',        action = act.ActivatePaneByIndex(3) },

  -- Alt+f: toggle pane full-screen (zoom)
  { key = 'f', mods = 'ALT',        action = act.TogglePaneZoomState },

  -- Alt+p: previous active tab (jump back to the last active tab)
  { key = 'p', mods = 'ALT',        action = act.ActivateLastTab },

  -- Alt+v: paste from clipboard
  { key = 'v', mods = 'ALT',        action = act.PasteFrom 'Clipboard' },

  -- Rename active tab
  {
    key = 'r',
    mods = 'LEADER',
    action = act.PromptInputLine {
      description = 'Enter new name for tab',
      action = wezterm.action_callback(function(window, _, line)
        if line then
          window:active_tab():set_title(line)
        end
      end),
    },
  },

  -- Open command-line recall in the second pane
  {
    key = "r",
    mods = "ALT",
    action = wezterm.action_callback(function(window)
      local target_pane = pane_at_index(window, 1)
      if target_pane then
        target_pane:send_text("\x12") -- Ctrl+r
        target_pane:activate()
      end
    end)
  },

  -- Execute the previous terminal command in the second pane
  {
    key = "r",
    mods = "ALT|SHIFT",
    action = wezterm.action_callback(function(window, pane)
      local second_pane = pane_at_index(window, 1)
      if not second_pane then
        return
      end
      -- If the current pane is nvim or vim then save all unsaved editor buffers
      local exe = string.gsub(pane:get_foreground_process_name(), '(.*[/\\])(.*)', '%2')
      if exe == 'nvim' or exe == 'vim' then
        pane:send_text('\x1b:wa\r')
      end
      -- Wait for editor to save then execute previous command in the second pane
      second_pane:send_text("sleep 0.1 && !!\n")
    end)
  },

  { key = "S", mods = "LEADER", action = wezterm.action { EmitEvent = "save_session" } },
  { key = "L", mods = "LEADER", action = wezterm.action { EmitEvent = "load_session" } },
  { key = "D", mods = "LEADER", action = wezterm.action { EmitEvent = "delete_session" } },
}

-- Tab bar
config.enable_tab_bar = true
config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = false
config.tab_bar_at_bottom = true

-- Color overrides
config.colors = {
  background = 'black',
  split = '#585858', -- The color of the split lines between panes
  tab_bar = {
    background = "#262626",

    active_tab = {
      bg_color = "#89b4fa",
      fg_color = "black",
      intensity = "Bold",
    },

    inactive_tab = {
      bg_color = "#444444",
      fg_color = "#c0c0c0",
    },

    inactive_tab_hover = {
      bg_color = "#4e4e4e",
      fg_color = "#ffffff",
    },

    new_tab = {
      bg_color = "#3a3a3a",
      fg_color = "#c0c0c0",
    },

    new_tab_hover = {
      bg_color = "#444444",
      fg_color = "#ffffff",
      italic = true,
      intensity = "Bold",
    },
  },
}

-- Window border
config.window_frame = {
  border_left_width = '2px',
  border_right_width = '2px',
  border_bottom_height = '2px',
  border_top_height = '2px',
  border_left_color = '#3a3a3a',
  border_right_color = '#3a3a3a',
  border_bottom_color = '#3a3a3a',
  border_top_color = '#3a3a3a',
}

-- Tab bar plugin
local tabline = wezterm.plugin.require("https://github.com/michaelbrusegard/tabline.wez")
tabline.setup({
  options = {
    icons_enabled = true,
    tabs_enabled = false, -- Use native WezTerm tabs
    theme = 'Catppuccin Mocha',
  },
})

-- Rename tab command
table.insert(palette_commands,
  {
    brief = 'Rename tab',
    icon = 'md_rename_box',
    action = act.PromptInputLine {
      description = 'Enter new name for tab',
      action = wezterm.action_callback(function(window, _, line)
        if line then
          window:active_tab():set_title(line)
        end
      end),
    },
  }
)

-- Layout save/restore plugin
local resurrect = wezterm.plugin.require("https://github.com/MLFlexer/resurrect.wezterm")

-- Resurrect on startup FIXME: this startup code does not work.
-- wezterm.on("gui-startup", resurrect.state_manager.resurrect_on_gui_startup)

local function update_plugins_action(window)
  wezterm.log_info("Updating plugins...")
  wezterm.plugin.update_all()
  wezterm.reload_configuration()
  window:toast_notification("WezTerm", "Plugins updated", nil, 4000)
end

local function save_workspace_state_action(window)
  resurrect.state_manager.save_state(resurrect.workspace_state.get_workspace_state())
  window:toast_notification("WezTerm", "Workspace state saved", nil, 4000)
end

local function load_workspace_state_action(win, pane)
  resurrect.fuzzy_loader.fuzzy_load(win, pane, function(id)
    local type = string.match(id, "^([^/]+)") -- match before '/'
    id = string.match(id, "([^/]+)$")         -- match after '/'
    id = string.match(id, "(.+)%..+$")        -- remove file extension
    local opts = {
      relative = true,
      restore_text = true,
      on_pane_restore = resurrect.tab_state.default_on_pane_restore,
    }
    if type == "workspace" then
      local state = resurrect.state_manager.load_state(id, "workspace")
      resurrect.workspace_state.restore_workspace(state, opts)
    elseif type == "window" then
      local state = resurrect.state_manager.load_state(id, "window")
      resurrect.window_state.restore_window(pane:window(), state, opts)
    elseif type == "tab" then
      local state = resurrect.state_manager.load_state(id, "tab")
      resurrect.tab_state.restore_tab(pane:tab(), state, opts)
    end
  end)
end

table.insert(palette_commands,
  {
    brief = 'Update Plugins',
    icon = 'md_rename_box',
    action = wezterm.action_callback(update_plugins_action),
  }
)

table.insert(palette_commands,
  {
    brief = 'Save workspace state',
    icon = 'md_content_save',
    action = wezterm.action_callback(save_workspace_state_action),
  }
)

table.insert(palette_commands,
  {
    brief = 'Load workspace state',
    icon = 'md_reload',
    action = wezterm.action_callback(load_workspace_state_action),
  }
)

-- Delete workspace state command
table.insert(palette_commands,
  {
    brief = 'Delete workspace state',
    icon = 'md_delete',
    action = wezterm.action_callback(function(win, pane)
      resurrect.fuzzy_loader.fuzzy_load(win, pane, function(id)
          resurrect.state_manager.delete_state(id)
        end,
        {
          title = "Delete State",
          description = "Select State to Delete and press Enter = accept, Esc = cancel, / = filter",
          fuzzy_description = "Search State to Delete: ",
          is_fuzzy = true,
        })
    end),
  }
)

-- WezTerm Session Manager
local session_manager = require("wezterm-session-manager/session-manager")

wezterm.on("save_session", function(window) session_manager.save_state(window) end)
wezterm.on("load_session", function(window) session_manager.load_state(window) end)
wezterm.on("delete_session", function(window) session_manager.delete_state(window) end)

table.insert(palette_commands,
  {
    brief = "Tabset: Save",
    icon = 'md_content_save',
    action = wezterm.action_callback(session_manager.save_state),
  }
)
table.insert(palette_commands,
  {
    brief = "Tabset: Load",
    icon = 'md_reload',
    action = wezterm.action_callback(session_manager.load_state),
  }
)
table.insert(palette_commands,
  {
    brief = "Tabset: Delete",
    icon = 'md_delete',
    action = wezterm.action_callback(session_manager.delete_state),
  }
)

wezterm.on('augment-command-palette', function() return palette_commands end)

return config
