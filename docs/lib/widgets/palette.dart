// The command palette panel (spec §2.8): 512 px wide, 15 % from the top,
// radius 14, `p-2 pb-11`, 4 px ring, **no scrim**, 320 px minimum list, 36 px
// selected rows, and the 40 px footer bar (`↵ Go to Page`, `⌘C` + action).
//
// Spike outcome (plan §6 D3): the registry `Command` always inserts dividers
// between rows and ships a dialog with its own scrim, so the panel is
// docs-only; the registry `Input` provides the search field and the footer
// hints are docs-only key caps (`keyboard_shortcut` currently exposes private
// named parameters — see the D3 report §6.3). Groups: Pages / Components /
// Presets; CLI commands search as Pages rows tagged `CLI` (they navigate to
// `/docs/cli`).

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../routing/docs_router.dart';
import '../ui/shadcn/components/input/input.dart';
import '../ui/shadcn/foundation/gap.dart';
import '../ui/shadcn/foundation/icons/lucide_icons.dart';
import '../ui/shadcn/primitives/clickable.dart';
import '../ui/shadcn/primitives/input_features/adornment_features.dart';
import '../ui/shadcn/primitives/input_features/input_features.dart';
import '../ui/shadcn/theme/color_tokens.dart';
import '../ui/shadcn/theme/theme.dart';
import 'docs_tokens.dart';
import 'palette_model.dart';

/// The palette panel body (D1's route provides the overlay + enter tween).
class DocsPalette extends StatefulWidget {
  /// Creates the palette.
  const DocsPalette({super.key, required this.onClose});

  /// Closes the palette.
  final VoidCallback onClose;

  @override
  State<DocsPalette> createState() => _DocsPaletteState();
}

class _DocsPaletteState extends State<DocsPalette> {
  final TextEditingController _query = TextEditingController();
  final ScrollController _scroll = ScrollController();
  final Map<String, GlobalKey> _keys = <String, GlobalKey>{};
  late final List<PaletteEntry> _items = buildPaletteEntries();
  int _selected = 0;

  @override
  void dispose() {
    _query.dispose();
    _scroll.dispose();
    super.dispose();
  }

  List<PaletteEntry> get _visible {
    final String query = _query.text.trim().toLowerCase();
    if (query.isEmpty) {
      // The reference shows only the Pages group for an empty query.
      return _items
          .where(
            (PaletteEntry item) =>
                item.group == PaletteGroup.pages && item.tag == null,
          )
          .toList();
    }
    return _items.where((PaletteEntry item) => item.matches(query)).toList();
  }

  void _move(int delta) {
    final int count = _visible.length;
    if (count == 0) {
      return;
    }
    setState(() => _selected = (_selected + delta + count) % count);
    _revealSelected();
  }

  void _revealSelected() {
    final PaletteEntry? item = _selectedItem;
    if (item == null) {
      return;
    }
    final BuildContext? context = _keys[_keyFor(item)]?.currentContext;
    if (context == null) {
      return;
    }
    Scrollable.ensureVisible(context, alignment: 0.5, duration: Duration.zero);
  }

  PaletteEntry? get _selectedItem {
    final List<PaletteEntry> visible = _visible;
    if (visible.isEmpty) {
      return null;
    }
    return visible[_selected.clamp(0, visible.length - 1).toInt()];
  }

  void _activateSelected() {
    final PaletteEntry? item = _selectedItem;
    if (item == null) {
      return;
    }
    final DocsRouterDelegate delegate = DocsRouterScope.of(context);
    widget.onClose();
    delegate.go(context, item.route);
  }

  void _copySelected() {
    final PaletteEntry? item = _selectedItem;
    if (item == null) {
      return;
    }
    Clipboard.setData(ClipboardData(text: item.action ?? item.route));
  }

