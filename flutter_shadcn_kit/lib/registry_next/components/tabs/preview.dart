// Gallery preview for `tabs`: pill strip, disabled strip, sortable tab
// pane and the dark palette. Widgets-only.

import 'package:flutter/widgets.dart';

import '../../foundation/gap.dart';
import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';
import 'tabs.dart';

/// Renders the tabs gallery.
class TabsPreview extends StatefulWidget {
  /// Creates the preview.
  const TabsPreview({super.key});

  @override
  State<TabsPreview> createState() => _TabsPreviewState();
}

class _TabsPreviewState extends State<TabsPreview> {
  int _index = 0;
  int _focused = 1;
  List<TabPaneData<String>> _order = const <TabPaneData<String>>[
    TabPaneData<String>('main.dart'),
    TabPaneData<String>('tabs.dart'),
    TabPaneData<String>('README.md'),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    return Directionality(
      textDirection: TextDirection.ltr,
      child: DefaultTextStyle(
        style: TextStyle(color: theme.colors.foreground, fontSize: 14),
        child: ColoredBox(
          color: theme.colors.background,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _section(
                  'Pill strip',
                  Tabs(
                    index: _index,
                    onChanged: (i) => setState(() => _index = i),
                    children: const [
                      TabItem(child: Text('Account')),
                      TabItem(child: Text('Password')),
                      TabItem(child: Text('Settings')),
                    ],
                  ),
                ),
                const Gap(24),
                _section(
                  'Disabled strip',
                  const Tabs(
                    index: 0,
                    children: [
                      TabItem(child: Text('Account')),
                      TabItem(child: Text('Password')),
                    ],
                  ),
                ),
                const Gap(24),
                _section(
                  'Tab pane',
                  SizedBox(
                    height: 220,
                    child: TabPane<String>(
                      items: _order,
                      focused: _focused,
                      onFocused: (i) => setState(() => _focused = i),
                      onSort: (next) => setState(() => _order = next),
                      itemBuilder: (context, item, i) =>
                          Text(item.data, overflow: TextOverflow.ellipsis),
                      child: const Padding(
                        padding: EdgeInsets.all(16),
                        child: Text('Editor content'),
                      ),
                    ),
                  ),
                ),
                const Gap(24),
                _section(
                  'Dark',
                  ShadcnTheme(
                    data: const ShadcnThemeData(
                      colors: ShadcnColors.darkFallback,
                    ),
                    child: Tabs(
                      index: _index,
                      onChanged: (i) => setState(() => _index = i),
                      children: const [
                        TabItem(child: Text('Account')),
                        TabItem(child: Text('Password')),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _section(String title, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const Gap(8),
        child,
      ],
    );
  }
}
