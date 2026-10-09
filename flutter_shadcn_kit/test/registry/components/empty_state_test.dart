// Widget tests for the `empty_state` component.
//
// Covers both sizes, all three variants and their default strings, the icon
// container, every action slot, the localized defaults, all four
// theme-precedence legs, light and dark tokens, and one regression test per old
// bug that was fixed.

import 'package:flutter/material.dart' show Icons;
import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/components/button/button.dart';
import 'package:flutter_shadcn_kit/registry/components/card/card.dart'
    as shadcn;
import 'package:flutter_shadcn_kit/registry/components/empty_state/empty_state.dart';
import 'package:flutter_shadcn_kit/registry/foundation/icons/radix_icons.dart';
import 'package:flutter_shadcn_kit/registry/primitives/localizations/localizations.dart';
import 'package:flutter_shadcn_kit/registry/theme/color_tokens.dart';
import 'package:flutter_shadcn_kit/registry/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

const Color _green = Color(0xFF00FF00);
const Color _blue = Color(0xFF0000FF);

Widget _frame({
  required Widget child,
  ShadcnThemeData data = const ShadcnThemeData(),
  List<ComponentThemeData> app = const <ComponentThemeData>[],
  EmptyStateTheme? scoped,
  Locale? locale,
}) {
  Widget body = child;
  if (scoped != null) {
    body = ComponentTheme<EmptyStateTheme>(data: scoped, child: body);
  }
  Widget root = ShadcnTheme(
    data: data,
    child: ComponentThemes(
      themes: app,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Center(child: SizedBox(width: 600, height: 600, child: body)),
      ),
    ),
  );
  if (locale != null) {
    root = Localizations(
      locale: locale,
      // `Localizations` insists on a widgets delegate, so both are needed.
      delegates: const <LocalizationsDelegate<dynamic>>[
        DefaultWidgetsLocalizations.delegate,
        ShadcnLocalizations.delegate,
      ],
      child: root,
    );
  }
  return root;
}

BoxDecoration _iconContainer(WidgetTester tester) =>
    tester
            .widget<DecoratedBox>(find.byKey(emptyStateIconContainerKey))
            .decoration
        as BoxDecoration;

