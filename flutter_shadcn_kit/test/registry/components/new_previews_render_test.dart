import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/flutter_shadcn_kit.dart';
import 'package:flutter_shadcn_kit/registry/components/form/color_field/preview.dart';
import 'package:flutter_shadcn_kit/registry/components/display/fade_scroll/preview.dart';
import 'package:flutter_shadcn_kit/registry/components/display/pinned_sheet/preview.dart';
import 'package:flutter_shadcn_kit/registry/components/form/sortable/preview.dart';
import 'package:flutter_shadcn_kit/registry/components/navigation/page_route/preview.dart';
import 'package:flutter_shadcn_kit/registry/components/overlay/anchor/preview.dart';
import 'package:flutter_shadcn_kit/registry/components/overlay/backdrop_transform/preview.dart';
import 'package:flutter_shadcn_kit/registry/components/overlay/drawer_container/preview.dart';
import 'package:flutter_shadcn_kit/registry/components/overlay/overlay_configuration/preview.dart';
import 'package:flutter_shadcn_kit/registry/components/overlay/spell_check_suggestions_toolbar/preview.dart';
import 'package:flutter_test/flutter_test.dart';

/// Every upstream-parity addition must render visible content in docs.
Future<void> pumpPreview(WidgetTester tester, Widget preview) async {
  await tester.pumpWidget(ShadcnApp(home: preview));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('AnchorPreview renders anchored content', (tester) async {
    await pumpPreview(tester, const AnchorPreview());
    expect(find.text('Anchored widget'), findsOneWidget);
  });

  testWidgets('BackdropTransformPreview renders transformed content', (
    tester,
  ) async {
    await pumpPreview(tester, const BackdropTransformPreview());
    expect(find.text('Scaled backdrop'), findsOneWidget);
  });

  testWidgets('DrawerContainerPreview renders sheet content', (tester) async {
    await pumpPreview(tester, const DrawerContainerPreview());
    expect(find.text('Sheet content'), findsOneWidget);
  });

  testWidgets('OverlayConfigurationPreview opens a popover', (tester) async {
    await pumpPreview(tester, const OverlayConfigurationPreview());
    await tester.tap(find.text('Show popover'));
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text('Presented via PopoverConfiguration'), findsOneWidget);
  });

  testWidgets('PinnedSheetPreview shows expanded sheet content', (
    tester,
  ) async {
    await pumpPreview(tester, const PinnedSheetPreview());
    expect(find.text('Sheet content'), findsOneWidget);
  });

  testWidgets('PageRoutePreview pushes a shadcn page', (tester) async {
    await pumpPreview(tester, const PageRoutePreview());
    await tester.tap(find.text('Open page'));
    await tester.pumpAndSettle();
    expect(find.text('Pushed via ShadcnPageRoute'), findsOneWidget);
  });

  testWidgets('ColorFieldPreview paints gradient fields', (tester) async {
    await pumpPreview(tester, const ColorFieldPreview());
    expect(find.byType(CustomPaint), findsWidgets);
  });

  testWidgets('SortablePreview renders stack content', (tester) async {
    await pumpPreview(tester, const SortablePreview());
    expect(find.text('Form sortable (RawSortableStack)'), findsOneWidget);
  });

  testWidgets('FadeScrollPreview renders scrollable items', (tester) async {
    await pumpPreview(tester, const FadeScrollPreview());
    expect(find.text('Item 1'), findsOneWidget);
  });

  testWidgets('SpellCheck preview describes its wiring', (tester) async {
    await pumpPreview(tester, const SpellCheckSuggestionsToolbarPreview());
    expect(find.textContaining('SpellCheckConfiguration'), findsOneWidget);
  });
}
