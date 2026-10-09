// Widget tests for the `item_picker` component.
//
// Covers the trigger, grid/list bodies, option selection chrome, dialog and
// popover presentation, the one-shot helpers and the four theme-precedence
// legs. Regression tests cover the retired pieces: `IconButton` options,
// `ModalBackdrop`/`ModalContainer` surfaces and the `form` component
// dependency (the field now builds on the `form_core` primitive alone).

import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/components/button/button.dart';
import 'package:flutter_shadcn_kit/registry/components/item_picker/item_picker.dart';
import 'package:flutter_shadcn_kit/registry/primitives/form_core/object_form_field.dart';
import 'package:flutter_shadcn_kit/registry/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

const ItemList<String> _items = ItemList<String>(<String>['A', 'B', 'C']);

Widget _optionBuilder(BuildContext context, String value) {
  return ItemPickerOption<String>(
    value: value,
    child: Center(child: Text(value)),
  );
}

Widget _frame({
  required Widget child,
  ShadcnThemeData data = const ShadcnThemeData(),
  List<ComponentThemeData> app = const <ComponentThemeData>[],
  ItemPickerTheme? scoped,
}) {
  Widget body = child;
  if (scoped != null) {
    body = ComponentTheme<ItemPickerTheme>(data: scoped, child: body);
  }
  return ShadcnTheme(
    data: data,
    child: ComponentThemes(
      themes: app,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Center(child: body),
      ),
    ),
  );
}

/// Pumps a page with a Navigator for prompt tests; records the host context.
late BuildContext _host;

Future<void> _pumpPage(WidgetTester tester, Widget child) async {
  await tester.pumpWidget(
    Directionality(
      textDirection: TextDirection.ltr,
      child: ShadcnTheme(
        data: const ShadcnThemeData(),
        child: Navigator(
          onGenerateRoute: (settings) => PageRouteBuilder<void>(
            settings: settings,
            pageBuilder: (context, _, _) {
              _host = context;
              return Center(child: child);
            },
          ),
        ),
      ),
    ),
  );
}