  String _keyFor(PaletteEntry item) =>
      '${item.group.name}:${item.route}:${item.label}';

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    final DocsSiteColors site = DocsSiteColors.of(context);
    final Size size = MediaQuery.sizeOf(context);
    final double top = size.height * DocsMetrics.paletteTopFraction;
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: EdgeInsets.only(top: top, left: 16, right: 16),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: DocsMetrics.paletteWidth,
            maxHeight: size.height - top - 48,
          ),
          child: CallbackShortcuts(
            bindings: <ShortcutActivator, VoidCallback>{
              const SingleActivator(LogicalKeyboardKey.arrowDown): () =>
                  _move(1),
              const SingleActivator(LogicalKeyboardKey.arrowUp): () =>
                  _move(-1),
              const SingleActivator(LogicalKeyboardKey.enter):
                  _activateSelected,
              const SingleActivator(LogicalKeyboardKey.escape): widget.onClose,
              const SingleActivator(LogicalKeyboardKey.keyC, meta: true):
                  _copySelected,
              const SingleActivator(LogicalKeyboardKey.keyC, control: true):
                  _copySelected,
            },
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: theme.colors.popover,
                borderRadius: theme.borderRadiusXl,
                boxShadow: <BoxShadow>[
                  BoxShadow(color: site.panelRing, spreadRadius: 4),
                  ...theme.tokens.shadows.shadow2xl,
                ],
              ),
              child: Stack(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 8, 8, 44),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Input(
                          controller: _query,
                          autofocus: true,
                          hintText: 'Search documentation…',
                          onChanged: (_) => setState(() => _selected = 0),
                          onSubmitted: (_) => _activateSelected(),
                          features: const <InputFeature>[
                            InputLeadingFeature(
                              Padding(
                                padding: EdgeInsets.only(right: 8),
                                child: Icon(LucideIcons.search),
                              ),
                            ),
                          ],
                        ),
                        const Gap(4),
                        Flexible(child: _results(context)),
                      ],
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    height: 40,
                    child: _Footer(
                      action: _selectedItem?.action ?? _selectedItem?.route,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _results(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    final String query = _query.text.trim();
    final List<PaletteEntry> visible = _visible;
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: query.isEmpty ? 320 : 0),
      child: ScrollConfiguration(
        behavior: const DocsScrollBehavior(),
        child: SingleChildScrollView(
          controller: _scroll,
          child: visible.isEmpty
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Center(
                    child: Text(
                      'No results found.',
                      style: docsText(
                        context,
                        size: 14,
                        color: theme.colors.mutedForeground,
                      ),
                    ),
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    for (final PaletteGroup group in PaletteGroup.values)
                      ..._groupRows(context, group, visible),
                  ],
                ),
        ),
      ),
    );
  }

  List<Widget> _groupRows(
    BuildContext context,
    PaletteGroup group,
    List<PaletteEntry> visible,
  ) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    final List<PaletteEntry> groupItems = visible
        .where((PaletteEntry item) => item.group == group)
        .toList();
    if (groupItems.isEmpty) {
      return const <Widget>[];
    }
    final String heading = switch (group) {
      PaletteGroup.pages => 'Pages',
      PaletteGroup.components => 'Components',
      PaletteGroup.presets => 'Presets',
    };
    return <Widget>[
      Padding(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
        child: Text(
          heading,
          style: docsText(
            context,
            size: 12,
            weight: FontWeight.w500,
            height: 16 / 12,
            color: theme.colors.mutedForeground,
          ),
        ),
      ),
      for (final PaletteEntry item in groupItems)
        _PaletteRow(
          key: _keys.putIfAbsent(_keyFor(item), () => GlobalKey()),
          item: item,
          selected: identical(_selectedItem, item),
          onPressed: () {
            final DocsRouterDelegate delegate = DocsRouterScope.of(context);
            widget.onClose();
            delegate.go(context, item.route);
          },
        ),
    ];
  }
}

class _PaletteRow extends StatelessWidget {
  const _PaletteRow({
    super.key,
    required this.item,
    required this.selected,
    required this.onPressed,
  });

  final PaletteEntry item;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    final ShadcnColors colors = theme.colors;
    return SizedBox(
      height: 36,
      child: Clickable(
        onPressed: onPressed,
        decoration: WidgetStateProperty.resolveWith<Decoration?>((
          Set<WidgetState> states,
        ) {
          if (selected) {
            return BoxDecoration(
              color: colors.input.withValues(alpha: 0.5),
              border: Border.all(color: colors.input),
              borderRadius: theme.borderRadiusMd,
            );
          }
          if (states.contains(WidgetState.hovered)) {
            return BoxDecoration(
              color: colors.muted,
              borderRadius: theme.borderRadiusMd,
            );
          }
          return const BoxDecoration();
        }),
        padding: const WidgetStatePropertyAll<EdgeInsetsGeometry>(
          EdgeInsets.symmetric(horizontal: 12),
        ),
        textStyle: WidgetStatePropertyAll<TextStyle?>(
          docsText(context, size: 14, weight: FontWeight.w500),
        ),
        child: Row(
          children: <Widget>[
            Icon(item.icon, size: 16, color: colors.mutedForeground),
            const Gap(12),
            Expanded(
              child: Text(
                item.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (item.tag != null)
              Text(
                item.tag!,
                style: docsText(
                  context,
                  size: 12,
                  color: colors.mutedForeground,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer({this.action});

  final String? action;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    final DocsSiteColors site = DocsSiteColors.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: site.panelFooter,
        border: Border(top: BorderSide(color: theme.colors.border)),
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(theme.radiusXl),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: <Widget>[
            const _KeyCap('↵'),
            const Gap(8),
            Text(
              'Go to Page',
              style: docsText(
                context,
                size: 12,
                weight: FontWeight.w500,
                color: theme.colors.mutedForeground,
              ),
            ),
            const Spacer(),
            const _KeyCap('⌘C'),
            const Gap(8),
            if (action != null)
              Flexible(
                child: Text(
                  action!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: docsText(
                    context,
                    size: 12,
                    color: theme.colors.mutedForeground,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// A docs-only key cap for the palette footer hints.
///
/// Deliberately not the registry `keyboard_shortcut` component: its current
/// constructor exposes the backing fields as named parameters (`this._keys`),
/// which cannot be passed from another library (reported to the registry
/// owners); the footer only needs two static caps.
class _KeyCap extends StatelessWidget {
  const _KeyCap(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: theme.colors.border),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
        child: Text(
          label,
          style: theme.typography.mono.copyWith(
            fontSize: 11,
            color: theme.colors.mutedForeground,
          ),
        ),
      ),
    );
  }
}
