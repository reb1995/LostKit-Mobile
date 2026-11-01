import 'package:flutter/material.dart';
import '../../core/feature_registry.dart';
import '../../core/tool_defs.dart';

typedef OnToolsChanged = void Function(Set<String> visibleIds);

/// Settings panel — lets the user show/hide tool tabs (like LostKit-Electron).
class SettingsFeature extends AppFeature {
  final Set<String> visibleIds;
  final OnToolsChanged onChanged;
  final String customUrl;
  final ValueChanged<String> onCustomUrlChanged;

  SettingsFeature({
    required this.visibleIds,
    required this.onChanged,
    required this.customUrl,
    required this.onCustomUrlChanged,
  });

  @override
  String get title => 'Settings';
  @override
  IconData get icon => Icons.settings;

  @override
  Widget buildPanel(BuildContext context, VoidCallback onClose) {
    return SettingsPanel(
      visibleIds: visibleIds,
      onChanged: onChanged,
      customUrl: customUrl,
      onCustomUrlChanged: (url) {
        onCustomUrlChanged(url);
        onClose();
      },
    );
  }
}

class SettingsPanel extends StatefulWidget {
  final Set<String> visibleIds;
  final OnToolsChanged onChanged;
  final String customUrl;
  final ValueChanged<String> onCustomUrlChanged;

  const SettingsPanel({
    super.key,
    required this.visibleIds,
    required this.onChanged,
    required this.customUrl,
    required this.onCustomUrlChanged,
  });

  @override
  State<SettingsPanel> createState() => _SettingsPanelState();
}

class _SettingsPanelState extends State<SettingsPanel> {
  late Set<String> _visible;
  late final TextEditingController _urlController =
      TextEditingController(text: widget.customUrl);

  @override
  void initState() {
    super.initState();
    _visible = {...widget.visibleIds};
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  void _toggle(String id) {
    setState(() {
      if (_visible.contains(id)) {
        _visible.remove(id);
      } else {
        _visible.add(id);
      }
    });
    widget.onChanged({..._visible});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 4),
          child: Text(
            'SERVER URL',
            style: TextStyle(
              fontFamily: 'RuneScape',
              color: Color(0xFFC8A450),
              fontSize: 11,
              letterSpacing: 2,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 32,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0D0D0D),
                    border: Border.all(color: const Color(0xFF443818)),
                  ),
                  child: TextField(
                    controller: _urlController,
                    style: const TextStyle(
                      fontFamily: 'RuneScape',
                      color: Color(0xFFE0D5A0),
                      fontSize: 11,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'https://...',
                      hintStyle: TextStyle(
                        fontFamily: 'RuneScape',
                        color: Color(0xFF555555),
                        fontSize: 11,
                      ),
                      isDense: true,
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              GestureDetector(
                onTap: () => widget.onCustomUrlChanged(_urlController.text.trim()),
                child: Container(
                  height: 32,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  color: const Color(0xFFCC0000),
                  alignment: Alignment.center,
                  child: const Text(
                    'Save',
                    style: TextStyle(
                      fontFamily: 'RuneScape',
                      color: Colors.white,
                      fontSize: 11,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        const Divider(color: Color(0xFF222222), height: 1),
        const Padding(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 4),
          child: Text(
            'TOOLS',
            style: TextStyle(
              fontFamily: 'RuneScape',
              color: Color(0xFFC8A450),
              fontSize: 11,
              letterSpacing: 2,
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(10, 0, 10, 6),
          child: Text(
            'Tap to show or hide tabs in the side list.',
            style: TextStyle(
              fontFamily: 'RuneScape',
              color: Color(0xFF666666),
              fontSize: 10,
            ),
          ),
        ),
        const Divider(color: Color(0xFF222222), height: 1),
        Expanded(
          child: Builder(
            builder: (ctx) {
              final tools = widget.customUrl.isNotEmpty
                  ? kWebTools
                      .where((t) => t.id != 'markets' && t.id != 'lcl')
                      .toList()
                  : kWebTools;
              return ListView.separated(
                padding: EdgeInsets.zero,
                itemCount: tools.length,
                separatorBuilder: (_, __) =>
                    const Divider(color: Color(0xFF1C1C1C), height: 1),
                itemBuilder: (ctx, i) {
                  final tool = tools[i];
                  final on = _visible.contains(tool.id);
                  return InkWell(
                onTap: () => _toggle(tool.id),
                splashColor: const Color(0x22CC0000),
                highlightColor: const Color(0x11CC0000),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 11),
                  child: Row(
                    children: [
                      Opacity(
                        opacity: on ? 1.0 : 0.4,
                        child: Image.asset(
                          tool.iconAsset,
                          width: 20,
                          height: 20,
                          errorBuilder: (_, __, ___) => const Icon(
                              Icons.web,
                              color: Color(0xFF888888),
                              size: 18),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          tool.label,
                          style: TextStyle(
                            fontFamily: 'RuneScape',
                            color: on
                                ? const Color(0xFFE0D5A0)
                                : const Color(0xFF666666),
                            fontSize: 12,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      _Switch(on: on),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    ),
  ],
);
  }
}

/// Small RuneScape-themed on/off pill.
class _Switch extends StatelessWidget {
  final bool on;
  const _Switch({required this.on});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: 40,
      height: 20,
      decoration: BoxDecoration(
        color: on ? const Color(0x3344CC44) : const Color(0xFF1A1A1A),
        border: Border.all(
          color: on ? const Color(0xFF44CC44) : const Color(0xFF444444),
        ),
      ),
      child: Stack(
        children: [
          AnimatedAlign(
            duration: const Duration(milliseconds: 150),
            alignment: on ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              width: 16,
              height: 16,
              margin: const EdgeInsets.all(1),
              color: on ? const Color(0xFF44CC44) : const Color(0xFF555555),
            ),
          ),
        ],
      ),
    );
  }
}
