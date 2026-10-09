// Widgets-only preview gallery for the `carousel` component.
//
// Shows both transitions, both axes, a fractional viewport, the dot row driven
// by the controller and a scoped theme leg.

import 'package:flutter/widgets.dart';

import '../../foundation/constants.dart';
import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';
import '../dot_indicator/dot_indicator.dart';
import 'carousel.dart';

/// Preview entry point used by the docs gallery.
class CarouselPreview extends StatefulWidget {
  /// Creates the preview.
  const CarouselPreview({super.key});

  @override
  State<CarouselPreview> createState() => _CarouselPreviewState();
}

class _CarouselPreviewState extends State<CarouselPreview> {
  final CarouselController _controller = CarouselController();
  int _index = 0;

  static const List<String> _pages = <String>['One', 'Two', 'Three', 'Four'];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _reset() {
    _controller.jumpTo(0);
    setState(() => _index = 0);
  }

  @override
  Widget build(BuildContext context) {
    return ShadcnTheme(
      data: const ShadcnThemeData(),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: _body(context),
      ),
    );
  }

  Widget _body(BuildContext context) {
    final colors = ShadcnTheme.of(context).colors;
    return ColoredBox(
      color: colors.background,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'sliding, page $_index',
              style: TextStyle(color: colors.foreground),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: 320,
              height: 96,
              child: Carousel(
                itemCount: _pages.length,
                controller: _controller,
                onIndexChanged: (int index) => setState(() => _index = index),
                itemBuilder: (context, index) => _page(colors, _pages[index]),
              ),
            ),
            const SizedBox(height: 8),
            DotIndicator(
              index: _index,
              length: _pages.length,
              onChanged: (int page) =>
                  _controller.animateTo(page.toDouble(), kDefaultDuration),
            ),
            const SizedBox(height: 24),
            const Text('fading, half viewport'),
            const SizedBox(height: 8),
            SizedBox(
              width: 320,
              height: 96,
              child: Carousel(
                itemCount: _pages.length,
                transition: CarouselTransition.fading,
                viewportFraction: 0.5,
                itemBuilder: (context, index) => _page(colors, _pages[index]),
              ),
            ),
            const SizedBox(height: 24),
            const Text('vertical, fixed 64px pages'),
            const SizedBox(height: 8),
            SizedBox(
              height: 128,
              width: 320,
              child: Carousel(
                itemCount: _pages.length,
                direction: Axis.vertical,
                itemExtent: 64,
                itemBuilder: (context, index) => _page(colors, _pages[index]),
              ),
            ),
            const SizedBox(height: 24),
            const Text('scoped theme leg (start aligned, no drag)'),
            const SizedBox(height: 8),
            ComponentTheme<CarouselTheme>(
              data: const CarouselTheme(
                alignment: CarouselAlignment.start,
                draggable: false,
                viewportFraction: 0.5,
                autoplayInterval: Duration(seconds: 3),
              ),
              child: SizedBox(
                width: 320,
                height: 96,
                child: Carousel(
                  itemCount: _pages.length,
                  onIndexChanged: (int index) {},
                  itemBuilder: (context, index) => _page(colors, _pages[index]),
                ),
              ),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: _reset,
              child: Text('reset', style: TextStyle(color: colors.primary)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _page(ShadcnColors colors, String label) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(color: colors.border),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(label, style: TextStyle(color: colors.foreground)),
    );
  }
}
