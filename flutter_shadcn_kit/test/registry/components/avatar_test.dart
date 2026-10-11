// Widget and unit tests for the `avatar` component.
//
// Avatar is not interactive, so there are no hover/press/keyboard cases.
// Covered: token rendering light + dark, sizes, image vs initials fallback,
// badge placement, group overlap and RTL, the four theme legs, per-field
// merge and regression tests for the fixes listed in the batch report.

import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/components/avatar/avatar.dart';
import 'package:flutter_shadcn_kit/registry/theme/color_tokens.dart';
import 'package:flutter_shadcn_kit/registry/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

const Color _red = Color(0xFFFF0000);
const Color _green = Color(0xFF00FF00);
const Color _blue = Color(0xFF0000FF);

class _TestImageProvider extends ImageProvider<_TestImageProvider> {
  _TestImageProvider(this.image);

  final ui.Image image;

  @override
  Future<_TestImageProvider> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture<_TestImageProvider>(this);
  }

  @override
  ImageStreamCompleter loadImage(
    _TestImageProvider key,
    ImageDecoderCallback decode,
  ) {
    return OneFrameImageStreamCompleter(
      SynchronousFuture<ImageInfo>(ImageInfo(image: image)),
    );
  }
}

Widget _frame({
  ShadcnThemeData data = const ShadcnThemeData(),
  List<ComponentThemeData> app = const <ComponentThemeData>[],
  TextDirection textDirection = TextDirection.ltr,
  required Widget child,
}) {
  return ShadcnTheme(
    data: data,
    child: ComponentThemes(
      themes: app,
      child: Directionality(
        textDirection: textDirection,
        child: Center(child: child),
      ),
    ),
  );
}

Color _tileColor(WidgetTester tester) {
  final box = tester.widget<ColoredBox>(
    find
        .descendant(of: find.byType(Avatar), matching: find.byType(ColoredBox))
        .first,
  );
  return box.color;
}

TextStyle _initialsStyle(WidgetTester tester) {
  final text = tester.widget<Text>(find.text('IB'));
  return DefaultTextStyle.of(
    tester.element(find.text('IB')),
  ).style.merge(text.style);
}

