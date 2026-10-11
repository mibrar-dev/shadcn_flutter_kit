// Named examples for the `tabs` component (P6-F3 preview contract).
//
// One focused demo per example; the first entry is the default. Spacing comes
// from the ambient theme, so the examples follow the selected preset and the
// site light/dark toggle.

import 'package:flutter/widgets.dart';

import '../../foundation/component_preview.dart';
import 'tabs.dart';

/// Interactive pill strip; owns its index.
class _InteractiveTabs extends StatefulWidget {
  const _InteractiveTabs();

  @override
  State<_InteractiveTabs> createState() => _InteractiveTabsState();
}

class _InteractiveTabsState extends State<_InteractiveTabs> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Tabs(
      index: _index,
      onChanged: (int index) => setState(() => _index = index),
      children: const <TabItem>[
        TabItem(child: Text('Account')),
        TabItem(child: Text('Password')),
        TabItem(child: Text('Settings')),
      ],
    );
  }
}

Widget _default(BuildContext context) {
  // The strip sizes to its content; it scrolls instead of overflowing on a
  // 375-wide phone.
  return const SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: _InteractiveTabs(),
  );
}

/// Strip with no callback, so every tab is disabled.
Widget _disabled(BuildContext context) {
  return const Tabs(
    index: 0,
    children: <TabItem>[
      TabItem(child: Text('Account')),
      TabItem(child: Text('Password')),
    ],
  );
}

/// Sortable IDE-style pane over a content card; owns its order. The fixed
/// height is inherent: the content card flexes inside the pane.
class _PaneDemo extends StatefulWidget {
  const _PaneDemo();

  @override
  State<_PaneDemo> createState() => _PaneDemoState();
}

class _PaneDemoState extends State<_PaneDemo> {
  int _focused = 1;
  List<TabPaneData<String>> _order = const <TabPaneData<String>>[
    TabPaneData<String>('main.dart'),
    TabPaneData<String>('tabs.dart'),
    TabPaneData<String>('README.md'),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: TabPane<String>(
        items: _order,
        focused: _focused,
        onFocused: (int index) => setState(() => _focused = index),
        onSort: (List<TabPaneData<String>> next) =>
            setState(() => _order = next),
        itemBuilder:
            (BuildContext context, TabPaneData<String> item, int index) =>
                Text(item.data, overflow: TextOverflow.ellipsis),
        child: const Padding(
          padding: EdgeInsets.all(12),
          child: Text('Editor content'),
        ),
      ),
    );
  }
}

Widget _pane(BuildContext context) => const _PaneDemo();

/// Named docs examples for `tabs`; the first entry is the default.
const List<ComponentPreview> tabsPreviews = <ComponentPreview>[
  ComponentPreview('Default', _default),
  ComponentPreview('Disabled', _disabled),
  ComponentPreview('Tab pane', _pane),
];
