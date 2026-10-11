// The shared copy control (spec §2.3/§2.8): copies [text] and swaps its icon
// copy→check for exactly 2000 ms (`copy-button.tsx:83`). Used by the header
// search area is NOT a copy target; D4's code figures and the article title
// row reuse this widget.

import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../motion/ease.dart';
import '../ui/shadcn/components/button/button.dart';
import '../ui/shadcn/components/tooltip/tooltip.dart';
import '../ui/shadcn/foundation/icons/lucide_icons.dart';

/// Copied-state reset window (spec §2.8: 2000 ms, not 1.5 s).
const Duration kCopyFeedbackDuration = kDurationCopyFeedback;

/// A button that copies [text] to the clipboard and shows a check for 2 s.
class CopyButton extends StatefulWidget {
  /// Creates a copy button.
  const CopyButton({
    super.key,
    required this.text,
    this.label = 'Copy',
    this.showLabel = false,
    this.variant = ButtonVariant.ghost,
    this.size = ButtonSize.sm,
    this.theme,
    this.tooltip = 'Copy',
  });

  /// The text written to the clipboard.
  final String text;

  /// Visible label; omitted when [showLabel] is false.
  final String label;

  /// Whether the label is rendered next to the icon.
  final bool showLabel;

  /// Button variant.
  final ButtonVariant variant;

  /// Button size row.
  final ButtonSize size;

  /// Widget-leg style override.
  final ButtonVariantStyle? theme;

  /// Tooltip text (kept "Copy" while copied, per the reference's sr-only).
  final String tooltip;

  @override
  State<CopyButton> createState() => _CopyButtonState();
}

class _CopyButtonState extends State<CopyButton> {
  Timer? _reset;
  bool _copied = false;

  @override
  void dispose() {
    _reset?.cancel();
    super.dispose();
  }

  Future<void> _copy() async {
    // Fire-and-forget: the check state is immediate (and the test binding has
    // no clipboard handler, so awaiting would stall the feedback).
    unawaited(Clipboard.setData(ClipboardData(text: widget.text)));
    if (!mounted) {
      return;
    }
    setState(() => _copied = true);
    _reset?.cancel();
    _reset = Timer(kCopyFeedbackDuration, () {
      if (mounted) {
        setState(() => _copied = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final Widget icon = Icon(
      _copied ? LucideIcons.check : LucideIcons.copy,
      size: 14,
    );
    final Widget button = Button(
      variant: widget.variant,
      size: widget.size,
      theme: widget.theme,
      onPressed: _copy,
      leading: widget.showLabel ? icon : null,
      child: widget.showLabel ? Text(widget.label) : icon,
    );
    return Tooltip(
      tooltip: (BuildContext context) => Text(widget.tooltip),
      child: button,
    );
  }
}