void main() {
  const ShadcnColors colors = ShadcnColors.lightFallback;

  group('Avatar.getInitials', () {
    test('two words take the first character of each', () {
      expect(Avatar.getInitials('Ibrar Ahmed'), 'IA');
      expect(Avatar.getInitials('  ada   lovelace '), 'AL');
    });

    test('one word takes up to two characters', () {
      expect(Avatar.getInitials('Ibrar'), 'IB');
      expect(Avatar.getInitials('x'), 'X');
    });

    test('empty input returns empty (regression: no crash)', () {
      expect(Avatar.getInitials(''), '');
      expect(Avatar.getInitials('   '), '');
    });
  });

  testWidgets('renders initials with the muted/foreground tokens', (
    tester,
  ) async {
    await tester.pumpWidget(_frame(child: const Avatar(initials: 'IB')));
    expect(find.text('IB'), findsOneWidget);
    expect(_tileColor(tester), colors.muted);
    expect(_initialsStyle(tester).color, colors.foreground);
    expect(_initialsStyle(tester).fontWeight, FontWeight.w600);
  });

  testWidgets('dark tokens drive the tile', (tester) async {
    const ShadcnThemeData dark = ShadcnThemeData(
      colors: ShadcnColors.darkFallback,
    );
    await tester.pumpWidget(
      _frame(
        data: dark,
        child: const Avatar(initials: 'IB'),
      ),
    );
    expect(_tileColor(tester), dark.colors.muted);
    expect(_initialsStyle(tester).color, dark.colors.foreground);
  });

  testWidgets('size controls the tile box', (tester) async {
    await tester.pumpWidget(
      _frame(child: const Avatar(initials: 'IB', size: 56)),
    );
    final box = tester.widget<SizedBox>(
      find
          .ancestor(of: find.byType(Stack), matching: find.byType(SizedBox))
          .first,
    );
    expect(box.width, 56);
    expect(box.height, 56);
  });

  testWidgets('image provider replaces the initials', (tester) async {
    final ui.Image image = (await tester.runAsync(createTestImage))!;
    await tester.pumpWidget(
      _frame(
        child: Avatar(initials: 'IB', image: _TestImageProvider(image)),
      ),
    );
    await tester.pump();
    expect(find.byType(RawImage), findsOneWidget);
    expect(find.text('IB'), findsNothing);
  });

  testWidgets('initials scale down instead of stretching (regression)', (
    tester,
  ) async {
    // The old tile used BoxFit.fill, which distorted multi-character
    // fallbacks; the new tile scales down.
    await tester.pumpWidget(_frame(child: const Avatar(initials: 'IB')));
    final fitted = tester.widget<FittedBox>(
      find
          .descendant(of: find.byType(Avatar), matching: find.byType(FittedBox))
          .first,
    );
    expect(fitted.fit, BoxFit.scaleDown);
  });

  testWidgets('badge uses the badge tokens and stays inside the tile', (
    tester,
  ) async {
    await tester.pumpWidget(
      _frame(
        child: const Avatar(initials: 'IB', badge: AvatarBadge()),
      ),
    );
    expect(find.byType(AvatarBadge), findsOneWidget);
    final container = tester.widget<Container>(
      find
          .descendant(
            of: find.byType(AvatarBadge),
            matching: find.byType(Container),
          )
          .first,
    );
    final decoration = container.decoration! as BoxDecoration;
    expect(decoration.color, colors.primary);
    // shadcn `size-2.5` = 10 on the default avatar (was 12 before P4-M1).
    expect(container.constraints?.maxWidth ?? 10, 10);
    final badgeRect = tester.getRect(find.byType(AvatarBadge));
    final avatarRect = tester.getRect(find.byType(Avatar));
    expect(avatarRect.contains(badgeRect.center), isTrue);
  });

  testWidgets('group overlaps tiles and mirrors in RTL', (tester) async {
    const Widget group = AvatarGroup(
      children: <Widget>[
        Avatar(initials: 'IB'),
        Avatar(initials: 'AC'),
        Avatar(initials: 'MK'),
      ],
    );
    await tester.pumpWidget(_frame(child: group));
    final ltrWidth = tester.getSize(find.byType(AvatarGroup)).width;
    final first = tester.getTopLeft(find.byType(Avatar).first).dx;
    final second = tester.getTopLeft(find.byType(Avatar).at(1)).dx;
    expect(second - first, lessThan(40));

    await tester.pumpWidget(
      _frame(textDirection: TextDirection.rtl, child: group),
    );
    final firstRtl = tester.getTopLeft(find.byType(Avatar).first).dx;
    final secondRtl = tester.getTopLeft(find.byType(Avatar).at(1)).dx;
    expect(firstRtl - secondRtl, lessThan(40));
    expect(tester.getSize(find.byType(AvatarGroup)).width, ltrWidth);
  });

  testWidgets('theme precedence: defaults < app < scoped < widget', (
    tester,
  ) async {
    const red = AvatarTheme(backgroundColor: ThemedColor.value(_red));
    const green = AvatarTheme(backgroundColor: ThemedColor.value(_green));
    const blue = AvatarTheme(backgroundColor: ThemedColor.value(_blue));

    await tester.pumpWidget(
      _frame(
        app: <ComponentThemeData>[red],
        child: const Avatar(initials: 'IB'),
      ),
    );
    expect(_tileColor(tester), _red);

    await tester.pumpWidget(
      _frame(
        app: <ComponentThemeData>[red],
        child: const ComponentTheme<AvatarTheme>(
          data: green,
          child: Avatar(initials: 'IB'),
        ),
      ),
    );
    expect(_tileColor(tester), _green);

    await tester.pumpWidget(
      _frame(
        app: <ComponentThemeData>[red],
        child: const ComponentTheme<AvatarTheme>(
          data: green,
          child: Avatar(initials: 'IB', theme: blue),
        ),
      ),
    );
    expect(_tileColor(tester), _blue);
  });

  testWidgets('partial legs merge per field (regression)', (tester) async {
    // The old component picked `widget.theme ?? scoped` wholesale, so a
    // widget leg that set one field dropped the lower leg's other fields.
    await tester.pumpWidget(
      _frame(
        app: const <ComponentThemeData>[
          AvatarTheme(backgroundColor: ThemedColor.value(_red)),
        ],
        child: const ComponentTheme<AvatarTheme>(
          data: AvatarTheme(foregroundColor: ThemedColor.value(_green)),
          child: Avatar(
            initials: 'IB',
            theme: AvatarTheme(textStyle: TextStyle(fontSize: 20)),
          ),
        ),
      ),
    );
    expect(_tileColor(tester), _red);
    expect(_initialsStyle(tester).color, _green);
    expect(_initialsStyle(tester).fontSize, 20);
  });
}
