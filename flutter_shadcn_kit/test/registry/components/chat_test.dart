// Widget and unit tests for the `chat` component.
//
// Covers: the token surface (light + dark), the four theme legs, row
// alignment, width factor, the three variants, tail behaviour inside a
// group, group spacing/avatar layout, RTL and the regressions for the old
// bugs (luminance-picked foreground, the unbounded-width crash).

import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/components/chat/chat.dart';
import 'package:flutter_shadcn_kit/registry/primitives/overlap_layout.dart';
import 'package:flutter_shadcn_kit/registry/theme/color_tokens.dart';
import 'package:flutter_shadcn_kit/registry/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

const Color _red = Color(0xFFFF0000);
const Color _green = Color(0xFF00FF00);
const Color _blue = Color(0xFF0000FF);

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

ChatTheme _style(WidgetTester tester) {
  final ChatBubble bubble = tester.widget<ChatBubble>(find.byType(ChatBubble));
  return resolveChatStyle(
    tester.element(find.byType(ChatBubble)),
    widgetTheme: bubble.theme,
    background: bubble.color,
    variant: bubble.variant,
    alignment: bubble.alignment,
    widthFactor: bubble.widthFactor,
    padding: bubble.padding,
    borderRadius: bubble.borderRadius,
    borderColor: bubble.borderColor,
  );
}

Finder _surfaceOf(int index) {
  return find.descendant(
    of: find.byType(ChatBubble).at(index),
    matching: find.byWidgetPredicate((Widget w) => w is DecoratedBox),
  );
}

Finder _tailOf(int index) {
  return find.descendant(
    of: find.byType(ChatBubble).at(index),
    matching: find.byType(CustomPaint),
  );
}

