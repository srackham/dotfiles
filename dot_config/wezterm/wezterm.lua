-- WezTerm configuration (see https://wezterm.org/config/files.html)

-- Pull in the wezterm API
local wezterm = require "wezterm"
local act = wezterm.action
local mux = wezterm.mux
local config = wezterm.config_builder()

-- Differentiate active pane
-- As of 02-Dec-2025 the is no way to set the active pane border color, only the HSB value
config.inactive_pane_hsb = {
  saturation = 0.5,
  brightness = 0.5,
}

-- config.window_decorations = "RESIZE" -- FIXME: does not work on Wayland (wezterm 0-unstable-2025-05-18)

-- Fonts
config.font = wezterm.font_with_fallback {
  "JetBrainsMono Nerd Font",
  "Symbols Nerd Font",
  "Noto Color Emoji",
}
config.font_size = 11.0
config.harfbuzz_features = { "calt=0", "clig=0", "liga=0" } -- Disable ligatures (https://wezterm.org/config/font-shaping.html)

-- config.color_scheme = 'Argonaut (Gogh)'
config.color_scheme = "catppuccin-mocha"
config.initial_rows = 50
config.initial_cols = 120
config.audible_bell = "Disabled"

-- Palette commands are accumulated in this table and then installed with the "augment-command-palette" event
local palette_commands = {}

-- Tab definitions
local tabs = {}

-- Append a normative 3-pane tab to the tabs definitions
local function append_tab(name, path)
  table.insert(tabs, {
    tab_name = name,
    shell_command_before = path,
    panes = {
      { shell_command = "nvim" },
      { shell_command = "pi -c", split = "Right", size = 0.5 },
      { shell_command = "lazygit", split = "Bottom", size = 0.5 },
    },
  })
end

append_tab("Notes", "cd ~/notes")
append_tab("Chezmoi", "cd ~/share/projects/chezmoi")
append_tab("NixOS", "cd ~/share/projects/nixos-configurations")
append_tab("PRS", "cd ~/share/methods/prs")
append_tab("HTMX Todo", "cd ~/share/projects/htmx-todos")
append_tab("qanda.nvim", "cd ~/share/projects/qanda.nvim")
table.insert(tabs, {
  tab_name = "Example",
  shell_command_before = "cd ~/tmp",
  panes = {
    { shell_command = "cd /var/log && ls -al | grep \\.log" },
    { shell_command = "echo second pane", split = "Right", size = 0.45 },
    { shell_command = "echo third pane", split = "Bottom", size = 0.3 },
  },
})
append_tab("Python STT", "cd ~/projects/experiments/stt")

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

local toggle_maximise_panes_state = false

local function toggle_maximise_panes(window, pane)
  toggle_maximise_panes_state = not toggle_maximise_panes_state
  local target_idx = toggle_maximise_panes_state and 2 or 1
  local direction = toggle_maximise_panes_state and "Up" or "Down"
  window:perform_action(
    wezterm.action.Multiple {
      act.ActivatePaneByIndex(target_idx),
      act.AdjustPaneSize { direction, 999 },
    },
    pane
  )
end

-- Key bindings
config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 5000 }
config.keys = {
  { key = "a", mods = "CTRL|SHIFT", action = act.ActivateTab(1) }, -- Activate tab 2 (AI agent)
  { key = "(", mods = "CTRL|SHIFT", action = act.ActivateTab(8) }, -- Activate tab 9
  { key = ")", mods = "CTRL|SHIFT", action = act.ActivateTab(9) }, -- Activate tab 10

  -- Show debug overlay
  { key = "d", mods = "CTRL|SHIFT", action = act.ShowDebugOverlay },

  -- Split horizontally (left/right)
  { key = "s", mods = "LEADER", action = wezterm.action { SplitHorizontal = { domain = "CurrentPaneDomain" } } },

  -- Split vertically (top/bottom)
  { key = "v", mods = "LEADER", action = wezterm.action { SplitVertical = { domain = "CurrentPaneDomain" } } },

  -- Open workspace picker
  { key = "s", mods = "CTRL|SHIFT", action = act.ShowLauncherArgs { flags = "WORKSPACES" } },

  -- Cycle tabs forward / backward
  { key = "[", mods = "ALT", action = act.ActivateTabRelative(-1) },
  { key = "]", mods = "ALT", action = act.ActivateTabRelative(1) },

  -- Move tabs forward / backward
  { key = "{", mods = "SHIFT|ALT", action = act.MoveTabRelative(-1) },
  { key = "}", mods = "SHIFT|ALT", action = act.MoveTabRelative(1) },

  -- Cycle panes forward / backward (by ordinal in pane tree)
  { key = "l", mods = "ALT", action = act.ActivatePaneDirection "Next" },
  { key = "h", mods = "ALT", action = act.ActivatePaneDirection "Prev" },

  -- Alt+1..Alt+4: select panes 1..4
  { key = "1", mods = "ALT", action = act.ActivatePaneByIndex(0) },
  { key = "2", mods = "ALT", action = act.ActivatePaneByIndex(1) },
  { key = "3", mods = "ALT", action = act.ActivatePaneByIndex(2) },
  { key = "4", mods = "ALT", action = act.ActivatePaneByIndex(3) },

  -- Alt+f: toggle pane full-screen (zoom)
  { key = "f", mods = "ALT", action = act.TogglePaneZoomState },

  -- Alt+o: Select pane 2 and maximize height
  {
    key = "o",
    mods = "ALT",
    action = wezterm.action.Multiple {
      act.ActivatePaneByIndex(1),
      act.AdjustPaneSize { "Down", 999 },
    },
  },

  -- Alt+Shift+o: Select pane 3 and maximize height
  {
    key = "O",
    mods = "SHIFT|ALT",
    action = wezterm.action.Multiple {
      act.ActivatePaneByIndex(2),
      act.AdjustPaneSize { "Up", 999 },
    },
  },

  -- Toggle-maximise the height of left hand panes
  { key = ";", mods = "ALT", action = wezterm.action_callback(toggle_maximise_panes) },

  -- Adjust pane sizes
  { key = "H", mods = "CTRL|SHIFT", action = act.AdjustPaneSize { "Left", 33 } },
  { key = "J", mods = "CTRL|SHIFT", action = act.AdjustPaneSize { "Down", 33 } },
  { key = "K", mods = "CTRL|SHIFT", action = act.AdjustPaneSize { "Up", 33 } },
  { key = "L", mods = "CTRL|SHIFT", action = act.AdjustPaneSize { "Right", 33 } },

  -- Alt+p: previous active tab (jump back to the last active tab)
  { key = "p", mods = "ALT", action = act.ActivateLastTab },

  -- Alt+v: paste from clipboard
  { key = "v", mods = "ALT", action = act.PasteFrom "Clipboard" },

  -- Rename active tab
  {
    key = "r",
    mods = "LEADER",
    action = act.PromptInputLine {
      description = "Enter new name for tab",
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
        target_pane:send_text "\x12" -- Ctrl+r
        target_pane:activate()
      end
    end),
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
      local exe = string.gsub(pane:get_foreground_process_name(), "(.*[/\\])(.*)", "%2")
      if exe == "nvim" or exe == "vim" then
        pane:send_text "\x1b:wa\r"
      end
      -- Wait for editor to save then execute previous command in the second pane
      second_pane:send_text "sleep 0.2\n"
      second_pane:send_text "!-2\n"
    end),
  },

  -- force Shift+Enter to send the CSI‑u CSI 13;2u sequence instead of bare ^M
  {
    key = "Enter",
    mods = "SHIFT",
    action = wezterm.action.SendString "\x1b[13;2u",
  },
}

