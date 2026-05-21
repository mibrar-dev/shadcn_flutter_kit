// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of 'preview.dart';

/// _CarouselPreviewState holds mutable state for the carousel implementation.
class _CarouselPreviewState extends m.State<CarouselPreview> {
  final shadcn.CarouselController controller = shadcn.CarouselController();

  @override
  m.Widget build(m.BuildContext context) {
    return m.Scaffold(
      body: m.Center(
        child: m.SingleChildScrollView(
          child: m.Padding(
            padding: const m.EdgeInsets.all(16.0),
            child: m.SizedBox(
              width: 800,
              child: m.Column(
                children: [
                  m.Row(
                    children: [
                      OutlineButton(
                        shape: ButtonShape.circle,
                        onPressed: () {
                          controller.animatePrevious(
                            const Duration(milliseconds: 500),
                          );
                        },
                        child: const m.Icon(m.Icons.arrow_back),
                      ),

                      const m.SizedBox(width: 24),

                      m.Expanded(
                        child: m.SizedBox(
                          height: 200,
                          child: shadcn.Carousel(
                            transition: const shadcn.CarouselTransition.sliding(
                              gap: 24,
                            ),
                            controller: controller,
                            sizeConstraint:
                                const shadcn.CarouselFixedConstraint(200),
                            autoplaySpeed: const Duration(seconds: 2),
                            itemCount: 5,
                            itemBuilder: (context, index) {
                              return m.Container(
                                decoration: m.BoxDecoration(
                                  color:
                                      m.Colors.primaries[index %
                                          m.Colors.primaries.length],
                                  borderRadius: m.BorderRadius.circular(8),
                                ),
                                child: m.Center(
                                  child: m.Text(
                                    'Slide ${index + 1}',
                                    style: const m.TextStyle(
                                      color: m.Colors.white,
                                      fontSize: 18,
                                      fontWeight: m.FontWeight.bold,
                                    ),
                                  ),
                                ),
                              );
                            },
                            duration: const Duration(milliseconds: 500),
                          ),
                        ),
                      ),

                      const m.SizedBox(width: 24),

                      OutlineButton(
                        shape: ButtonShape.circle,
                        onPressed: () {
                          controller.animateNext(
                            const Duration(milliseconds: 500),
                          );
                        },
                        child: const m.Icon(m.Icons.arrow_forward),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