void main() {
  const ShadcnColors light = ShadcnColors.lightFallback;
  const ShadcnColors dark = ShadcnColors.darkFallback;

  testWidgets('token surface: primary fill, primaryForeground label', (
    tester,
  ) async {
    await tester.pumpWidget(
      _frame(child: ChatBubble(child: const Text('hello'))),
    );
    final ChatTheme style = _style(tester);
    expect(style.background?.resolve(light), light.primary);
    expect(style.foreground?.resolve(light), light.primaryForeground);
    expect(style.variant, ChatBubbleVariant.tail);
    expect(style.widthFactor, 0.5);
    expect(
      style.padding,
      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    );

    // Regression: the old copy picked the label colour by luminance
    // (0xFF111827 / 0xFFF9FAFB) instead of the token.
    final TextStyle label = DefaultTextStyle.of(
      tester.element(find.text('hello')),
    ).style;
    expect(label.color, light.primaryForeground);
    expect(label.color, isNot(const Color(0xFF111827)));
  });

  testWidgets('dark tokens drive the bubble', (tester) async {
    await tester.pumpWidget(
      _frame(
        data: const ShadcnThemeData(colors: dark),
        child: const ChatBubble(child: Text('hello')),
      ),
    );
    final ChatTheme style = _style(tester);
    expect(style.background?.resolve(dark), dark.primary);
    expect(style.foreground?.resolve(dark), dark.primaryForeground);
  });

  testWidgets('theme precedence: defaults < app < scoped < widget', (
    tester,
  ) async {
    const ChatTheme app = ChatTheme(
      background: ThemedColor.value(_red),
      widthFactor: 0.75,
    );
    const ChatTheme scoped = ChatTheme(background: ThemedColor.value(_green));
    const ChatTheme widgetLeg = ChatTheme(
      background: ThemedColor.value(_blue),
      widthFactor: 0.25,
    );

    await tester.pumpWidget(
      _frame(
        app: <ComponentThemeData>[app],
        child: const ChatBubble(child: Text('x')),
      ),
    );
    ChatTheme style = _style(tester);
    expect(style.background?.resolve(light), _red);
    expect(style.widthFactor, 0.75);

    await tester.pumpWidget(const SizedBox());
    await tester.pumpWidget(
      _frame(
        app: <ComponentThemeData>[app],
        child: const ComponentTheme<ChatTheme>(
          data: scoped,
          child: ChatBubble(child: Text('x')),
        ),
      ),
    );
    style = _style(tester);
    expect(style.background?.resolve(light), _green);
    // `scoped` sets no widthFactor, so the app leg survives the merge.
    expect(style.widthFactor, 0.75);

    await tester.pumpWidget(const SizedBox());
    await tester.pumpWidget(
      _frame(
        app: <ComponentThemeData>[app],
        child: const ComponentTheme<ChatTheme>(
          data: scoped,
          child: ChatBubble(theme: widgetLeg, child: Text('x')),
        ),
      ),
    );
    style = _style(tester);
    expect(style.background?.resolve(light), _blue);
    expect(style.widthFactor, 0.25);
  });

  testWidgets('bubble hugs content up to widthFactor and hugs its side', (
    tester,
  ) async {
    const String long =
        'A message that is definitely long enough to reach the width limit '
        'of a half-width bubble in this row.';
    await tester.pumpWidget(
      _frame(
        child: SizedBox(
          width: 400,
          height: 80,
          child: ChatBubble(child: const Text(long)),
        ),
      ),
    );
    final Rect row = tester.getRect(find.byType(ChatBubble));
    final Rect bubble = tester.getRect(_surfaceOf(0));
    // Half of the 400px row.
    expect(bubble.width, closeTo(200, 0.01));
    // Alignment end: the bubble touches the right edge of the row.
    expect(bubble.right, closeTo(row.right, 0.01));
  });

  testWidgets('alignment start puts the bubble on the left', (tester) async {
    await tester.pumpWidget(
      _frame(
        child: SizedBox(
          width: 400,
          height: 80,
          child: const ChatBubble(
            alignment: AlignmentDirectional.centerStart,
            child: Text('left side'),
          ),
        ),
      ),
    );
    final Rect row = tester.getRect(find.byType(ChatBubble));
    final Rect bubble = tester.getRect(_surfaceOf(0));
    expect(bubble.left, closeTo(row.left, 0.01));
  });

  testWidgets('variants: plain has no tail, tail adds one, sharp corners', (
    tester,
  ) async {
    Widget build(ChatBubbleVariant? variant) {
      return _frame(
        child: SizedBox(
          width: 400,
          child: ChatBubble(variant: variant, child: const Text('bubble')),
        ),
      );
    }

    await tester.pumpWidget(build(ChatBubbleVariant.plain));
    expect(_tailOf(0), findsNothing);
    final double plainHeight = tester.getSize(_surfaceOf(0)).height;

    await tester.pumpWidget(const SizedBox());
    await tester.pumpWidget(build(ChatBubbleVariant.tail));
    expect(_tailOf(0), findsOneWidget);
    // The tail adds its 8px below the bubble box.
    expect(tester.getSize(_tailOf(0)).height, closeTo(plainHeight + 8, 0.01));

    await tester.pumpWidget(const SizedBox());
    await tester.pumpWidget(build(ChatBubbleVariant.sharpCorner));
    expect(_tailOf(0), findsNothing);
    expect(tester.getSize(_surfaceOf(0)).height, closeTo(plainHeight, 0.01));

    final DecoratedBox box = tester.widget<DecoratedBox>(_surfaceOf(0));
    final BorderRadius radius =
        (box.decoration as BoxDecoration).borderRadius! as BorderRadius;
    expect(radius.bottomRight, Radius.zero);
    expect(radius.topLeft, isNot(Radius.zero));
  });

  testWidgets('tail behaviour picks the right bubble of the group', (
    tester,
  ) async {
    Widget group({ChatTailBehavior behavior = ChatTailBehavior.last}) {
      return _frame(
        child: SizedBox(
          width: 400,
          child: ChatGroup(
            theme: ChatTheme(tailBehavior: behavior),
            children: const <Widget>[
              ChatBubble(child: Text('one')),
              ChatBubble(child: Text('two')),
              ChatBubble(child: Text('three')),
            ],
          ),
        ),
      );
    }

    await tester.pumpWidget(group());
    expect(_tailOf(0), findsNothing);
    expect(_tailOf(1), findsNothing);
    expect(_tailOf(2), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
    await tester.pumpWidget(group(behavior: ChatTailBehavior.middle));
    expect(_tailOf(1), findsOneWidget);
    expect(_tailOf(2), findsNothing);

    await tester.pumpWidget(const SizedBox());
    await tester.pumpWidget(group(behavior: ChatTailBehavior.first));
    expect(_tailOf(0), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
    await tester.pumpWidget(group(behavior: ChatTailBehavior.never));
    expect(_tailOf(0), findsNothing);
    expect(_tailOf(2), findsNothing);
  });

  testWidgets('group spacing and avatar gap come from the theme', (
    tester,
  ) async {
    await tester.pumpWidget(
      _frame(
        child: SizedBox(
          width: 400,
          child: const ChatGroup(
            avatarPrefix: SizedBox(width: 24, height: 24),
            children: <Widget>[
              ChatBubble(child: Text('one')),
              ChatBubble(child: Text('two')),
            ],
          ),
        ),
      ),
    );
    final Column column = tester.widget<Column>(
      find
          .descendant(of: find.byType(ChatGroup), matching: find.byType(Column))
          .first,
    );
    expect(column.spacing, 2);
    final Row row = tester.widget<Row>(
      find.descendant(of: find.byType(ChatGroup), matching: find.byType(Row)),
    );
    expect(row.spacing, 8);
  });

  testWidgets('group surface overrides reach its bubbles but not the app leg', (
    tester,
  ) async {
    await tester.pumpWidget(
      _frame(
        app: const <ComponentThemeData>[ChatTheme(widthFactor: 0.9)],
        child: const ChatGroup(
          color: ThemedColor.value(_green),
          children: <Widget>[ChatBubble(child: Text('one'))],
        ),
      ),
    );
    final ChatTheme style = _style(tester);
    expect(style.background?.resolve(light), _green);
    // The group only publishes explicit values, so the app leg survives.
    expect(style.widthFactor, 0.9);
  });

  testWidgets('RTL flips the bubble to the start (left) edge', (tester) async {
    await tester.pumpWidget(
      _frame(
        textDirection: TextDirection.rtl,
        child: SizedBox(
          width: 400,
          height: 60,
          child: const ChatBubble(child: Text('مرحبا')),
        ),
      ),
    );
    final Rect row = tester.getRect(find.byType(ChatBubble));
    final Rect bubble = tester.getRect(_surfaceOf(0));
    expect(bubble.left, closeTo(row.left, 0.01));
  });

  testWidgets('regression: unbounded width no longer crashes', (tester) async {
    await tester.pumpWidget(
      _frame(
        child: const UnconstrainedBox(child: ChatBubble(child: Text('x'))),
      ),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('reaction chips render inside an overlap row', (tester) async {
    await tester.pumpWidget(
      _frame(
        child: SizedBox(
          width: 400,
          child: ChatReaction(
            chips: const <Widget>[
              ChatReactionContainer(child: Text('thumbs 3')),
              ChatReactionContainer(child: Text('party 1')),
            ],
            child: const ChatBubble(child: Text('bubble')),
          ),
        ),
      ),
    );
    expect(find.byType(OverlapLayout), findsOneWidget);
    expect(find.text('thumbs 3'), findsOneWidget);
    expect(find.text('party 1'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('chips hang off the bubble edge, aligned to its side', (
    tester,
  ) async {
    await tester.pumpWidget(
      _frame(
        child: SizedBox(
          width: 400,
          child: ChatReaction(
            chips: const <Widget>[
              ChatReactionContainer(child: Text('thumbs 3')),
            ],
            child: const ChatBubble(child: Text('bubble')),
          ),
        ),
      ),
    );
    final Rect row = tester.getRect(find.byType(ChatReaction));
    final Rect bubble = tester.getRect(find.byType(ChatBubble));
    final Rect chip = tester.getRect(find.byType(ChatReactionContainer));
    // Side alignment: the bubble touches the row's end (right) edge.
    expect(bubble.right, closeTo(row.right, 0.01));
    // bottomEnd corner: `gap` (8) inside the right edge, straddling the
    // bubble's bottom edge.
    expect(chip.right, closeTo(bubble.right - 8, 0.01));
    expect(chip.top, closeTo(bubble.bottom - 8, 0.01));
    expect(chip.bottom, greaterThan(bubble.bottom));
  });

  testWidgets('tapping a chip fires its callback (toggle)', (tester) async {
    int taps = 0;
    await tester.pumpWidget(
      _frame(
        child: SizedBox(
          width: 400,
          child: ChatReaction(
            chips: <Widget>[
              ChatReactionContainer(
                onTap: () => taps++,
                child: const Text('thumbs 3'),
              ),
              const ChatReactionContainer(child: Text('party 1')),
            ],
            child: const ChatBubble(child: Text('bubble')),
          ),
        ),
      ),
    );
    await tester.tap(find.text('thumbs 3'));
    expect(taps, 1);
    // A chip without a callback stays inert instead of crashing.
    await tester.tap(find.text('party 1'));
    expect(taps, 1);
    expect(tester.takeException(), isNull);
  });

  testWidgets('chip colours and padding come from the theme legs', (
    tester,
  ) async {
    await tester.pumpWidget(
      _frame(
        app: const <ComponentThemeData>[
          ChatTheme(
            reactionBackground: ThemedColor.value(_red),
            reactionSelectedBackground: ThemedColor.value(_blue),
            reactionPadding: EdgeInsets.all(3),
          ),
        ],
        child: ChatReaction(
          chips: const <Widget>[
            ChatReactionContainer(child: Text('rest')),
            ChatReactionContainer(selected: true, child: Text('on')),
          ],
          child: const ChatBubble(child: Text('bubble')),
        ),
      ),
    );
    Container chipOf(String text) {
      final Finder chip = find.ancestor(
        of: find.text(text),
        matching: find.byType(ChatReactionContainer),
      );
      return tester.widget<Container>(
        find.descendant(
          of: chip,
          matching: find.byWidgetPredicate(
            (Widget w) => w is Container && w.decoration is BoxDecoration,
          ),
        ),
      );
    }

    expect((chipOf('rest').decoration as BoxDecoration).color, _red);
    expect((chipOf('on').decoration as BoxDecoration).color, _blue);
    expect(chipOf('rest').padding, const EdgeInsets.all(3));
  });

  testWidgets('RTL flips the reaction corner to the start side', (
    tester,
  ) async {
    await tester.pumpWidget(
      _frame(
        textDirection: TextDirection.rtl,
        child: SizedBox(
          width: 400,
          child: ChatReaction(
            chips: const <Widget>[
              ChatReactionContainer(child: Text('thumbs 3')),
            ],
            child: const ChatBubble(child: Text('bubble')),
          ),
        ),
      ),
    );
    final Rect row = tester.getRect(find.byType(ChatReaction));
    final Rect bubble = tester.getRect(find.byType(ChatBubble));
    final Rect chip = tester.getRect(find.byType(ChatReactionContainer));
    // end resolves to the left edge in RTL, so the bubble hugs it.
    expect(bubble.left, closeTo(row.left, 0.01));
    expect(chip.left, closeTo(bubble.left + 8, 0.01));
    expect(chip.bottom, greaterThan(bubble.bottom));
  });

  testWidgets('regression: bubbles answer intrinsic queries (F2)', (
    tester,
  ) async {
    // The old LayoutBuilder-based measure threw "does not support returning
    // intrinsic dimensions" in these wrappers.
    // (a) A group list under IntrinsicHeight: the old LayoutBuilder in the
    // bubble refused these queries ("does not support returning intrinsic
    // dimensions").
    await tester.pumpWidget(
      _frame(
        child: SizedBox(
          width: 400,
          child: IntrinsicHeight(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                ChatGroup(
                  children: const <Widget>[
                    ChatBubble(child: Text('one')),
                    ChatBubble(child: Text('two')),
                  ],
                ),
                ChatGroup(
                  children: const <Widget>[ChatBubble(child: Text('three'))],
                ),
              ],
            ),
          ),
        ),
      ),
    );
    expect(tester.takeException(), isNull);

    // (b) IntrinsicWidth around a single bubble.
    await tester.pumpWidget(const SizedBox());
    await tester.pumpWidget(
      _frame(
        child: SizedBox(
          height: 60,
          child: IntrinsicWidth(
            child: IntrinsicHeight(child: const ChatBubble(child: Text('hi'))),
          ),
        ),
      ),
    );
    expect(tester.takeException(), isNull);

    // (c) Bubbles stretched across a row inside IntrinsicHeight (a horizontal
    // Row gives non-flex children unbounded width; the factor must cope).
    await tester.pumpWidget(const SizedBox());
    await tester.pumpWidget(
      _frame(
        child: SizedBox(
          width: 400,
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: const <Widget>[
                ChatBubble(child: Text('one')),
                ChatBubble(child: Text('two')),
              ],
            ),
          ),
        ),
      ),
    );
    expect(tester.takeException(), isNull);
  });

  test('merge is receiver-wins per field', () {
    const ChatTheme base = ChatTheme(
      background: ThemedColor.value(_red),
      widthFactor: 0.5,
      spacing: 4,
    );
    const ChatTheme over = ChatTheme(background: ThemedColor.value(_blue));
    final ChatTheme merged = over.merge(base);
    expect(merged.background, const ThemedColor.value(_blue));
    expect(merged.widthFactor, 0.5);
    expect(merged.spacing, 4);
  });
}
