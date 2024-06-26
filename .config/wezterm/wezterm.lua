local wezterm = require('wezterm')

return {
  default_prog = { 'C:\\Program Files\\PowerShell\\7\\pwsh.exe' },
  color_scheme = 'GruvboxDarkHard',
  window_background_opacity = 0.95,
  text_background_opacity = 0.7,
  tab_bar_at_bottom = true,
  use_fancy_tab_bar = false,
  font = wezterm.font('Comic Code Ligatures Medium'),
  cell_width = 0.85,
  font_size = 9.0,
  harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' },
  use_ime = false,
  leader = { key = 'Q', mods = 'CTRL', timeout_milliseconds = 1000 },
  keys = {
    { key = 'Escape', mods = 'LEADER', action = wezterm.action.ActivateCopyMode },
    { key = ' ', mods = 'CTRL', action = wezterm.action.SendKey({ key = 'ɀ' }) },
    { key = 'v', mods = 'CTRL|SHIFT', action = wezterm.action.SplitHorizontal({}) },
    { key = 's', mods = 'CTRL|SHIFT', action = wezterm.action.SplitVertical({}) },
    { key = 'j', mods = 'ALT', action = wezterm.action.ActivatePaneDirection('Down') },
    { key = 'k', mods = 'ALT', action = wezterm.action.ActivatePaneDirection('Up') },
    { key = 'h', mods = 'ALT', action = wezterm.action.ActivatePaneDirection('Left') },
    { key = 'l', mods = 'ALT', action = wezterm.action.ActivatePaneDirection('Right') },
    { key = 'F2', mods = '', action = wezterm.action.SpawnTab('CurrentPaneDomain') },
    { key = 'F3', mods = '', action = wezterm.action.ActivateTabRelative(-1) },
    { key = 'F4', mods = '', action = wezterm.action.ActivateTabRelative(1) },
    { key = 'p', mods = 'LEADER', action = wezterm.action.PasteFrom('PrimarySelection') },
  },
  mouse_bindings = {
    {
      event = { Up = { streak = 1, button = 'Right' } },
      mods = 'SHIFT',
      action = wezterm.action.PasteFrom('Clipboard'),
    },
  },
}