-- Tab bar
config.enable_tab_bar = true
config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = false
config.tab_bar_at_bottom = true

-- Color overrides
config.colors = {
  background = "black",
  split = "#585858", -- The color of the split lines between panes
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
  border_left_width = "2px",
  border_right_width = "2px",
  border_bottom_height = "2px",
  border_top_height = "2px",
  border_left_color = "#3a3a3a",
  border_right_color = "#3a3a3a",
  border_bottom_color = "#3a3a3a",
  border_top_color = "#3a3a3a",
}

-- Tab bar plugin
local tabline = wezterm.plugin.require "https://github.com/michaelbrusegard/tabline.wez"
tabline.setup {
  options = {
    icons_enabled = true,
    tabs_enabled = false, -- Use native WezTerm tabs
    theme = "Catppuccin Mocha",
  },
}

-- Rename tab Palette command
table.insert(palette_commands, {
  brief = "Rename tab",
  icon = "md_rename_box",
  action = act.PromptInputLine {
    description = "Enter new name for tab",
    action = wezterm.action_callback(function(window, _, line)
      if line then
        window:active_tab():set_title(line)
      end
    end),
  },
})

-- Update plugins Palette command
table.insert(palette_commands, {
  brief = "Update Plugins",
  icon = "md_reload",
  action = wezterm.action_callback(function(window)
    wezterm.log_info "Updating plugins..."
    wezterm.plugin.update_all()
    wezterm.reload_configuration()
    window:toast_notification("WezTerm", "Plugins updated", nil, 4000)
  end),
})

