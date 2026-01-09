local wezterm = require('wezterm')

return {
  default_prog = { '/usr/bin/bash' },
  -- default_prog = { 'wsl.exe', '--cd', '/home/devo' },
  window_background_opacity = 0.95,
  window_decorations = "INTEGRATED_BUTTONS|RESIZE",
  window_padding = {
    left = 10,
    right = 1,
    top = 10,
    bottom = 0,
  },
  -- text_background_opacity = 0.7,
  tab_bar_at_bottom = true,
  hide_tab_bar_if_only_one_tab = true,
  use_fancy_tab_bar = false,

  -- font = wezterm.font('Pixel Code Regular'),
  -- font_rules = {
  --   {
  --     intensity = 'Bold',
  --     italic = false,
  --     font = wezterm.font('Pixel Code ExtraBold', { weight = 'Bold', stretch = 'Normal', style = 'Normal' }),
  --   },
  --   {
  --     intensity = 'Bold',
  --     italic = true,
  --     font = wezterm.font('Pixel Code ExtraBold', { weight = 'Bold', stretch = 'Normal', style = 'Italic' }),
  --   },
  --   {
  --     intensity = 'Normal',
  --     italic = true,
  --        font = wezterm.font(
  --          'Pixel Code Thin',
  --          { weight = 'Regular', stretch = 'Normal', style = 'Normal' }
  --        ),
  --   },
  -- },
  -- line_height = 1,
  -- font_size = 7.0,
  -- underline_position = -2,
  -- cell_width = 1.1,

  font = wezterm.font('SeriousShanns Nerd Font Mono'),
  font_rules = {
    {
      intensity = 'Bold',
      italic = false,
      font = wezterm.font('SeriousShanns Nerd Font Mono', { weight = 'Bold', stretch = 'Normal', style = 'Normal' }),
    },
    {
      intensity = 'Bold',
      italic = true,
      font = wezterm.font('SeriousShanns Nerd Font Mono', { weight = 'Bold', stretch = 'Normal', style = 'Italic' }),
    },
    {
      intensity = 'Normal',
      italic = true,
         font = wezterm.font(
           'SeriousShanns Nerd Font Mono',
           { weight = 'Regular', stretch = 'Normal', style = 'Italic' }
         ),
    },
  },
  line_height = 1.05,
  font_size = 11.0,
  use_cap_height_to_scale_fallback_fonts = true,
  underline_position = -2,
  -- force_reverse_video_cursor = true,

  -- font = wezterm.font('Comic Code Ligatures Medium'),
  -- cell_width = 0.85,
  -- line_height = 1.4,
  -- font_size = 10.0,

  harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' },
  use_ime = false,
  leader = { key = 'Q', mods = 'CTRL', timeout_milliseconds = 1000 },
  keys = {
    { key = 'Escape', mods = 'LEADER', action = wezterm.action.ActivateCopyMode },
    { key = 'f', mods = 'LEADER', action = wezterm.action.QuickSelect },
    { key = 'v', mods = 'CTRL|SHIFT', action = wezterm.action.SplitHorizontal({}) },
    { key = 's', mods = 'CTRL|SHIFT', action = wezterm.action.SplitVertical({}) },
    { key = 'j', mods = 'LEADER', action = wezterm.action.ActivatePaneDirection('Down') },
    { key = 'k', mods = 'LEADER', action = wezterm.action.ActivatePaneDirection('Up') },
    { key = 'h', mods = 'LEADER', action = wezterm.action.ActivatePaneDirection('Left') },
    { key = 'l', mods = 'LEADER', action = wezterm.action.ActivatePaneDirection('Right') },
    { key = 'F2', mods = 'LEADER', action = wezterm.action.SpawnTab('CurrentPaneDomain') },
    { key = 'F3', mods = 'LEADER', action = wezterm.action.ActivateTabRelative(-1) },
    { key = 'F4', mods = 'LEADER', action = wezterm.action.ActivateTabRelative(1) },
    { key = '.', mods = 'LEADER', action = wezterm.action.CharSelect({copy_on_select=false}) },
    { key = 'p', mods = 'LEADER', action = wezterm.action.PasteFrom('Clipboard') },
    { key = 'm', mods = 'LEADER', action = wezterm.action.ToggleFullScreen },
    { key = 'Enter', mods = 'ALT', action = wezterm.action.ToggleFullScreen },
  },
  mouse_bindings = {
    {
      event = { Up = { streak = 1, button = 'Right' } },
      mods = 'SHIFT',
      action = wezterm.action.PasteFrom('Clipboard'),
    },
  },
}
