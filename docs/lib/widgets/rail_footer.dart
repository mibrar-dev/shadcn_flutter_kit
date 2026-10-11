// The footer of the Theme Studio rail (spec §2.7).
//
// The reference's footer is two stacked bars on `muted/50` with a top border:
// a monospace pill showing the active preset id, then `Open Preset`, `Shuffle`
// and a primary `Get Code`. Ours keeps that order and swaps the first pill for
// a real id field (typing an id loads that registry preset, which is what the
// reference's read-only pill invites you to do).

import 'package:flutter/widgets.dart';

import '../../ui/shadcn/components/button/button.dart';
import '../../ui/shadcn/components/input/input.dart';
import '../../ui/shadcn/foundation/gap.dart';
import '../../ui/shadcn/theme/theme.dart';

/// The rail footer: preset id field plus the three actions.
class RailFooter extends StatefulWidget {
  /// Creates the footer.
  const RailFooter({
    super.key,
    required this.presetId,
    required this.onOpenPreset,
    required this.onShuffle,
    required this.onGetCode,
  });

  /// The active preset id, shown (and editable) in the mono pill.
  final String presetId;

  /// Opens the `Open Preset` paste dialog.
  final VoidCallback onOpenPreset;

  /// Picks a random valid combination.
  final VoidCallback onShuffle;

  /// Opens the `Get Code` dialog.
  final VoidCallback onGetCode;

  @override
  State<RailFooter> createState() => _RailFooterState();
}

class _RailFooterState extends State<RailFooter> {
  late final TextEditingController _id = TextEditingController(
    text: widget.presetId,
  );

  @override
  void didUpdateWidget(RailFooter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.presetId != _id.text) {
      _id.text = widget.presetId;
    }
  }

  @override
  void dispose() {
    _id.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: theme.colors.border)),
        color: theme.colors.muted.withValues(alpha: 0.5),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 28,
            child: Input(
              key: const ValueKey<String>('theme-rail-preset-id'),
              controller: _id,
              style: theme.typography.mono.copyWith(fontSize: 12),
              filled: true,
              decoration: BoxDecoration(
                color: theme.colors.background,
                borderRadius: BorderRadius.circular(6),
              ),
              border: Border.all(color: theme.colors.border),
              borderRadius: BorderRadius.circular(6),
              padding: const EdgeInsets.symmetric(horizontal: 8),
            ),
          ),
          const Gap(8),
          _FooterButton(label: 'Open Preset', onPressed: widget.onOpenPreset),
          const Gap(8),
          _FooterButton(label: 'Shuffle', onPressed: widget.onShuffle),
          const Gap(8),
          Button(
            key: const ValueKey<String>('theme-rail-get-code'),
            variant: ButtonVariant.primary,
            size: ButtonSize.sm,
            onPressed: widget.onGetCode,
            child: const Text('Get Code'),
          ),
        ],
      ),
    );
  }
}

class _FooterButton extends StatelessWidget {
  const _FooterButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Button(
        variant: ButtonVariant.outline,
        size: ButtonSize.sm,
        onPressed: onPressed,
        child: Text(label),
      ),
    );
  }
}