-- Install Palette commands
wezterm.on("augment-command-palette", function()
  return palette_commands
end)

-- Tabs loader.
-- Published as a Github Gist: https://gist.github.com/srackham/2004f9a0ac4e555deba548c2e7549f2b
local function apply_tab(tab_def, mux_win)

  local system_shell = os.getenv "SHELL" or "bash"
  local first_pane = nil
  local tab = nil

  local cmd_before = tab_def.shell_command_before or ""

  local last_pane

  for i, p_conf in ipairs(tab_def.panes or {}) do
    local p_cmd = p_conf.shell_command or ":" -- ":" is shell no-op command
    local full_cmd = cmd_before ~= "" and (cmd_before .. " && " .. p_cmd) or p_cmd

    -- The shell is exec'd when the pane commands finish so that the pane doesn't close.
    full_cmd = full_cmd .. "; exec " .. system_shell
    local split_dir = p_conf.split or "Bottom"
    local split_size = p_conf.size

    if i == 1 then
      -- Spawn the tab
      tab, first_pane = mux_win:spawn_tab {
        args = { system_shell, "-ic", full_cmd },
      }
      if tab_def.tab_name then
        tab:set_title(tab_def.tab_name)
      end
      last_pane = first_pane
    else
      -- Split from the previous pane
      last_pane = last_pane:split {
        direction = split_dir,
        size = split_size,
        args = { system_shell, "-ic", full_cmd },
      }
    end
  end

  if first_pane then
    first_pane:activate()
  end

  return tab
end

local function apply_tabs(tab_defs, mux_win)
  if not tab_defs or not mux_win then
    return
  end

  local first_created_tab = nil

  for i, tab_def in ipairs(tab_defs) do
    local tab = apply_tab(tab_def, mux_win)

    if i == 1 then
      first_created_tab = tab
    end
  end

  -- Activate the very first tab in the list
  assert(first_created_tab)
  -- Schedule this to execute after all the pane activations queued by `apply_tab` have settled
  wezterm.time.call_after(0.1, function()
    first_created_tab:activate()
  end)
end

-- Bind <Leader>t keys to load tab definitions
local load_tabs = {
  key = "t",
  mods = "LEADER",
  action = wezterm.action_callback(function(win, pane)
    -- Close the current tab (assumed empty, sitting at the shell prompt)
    pane:send_text "exit\n"
    -- This converts the GUI window handle into the Mux window handle
    local mux_win = mux.get_window(win:window_id())
    apply_tabs(tabs, mux_win)
  end),
}
table.insert(config.keys, load_tabs)

return config
