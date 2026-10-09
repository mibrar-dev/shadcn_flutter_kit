// Gallery preview for the `navigation_bar` component: bar, rail, sidebar,
// labels, groups, a collapsible, disabled items and dark.
// Widgets-only; the docs app embeds [NavigationBarPreview] directly.

import 'package:flutter/widgets.dart';

import '../../foundation/gap.dart';
import '../../foundation/icons/radix_icons.dart';
import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';
import 'navigation_bar.dart';

/// Renders the navigation bar gallery.
class NavigationBarPreview extends StatefulWidget {
  /// Creates the preview.
  const NavigationBarPreview({super.key});

  @override
  State<NavigationBarPreview> createState() => _NavigationBarPreviewState();
}

class _NavigationBarPreviewState extends State<NavigationBarPreview> {
  int _index = 0;

  List<NavigationBarItem> get _items => <NavigationBarItem>[
    NavigationItem(
      label: const Text('Home'),
      child: const Icon(RadixIcons.home),
    ),
    NavigationItem(
      label: const Text('Search'),
      child: const Icon(RadixIcons.magnifyingGlass),
    ),
    NavigationItem(
      label: const Text('Settings'),
      child: const Icon(RadixIcons.gear),
    ),
    NavigationItem(
      label: const Text('Disabled'),
      enabled: false,
      child: const Icon(RadixIcons.person),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return Directionality(
      textDirection: TextDirection.ltr,
      child: DefaultTextStyle(
        style: TextStyle(color: theme.colors.foreground, fontSize: 13),
        child: ColoredBox(
          color: theme.colors.background,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _section(
                  'Bar',
                  NavigationBar(
                    index: _index,
                    onSelected: (int value) => setState(() => _index = value),
                    labelType: NavigationLabelType.selected,
                    children: _items,
                  ),
                ),
                const Gap(16),
                _section(
                  'Rail (labels as tooltips)',
                  SizedBox(
                    height: 280,
                    child: NavigationBar(
                      container: NavigationContainerType.rail,
                      index: _index,
                      onSelected: (int value) => setState(() => _index = value),
                      labelType: NavigationLabelType.tooltip,
                      children: _items,
                    ),
                  ),
                ),
                const Gap(16),
                _section(
                  'Sidebar (groups + collapsible)',
                  SizedBox(
                    height: 380,
                    child: NavigationBar(
                      container: NavigationContainerType.sidebar,
                      index: _index,
                      onSelected: (int value) => setState(() => _index = value),
                      children: <NavigationBarItem>[
                        const NavigationLabel(child: Text('Main')),
                        ..._items,
                        const NavigationDivider(),
                        NavigationGroup(
                          label: const Text('Account'),
                          children: <Widget>[
                            NavigationCollapsible(
                              label: const Text('Profile'),
                              leading: const Icon(RadixIcons.person),
                              initialExpanded: true,
                              children: <Widget>[
                                NavigationItem(
                                  index: 4,
                                  label: const Text('Details'),
                                  child: const Icon(RadixIcons.idCard),
                                ),
                                NavigationItem(
                                  index: 5,
                                  label: const Text('Security'),
                                  child: const Icon(RadixIcons.lockClosed),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const Gap(16),
                _section('Dark', _dark()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _dark() {
    return ShadcnTheme(
      data: const ShadcnThemeData(colors: ShadcnColors.darkFallback),
      child: ColoredBox(
        color: ShadcnColors.darkFallback.background,
        child: NavigationBar(
          labelType: NavigationLabelType.all,
          children: _items,
        ),
      ),
    );
  }

  Widget _section(String title, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
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
