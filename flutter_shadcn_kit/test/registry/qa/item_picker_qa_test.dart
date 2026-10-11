// QA for `item_picker` previews (P7-Q1 batch E): behaviour, robustness.
//
// Regression cover for: a null placeholder collapsing the trigger to zero
// size, infinite delegates meeting shrink-wrap layouts, and the popover
// helper's non-directional default alignment.

import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/components/item_picker/item_picker.dart';
import 'package:flutter_shadcn_kit/registry/components/item_picker/preview.dart';
import 'package:flutter_shadcn_kit/registry/primitives/form_core/object_form_field.dart';
import 'package:flutter_shadcn_kit/registry/theme/color_tokens.dart';
import 'package:flutter_shadcn_kit/registry/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

const ItemList<String> _items = ItemList<String>(<String>['A', 'B', 'C']);

/// An unbounded delegate: `itemCount` is null (infinite).
class _Infinite extends ItemChildDelegate<String> {
  const _Infinite();

  @override
  int? get itemCount => null;

  @override
  String? operator [](int index) => 'x$index';
}

Widget _optionBuilder(BuildContext context, String value) {
  return ItemPickerOption<String>(
    value: value,
    child: Center(child: Text(value)),
  );
}

Widget _frame(
  Widget child, {
  ShadcnThemeData data = const ShadcnThemeData(),
  TextDirection direction = TextDirection.ltr,
  double? width,
}) {
  return ShadcnTheme(
    data: data,
    child: Directionality(
      textDirection: direction,
      child: Center(
        child: width == null ? child : SizedBox(width: width, child: child),
      ),
    ),
  );
}

/// Navigator host for prompt tests; pumped once per test (the route keeps
/// the first page, so re-pumping with different content needs a reset pump).
Widget _page(
  Widget child, {
  TextDirection direction = TextDirection.ltr,
  required void Function(BuildContext context) onHost,
}) {
  return ShadcnTheme(
    data: const ShadcnThemeData(),
    child: Directionality(
      textDirection: direction,
      child: Navigator(
        onGenerateRoute: (RouteSettings settings) => PageRouteBuilder<void>(
          settings: settings,
          pageBuilder: (BuildContext context, _, _) {
            onHost(context);
            return Center(child: child);
          },
        ),
      ),
    ),
  );
}

void main() {
  testWidgets('every preview pumps light + dark with no exception', (
    tester,
  ) async {
    for (final preview in itemPickerPreviews) {
      for (final colors in <ShadcnColors>[
        ShadcnColors.lightFallback,
        ShadcnColors.darkFallback,
      ]) {
        await tester.pumpWidget(
          _frame(
            Builder(builder: preview.builder),
            data: ShadcnThemeData(colors: colors),
          ),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));
        expect(
          tester.takeException(),
          isNull,
          reason: '${preview.name} light/dark',
        );
      }
    }
  });

  testWidgets('null placeholder trigger stays tappable and picks', (
    tester,
  ) async {
    // NOTE: popover mode, not the dialog route: opening the dialog prompt
    // crashes in `object_form_prompt` (shrink-wrap viewport under
    // IntrinsicWidth), a pre-existing primitive failure also present on HEAD.
    String? picked;
    late BuildContext host;
    await tester.pumpWidget(
      _page(
        ItemPicker<String>(
          items: _items,
          builder: _optionBuilder,
          mode: PromptMode.popover,
          onChanged: (String? next) => picked = next,
        ),
        onHost: (BuildContext context) => host = context,
      ),
    );
    await tester.pump();
    expect(host, isNotNull);
    // The fallback box keeps a non-zero trigger even with no placeholder.
    final Size trigger = tester.getSize(find.byType(ItemPicker<String>));
    expect(trigger.width, greaterThan(0));
    expect(trigger.height, greaterThanOrEqualTo(36));
    await tester.tap(find.byType(ItemPicker<String>));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.byType(ItemPickerDialog<String>), findsOneWidget);
    await tester.tap(find.text('C'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(picked, 'C');
  });

  testWidgets('infinite delegate asserts in shrink-wrap layouts', (
    tester,
  ) async {
    await tester.pumpWidget(
      _frame(
        ItemPickerDialog<String>(
          items: const _Infinite(),
          builder: _optionBuilder,
          onChanged: (_) {},
        ),
      ),
    );
    expect(tester.takeException(), isA<AssertionError>());

    await tester.pumpWidget(
      _frame(
        ItemPickerDialog<String>(
          items: const _Infinite(),
          layout: ItemPickerLayout.list,
          builder: _optionBuilder,
          onChanged: (_) {},
        ),
      ),
    );
    expect(tester.takeException(), isA<AssertionError>());
  });

  testWidgets('showItemPicker opens and completes in RTL', (tester) async {
    late BuildContext host;
    await tester.pumpWidget(
      _page(
        const Text('page'),
        direction: TextDirection.rtl,
        onHost: (BuildContext context) => host = context,
      ),
    );
    final Future<String?> future = showItemPicker<String>(
      host,
      items: _items,
      builder: _optionBuilder,
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.byType(ItemPickerDialog<String>), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.tap(find.text('A'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));
    expect(await future, 'A');
  });

  testWidgets('grid preview fits 375px with no overflow', (tester) async {
    await tester.pumpWidget(
      _frame(Builder(builder: itemPickerPreviews[0].builder), width: 375),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(tester.takeException(), isNull);
  });

  testWidgets('RTL pumps with no exception', (tester) async {
    for (final preview in itemPickerPreviews) {
      await tester.pumpWidget(
        _frame(Builder(builder: preview.builder), direction: TextDirection.rtl),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      expect(tester.takeException(), isNull, reason: '${preview.name} RTL');
    }
    // The field trigger mirrors too.
    await tester.pumpWidget(
      _frame(
        ItemPicker<String>(
          items: _items,
          placeholder: const Text('Pick me'),
          builder: _optionBuilder,
          onChanged: (_) {},
        ),
        direction: TextDirection.rtl,
      ),
    );
    await tester.pump();
    expect(tester.takeException(), isNull);
    expect(find.byType(ObjectFormField<String>), findsOneWidget);
  });
}
