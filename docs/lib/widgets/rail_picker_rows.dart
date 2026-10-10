// The row widgets of the Theme Studio picker popups (spec §2.7).
//
// Split out of `rail_pickers.dart` for the ~400-line rule: the fixed-width
// panel, one selectable row, one colour swatch and the hex field. The popup
// chrome (`showShadcnPicker`) and the scroll area (`RailPickerScroll`) live
// in their own files.

import 'package:flutter/widgets.dart';

import '../../theme/theme_document.dart';
import '../../ui/shadcn/components/input/input.dart';
import '../../ui/shadcn/components/tooltip/tooltip.dart';
import '../../ui/shadcn/primitives/clickable.dart';
import '../../ui/shadcn/theme/color_tokens.dart';
import '../../ui/shadcn/theme/theme.dart';
import 'docs_tokens.dart';
import 'rail_picker_scroll.dart';

/// The picker's panel width (the reference's colour popovers are ~200 px).
const double kDocsPickerWidth = 224;

/// The fixed-width panel body every picker renders in.
class RailPickerPanel extends StatelessWidget {
  /// Creates a panel.
  const RailPickerPanel({super.key, required this.child});

  /// The panel content.
  final Widget child;

  @override
  Widget build(BuildContext context) =>
      SizedBox(width: kDocsPickerWidth, child: child);
}

/// One selectable row of a picker (hover + selected accent fill).
class RailPickerRow extends StatelessWidget {
  /// Creates a row.
  const RailPickerRow({
    super.key,
    required this.label,
    required this.detail,
    required this.selected,
    required this.onPick,
    this.onHighlight,
    this.trailing,
  });

  /// The option name.
  final String label;

  /// The option value.
  final String detail;

  /// Whether the row is the live value.
  final bool selected;

  /// Applies and closes.
  final VoidCallback onPick;

  /// Applies without closing (hover and keyboard focus).
  final VoidCallback? onHighlight;

  /// The trailing glyph.
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Clickable(
        onPressed: onPick,
        onHover: (bool hovered) {
          if (hovered) onHighlight?.call();
        },
        onFocus: (bool focused) {
          if (focused) {
            onHighlight?.call();
            revealOnFocus(context, focused);
          }
        },
        behavior: HitTestBehavior.opaque,
        decoration: WidgetStateProperty.resolveWith<Decoration?>((
          Set<WidgetState> states,
        ) {
          return BoxDecoration(
            color: states.contains(WidgetState.hovered) || selected
                ? theme.colors.accent
                : const Color(0x00000000),
            borderRadius: BorderRadius.circular(6),
          );
        }),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: docsText(context, size: 13),
                    ),
                    Text(
                      detail,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: docsText(
                        context,
                        size: 11,
                        color: theme.colors.mutedForeground,
                      ),
                    ),
                  ],
                ),
              ),
              if (trailing case final Widget widget)
                SizedBox(width: 24, height: 24, child: widget),
            ],
          ),
        ),
      ),
    );
  }
}

/// One seed colour of the colour grid.
class RailSeedSwatch extends StatelessWidget {
  /// Creates a swatch.
  const RailSeedSwatch({
    super.key,
    required this.color,
    required this.name,
    required this.selected,
    required this.onPick,
    this.onHighlight,
  });

  /// The swatch fill.
  final Color color;

  /// The accessible name.
  final String name;

  /// Whether the swatch is the live value.
  final bool selected;

  /// Applies and closes.
  final VoidCallback onPick;

  /// Applies without closing (hover and keyboard focus).
  final VoidCallback? onHighlight;

  @override
  Widget build(BuildContext context) {
    final ShadcnColors colors = ShadcnTheme.of(context).colors;
    return Tooltip(
      tooltip: (BuildContext context) => Text(name),
      child: Clickable(
        onPressed: onPick,
        onHover: (bool hovered) {
          if (hovered) onHighlight?.call();
        },
        onFocus: (bool focused) {
          if (focused) {
            onHighlight?.call();
            revealOnFocus(context, focused);
          }
        },
        decoration: const WidgetStatePropertyAll<Decoration?>(null),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: selected ? colors.foreground : colors.border,
              width: selected ? 2 : 1,
            ),
          ),
        ),
      ),
    );
  }
}

/// A `#RRGGBB` field for a colour the grid does not offer.
/// A `#RRGGBB` field for a colour the grid does not offer.
class RailHexField extends StatefulWidget {
  /// Creates the field.
  const RailHexField({super.key, required this.initial, required this.onPick});

  /// The current colour, as the initial text.
  final Color initial;

  /// Applies the parsed colour (the caller closes the popup).
  final ValueChanged<Color> onPick;

  @override
  State<RailHexField> createState() => RailHexFieldState();
}

/// The field state.
class RailHexFieldState extends State<RailHexField> {
  late final TextEditingController _controller = TextEditingController(
    text: formatDocsHexColor(widget.initial.toARGB32()),
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Input(
      controller: _controller,
      hintText: '#RRGGBB',
      maxLength: 9,
      onSubmitted: (String value) {
        if (kDocsHexColorPattern.hasMatch(value.trim())) {
          widget.onPick(docsColorOf(value.trim()));
        }
      },
      onChanged: (String value) {
        final String trimmed = value.trim();
        if (kDocsHexColorPattern.hasMatch(trimmed)) {
          widget.onPick(docsColorOf(trimmed));
        }
      },
    );
  }
}
