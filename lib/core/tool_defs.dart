/// Data-driven definitions for the web "tool" tabs shown in the left column.
///
/// The Game tab (index 0) is special and handled directly in GameScreen.
/// Everything here is a WebView tool that can be shown/hidden from Settings.
class ToolDef {
  /// Stable id — used for SharedPreferences keys (visibility + zoom) and
  /// must never change once shipped, or saved prefs will orphan.
  final String id;
  final String label;
  final String iconAsset;
  final String url;

  /// When true the tool uses our custom pinch-to-zoom / single-finger pan JS
  /// (for Leaflet-style maps) instead of the WebView's native zoom.
  final bool pinch;

  const ToolDef({
    required this.id,
    required this.label,
    required this.iconAsset,
    required this.url,
    this.pinch = false,
  });
}

/// Master list of available tools, in display order.
/// Mirrors the LostKit-Electron tool set (minus the puzzle solver, which
/// doesn't work on mobile).
const List<ToolDef> kWebTools = [
  ToolDef(
    id: 'coordinates',
    label: 'Coordinates',
    iconAsset: 'assets/widgets/coordinates.png',
    url: 'https://tools.losthq.rs/cluecoordinator/',
    pinch: true,
  ),
  ToolDef(
    id: 'cluehelp',
    label: 'Clue Help',
    iconAsset: 'assets/widgets/cluehelp.png',
    url: 'https://2004.losthq.rs/?p=clueguides',
  ),
  ToolDef(
    id: 'worldmap',
    label: 'World Map',
    iconAsset: 'assets/widgets/worldmap.png',
    url: 'https://tools.losthq.rs/map',
    pinch: true,
  ),
  ToolDef(
    id: 'itemdb',
    label: 'Item Database',
    iconAsset: 'assets/widgets/itemdb.png',
    url: 'https://2004.losthq.rs/?p=itemdb',
  ),
  ToolDef(
    id: 'bestiary',
    label: 'Bestiary',
    iconAsset: 'assets/widgets/bestiary.png',
    url: 'https://2004.losthq.rs/?p=droptables',
  ),
  ToolDef(
    id: 'quests',
    label: 'Quest Guides',
    iconAsset: 'assets/widgets/quests.png',
    url: 'https://2004.losthq.rs/?p=questguides',
  ),
  ToolDef(
    id: 'skillscalc',
    label: 'Skills Calculator',
    iconAsset: 'assets/widgets/skillscalculator.png',
    url: 'https://2004.losthq.rs/?p=calculators',
  ),
];

/// Default zoom per tool id (others default to 1.0).
const Map<String, double> kDefaultZoom = {
  'game': 1.20,
};
