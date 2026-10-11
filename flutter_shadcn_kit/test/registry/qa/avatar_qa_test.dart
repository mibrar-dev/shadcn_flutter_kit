// QA for `avatar` previews (P7-Q1).
//
// Regression cover for: docs claiming a 40px default (code resolves 32 =
// shadcn `size-8`) and the group ring staying circular for rounded tiles.

import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/components/avatar/avatar.dart';
import 'package:flutter_shadcn_kit/registry/components/avatar/preview.dart';
import 'package:flutter_shadcn_kit/registry/theme/color_tokens.dart';
import 'package:flutter_shadcn_kit/registry/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _frame(
  Widget child, {
  ShadcnThemeData data = const ShadcnThemeData(),
  double? width,
}) {
  return ShadcnTheme(
    data: data,
    child: Directionality(
      textDirection: TextDirection.ltr,
      child: Center(
        child: width == null ? child : SizedBox(width: width, child: child),
      ),
    ),
  );
}

void main() {
  testWidgets('every preview pumps light + dark with no exception', (
    tester,
  ) async {
    for (final preview in avatarPreviews) {
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
        await tester.pumpAndSettle();
        expect(
          tester.takeException(),
          isNull,
          reason: '${preview.name} light/dark',
        );
      }
    }
  });

  testWidgets('default tile is 32 (shadcn size-8)', (tester) async {
    await tester.pumpWidget(_frame(const Avatar(initials: 'IB')));
    await tester.pump();
    expect(tester.getSize(find.byType(Avatar)), const Size(32, 32));
  });

  testWidgets('group ring follows borderRadius for rounded tiles', (
    tester,
  ) async {
    const BorderRadius radius = BorderRadius.all(Radius.circular(8));
    await tester.pumpWidget(
      _frame(
        const AvatarGroup(
          borderRadius: radius,
          children: <Widget>[
            Avatar(initials: 'A', borderRadius: radius),
            Avatar(initials: 'B', borderRadius: radius),
          ],
        ),
      ),
    );
    await tester.pump();
    final DecoratedBox ring = tester.widget<DecoratedBox>(
      find
          .descendant(
            of: find.byType(AvatarGroup),
            matching: find.byType(DecoratedBox),
          )
          .first,
    );
    final BoxDecoration decoration = ring.decoration as BoxDecoration;
    expect(decoration.borderRadius, radius);
  });

  testWidgets('group ring defaults to a circle', (tester) async {
    await tester.pumpWidget(
      _frame(
        const AvatarGroup(
          children: <Widget>[
            Avatar(initials: 'A'),
            Avatar(initials: 'B'),
          ],
        ),
      ),
    );
    await tester.pump();
    final DecoratedBox ring = tester.widget<DecoratedBox>(
      find
          .descendant(
            of: find.byType(AvatarGroup),
            matching: find.byType(DecoratedBox),
          )
          .first,
    );
    final BoxDecoration decoration = ring.decoration as BoxDecoration;
    expect(decoration.borderRadius, BorderRadius.circular((32 + 2 * 2) / 2));
  });
}
