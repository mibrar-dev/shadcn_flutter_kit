// Size audit B: already-accepted components vs shadcn/ui new-york v4.
//
// Same conventions as `size_audit_a_test.dart`: every expectation cites the
// shadcn class it mirrors, kit-specific controls assert their documented
// structure.

import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry_next/components/accordion/accordion.dart';
import 'package:flutter_shadcn_kit/registry_next/components/collapsible/collapsible.dart';
import 'package:flutter_shadcn_kit/registry_next/components/dot_indicator/dot_indicator.dart';
import 'package:flutter_shadcn_kit/registry_next/components/icon/icon.dart';
import 'package:flutter_shadcn_kit/registry_next/components/outlined_container/outlined_container.dart';
import 'package:flutter_shadcn_kit/registry_next/components/progress/progress.dart';
import 'package:flutter_shadcn_kit/registry_next/components/scrollbar/scrollbar.dart';
import 'package:flutter_shadcn_kit/registry_next/components/scrollview/scrollview.dart';
import 'package:flutter_shadcn_kit/registry_next/components/selectable/selectable.dart';
import 'package:flutter_shadcn_kit/registry_next/components/slider/slider.dart';
import 'package:flutter_shadcn_kit/registry_next/components/spinner/spinner.dart';
import 'package:flutter_shadcn_kit/registry_next/components/triple_dots/triple_dots.dart';
import 'package:flutter_shadcn_kit/registry_next/primitives/clickable.dart';
import 'package:flutter_shadcn_kit/registry_next/primitives/slider/slider.dart';
import 'package:flutter_shadcn_kit/registry_next/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _frame({required Widget child}) {
  return ShadcnTheme(
    data: const ShadcnThemeData(),
    child: Directionality(
      textDirection: TextDirection.ltr,
      child: Center(child: child),
    ),
  );
}

