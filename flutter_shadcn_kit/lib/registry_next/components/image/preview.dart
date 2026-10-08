// Widgets-only preview gallery for the `image` component.
//
// No prefix needed: the component is `ShadcnImage`, which does not collide
// with Flutter's `Image`.

import 'package:flutter/widgets.dart';

import '../../foundation/icons/lucide_icons.dart';
import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';
import 'image.dart';

/// Preview entry point used by the docs gallery.
class ImagePreview extends StatelessWidget {
  /// Creates the preview.
  const ImagePreview({super.key});

  static const String _url =
      'https://raw.githubusercontent.com/facebook/react/main/fixtures/dom/public/react-logo.svg';

  @override
  Widget build(BuildContext context) {
    return const ShadcnTheme(
      data: ShadcnThemeData(),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: _ImagePreviewBody(),
      ),
    );
  }
}

class _ImagePreviewBody extends StatelessWidget {
  const _ImagePreviewBody();

  @override
  Widget build(BuildContext context) {
    final ShadcnColors colors = ShadcnTheme.of(context).colors;
    return ColoredBox(
      color: colors.background,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text('sizes and radii'),
            const SizedBox(height: 8),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ShadcnImage(
                  image: const NetworkImage(ImagePreview._url),
                  width: 96,
                  aspectRatio: 1,
                ),
                const SizedBox(width: 16),
                ShadcnImage(
                  image: const NetworkImage(ImagePreview._url),
                  width: 96,
                  aspectRatio: 1,
                  borderRadius: BorderRadius.zero,
                ),
                const SizedBox(width: 16),
                ShadcnImage(
                  image: const NetworkImage(ImagePreview._url),
                  width: 96,
                  aspectRatio: 1,
                  borderRadius: BorderRadius.circular(48),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text('placeholder and error slots'),
            const SizedBox(height: 8),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ShadcnImage(
                  image: const NetworkImage(
                    'https://example.invalid/missing.png',
                  ),
                  width: 96,
                  aspectRatio: 1,
                  placeholder: const Center(child: Icon(LucideIcons.loader)),
                  errorBuilder: (context, error, stackTrace) =>
                      const Center(child: Icon(LucideIcons.imageOff)),
                ),
                const SizedBox(width: 16),
                ShadcnImage(
                  image: const NetworkImage(
                    'https://example.invalid/missing.png',
                  ),
                  width: 96,
                  aspectRatio: 1,
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text('theme legs'),
            const SizedBox(height: 8),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ComponentTheme<ImageTheme>(
                  data: const ImageTheme(
                    background: ThemedColor.ref(ColorRef.accent, alpha: 0.5),
                    borderRadius: BorderRadius.zero,
                  ),
                  child: ShadcnImage(
                    image: const NetworkImage(ImagePreview._url),
                    width: 96,
                    aspectRatio: 1,
                  ),
                ),
                const SizedBox(width: 16),
                ShadcnImage(
                  image: const NetworkImage(ImagePreview._url),
                  width: 96,
                  aspectRatio: 1,
                  theme: const ImageTheme(borderRadius: BorderRadius.zero),
                ),
              ],
            ),
            const SizedBox(height: 24),
            ShadcnTheme(
              data: const ShadcnThemeData(colors: ShadcnColors.darkFallback),
              child: Builder(
                builder: (context) => ColoredBox(
                  color: ShadcnTheme.of(context).colors.background,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ShadcnImage(
                          image: const NetworkImage(ImagePreview._url),
                          width: 96,
                          aspectRatio: 1,
                        ),
                        const SizedBox(width: 16),
                        const Text('dark tokens'),
                      ],
                    ),
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
