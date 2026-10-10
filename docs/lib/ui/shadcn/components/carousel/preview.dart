// Named examples for the `carousel` component (P6-F3 preview contract).
//
// One focused demo per example; the first entry is the default. Spacing comes
// from the ambient theme, so the examples follow the selected preset and the
// site light/dark toggle.

import 'package:flutter/widgets.dart';

import '../../foundation/component_preview.dart';
import '../../foundation/constants.dart';
import '../../foundation/gap.dart';
import '../../theme/theme.dart';
import '../dot_indicator/dot_indicator.dart';
import 'carousel.dart';

/// Pages the carousel slides through.
const List<String> _carouselPages = <String>['One', 'Two', 'Three', 'Four'];

/// One palette-derived page surface.
Widget _carouselPage(BuildContext context, String label) {
  final theme = ShadcnTheme.of(context);
  return DecoratedBox(
    decoration: BoxDecoration(
      color: theme.colors.muted,
      borderRadius: theme.borderRadiusMd,
    ),
    child: Center(
      child: Text(
        label,
        style: TextStyle(
          color: theme.colors.foreground,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
  );
}

/// The carousel with the dot row driven by its controller.
class _CarouselCarousel extends StatefulWidget {
  const _CarouselCarousel({this.fade = false});

  final bool fade;

  @override
  State<_CarouselCarousel> createState() => _CarouselCarouselState();
}

class _CarouselCarouselState extends State<_CarouselCarousel> {
  final CarouselController _controller = CarouselController();
  int _index = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final spacing = ShadcnTheme.of(context).spacing;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          width: 320,
          height: 96,
          child: Carousel(
            itemCount: _carouselPages.length,
            controller: _controller,
            transition: widget.fade ? CarouselTransition.fading : null,
            onIndexChanged: (int index) => setState(() => _index = index),
            itemBuilder: (context, index) =>
                _carouselPage(context, _carouselPages[index]),
          ),
        ),
        Gap(spacing.md),
        DotIndicator(
          index: _index,
          length: _carouselPages.length,
          onChanged: (int page) =>
              _controller.animateTo(page.toDouble(), kDefaultDuration),
        ),
      ],
    );
  }
}

/// Sliding transition.
Widget _carouselSlide(BuildContext context) => const _CarouselCarousel();

/// Fading transition.
Widget _carouselFade(BuildContext context) =>
    const _CarouselCarousel(fade: true);

/// An autoplaying carousel that advances on its own.
class _CarouselAutoplay extends StatelessWidget {
  const _CarouselAutoplay();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 320,
      height: 96,
      child: Carousel(
        itemCount: _carouselPages.length,
        autoplayInterval: const Duration(seconds: 2),
        itemBuilder: (context, index) =>
            _carouselPage(context, _carouselPages[index]),
      ),
    );
  }
}

Widget _carouselAutoplay(BuildContext context) => const _CarouselAutoplay();

/// Named docs examples for `carousel`; the first entry is the default.
const List<ComponentPreview> carouselPreviews = <ComponentPreview>[
  ComponentPreview('Slide', _carouselSlide),
  ComponentPreview('Fade', _carouselFade),
  ComponentPreview('Autoplay', _carouselAutoplay),
];
