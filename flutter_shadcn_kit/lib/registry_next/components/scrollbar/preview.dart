// Gallery preview for the `scrollbar` component: default thumb, track
// visibility, a themed bar and the dark palette.
// Widgets-only; the docs app embeds [ScrollbarPreview] directly.

import 'package:flutter/widgets.dart';

import '../../foundation/gap.dart';
import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';
import 'scrollbar.dart';

/// Renders the scrollbar gallery.
class ScrollbarPreview extends StatefulWidget {
  /// Creates the preview.
  const ScrollbarPreview({super.key});

  @override
  State<ScrollbarPreview> createState() => _ScrollbarPreviewState();
}

class _ScrollbarPreviewState extends State<ScrollbarPreview> {
  final ScrollController _controller = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
                _section('Always visible', _sample(thumbVisibility: true)),
                const Gap(24),
                _section(
                  'Track',
                  _sample(thumbVisibility: true, trackVisibility: true),
                ),
                const Gap(24),
                _section(
                  'Themed',
                  ComponentTheme<ScrollbarTheme>(
                    data: const ScrollbarTheme(
                      color: ThemedColor.ref(ColorRef.primary),
                      thickness: 10,
                    ),
                    child: _sample(thumbVisibility: true),
                  ),
                ),
                const Gap(24),
                _section('Dark', _dark()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _sample({bool? thumbVisibility, bool? trackVisibility}) {
    return SizedBox(
      width: 320,
      height: 180,
      child: Scrollbar(
        controller: _controller,
        thumbVisibility: thumbVisibility,
        trackVisibility: trackVisibility,
        child: ListView.builder(
          controller: _controller,
          itemCount: 30,
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.all(8),
            child: Text('Item ${index + 1}'),
          ),
        ),
      ),
    );
  }

  Widget _dark() {
    return ShadcnTheme(
      data: const ShadcnThemeData(colors: ShadcnColors.darkFallback),
      child: _sample(thumbVisibility: true),
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