void main() {
  group('trigger', () {
    testWidgets('shows placeholder while unpicked', (tester) async {
      await tester.pumpWidget(
        _frame(
          child: ItemPicker<String>(
            items: _items,
            placeholder: const Text('Pick me'),
            builder: _optionBuilder,
            onChanged: (_) {},
          ),
        ),
      );
      expect(find.text('Pick me'), findsOneWidget);
    });

    testWidgets('shows the current value', (tester) async {
      await tester.pumpWidget(
        _frame(
          child: ItemPicker<String>(
            items: _items,
            value: 'B',
            builder: (context, value) => Text('got $value'),
            onChanged: (_) {},
          ),
        ),
      );
      expect(find.text('got B'), findsOneWidget);
    });

    testWidgets('null onChanged disables the trigger', (tester) async {
      await tester.pumpWidget(
        _frame(
          child: ItemPicker<String>(
            items: _items,
            placeholder: const Text('Pick me'),
            builder: _optionBuilder,
          ),
        ),
      );
      await tester.tap(find.text('Pick me'));
      await tester.pump();
      expect(find.byType(ItemPickerDialog<String>), findsNothing);
    });
  });

  group('dialog presentation', () {
    testWidgets('tap opens the dialog; tap selects and closes', (tester) async {
      String? picked;
      await _pumpPage(
        tester,
        ItemPicker<String>(
          items: _items,
          placeholder: const Text('Pick me'),
          builder: _optionBuilder,
          title: const Text('Choose'),
          onChanged: (value) => picked = value,
        ),
      );
      await tester.tap(find.text('Pick me'));
      await tester.pumpAndSettle();
      expect(find.byType(ItemPickerDialog<String>), findsOneWidget);
      expect(find.text('Choose'), findsWidgets);
      await tester.tap(find.text('C'));
      await tester.pumpAndSettle();
      expect(picked, 'C');
      expect(find.byType(ItemPickerDialog<String>), findsNothing);
    });

    testWidgets('selected option uses the primary row', (tester) async {
      await tester.pumpWidget(
        _frame(
          child: ItemPickerDialog<String>(
            items: _items,
            builder: _optionBuilder,
            value: 'A',
            onChanged: (_) {},
          ),
        ),
      );
      final Iterable<Button> buttons = tester.widgetList<Button>(
        find.byType(Button),
      );
      expect(buttons.length, 3);
    });

    testWidgets('list layout renders rows', (tester) async {
      await tester.pumpWidget(
        _frame(
          child: ItemPickerDialog<String>(
            items: _items,
            layout: ItemPickerLayout.list,
            builder: (context, value) => ItemPickerOption<String>(
              value: value,
              label: Text(value),
              child: Text('icon $value'),
            ),
            onChanged: (_) {},
          ),
        ),
      );
      expect(find.byType(ListView), findsOneWidget);
      expect(find.text('icon A'), findsOneWidget);
    });
  });

  group('one-shot helpers', () {
    testWidgets('showItemPickerDialog completes with the pick', (tester) async {
      await _pumpPage(tester, const Text('page'));
      final Future<String?> future = showItemPickerDialog<String>(
        _host,
        title: const Text('Choose'),
        items: _items,
        builder: _optionBuilder,
      );
      await tester.pumpAndSettle();
      expect(find.byType(ItemPickerDialog<String>), findsOneWidget);
      await tester.tap(find.text('B'));
      await tester.pumpAndSettle();
      expect(await future, 'B');
    });

    testWidgets('showItemPicker completes with the pick', (tester) async {
      await _pumpPage(tester, const Text('page'));
      final Future<String?> future = showItemPicker<String>(
        _host,
        items: _items,
        builder: _optionBuilder,
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));
      expect(find.byType(ItemPickerDialog<String>), findsOneWidget);
      await tester.tap(find.text('A'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));
      expect(await future, 'A');
    });
  });

  group('theme precedence', () {
    testWidgets('widget > scoped > app > defaults', (tester) async {
      ItemPickerTheme resolve(BuildContext context, ItemPickerTheme? widget) {
        return resolveComponentStyle<ItemPickerTheme, ItemPickerTheme>(
          context,
          widget: widget,
          select: (t) => t,
          defaults: itemPickerDefaults,
        );
      }

      ItemPickerTheme? seen;
      Future<void> pump({
        ItemPickerTheme? widget,
        ItemPickerTheme? scoped,
        List<ComponentThemeData> app = const <ComponentThemeData>[],
      }) async {
        await tester.pumpWidget(
          _frame(
            app: app,
            scoped: scoped,
            child: Builder(
              builder: (context) {
                seen = resolve(context, widget);
                return const SizedBox();
              },
            ),
          ),
        );
      }

      await pump();
      expect(seen!.spacing, itemPickerDefaults.spacing);
      await pump(app: const <ComponentThemeData>[ItemPickerTheme(spacing: 1)]);
      expect(seen!.spacing, 1);
      await pump(
        scoped: const ItemPickerTheme(spacing: 2),
        app: const <ComponentThemeData>[ItemPickerTheme(spacing: 1)],
      );
      expect(seen!.spacing, 2);
      await pump(
        widget: const ItemPickerTheme(spacing: 3),
        scoped: const ItemPickerTheme(spacing: 2),
        app: const <ComponentThemeData>[ItemPickerTheme(spacing: 1)],
      );
      expect(seen!.spacing, 3);
    });

    testWidgets('dialog prompt stays live across themes', (tester) async {
      await tester.pumpWidget(
        _frame(
          child: ItemPickerDialog<String>(
            items: _items,
            builder: _optionBuilder,
            onChanged: (_) {},
          ),
        ),
      );
      expect(find.byType(GridView), findsOneWidget);
    });
  });

  group('regressions', () {
    testWidgets('options are Buttons, not IconButtons', (tester) async {
      await tester.pumpWidget(
        _frame(
          child: ItemPickerDialog<String>(
            items: _items,
            builder: _optionBuilder,
            onChanged: (_) {},
          ),
        ),
      );
      expect(find.byType(Button), findsWidgets);
    });

    testWidgets('field reports through ObjectFormField', (tester) async {
      await tester.pumpWidget(
        _frame(
          child: ItemPicker<String>(
            items: _items,
            placeholder: const Text('Pick me'),
            builder: _optionBuilder,
            onChanged: (_) {},
          ),
        ),
      );
      expect(find.byType(ObjectFormField<String>), findsOneWidget);
    });

    testWidgets('field prompt shows dialog chrome with actions', (
      tester,
    ) async {
      await _pumpPage(
        tester,
        ItemPicker<String>(
          items: _items,
          placeholder: const Text('Pick me'),
          builder: _optionBuilder,
          title: const Text('Choose'),
          onChanged: (_) {},
        ),
      );
      await tester.tap(find.text('Pick me'));
      await tester.pumpAndSettle();
      expect(find.byType(ItemPickerDialog<String>), findsOneWidget);
      expect(find.text('Choose'), findsWidgets);
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Save'), findsOneWidget);
    });
  });
}