void main() {
  group('slider (track h-1.5 = 6, thumb size-4 = 16)', () {
    testWidgets('standard track is 6px and the widget is 16px tall', (
      tester,
    ) async {
      await tester.pumpWidget(
        _frame(
          child: SizedBox(
            width: 300,
            child: Slider(value: 0.5, onChanged: (_) {}),
          ),
        ),
      );
      final CustomPaint paint = tester.widget<CustomPaint>(
        find
            .descendant(
              of: find.byType(Slider),
              matching: find.byType(CustomPaint),
            )
            .first,
      );
      final SliderPainter painter = paint.painter! as SliderPainter;
      expect(painter.view.trackRect.height, 6);
      expect(tester.getSize(find.byType(Slider)).height, 16);
    });
  });

  group('progress (h-2 = 8)', () {
    testWidgets('bar is 8px tall', (tester) async {
      await tester.pumpWidget(_frame(child: const Progress(value: 0.4)));
      expect(tester.getSize(find.byType(Progress)).height, 8);
    });
  });

  group('spinner (lucide default 24, stroke size/12)', () {
    testWidgets('default box is 24px', (tester) async {
      await tester.pumpWidget(_frame(child: const Spinner()));
      expect(tester.getSize(find.byType(Spinner)), const Size.square(24));
    });
  });

  group('triple_dots (kit loading dots: 4px dots, 2px gaps)', () {
    testWidgets('three dots measure 16 x 4', (tester) async {
      await tester.pumpWidget(_frame(child: const TripleDots()));
      expect(tester.getSize(find.byType(TripleDots)), const Size(16, 4));
    });
  });

  group('icon container (kit: padXs x container density = 8)', () {
    testWidgets('padding sits inside the decoration', (tester) async {
      await tester.pumpWidget(
        _frame(child: IconContainer(icon: const Text('i'))),
      );
      final Container box = tester.widget<Container>(
        find
            .descendant(
              of: find.byType(IconContainer),
              matching: find.byType(Container),
            )
            .first,
      );
      expect(box.padding, const EdgeInsets.all(8));
      final BoxDecoration decoration = box.decoration! as BoxDecoration;
      expect(decoration.borderRadius, const ShadcnThemeData().borderRadiusMd);
    });
  });

  group('selectable (theme font via resolveEditableTextStyle)', () {
    testWidgets('bare app still gets the theme font', (tester) async {
      // No ambient DefaultTextStyle: EditableText ignores inheritance, so
      // without the resolver the style would carry no font at all.
      await tester.pumpWidget(
        ShadcnTheme(
          data: const ShadcnThemeData(),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Center(child: SelectableText('Select me')),
          ),
        ),
      );
      final EditableText editable = tester.widget<EditableText>(
        find.byType(EditableText),
      );
      expect(
        editable.style.fontFamily,
        const ShadcnThemeData().typography.sans.fontFamily,
      );
    });
  });

  group('scrollbar (kit: 7px thumb)', () {
    testWidgets('thumb thickness resolves 7 at default scaling', (
      tester,
    ) async {
      await tester.pumpWidget(
        _frame(
          child: SizedBox(
            height: 100,
            child: Scrollbar(
              child: SingleChildScrollView(
                child: SizedBox(height: 2000, width: 10),
              ),
            ),
          ),
        ),
      );
      final RawScrollbar raw = tester.widget<RawScrollbar>(
        find.byType(RawScrollbar),
      );
      expect(raw.thickness, 7);
    });
  });

  group('scrollview (behavior-only autoscroll wrapper)', () {
    testWidgets('child size passes through untouched', (tester) async {
      await tester.pumpWidget(
        _frame(
          child: ScrollViewInterceptor(child: SizedBox(width: 100, height: 50)),
        ),
      );
      expect(
        tester.getSize(find.byType(ScrollViewInterceptor)),
        const Size(100, 50),
      );
    });
  });

  group('outlined container (kit: xl radius, zero padding)', () {
    testWidgets('radius follows xl, padding defaults to zero', (tester) async {
      await tester.pumpWidget(
        _frame(child: const OutlinedContainer(child: Text('hi'))),
      );
      final Container box = tester.widget<Container>(
        find
            .descendant(
              of: find.byType(OutlinedContainer),
              matching: find.byType(Container),
            )
            .first,
      );
      final BoxDecoration decoration = box.decoration! as BoxDecoration;
      expect(decoration.borderRadius, const ShadcnThemeData().borderRadiusXl);
      expect(box.padding, EdgeInsets.zero);
    });
  });

  group('collapsible (unstyled in shadcn; kit content padding 16)', () {
    testWidgets('trigger pads 16 horizontally, content is unpadded', (
      tester,
    ) async {
      await tester.pumpWidget(
        _frame(
          child: const Collapsible(
            children: <Widget>[
              CollapsibleTrigger(child: Text('More')),
              CollapsibleContent(child: Text('Details')),
            ],
          ),
        ),
      );
      final Padding trigger = tester.widget<Padding>(
        find
            .descendant(
              of: find.byType(CollapsibleTrigger),
              matching: find.byType(Padding),
            )
            .first,
      );
      expect(trigger.padding, const EdgeInsets.symmetric(horizontal: 16));
      expect(
        find.ancestor(of: find.text('Details'), matching: find.byType(Padding)),
        findsNothing,
      );
    });
  });

  group('accordion (trigger py-4 text-sm, content pb-4, 1px dividers)', () {
    Widget accordion({bool expanded = true}) {
      return Accordion(
        items: <AccordionItem>[
          AccordionItem(
            trigger: const AccordionTrigger(child: Text('Q1')),
            content: const Text('A1'),
            expanded: expanded,
          ),
          AccordionItem(
            trigger: const AccordionTrigger(child: Text('Q2')),
            content: const Text('A2'),
          ),
        ],
      );
    }

    testWidgets('trigger pads 16 vertically, chevron is size-4 (16)', (
      tester,
    ) async {
      await tester.pumpWidget(_frame(child: accordion()));
      final Finder clickableFinder = find.descendant(
        of: find.byType(AccordionTrigger).first,
        matching: find.byType(Clickable),
      );
      expect(clickableFinder, findsOneWidget);
      // The trigger paints no surface of its own: height comes from the
      // text plus this vertical padding (py-4), never stacked outside a
      // minHeight.
      final Clickable clickable = tester.widget<Clickable>(clickableFinder);
      expect(
        clickable.padding?.resolve(const <WidgetState>{}),
        const EdgeInsets.symmetric(vertical: 16),
      );
      final IconTheme iconTheme = tester.widget<IconTheme>(
        // Nearest scope above the chevron: Clickable also publishes its
        // own default (24) icon theme higher up the trigger row.
        find
            .ancestor(
              of: find.descendant(
                of: find.byType(AccordionTrigger).first,
                matching: find.byType(Icon),
              ),
              matching: find.byType(IconTheme),
            )
            .first,
      );
      expect(iconTheme.data.size, 16);
    });

    testWidgets('expanded content pads 16 at the bottom only', (tester) async {
      await tester.pumpWidget(_frame(child: accordion()));
      await tester.pump(const Duration(milliseconds: 300));
      final Padding padding = tester.widget<Padding>(
        find
            .ancestor(of: find.text('A1'), matching: find.byType(Padding))
            .first,
      );
      expect(padding.padding, const EdgeInsets.only(bottom: 16));
    });

    testWidgets('items divide with a 1px rule (border-b)', (tester) async {
      await tester.pumpWidget(_frame(child: accordion(expanded: false)));
      expect(
        find.byWidgetPredicate(
          (w) => w is SizedBox && w.height == 1,
          description: '1px divider',
        ),
        findsOneWidget,
      );
    });
  });

  group('dot indicator (kit: 12px dots, 8px gaps)', () {
    double pitch(WidgetTester tester) {
      // The dots are the only 12px boxes: in interactive mode the Clickable
      // containers around them measure 20 (12 + gap/2 padding per side).
      final List<Rect> rects = <Rect>[
        for (final AnimatedContainer dot
            in tester.widgetList<AnimatedContainer>(
              find.descendant(
                of: find.byType(DotIndicator),
                matching: find.byType(AnimatedContainer),
              ),
            ))
          tester.getRect(find.byWidget(dot)),
      ].where((Rect r) => (r.width - 12).abs() < 0.01).toList();
      expect(rects.length, 3);
      rects.sort((Rect a, Rect b) => a.left.compareTo(b.left));
      return rects[1].center.dx - rects[0].center.dx;
    }

    testWidgets('read-only dots pitch 20 (12 + 8)', (tester) async {
      await tester.pumpWidget(
        _frame(child: const DotIndicator(index: 0, length: 3)),
      );
      expect(pitch(tester), 20);
    });

    testWidgets('interactive dots keep the same 20 pitch', (tester) async {
      // The Clickable pads gap/2 per side inside its decoration, which
      // already forms the visual gap; a spacer on top doubled it to 28.
      await tester.pumpWidget(
        _frame(child: DotIndicator(index: 0, length: 3, onChanged: (_) {})),
      );
      expect(pitch(tester), 20);
    });
  });
}