void main() {
  group('variants', () {
    testWidgets('empty supplies the default strings and icon', (tester) async {
      await tester.pumpWidget(_frame(child: const EmptyState()));
      expect(find.text('Nothing here yet'), findsOneWidget);
      expect(
        find.text('Create your first item to get started.'),
        findsOneWidget,
      );
      expect(find.byIcon(RadixIcons.archive), findsOneWidget);
    });

    testWidgets('noResults supplies its own defaults', (tester) async {
      await tester.pumpWidget(
        _frame(child: const EmptyState(variant: EmptyStateVariant.noResults)),
      );
      expect(find.text('No results found'), findsOneWidget);
      expect(
        find.text('Try adjusting your filters or search terms.'),
        findsOneWidget,
      );
      expect(find.byIcon(RadixIcons.magnifyingGlass), findsOneWidget);
    });

    testWidgets('errorFallback supplies its own defaults', (tester) async {
      await tester.pumpWidget(
        _frame(
          child: const EmptyState(variant: EmptyStateVariant.errorFallback),
        ),
      );
      expect(find.text('Something went wrong'), findsOneWidget);
      expect(
        find.text('We couldn\u2019t load this data. Try again in a moment.'),
        findsOneWidget,
      );
      expect(find.byIcon(RadixIcons.exclamationTriangle), findsOneWidget);
    });

    testWidgets('the variant icon side comes from the size table', (
      tester,
    ) async {
      await tester.pumpWidget(_frame(child: const EmptyState()));
      expect(tester.getSize(find.byIcon(RadixIcons.archive)).width, 36);
      await tester.pumpWidget(
        _frame(child: const EmptyState(size: EmptyStateSize.compact)),
      );
      expect(tester.getSize(find.byIcon(RadixIcons.archive)).width, 28);
    });

    testWidgets('explicit title and description win', (tester) async {
      await tester.pumpWidget(
        _frame(
          child: const EmptyState(
            title: Text('Custom title'),
            description: Text('Custom description'),
          ),
        ),
      );
      expect(find.text('Custom title'), findsOneWidget);
      expect(find.text('Custom description'), findsOneWidget);
      expect(find.text('Nothing here yet'), findsNothing);
    });

    testWidgets('an explicit icon wins', (tester) async {
      await tester.pumpWidget(
        _frame(child: const EmptyState(icon: Icon(Icons.star))),
      );
      expect(find.byIcon(Icons.star), findsOneWidget);
      expect(find.byIcon(RadixIcons.archive), findsNothing);
    });
  });

  group('localization', () {
    testWidgets('regression: the defaults come from the localizations', (
      tester,
    ) async {
      // The old defaults were plain functions returning hard-coded English
      // (`defaultEmptyStateTitle(variant)`), so the block never translated.
      await tester.pumpWidget(
        _frame(
          child: const EmptyState(variant: EmptyStateVariant.noResults),
          locale: const Locale('en'),
        ),
      );
      final ShadcnLocalizations l10n = ShadcnLocalizations.of(
        tester.element(find.byType(EmptyState)),
      );
      expect(find.text(l10n.emptyStateNoResultsTitle), findsOneWidget);
      expect(find.text(l10n.emptyStateNoResultsDescription), findsOneWidget);
    });

    testWidgets('an untranslated locale falls back to English', (tester) async {
      await tester.pumpWidget(
        _frame(
          child: const EmptyState(variant: EmptyStateVariant.errorFallback),
          locale: const Locale('tr'),
        ),
      );
      expect(find.text('Something went wrong'), findsOneWidget);
    });
  });

  group('sizes', () {
    testWidgets('compact draws a card surface, full page does not', (
      tester,
    ) async {
      await tester.pumpWidget(
        _frame(child: const EmptyState(size: EmptyStateSize.compact)),
      );
      expect(find.byType(shadcn.Card), findsOneWidget);
      await tester.pumpWidget(_frame(child: const EmptyState()));
      expect(find.byType(shadcn.Card), findsNothing);
    });

    testWidgets('full page centres the block', (tester) async {
      await tester.pumpWidget(_frame(child: const EmptyState()));
      // The whole padded block is centred, so the title sits below the middle:
      // half the block's height above it.
      final Size block = tester.getSize(find.byType(EmptyState));
      final Rect title = tester.getRect(find.text('Nothing here yet'));
      expect(block.height, greaterThan(0));
      expect(title.center.dy, greaterThan(300));
    });

    testWidgets('the title style follows the size table', (tester) async {
      // The title is merged through `DefaultTextStyle`, so the size lives on
      // the wrapper rather than on the `Text` itself.
      TextStyle titleStyle() => tester
          .widget<DefaultTextStyle>(
            find
                .ancestor(
                  of: find.text('Nothing here yet'),
                  matching: find.byType(DefaultTextStyle),
                )
                .first,
          )
          .style;
      await tester.pumpWidget(_frame(child: const EmptyState()));
      expect(titleStyle().fontSize, 24);
      expect(titleStyle().fontWeight, FontWeight.w600);
      expect(titleStyle().color, ShadcnColors.lightFallback.foreground);
      await tester.pumpWidget(
        _frame(child: const EmptyState(size: EmptyStateSize.compact)),
      );
      expect(titleStyle().fontSize, 20);
    });

    testWidgets('regression: scaling applies once, to the whole scale', (
      tester,
    ) async {
      // The old widget multiplied each metric by `theme.scaling` inline and
      // multiplied some of them a second time by `density.baseGap * gapMd`, so
      // the numbers depended on the flags the caller happened to set.
      await tester.pumpWidget(
        _frame(
          data: const ShadcnThemeData(scaling: 2),
          child: const EmptyState(),
        ),
      );
      // 36 icon + 2 * (24 padding + 24 icon->title + 12 title->desc) + title
      expect(tester.getSize(find.byIcon(RadixIcons.archive)).width, 72);
      final Size block = tester.getSize(find.byType(EmptyState));
      expect(block.width, 600); // clamped by the 600 test surface
      // The container is icon (36 * 2) plus its own padding (12 * 2, each
      // side): 72 + 48 = 120.
      expect(tester.getSize(find.byKey(emptyStateIconContainerKey)).width, 120);
    });
  });

  group('icon container', () {
    testWidgets('uses the muted and border tokens', (tester) async {
      await tester.pumpWidget(_frame(child: const EmptyState()));
      final BoxDecoration decoration = _iconContainer(tester);
      expect(decoration.color, ShadcnColors.lightFallback.muted);
      expect(decoration.border?.top.color, ShadcnColors.lightFallback.border);
    });

    testWidgets('showIconContainer: false drops it', (tester) async {
      await tester.pumpWidget(
        _frame(child: const EmptyState(showIconContainer: false)),
      );
      expect(find.byKey(emptyStateIconContainerKey), findsNothing);
      expect(find.byIcon(RadixIcons.archive), findsOneWidget);
    });

    testWidgets('dark palette drives the same slots', (tester) async {
      const ShadcnColors dark = ShadcnColors.darkFallback;
      await tester.pumpWidget(
        _frame(
          data: const ShadcnThemeData(colors: dark),
          child: const EmptyState(),
        ),
      );
      final BoxDecoration decoration = _iconContainer(tester);
      expect(decoration.color, dark.muted);
      expect(decoration.border?.top.color, dark.border);
    });
  });

  group('actions', () {
    testWidgets('no action means no action row', (tester) async {
      await tester.pumpWidget(_frame(child: const EmptyState()));
      expect(find.byKey(emptyStateActionsKey), findsNothing);
      expect(find.byType(Button), findsNothing);
    });

    testWidgets('primary and secondary sit in one wrapped row', (tester) async {
      await tester.pumpWidget(
        _frame(
          child: const EmptyState(
            primaryAction: EmptyStateAction(label: 'Create'),
            secondaryAction: EmptyStateAction(label: 'Import'),
          ),
        ),
      );
      expect(find.byKey(emptyStateActionsKey), findsOneWidget);
      final List<Button> buttons = tester
          .widgetList<Button>(find.byType(Button))
          .toList();
      expect(buttons.length, 2);
      // The first action is primary, the second falls back to secondary.
      expect(buttons[0].variant, ButtonVariant.primary);
      expect(buttons[1].variant, ButtonVariant.secondary);
    });

    testWidgets('the footer action gets its own row', (tester) async {
      await tester.pumpWidget(
        _frame(
          child: const EmptyState(
            primaryAction: EmptyStateAction(label: 'Create'),
            footerAction: EmptyStateAction(label: 'Report this'),
          ),
        ),
      );
      final List<Button> buttons = tester
          .widgetList<Button>(find.byType(Button))
          .toList();
      expect(buttons.length, 2);
      expect(buttons[1].child, isA<Text>());
    });

    testWidgets('an explicit variant beats the positional default', (
      tester,
    ) async {
      await tester.pumpWidget(
        _frame(
          child: const EmptyState(
            secondaryAction: EmptyStateAction(
              label: 'Import',
              variant: ButtonVariant.link,
            ),
          ),
        ),
      );
      expect(
        tester.widget<Button>(find.byType(Button)).variant,
        ButtonVariant.link,
      );
    });

    testWidgets('the button size follows the empty-state size', (tester) async {
      await tester.pumpWidget(
        _frame(
          child: const EmptyState(
            size: EmptyStateSize.compact,
            primaryAction: EmptyStateAction(label: 'Create'),
          ),
        ),
      );
      expect(tester.widget<Button>(find.byType(Button)).size, ButtonSize.sm);
      await tester.pumpWidget(
        _frame(
          child: const EmptyState(
            primaryAction: EmptyStateAction(label: 'Create'),
          ),
        ),
      );
      expect(tester.widget<Button>(find.byType(Button)).size, ButtonSize.md);
    });

    testWidgets('a null onPressed renders a disabled button', (tester) async {
      await tester.pumpWidget(
        _frame(
          child: const EmptyState(
            primaryAction: EmptyStateAction(label: 'Create'),
          ),
        ),
      );
      expect(tester.widget<Button>(find.byType(Button)).onPressed, isNull);
    });

    testWidgets('an onPressed fires', (tester) async {
      int taps = 0;
      await tester.pumpWidget(
        _frame(
          child: EmptyState(
            primaryAction: EmptyStateAction(
              label: 'Create',
              onPressed: () => taps++,
            ),
          ),
        ),
      );
      await tester.tap(find.text('Create'));
      await tester.pump();
      expect(taps, 1);
    });
  });

  group('theme precedence', () {
    testWidgets('app leg overrides the defaults', (tester) async {
      await tester.pumpWidget(
        _frame(
          app: const <ComponentThemeData>[
            EmptyStateTheme(iconContainerBackground: ThemedColor.value(_green)),
          ],
          child: const EmptyState(),
        ),
      );
      expect(_iconContainer(tester).color, _green);
    });

    testWidgets('scoped leg overrides the app leg', (tester) async {
      await tester.pumpWidget(
        _frame(
          app: const <ComponentThemeData>[
            EmptyStateTheme(iconContainerBackground: ThemedColor.value(_green)),
          ],
          scoped: const EmptyStateTheme(
            iconContainerBackground: ThemedColor.value(_blue),
          ),
          child: const EmptyState(),
        ),
      );
      expect(_iconContainer(tester).color, _blue);
    });

    testWidgets('widget leg overrides the scoped leg', (tester) async {
      await tester.pumpWidget(
        _frame(
          scoped: const EmptyStateTheme(
            iconContainerBackground: ThemedColor.value(_green),
          ),
          child: const EmptyState(
            theme: EmptyStateTheme(
              iconContainerBackground: ThemedColor.value(_blue),
            ),
          ),
        ),
      );
      expect(_iconContainer(tester).color, _blue);
    });

    testWidgets('a leg setting one field keeps the other defaults', (
      tester,
    ) async {
      await tester.pumpWidget(
        _frame(
          scoped: const EmptyStateTheme(
            iconContainerBackground: ThemedColor.value(_green),
          ),
          child: const EmptyState(),
        ),
      );
      final BoxDecoration decoration = _iconContainer(tester);
      expect(decoration.color, _green);
      // The border still comes from the defaults row.
      expect(decoration.border?.top.color, ShadcnColors.lightFallback.border);
    });

    testWidgets('regression: a leg setting one field keeps the whole rest', (
      tester,
    ) async {
      // The old `EmptyStateTheme` had no `Mergeable`, so `resolveComponentStyle`
      // could not merge it: a leg that set only `iconColor` replaced the whole
      // theme and every other field fell back to `null`.
      await tester.pumpWidget(
        _frame(
          scoped: const EmptyStateTheme(iconColor: ThemedColor.value(_blue)),
          child: const EmptyState(),
        ),
      );
      final BoxDecoration decoration = _iconContainer(tester);
      expect(decoration.color, ShadcnColors.lightFallback.muted);
      expect(decoration.border?.top.color, ShadcnColors.lightFallback.border);
      expect(tester.getSize(find.byIcon(RadixIcons.archive)).width, 36);
    });

    testWidgets('a metrics entry wins as a whole', (tester) async {
      await tester.pumpWidget(
        _frame(
          scoped: EmptyStateTheme(
            metrics: const <EmptyStateSize, EmptyStateMetrics>{
              EmptyStateSize.fullPage: EmptyStateMetrics(
                iconSize: 48,
                titleStyle: TextStyle(fontSize: 30),
                descriptionStyle: TextStyle(fontSize: 16),
                padding: EdgeInsets.all(40),
                contentGap: 32,
                titleGap: 12,
                actionGap: 32,
                actionSpacing: 12,
                maxWidth: 640,
                descriptionMaxWidth: 640,
              ),
            },
          ),
          child: const EmptyState(),
        ),
      );
      expect(tester.getSize(find.byIcon(RadixIcons.archive)).width, 48);
      expect(
        tester
            .widget<DefaultTextStyle>(
              find
                  .ancestor(
                    of: find.text('Nothing here yet'),
                    matching: find.byType(DefaultTextStyle),
                  )
                  .first,
            )
            .style
            .fontSize,
        30,
      );
    });

    testWidgets('a metrics entry for the other size is ignored', (
      tester,
    ) async {
      await tester.pumpWidget(
        _frame(
          scoped: EmptyStateTheme(
            metrics: const <EmptyStateSize, EmptyStateMetrics>{
              EmptyStateSize.compact: EmptyStateMetrics(
                iconSize: 48,
                titleStyle: TextStyle(fontSize: 30),
                descriptionStyle: TextStyle(fontSize: 16),
                padding: EdgeInsets.all(40),
                contentGap: 32,
                titleGap: 12,
                actionGap: 32,
                actionSpacing: 12,
                maxWidth: 640,
                descriptionMaxWidth: 640,
              ),
            },
          ),
          child: const EmptyState(),
        ),
      );
      expect(tester.getSize(find.byIcon(RadixIcons.archive)).width, 36);
    });

    testWidgets('alpha multiplies the token alpha', (tester) async {
      const ShadcnColors dark = ShadcnColors.darkFallback;
      await tester.pumpWidget(
        _frame(
          data: const ShadcnThemeData(colors: dark),
          child: const EmptyState(
            theme: EmptyStateTheme(
              iconContainerBackground: ThemedColor.ref(
                ColorRef.accent,
                alpha: 0.5,
              ),
            ),
          ),
        ),
      );
      expect(
        _iconContainer(tester).color!.a,
        closeTo(dark.accent.a * 0.5, 0.001),
      );
    });
  });

  group('regressions', () {
    testWidgets('a themed compact surface does not crash', (tester) async {
      // The old widget read `cardFillColor != null ? true : null` into a
      // `Card(filled:, fillColor:)` API the accepted `Card` no longer has.
      await tester.pumpWidget(
        _frame(
          child: const EmptyState(
            size: EmptyStateSize.compact,
            theme: EmptyStateTheme(surface: ThemedColor.ref(ColorRef.muted)),
          ),
        ),
      );
      expect(tester.takeException(), isNull);
      final shadcn.Card card = tester.widget<shadcn.Card>(
        find.byType(shadcn.Card),
      );
      expect(card.background, isNotNull);
    });
  });
}
