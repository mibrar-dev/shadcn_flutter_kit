import 'package:flutter/widgets.dart';

import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';
import '../../theme/tokens.dart';
import 'dialog.dart';
import 'dialog_style.dart';

/// Widgets-only gallery of the dialog: dismissal modes, alignments, barrier
/// theming, full-screen mode, a dark subtree and a result round trip.
class DialogPreview extends StatelessWidget {
  const DialogPreview({super.key});

  @override
  Widget build(BuildContext context) {
    // The gallery ships its own navigator so the demos work wherever the
    // preview is mounted, and its own directionality + text style because
    // there is no Scaffold ancestor to inherit from.
    return Directionality(
      textDirection: TextDirection.ltr,
      child: DefaultTextStyle(
        style: const TextStyle(fontSize: 14),
        child: Navigator(
          onGenerateRoute: (settings) => PageRouteBuilder<void>(
            settings: settings,
            pageBuilder: (context, animation, secondaryAnimation) =>
                const _DialogGallery(),
          ),
        ),
      ),
    );
  }
}

class _DialogGallery extends StatelessWidget {
  const _DialogGallery();

  @override
  Widget build(BuildContext context) {
    final colors = ShadcnTheme.of(context).colors;
    return ColoredBox(
      color: colors.background,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: <Widget>[
            _Trigger(
              label: 'Open dialog',
              onPressed: (context) => showShadcnDialog<void>(
                context: context,
                builder: (context) => _DialogBody(
                  title: 'Delete this project?',
                  message: 'This cannot be undone.',
                ),
              ),
            ),
            _Trigger(
              label: 'Barrier locked',
              onPressed: (context) => showShadcnDialog<void>(
                context: context,
                barrierDismissible: false,
                builder: (context) => _DialogBody(
                  title: 'Confirm',
                  message: 'Escape and barrier taps are disabled.',
                ),
              ),
            ),
            _Trigger(
              label: 'Top left',
              onPressed: (context) => showShadcnDialog<void>(
                context: context,
                alignment: Alignment.topLeft,
                builder: (context) => _DialogBody(
                  title: 'Top left',
                  message: 'Alignment topLeft.',
                ),
              ),
            ),
            _Trigger(
              label: 'Returns a result',
              onPressed: (context) async {
                final result = await showShadcnDialog<String>(
                  context: context,
                  builder: (context) => _DialogBody(
                    title: 'Pick one',
                    message: 'The future completes with the picked value.',
                    onResult: (value) => Navigator.pop(context, value),
                  ),
                );
                debugPrint('showShadcnDialog returned $result');
              },
            ),
            _Trigger(
              label: 'Full screen',
              onPressed: (context) => showShadcnDialog<void>(
                context: context,
                fullScreen: true,
                builder: (context) => _DialogBody(
                  title: 'Full screen',
                  message: 'No radius, border, shadow or inset.',
                ),
              ),
            ),
            _Trigger(
              label: 'No safe area',
              onPressed: (context) => showShadcnDialog<void>(
                context: context,
                useSafeArea: false,
                builder: (context) => const _DialogBody(
                  title: 'No safe area',
                  message: 'The card reaches the screen edges.',
                ),
              ),
            ),
            _Trigger(
              label: 'Themed barrier',
              onPressed: (context) => showShadcnDialog<void>(
                context: context,
                theme: const DialogTheme(
                  barrierColor: ThemedColor.ref(ColorRef.primary, alpha: 0.35),
                  maxWidth: 320,
                  borderRadius: BorderRadius.all(Radius.circular(24)),
                  shadows: <BoxShadow>[],
                ),
                builder: (context) => const _DialogBody(
                  title: 'Widget theme',
                  message: 'Barrier and radius come from the theme param.',
                ),
              ),
            ),
            ShadcnTheme(
              data: ShadcnThemeData(
                colors: ShadcnColors.darkFallback,
                tokens: ShadcnTokens(radius: 1.0),
              ),
              child: _Trigger(
                label: 'Open (dark, radius 1.0)',
                onPressed: (context) => showShadcnDialog<void>(
                  context: context,
                  builder: (context) => _DialogBody(
                    title: 'Dark tokens',
                    message: 'Card, border and shadows follow the tokens.',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Minimal focusable, pressable control used by the gallery so the preview
/// needs no dependency on the button component.
class _Trigger extends StatefulWidget {
  const _Trigger({required this.label, required this.onPressed});

  final String label;
  final void Function(BuildContext context) onPressed;

  @override
  State<_Trigger> createState() => _TriggerState();
}

class _TriggerState extends State<_Trigger> {
  bool _hovered = false;
  bool _pressed = false;

  bool get _activated => _hovered || _pressed;

  @override
  Widget build(BuildContext context) {
    final colors = ShadcnTheme.of(context).colors;
    return FocusableActionDetector(
      onShowHoverHighlight: (value) => setState(() => _hovered = value),
      onShowFocusHighlight: (value) =>
          setState(() => _hovered = _hovered || value),
      actions: <Type, Action<Intent>>{
        ActivateIntent: CallbackAction<ActivateIntent>(
          onInvoke: (_) {
            widget.onPressed(context);
            return null;
          },
        ),
      },
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTapDown: (_) => setState(() => _pressed = true),
          onTapUp: (_) => setState(() => _pressed = false),
          onTapCancel: () => setState(() => _pressed = false),
          onTap: () => widget.onPressed(context),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: _activated
                  ? colors.accent.withValues(alpha: 0.5)
                  : colors.primary,
              borderRadius: const BorderRadius.all(Radius.circular(6)),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Text(
                widget.label,
                style: TextStyle(color: colors.primaryForeground),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Content placed inside the dialog card. Actions are caller supplied.
class _DialogBody extends StatelessWidget {
  const _DialogBody({
    required this.title,
    required this.message,
    this.onResult,
  });

  final String title;
  final String message;
  final void Function(String result)? onResult;

  @override
  Widget build(BuildContext context) {
    final colors = ShadcnTheme.of(context).colors;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: TextStyle(
            color: colors.foreground,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        Text(message, style: TextStyle(color: colors.mutedForeground)),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            _Trigger(
              label: 'Close',
              onPressed: (context) => Navigator.of(context).maybePop(),
            ),
            if (onResult != null) ...<Widget>[
              const SizedBox(width: 8),
              _Trigger(
                label: 'Confirm',
                onPressed: (context) => onResult!('ok'),
              ),
            ],
          ],
        ),
      ],
    );
  }
}
