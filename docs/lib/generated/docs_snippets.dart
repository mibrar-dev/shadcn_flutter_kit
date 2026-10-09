// GENERATED CODE - DO NOT MODIFY BY HAND.
//
// Sources:
//   * flutter_shadcn_kit/lib/registry/components/<id>/README.md
//   * flutter_shadcn_kit/lib/registry/manifests/registry.json
//
// Regenerate: dart run tool/gen_docs_data.dart
//
// Highlight classes are generated with package:analyzer (Dart) and
// small scanners (bash/json) at codegen time; `tokenClasses` holds
// one class per character of `code`: p plain, c comment, k keyword,
// s string. `kComponentFileLists` drives the manual install tab.

import 'package:flutter/widgets.dart';

/// Highlight class of one character run in a code snippet.
enum DocsCodeToken {
  /// Unstyled code.
  plain,

  /// `//`, `/* */` or `#` comments.
  comment,

  /// Language keywords and CLI command words.
  keyword,

  /// String literals.
  string,
}

/// One README code block plus its generated highlight classes.
class DocsSnippet {
  /// Creates a snippet.
  const DocsSnippet({
    required this.id,
    required this.componentId,
    required this.language,
    required this.code,
    required this.tokenClasses,
  });

  /// Stable id (`button.0`).
  final String id;

  /// Owning component id.
  final String componentId;

  /// Fence language (`dart`, `bash`).
  final String language;

  /// Block content, verbatim.
  final String code;

  /// One class per character of [code] (`p`/`c`/`k`/`s`).
  final String tokenClasses;

  /// Builds the highlighted spans for this snippet.
  List<TextSpan> spans({
    required TextStyle plain,
    required TextStyle comment,
    required TextStyle keyword,
    required TextStyle string,
  }) {
    final List<TextSpan> result = <TextSpan>[];
    if (code.isEmpty) {
      return result;
    }
    int start = 0;
    DocsCodeToken current = _tokenAt(0);
    for (int i = 1; i < code.length; i++) {
      final DocsCodeToken next = _tokenAt(i);
      if (next != current) {
        result.add(
          TextSpan(
            text: code.substring(start, i),
            style: _styleFor(current, plain, comment, keyword, string),
          ),
        );
        start = i;
        current = next;
      }
    }
    result.add(
      TextSpan(
        text: code.substring(start),
        style: _styleFor(current, plain, comment, keyword, string),
      ),
    );
    return result;
  }

  DocsCodeToken _tokenAt(int index) {
    return switch (tokenClasses.codeUnitAt(index)) {
      0x63 => DocsCodeToken.comment,
      0x6B => DocsCodeToken.keyword,
      0x73 => DocsCodeToken.string,
      _ => DocsCodeToken.plain,
    };
  }

  static TextStyle _styleFor(
    DocsCodeToken token,
    TextStyle plain,
    TextStyle comment,
    TextStyle keyword,
    TextStyle string,
  ) {
    return switch (token) {
      DocsCodeToken.plain => plain,
      DocsCodeToken.comment => comment,
      DocsCodeToken.keyword => keyword,
      DocsCodeToken.string => string,
    };
  }
}

/// README code blocks keyed by component id, in README order.
const Map<String, List<DocsSnippet>>
kDocsSnippets = <String, List<DocsSnippet>>{
  'button': <DocsSnippet>[
    DocsSnippet(
      id: 'button.0',
      componentId: 'button',
      language: 'dart',
      code: r'''Button(onPressed: save, child: const Text('Save'));''',
      tokenClasses: 'pppppppppppppppppppppppppppppppkkkkkppppppssssssppp',
    ),
    DocsSnippet(
      id: 'button.1',
      componentId: 'button',
      language: 'dart',
      code: r'''Button(
  variant: ButtonVariant.outline,
  size: ButtonSize.sm,
  leading: const Icon(LucideIcons.plus, size: 16),
  onPressed: addItem,
  child: const Text('Add item'),
);''',
      tokenClasses:
          'ppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppssssssssssppppp',
    ),
    DocsSnippet(
      id: 'button.2',
      componentId: 'button',
      language: 'dart',
      code: r'''ButtonGroup(
  children: <Widget>[
    Button(variant: ButtonVariant.outline, onPressed: prev, child: const Text('Prev')),
    Button(variant: ButtonVariant.outline, onPressed: next, child: const Text('Next')),
  ],
);''',
      tokenClasses:
          'ppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppsssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppssssssppppppppppp',
    ),
  ],
  'command': <DocsSnippet>[
    DocsSnippet(
      id: 'command.0',
      componentId: 'command',
      language: 'dart',
      code: r'''Command(
  builder: (context, query) async* {
    final items = allItems.where(
      (item) => query == null || item.label.contains(query),
    );
    yield <Widget>[
      for (final item in items)
        SubFocusListItem(title: Text(item.label), onTap: item.run),
    ];
  },
);''',
      tokenClasses:
          'pppppppppppppppppppppppppppppppppppppkkkkkppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppkkkkpppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppkkkppkkkkkppppppkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
    DocsSnippet(
      id: 'command.1',
      componentId: 'command',
      language: 'dart',
      code: r'''showCommandDialog<void>(
  context: context,
  builder: (context, query) async* => ...,
);''',
      tokenClasses:
          'ppppppppppppppppppkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppp',
    ),
    DocsSnippet(
      id: 'command.2',
      componentId: 'command',
      language: 'dart',
      code: r'''SubFocusListItem(
  title: const Text('Search'),
  trailing: const CommandShortcut(label: '⌘K'),
  onTap: () => search(),
);''',
      tokenClasses:
          'pppppppppppppppppppppppppppkkkkkppppppsssssssspppppppppppppppkkkkkppppppppppppppppppppppppsssspppppppppppppppppppppppppppppp',
    ),
  ],
  'patch': <DocsSnippet>[
    DocsSnippet(
      id: 'patch.0',
      componentId: 'patch',
      language: 'dart',
      code: r'''ClickDetector(
  threshold: const Duration(milliseconds: 300),
  onClick: (ClickDetails details) {
    if (details.clickCount == 2) openFile();
  },
  child: const FileTile(),
)''',
      tokenClasses:
          'ppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkpppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppp',
    ),
  ],
  'scrollbar': <DocsSnippet>[
    DocsSnippet(
      id: 'scrollbar.0',
      componentId: 'scrollbar',
      language: 'dart',
      code: r'''Scrollbar(
  thumbVisibility: true,
  child: ListView(controller: controller, children: items),
);''',
      tokenClasses:
          'ppppppppppppppppppppppppppppppkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
    DocsSnippet(
      id: 'scrollbar.1',
      componentId: 'scrollbar',
      language: 'dart',
      code: r'''Scrollbar(
  thumbVisibility: true,
  trackVisibility: true,
  thickness: 10,
  child: SingleChildScrollView(controller: controller, child: content),
);''',
      tokenClasses:
          'ppppppppppppppppppppppppppppppkkkkpppppppppppppppppppppkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
  ],
  'scrollview': <DocsSnippet>[
    DocsSnippet(
      id: 'scrollview.0',
      componentId: 'scrollview',
      language: 'dart',
      code: r'''ScrollViewInterceptor(
  child: SingleChildScrollView(child: content),
);''',
      tokenClasses:
          'ppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
  ],
  'toggle': <DocsSnippet>[
    DocsSnippet(
      id: 'toggle.0',
      componentId: 'toggle',
      language: 'dart',
      code: r'''Toggle(
  value: bold,
  onChanged: (value) => setState(() => bold = value),
  child: const Text('Bold'),
);''',
      tokenClasses:
          'ppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppssssssppppp',
    ),
    DocsSnippet(
      id: 'toggle.1',
      componentId: 'toggle',
      language: 'dart',
      code: r'''final controller = ToggleController();
Toggle(controller: controller, child: const Text('Show sidebar'));
// controller.toggle();''',
      tokenClasses:
          'kkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppssssssssssssssppppccccccccccccccccccccccc',
    ),
    DocsSnippet(
      id: 'toggle.2',
      componentId: 'toggle',
      language: 'dart',
      code: r'''Toggle(
  value: selected,
  onChanged: onSelect,
  activeStyle: const ToggleStyle(
    background: StateValue(rest: ThemedColor.ref(ColorRef.secondary)),
  ),
  child: const Text('Option'),
);''',
      tokenClasses:
          'pppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppssssssssppppp',
    ),
  ],
  'avatar': <DocsSnippet>[
    DocsSnippet(
      id: 'avatar.0',
      componentId: 'avatar',
      language: 'dart',
      code: r'''const Avatar(initials: 'IB');''',
      tokenClasses: 'kkkkkppppppppppppppppppsssspp',
    ),
    DocsSnippet(
      id: 'avatar.1',
      componentId: 'avatar',
      language: 'dart',
      code: r'''Avatar(
  initials: 'IB',
  image: NetworkImage(photoUrl),
  badge: const AvatarBadge(child: Icon(LucideIcons.check, size: 8)),
);''',
      tokenClasses:
          'ppppppppppppppppppppssssppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
    DocsSnippet(
      id: 'avatar.2',
      componentId: 'avatar',
      language: 'dart',
      code: r'''const AvatarGroup(
  children: <Widget>[
    Avatar(initials: 'IB'),
    Avatar(initials: 'AC'),
    Avatar(initials: '+4'),
  ],
);''',
      tokenClasses:
          'kkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssppppppppppppppppppppppppssssppppppppppppppppppppppppsssspppppppppp',
    ),
  ],
  'badge': <DocsSnippet>[
    DocsSnippet(
      id: 'badge.0',
      componentId: 'badge',
      language: 'dart',
      code: r'''const Badge(child: Text('New'));''',
      tokenClasses: 'kkkkkpppppppppppppppppppsssssppp',
    ),
    DocsSnippet(
      id: 'badge.1',
      componentId: 'badge',
      language: 'dart',
      code:
          r'''Badge(variant: BadgeVariant.destructive, child: const Text('Deprecated'));''',
      tokenClasses:
          'ppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppssssssssssssppp',
    ),
    DocsSnippet(
      id: 'badge.2',
      componentId: 'badge',
      language: 'dart',
      code: r'''Badge(
  onPressed: () => setState(() => selected = !selected),
  child: const Text('Mine'),
);''',
      tokenClasses:
          'pppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppssssssppppp',
    ),
    DocsSnippet(
      id: 'badge.3',
      componentId: 'badge',
      language: 'dart',
      code: r'''Badge(showAsDot: true, child: const SizedBox.shrink());''',
      tokenClasses: 'pppppppppppppppppkkkkpppppppppkkkkkpppppppppppppppppppp',
    ),
  ],
  'border_loading': <DocsSnippet>[
    DocsSnippet(
      id: 'border_loading.0',
      componentId: 'border_loading',
      language: 'dart',
      code: r'''BorderLoading(child: Text('Uploading...'));

BorderLoading(
  mode: BorderLoadingMode.tracer,
  tracer: const BorderTracerSpec(dashCount: 3),
  child: const Text('Working...'),
);

BorderLoading(
  mode: BorderLoadingMode.progress,
  progress: value,                      // or progressStream: stream
  child: const Text('62%'),
);''',
      tokenClasses:
          'ppppppppppppppppppppppppppssssssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppkkkkkppppppssssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppccccccccccccccccccccccccccccppppppppppkkkkkppppppsssssppppp',
    ),
  ],
  'calendar': <DocsSnippet>[
    DocsSnippet(
      id: 'calendar.0',
      componentId: 'calendar',
      language: 'dart',
      code: r'''Calendar(
  view: CalendarView.now(),
  selectionMode: CalendarSelectionMode.single,
  onChanged: (value) => setState(() => picked = value),
);''',
      tokenClasses:
          'ppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
    DocsSnippet(
      id: 'calendar.1',
      componentId: 'calendar',
      language: 'dart',
      code: r'''Calendar(
  view: CalendarView(2024, 3),
  now: DateTime(2024, 3, 14),
  value: CalendarValue.range(DateTime(2024, 3, 6), DateTime(2024, 3, 12)),
  selectionMode: CalendarSelectionMode.range,
  stateBuilder: (date) => date.weekday == DateTime.sunday
      ? DateState.disabled
      : DateState.enabled,
  onChanged: (value) => setState(() => range = value),
);''',
      tokenClasses:
          'ppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
    DocsSnippet(
      id: 'calendar.2',
      componentId: 'calendar',
      language: 'dart',
      code: r'''Calendar(view: view, firstDayOfWeek: DateTime.sunday);''',
      tokenClasses: 'pppppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
    DocsSnippet(
      id: 'calendar.3',
      componentId: 'calendar',
      language: 'dart',
      code: r'''Calendar(view: view, viewType: CalendarViewType.month);
Calendar(view: view, viewType: CalendarViewType.year);''',
      tokenClasses:
          'pppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
    DocsSnippet(
      id: 'calendar.4',
      componentId: 'calendar',
      language: 'dart',
      code: r'''Calendar(
  view: view,
  autofocus: true,
  onChanged: (value) => setState(() => picked = value),
  onViewChanged: (next) => setState(() => view = next),
);''',
      tokenClasses:
          'pppppppppppppppppppppppppppppppppppppkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
  ],
  'carousel': <DocsSnippet>[
    DocsSnippet(
      id: 'carousel.0',
      componentId: 'carousel',
      language: 'dart',
      code: r'''final controller = CarouselController();

Carousel(
  itemCount: pages.length,
  controller: controller,
  onIndexChanged: (int index) => setState(() => _page = index),
  itemBuilder: (context, index) => pages[index],
);''',
      tokenClasses:
          'kkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
    DocsSnippet(
      id: 'carousel.1',
      componentId: 'carousel',
      language: 'dart',
      code: r'''Carousel(
  itemCount: pages.length,
  transition: CarouselTransition.fading,
  viewportFraction: 0.5,
  itemBuilder: (context, index) => pages[index],
);''',
      tokenClasses:
          'pppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
    DocsSnippet(
      id: 'carousel.2',
      componentId: 'carousel',
      language: 'dart',
      code: r'''Carousel(
  itemCount: pages.length,
  autoplayInterval: const Duration(seconds: 3),
  itemBuilder: (context, index) => pages[index],
);''',
      tokenClasses:
          'pppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
    DocsSnippet(
      id: 'carousel.3',
      componentId: 'carousel',
      language: 'dart',
      code: r'''DotIndicator(
  index: controller.value.round(),
  length: pages.length,
  onChanged: (int page) => controller.animateTo(page.toDouble(), kDefaultDuration),
);''',
      tokenClasses:
          'ppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
  ],
  'chat': <DocsSnippet>[
    DocsSnippet(
      id: 'chat.0',
      componentId: 'chat',
      language: 'dart',
      code: r'''ChatGroup(
  // any widget works here; `avatar` is a separate component
  avatarPrefix: const Avatar(initials: 'JO'),
  children: const [
    ChatBubble(child: Text('Around 6 or 7?')),
    ChatBubble(child: Text('New phone who dis?')),
  ],
);

ChatGroup(
  variant: ChatBubbleVariant.sharpCorner,
  children: const [ChatBubble(child: Text('Sharp corner.'))],
);''',
      tokenClasses:
          'pppppppppppppccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpppppppppppppppppkkkkkppppppppppppppppppsssspppppppppppppppkkkkkppppppppppppppppppppppppppppppsssssssssssssssspppppppppppppppppppppppppppppppssssssssssssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppsssssssssssssssppppppp',
    ),
    DocsSnippet(
      id: 'chat.1',
      componentId: 'chat',
      language: 'dart',
      code: r'''ChatReaction(
  child: const ChatBubble(child: Text('Nice work!')),
  chips: <Widget>[
    ChatReactionContainer(
      selected: liked,
      onTap: () => setState(() => liked = !liked),
      child: const Text('👍 3'),
    ),
    const ChatReactionContainer(child: Text('🎉 1')),
  ],
);''',
      tokenClasses:
          'pppppppppppppppppppppppkkkkkppppppppppppppppppppppppsssssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppssssssppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppssssssppppppppppp',
    ),
  ],
  'chip': <DocsSnippet>[
    DocsSnippet(
      id: 'chip.0',
      componentId: 'chip',
      language: 'dart',
      code: r'''const Chip(child: Text('flutter'));''',
      tokenClasses: 'kkkkkppppppppppppppppppsssssssssppp',
    ),
    DocsSnippet(
      id: 'chip.1',
      componentId: 'chip',
      language: 'dart',
      code: r'''Chip(onPressed: () {}, child: const Text('pressable'));''',
      tokenClasses: 'ppppppppppppppppppppppppppppppkkkkkppppppsssssssssssppp',
    ),
    DocsSnippet(
      id: 'chip.2',
      componentId: 'chip',
      language: 'dart',
      code: r'''Chip(
  trailing: ChipButton(
    onPressed: () => setState(() => tags.remove(tag)),
    child: const Icon(LucideIcons.x, size: 12),
  ),
  child: Text(tag),
);''',
      tokenClasses:
          'ppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
  ],
  'code_snippet': <DocsSnippet>[
    DocsSnippet(
      id: 'code_snippet.0',
      componentId: 'code_snippet',
      language: 'dart',
      code: r'''const CodeSnippet(code: Text('flutter run -d chrome'));''',
      tokenClasses: 'kkkkkppppppppppppppppppppppppsssssssssssssssssssssssppp',
    ),
    DocsSnippet(
      id: 'code_snippet.1',
      componentId: 'code_snippet',
      language: 'dart',
      code: r'''CodeSnippet(
  constraints: const BoxConstraints(maxWidth: 480, maxHeight: 200),
  actions: [
    Button(
      size: ButtonSize.sm,
      variant: ButtonVariant.ghost,
      onPressed: copy,
      child: const Text('Copy'),
    ),
  ],
  code: const Text('dart format .'),
);''',
      tokenClasses:
          'ppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppsssssspppppppppppppppppppppppkkkkkppppppsssssssssssssssppppp',
    ),
  ],
  'country_flag': <DocsSnippet>[
    DocsSnippet(
      id: 'country_flag.0',
      componentId: 'country_flag',
      language: 'dart',
      code: r'''const CountryFlag.fromCountryCode('US');''',
      tokenClasses: 'kkkkkpppppppppppppppppppppppppppppsssspp',
    ),
    DocsSnippet(
      id: 'country_flag.1',
      componentId: 'country_flag',
      language: 'dart',
      code: r'''const CountryFlag.fromCurrencyCode('JPY');
const CountryFlag.fromPhonePrefix('+49');''',
      tokenClasses:
          'kkkkkppppppppppppppppppppppppppppppssssspppkkkkkpppppppppppppppppppppppppppppssssspp',
    ),
    DocsSnippet(
      id: 'country_flag.2',
      componentId: 'country_flag',
      language: 'dart',
      code: r'''CountryFlag.fromCountryCode(
  'FR',
  width: 36,
  height: 27,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
);''',
      tokenClasses:
          'pppppppppppppppppppppppppppppppsssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
    DocsSnippet(
      id: 'country_flag.3',
      componentId: 'country_flag',
      language: 'dart',
      code: r'''ComponentTheme<CountryFlagTheme>(
  data: CountryFlagTheme(
    builder: (context, details) => MyFlagImage(code: details.countryCode),
  ),
  child: const CountryFlag.fromCountryCode('US'),
);''',
      tokenClasses:
          'pppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppssssppppp',
    ),
  ],
  'divider': <DocsSnippet>[
    DocsSnippet(
      id: 'divider.0',
      componentId: 'divider',
      language: 'dart',
      code: r'''const Divider();''',
      tokenClasses: 'kkkkkppppppppppp',
    ),
    DocsSnippet(
      id: 'divider.1',
      componentId: 'divider',
      language: 'dart',
      code: r'''Row(
  mainAxisSize: MainAxisSize.min,
  crossAxisAlignment: CrossAxisAlignment.stretch,
  children: const <Widget>[
    Text('left'),
    Divider(axis: Axis.vertical),
    Text('right'),
  ],
);''',
      tokenClasses:
          'pppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppssssssppppppppppppppppppppppppppppppppppppppppppppppssssssspppppppppp',
    ),
    DocsSnippet(
      id: 'divider.2',
      componentId: 'divider',
      language: 'dart',
      code: r'''const Divider(label: Text('or continue with'));
const Divider(
  label: Text('start'),
  labelAlignment: DividerLabelAlignment.start,
);''',
      tokenClasses:
          'kkkkkpppppppppppppppppppppssssssssssssssssssppppkkkkkppppppppppppppppppppppppssssssspppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
  ],
  'dot_indicator': <DocsSnippet>[
    DocsSnippet(
      id: 'dot_indicator.0',
      componentId: 'dot_indicator',
      language: 'dart',
      code: r'''DotIndicator(
  index: page,
  length: pages.length,
  onChanged: (int index) => controller.animateToPage(index),
)''',
      tokenClasses:
          'ppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
    DocsSnippet(
      id: 'dot_indicator.1',
      componentId: 'dot_indicator',
      language: 'dart',
      code: r'''const DotIndicator(index: 1, length: 5)''',
      tokenClasses: 'kkkkkpppppppppppppppppppppppppppppppppp',
    ),
    DocsSnippet(
      id: 'dot_indicator.2',
      componentId: 'dot_indicator',
      language: 'dart',
      code: r'''DotIndicator(
  index: page,
  length: pages.length,
  dotBuilder: (context, index, isActive) => SizedBox(
    width: isActive ? 24 : 8,
    height: 8,
    child: const DecoratedBox(decoration: BoxDecoration(color: Colors.grey)),
  ),
)''',
      tokenClasses:
          'pppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
  ],
  'empty_state': <DocsSnippet>[
    DocsSnippet(
      id: 'empty_state.0',
      componentId: 'empty_state',
      language: 'dart',
      code: r'''EmptyState(
  variant: EmptyStateVariant.empty,
  size: EmptyStateSize.fullPage,
  primaryAction: EmptyStateAction(
    label: 'Create project',
    onPressed: _create,
  ),
  secondaryAction: EmptyStateAction(
    label: 'Import',
    variant: ButtonVariant.secondary,
    onPressed: _import,
  ),
);''',
      tokenClasses:
          'pppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssssssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
    DocsSnippet(
      id: 'empty_state.1',
      componentId: 'empty_state',
      language: 'dart',
      code: r'''EmptyState(
  size: EmptyStateSize.compact,
  title: const Text('Nothing here yet'),
  primaryAction: const EmptyStateAction(label: 'Create'),
);''',
      tokenClasses:
          'pppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppssssssssssssssssssppppppppppppppppppppkkkkkpppppppppppppppppppppppppssssssssppppp',
    ),
  ],
  'feature_carousel': <DocsSnippet>[
    DocsSnippet(
      id: 'feature_carousel.0',
      componentId: 'feature_carousel',
      language: 'dart',
      code: r'''FeatureCarousel(
  items: const <FeatureCarouselItem>[
    FeatureCarouselItem(
      title: 'Fast',
      description: 'Ship a build in seconds.',
      icon: LucideIcons.zap,
    ),
    FeatureCarouselItem(title: 'Safe', icon: LucideIcons.shield),
  ],
);''',
      tokenClasses:
          'ppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssspppppppppppppppppppppsssssssssssssssssssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssspppppppppppppppppppppppppppppppppppp',
    ),
    DocsSnippet(
      id: 'feature_carousel.1',
      componentId: 'feature_carousel',
      language: 'dart',
      code: r'''final controller = FeatureCarouselController(
  autoPlay: false,
  primaryActionLabel: 'Get started',
  onPrimaryAction: (item, index) => open(item),
);

FeatureCarousel(items: items, controller: controller);''',
      tokenClasses:
          'kkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppssssssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
    DocsSnippet(
      id: 'feature_carousel.2',
      componentId: 'feature_carousel',
      language: 'dart',
      code: r'''FeatureCarousel(
  items: items,
  cardBuilder: (context, item, index, theme) =>
      MyCard(item: item, theme: theme),
);''',
      tokenClasses:
          'ppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
  ],
  'file_diff_viewer': <DocsSnippet>[
    DocsSnippet(
      id: 'file_diff_viewer.0',
      componentId: 'file_diff_viewer',
      language: 'dart',
      code: r'''FileDiffViewer(
  files: [
    FileDiff(
      path: 'lib/src/widget.dart',
      hunks: [
        FileDiffHunk(
          header: '@@ -10,7 +10,8 @@',
          lines: [
            FileDiffLine(type: FileDiffLineType.context, content: 'Widget build(...) {', oldLineNumber: 10, newLineNumber: 10),
            FileDiffLine(type: FileDiffLineType.addition, content: '  return Text(label);', newLineNumber: 11),
            FileDiffLine(type: FileDiffLineType.deletion, content: '  return label;', oldLineNumber: 11),
          ],
        ),
      ],
    ),
  ],
);

FileDiffViewer(layout: FileDiffLayout.split, files: files);''',
      tokenClasses:
          'pppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssssssssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssssssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssssssssssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssssssssssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
  ],
  'icon': <DocsSnippet>[
    DocsSnippet(
      id: 'icon.0',
      componentId: 'icon',
      language: 'dart',
      code: r'''const Icon(LucideIcons.chevronRight).iconSmall();

const Icon(LucideIcons.x).iconSmall().iconMutedForeground();

const IconContainer(icon: Icon(LucideIcons.check));''',
      tokenClasses:
          'kkkkkppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppp',
    ),
  ],
  'image': <DocsSnippet>[
    DocsSnippet(
      id: 'image.0',
      componentId: 'image',
      language: 'dart',
      code:
          r'''ShadcnImage(image: NetworkImage(url), width: 200, aspectRatio: 1)''',
      tokenClasses:
          'ppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
    DocsSnippet(
      id: 'image.1',
      componentId: 'image',
      language: 'dart',
      code: r'''ShadcnImage(
  image: NetworkImage(url),
  width: 200,
  aspectRatio: 1,
  placeholder: const Center(child: Icon(LucideIcons.loader)),
  errorBuilder: (context, error, stackTrace) =>
      const Center(child: Icon(LucideIcons.imageOff)),
)''',
      tokenClasses:
          'ppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppp',
    ),
  ],
  'keyboard_shortcut': <DocsSnippet>[
    DocsSnippet(
      id: 'keyboard_shortcut.0',
      componentId: 'keyboard_shortcut',
      language: 'dart',
      code: r'''KeyboardShortcut.fromActivator(
  activator: const SingleActivator(LogicalKeyboardKey.keyK, meta: true),
);''',
      tokenClasses:
          'pppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppkkkkppppp',
    ),
    DocsSnippet(
      id: 'keyboard_shortcut.1',
      componentId: 'keyboard_shortcut',
      language: 'dart',
      code: r'''KeyboardShortcut(
  keys: const <LogicalKeyboardKey>[
    LogicalKeyboardKey.control,
    LogicalKeyboardKey.shift,
    LogicalKeyboardKey.keyP,
  ],
);''',
      tokenClasses:
          'ppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
    DocsSnippet(
      id: 'keyboard_shortcut.2',
      componentId: 'keyboard_shortcut',
      language: 'dart',
      code: r'''KeyboardKeyCap(keyboardKey: LogicalKeyboardKey.enter)''',
      tokenClasses: 'ppppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
    DocsSnippet(
      id: 'keyboard_shortcut.3',
      componentId: 'keyboard_shortcut',
      language: 'dart',
      code: r'''KeyboardShortcutDisplayScope(
  builder: (context, key) => Text(key.keyLabel.toUpperCase()),
  child: myApp,
);''',
      tokenClasses:
          'ppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
  ],
  'markdown': <DocsSnippet>[
    DocsSnippet(
      id: 'markdown.0',
      componentId: 'markdown',
      language: 'dart',
      code: r'''const Markdown(data: '# Hello\n\nSome **bold** text.');''',
      tokenClasses: 'kkkkkppppppppppppppppsssssssssssssssssssssssssssssssspp',
    ),
    DocsSnippet(
      id: 'markdown.1',
      componentId: 'markdown',
      language: 'dart',
      code: r'''Markdown(
  data: 'Read the [docs](https://example.com).',
  onTapLink: (text, url) => launchUrl(Uri.parse(url)),
)''',
      tokenClasses:
          'ppppppppppppppppppssssssssssssssssssssssssssssssssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
    DocsSnippet(
      id: 'markdown.2',
      componentId: 'markdown',
      language: 'dart',
      code: r'''ComponentTheme<MarkdownTheme>(
  data: const MarkdownTheme(linkColor: ThemedColor.ref(ColorRef.accent)),
  child: const Markdown(data: '[accent link](https://example.com)'),
)''',
      tokenClasses:
          'pppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppsssssssssssssssssssssssssssssssssssspppp',
    ),
  ],
  'number_ticker': <DocsSnippet>[
    DocsSnippet(
      id: 'number_ticker.0',
      componentId: 'number_ticker',
      language: 'dart',
      code: r'''NumberTicker(
  number: balance,
  formatter: (value) => value.toStringAsFixed(2),
);''',
      tokenClasses:
          'ppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
    DocsSnippet(
      id: 'number_ticker.1',
      componentId: 'number_ticker',
      language: 'dart',
      code: r'''import 'package:intl/intl.dart' as intl;

NumberTicker(
  number: followers,
  formatter: (value) => intl.NumberFormat.compact().format(value),
);''',
      tokenClasses:
          'kkkkkkpsssssssssssssssssssssssspkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
    DocsSnippet(
      id: 'number_ticker.2',
      componentId: 'number_ticker',
      language: 'dart',
      code: r'''NumberTicker.builder(
  number: score,
  builder: (context, value, _) => Text('${value.toInt()} pts'),
);''',
      tokenClasses:
          'ppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsppppppppppppppppsssssppppp',
    ),
    DocsSnippet(
      id: 'number_ticker.3',
      componentId: 'number_ticker',
      language: 'dart',
      code: r'''TextFlipper(charset: FlipperCharset.numbers, text: code);''',
      tokenClasses: 'ppppppppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
  ],
  'pinned_sheet': <DocsSnippet>[
    DocsSnippet(
      id: 'pinned_sheet.0',
      componentId: 'pinned_sheet',
      language: 'dart',
      code: r'''final controller = SheetController();

PinnedSheet(
  controller: controller,
  stages: const [
    SheetStage.closed(),
    SheetStage.fraction(0.4),
    SheetStage.expanded(),
  ],
  child: const DrawerContainer(child: Text('Sheet content')),
);

// Later:
controller.animateTo(const SheetStage.fraction(0.4));
if (controller.stage == SheetStage.expanded() - SheetStage.fixed(100)) { ... }''',
      tokenClasses:
          'kkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppsssssssssssssssppppppppcccccccccppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
  ],
  'progress': <DocsSnippet>[
    DocsSnippet(
      id: 'progress.0',
      componentId: 'progress',
      language: 'dart',
      code: r'''const Progress(value: 0.4);

const Progress();

const Progress(
  value: 0.85,
  showSparks: true,
  semanticsLabel: 'Uploading',
  semanticsValue: '85%',
);''',
      tokenClasses:
          'kkkkkppppppppppppppppppppppppkkkkkppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppkkkkppppppppppppppppppppsssssssssssppppppppppppppppppppssssspppp',
    ),
  ],
  'selectable': <DocsSnippet>[
    DocsSnippet(
      id: 'selectable.0',
      componentId: 'selectable',
      language: 'dart',
      code: r'''const SelectableText('Select this text');

SelectableText.rich(
  TextSpan(
    children: <TextSpan>[
      TextSpan(text: 'Bold', style: TextStyle(fontWeight: FontWeight.bold)),
      TextSpan(text: ' and normal text.'),
    ],
  ),
);''',
      tokenClasses:
          'kkkkkppppppppppppppppssssssssssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssssssssssssssssppppppppppppppppp',
    ),
  ],
  'skeleton': <DocsSnippet>[
    DocsSnippet(
      id: 'skeleton.0',
      componentId: 'skeleton',
      language: 'dart',
      code: r'''Skeleton(
  enabled: loading,
  child: Text('Summary'),
);''',
      tokenClasses:
          'ppppppppppppppppppppppppppppppppppppppppppppsssssssssppppp',
    ),
    DocsSnippet(
      id: 'skeleton.1',
      componentId: 'skeleton',
      language: 'dart',
      code: r'''const Skeleton(
  borderRadius: BorderRadius.all(Radius.circular(40)),
  child: SizedBox(width: 80, height: 80),
);''',
      tokenClasses:
          'kkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
    DocsSnippet(
      id: 'skeleton.2',
      componentId: 'skeleton',
      language: 'dart',
      code: r'''Skeleton(
  enabled: loading,
  theme: SkeletonTheme(duration: Duration(milliseconds: 1600)),
  child: content,
);''',
      tokenClasses:
          'pppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
    DocsSnippet(
      id: 'skeleton.3',
      componentId: 'skeleton',
      language: 'dart',
      code: r'''const SkeletonTheme skeletonThemeOverrides = SkeletonTheme(
  fromColor: ThemedColor.ref(ColorRef.accent),
  toColor: ThemedColor.ref(ColorRef.secondary),
);''',
      tokenClasses:
          'kkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
  ],
  'spinner': <DocsSnippet>[
    DocsSnippet(
      id: 'spinner.0',
      componentId: 'spinner',
      language: 'dart',
      code: r'''const Spinner();

const Spinner(size: 16, strokeWidth: 2);

const Spinner(semanticsLabel: 'Loading');''',
      tokenClasses:
          'kkkkkpppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppssssssssspp',
    ),
  ],
  'text_animate': <DocsSnippet>[
    DocsSnippet(
      id: 'text_animate.0',
      componentId: 'text_animate',
      language: 'dart',
      code: r'''TextAnimate(text: streamedText)''',
      tokenClasses: 'ppppppppppppppppppppppppppppppp',
    ),
    DocsSnippet(
      id: 'text_animate.1',
      componentId: 'text_animate',
      language: 'dart',
      code: r'''TextAnimate(
  text: streamedText,
  effect: const TextAnimateEffect.blur(maxBlurSigma: 6, slideUpPx: 2),
  cursor: const TextAnimateCursor.blink(showWhenSettled: false),
)''',
      tokenClasses:
          'pppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppkkkkkpppp',
    ),
    DocsSnippet(
      id: 'text_animate.2',
      componentId: 'text_animate',
      language: 'dart',
      code: r'''TextAnimate(
  text: streamedText,
  animateByWord: true,
  effect: const TextAnimateEffect.scramble(),
)''',
      tokenClasses:
          'ppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkppppppppppppkkkkkpppppppppppppppppppppppppppppppp',
    ),
    DocsSnippet(
      id: 'text_animate.3',
      componentId: 'text_animate',
      language: 'dart',
      code: r'''Markdown(data: streamedMarkdown).withTextStreaming(
  effect: const TextAnimateEffect.fade(
    duration: Duration(milliseconds: 220),
  ),
)''',
      tokenClasses:
          'ppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
    DocsSnippet(
      id: 'text_animate.4',
      componentId: 'text_animate',
      language: 'dart',
      code: r'''ComponentTheme<TextAnimateTheme>(
  data: const TextAnimateTheme(
    effect: TextAnimateEffect.slide(offsetY: 16),
  ),
  child: TextAnimate(text: streamedText),
)''',
      tokenClasses:
          'ppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
  ],
  'tracker': <DocsSnippet>[
    DocsSnippet(
      id: 'tracker.0',
      componentId: 'tracker',
      language: 'dart',
      code: r'''Tracker(
  data: <TrackerData>[
    TrackerData(tooltip: const Text('Healthy'), level: TrackerLevel.fine),
    TrackerData(tooltip: const Text('Degraded'), level: TrackerLevel.warning),
    TrackerData(tooltip: const Text('Down'), level: TrackerLevel.critical),
  ],
);''',
      tokenClasses:
          'pppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppssssssppppppppppppppppppppppppppppppppppppppppp',
    ),
    DocsSnippet(
      id: 'tracker.1',
      componentId: 'tracker',
      language: 'dart',
      code: r'''TrackerData(
  level: TrackerLevel.critical,
  tooltip: Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[const Text('API'), const Text('500 · 2m ago')],
  ),
);''',
      tokenClasses:
          'pppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppssssspppkkkkkppppppssssssssssssssppppppppppp',
    ),
    DocsSnippet(
      id: 'tracker.2',
      componentId: 'tracker',
      language: 'dart',
      code: r'''Tracker(
  theme: const TrackerTheme(itemHeight: 24, gap: 4, radius: 4),
  data: data,
);''',
      tokenClasses:
          'ppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
  ],
  'tree': <DocsSnippet>[
    DocsSnippet(
      id: 'tree.0',
      componentId: 'tree',
      language: 'dart',
      code: r'''List<TreeNode<String>> _nodes = <TreeNode<String>>[
  TreeItem<String>(
    data: 'Documents',
    expanded: true,
    children: <TreeNode<String>>[TreeItem<String>(data: 'a.txt')],
  ),
];

Tree<String>(
  nodes: _nodes,
  builder: (context, item) => TreeRow(
    leading: const Icon(LucideIcons.file),
    child: Text(item.data),
  ),
  onExpandedChanged: (node, expanded) => setState(
    () => _nodes = expanded ? _nodes.expandNode(node) : _nodes.collapseNode(node),
  ),
  onSelectionChanged: (nodes, multi, selected) => setState(
    () => _nodes = multi && selected
        ? _nodes.updateNodes((n) => n.selected ? null : n.updateState(selected: true))
        : _nodes.setSelectedNodes(nodes),
  ),
);''',
      tokenClasses:
          'ppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssssssssppppppppppppppppkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkpppppppppppppppppppppppppppkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
  ],
  'triple_dots': <DocsSnippet>[
    DocsSnippet(
      id: 'triple_dots.0',
      componentId: 'triple_dots',
      language: 'dart',
      code: r'''const TripleDots();

const TripleDots(count: 4, direction: Axis.vertical);''',
      tokenClasses:
          'kkkkkppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
  ],
  'autocomplete': <DocsSnippet>[
    DocsSnippet(
      id: 'autocomplete.0',
      componentId: 'autocomplete',
      language: 'dart',
      code: r'''Input(
  hintText: 'Fruit',
  features: <InputFeature>[
    AutoCompleteFeature(suggestions: (query) => fruits(query)),
  ],
);''',
      tokenClasses:
          'pppppppppppppppppppsssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
    DocsSnippet(
      id: 'autocomplete.1',
      componentId: 'autocomplete',
      language: 'dart',
      code: r'''Input(
  features: <InputFeature>[
    AutoCompleteFeature(
      suggestions: (query) => _filter(query),
      mode: AutoCompleteMode.replaceWord, // append | replaceWord | replaceAll
      completer: (suggestion) => '$suggestion ', // add a trailing space
      onSuggestionSelected: (value) => print(value),
    ),
  ],
);''',
      tokenClasses:
          'ppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppccccccccccccccccccccccccccccccccccccppppppppppppppppppppppppppppppppppspppppppppppssppcccccccccccccccccccccccpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
    DocsSnippet(
      id: 'autocomplete.2',
      componentId: 'autocomplete',
      language: 'dart',
      code: r'''AutoCompleteFeature(
  suggestions: (query) => _filter(query),
  itemBuilder: (context, suggestion, highlighted) => Text(
    suggestion,
    style: TextStyle(fontWeight: highlighted ? FontWeight.w600 : FontWeight.w400),
  ),
)''',
      tokenClasses:
          'ppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
  ],
  'checkbox': <DocsSnippet>[
    DocsSnippet(
      id: 'checkbox.0',
      componentId: 'checkbox',
      language: 'dart',
      code: r'''Checkbox(
  value: accepted,
  onChanged: (value) => setState(() => accepted = value),
  label: const Text('I accept the terms'),
);''',
      tokenClasses:
          'ppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppssssssssssssssssssssppppp',
    ),
    DocsSnippet(
      id: 'checkbox.1',
      componentId: 'checkbox',
      language: 'dart',
      code: r'''Checkbox(
  tristate: true,
  value: value,
  onChanged: (next) => setState(() => value = next),
  label: const Text('All notifications'),
);''',
      tokenClasses:
          'ppppppppppppppppppppppkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppsssssssssssssssssssppppp',
    ),
    DocsSnippet(
      id: 'checkbox.2',
      componentId: 'checkbox',
      language: 'dart',
      code: r'''final controller = CheckboxController();
Checkbox(controller: controller, label: const Text('Remember me'));
// controller.check(); controller.setIndeterminate();''',
      tokenClasses:
          'kkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppsssssssssssssppppccccccccccccccccccccccccccccccccccccccccccccccccccccc',
    ),
  ],
  'chip_input': <DocsSnippet>[
    DocsSnippet(
      id: 'chip_input.0',
      componentId: 'chip_input',
      language: 'dart',
      code: r'''ChipInput<String>(
  hintText: 'Add a tag',
  onChipSubmit: (text) => text.trim().toLowerCase(),
  initialChips: const <String>['flutter'],
  suggestions: (query) => _tags.where((t) => t.startsWith(query)),
);''',
      tokenClasses:
          'pppppppppppppppppppppppppppppppssssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
  ],
  'color_field': <DocsSnippet>[
    DocsSnippet(
      id: 'color_field.0',
      componentId: 'color_field',
      language: 'dart',
      code: r'''SizedBox(
  width: 240,
  height: 160,
  child: ColorField(
    color: const Color(0xFF2563EB),
    saturationAxis: ColorFieldAxis.horizontal,
    valueAxis: ColorFieldAxis.vertical,
  ),
);''',
      tokenClasses:
          'pppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
  ],
  'color_input': <DocsSnippet>[
    DocsSnippet(
      id: 'color_input.0',
      componentId: 'color_input',
      language: 'bash',
      code: r'''flutter_shadcn add color_input''',
      tokenClasses: 'kkkkkkkkkkkkkkpkkkpppppppppppp',
    ),
    DocsSnippet(
      id: 'color_input.1',
      componentId: 'color_input',
      language: 'dart',
      code:
          r'''import 'package:<your_app>/ui/shadcn/color_input/color_input.dart';''',
      tokenClasses:
          'kkkkkkpsssssssssssssssssssssssssssssssssssssssssssssssssssssssssssp',
    ),
    DocsSnippet(
      id: 'color_input.2',
      componentId: 'color_input',
      language: 'dart',
      code: r'''ColorInput(
  value: ColorDerivative.fromColor(const Color(0xFF2563EB)),
  onChanged: (value) => setState(() => _color = value),
)''',
      tokenClasses:
          'pppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
    DocsSnippet(
      id: 'color_input.3',
      componentId: 'color_input',
      language: 'dart',
      code: r'''ColorInput(
  value: _color,
  showAlpha: true,
  showHistory: true,
  mode: PromptMode.dialog,
  dialogTitle: const Text('Select a colour'),
  onChanging: (value) => setState(() => _color = value),
  onChanged: (value) => setState(() => _color = value),
)''',
      tokenClasses:
          'ppppppppppppppppppppppppppppppppppppppppppkkkkpppppppppppppppppkkkkppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppsssssssssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
  ],
  'color_picker': <DocsSnippet>[
    DocsSnippet(
      id: 'color_picker.0',
      componentId: 'color_picker',
      language: 'bash',
      code: r'''flutter_shadcn add color_picker''',
      tokenClasses: 'kkkkkkkkkkkkkkpkkkppppppppppppp',
    ),
    DocsSnippet(
      id: 'color_picker.1',
      componentId: 'color_picker',
      language: 'dart',
      code:
          r'''import 'package:<your_app>/ui/shadcn/color_picker/color_picker.dart';''',
      tokenClasses:
          'kkkkkkpsssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssp',
    ),
    DocsSnippet(
      id: 'color_picker.2',
      componentId: 'color_picker',
      language: 'dart',
      code: r'''ColorPicker(
  value: ColorDerivative.fromColor(const Color(0xFF2563EB)),
  onChanged: (value) => setState(() => _color = value),
)''',
      tokenClasses:
          'ppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
    DocsSnippet(
      id: 'color_picker.3',
      componentId: 'color_picker',
      language: 'dart',
      code: r'''RecentColorsScope(
  child: ColorPicker(
    value: _color,
    initialMode: ColorPickerMode.hsv,
    showAlpha: true,
    initialShowHistory: true,
    onChanging: (value) => setState(() => _color = value),
    onChanged: (value) => setState(() => _color = value),
  ),
)''',
      tokenClasses:
          'pppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkppppppppppppppppppppppppppkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
    DocsSnippet(
      id: 'color_picker.4',
      componentId: 'color_picker',
      language: 'dart',
      code: r'''EyeDropperLayer(
  child: RecentColorsScope(
    child: ColorPicker(value: _color, onChanged: (v) => setState(() => _color = v)),
  ),
)''',
      tokenClasses:
          'pppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
  ],
  'date_picker': <DocsSnippet>[
    DocsSnippet(
      id: 'date_picker.0',
      componentId: 'date_picker',
      language: 'dart',
      code: r'''DatePicker(
  value: selected,
  onChanged: (next) => setState(() => selected = next),
);''',
      tokenClasses:
          'ppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
    DocsSnippet(
      id: 'date_picker.1',
      componentId: 'date_picker',
      language: 'dart',
      code: r'''DateRangePicker(
  value: range,
  onChanged: (next) => setState(() => range = next),
);''',
      tokenClasses:
          'pppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
  ],
  'dropzone': <DocsSnippet>[
    DocsSnippet(
      id: 'dropzone.0',
      componentId: 'dropzone',
      language: 'dart',
      code: r'''Dropzone(
  state: DropzoneState.idle,
  hint: const Text('Up to 10 MB each.'),
  onBrowse: _pickFiles,
)''',
      tokenClasses:
          'pppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppssssssssssssssssssspppppppppppppppppppppppppppp',
    ),
    DocsSnippet(
      id: 'dropzone.1',
      componentId: 'dropzone',
      language: 'dart',
      code: r'''Dropzone(isDragOver: true, onBrowse: _pickFiles)''',
      tokenClasses: 'pppppppppppppppppppppkkkkppppppppppppppppppppppp',
    ),
    DocsSnippet(
      id: 'dropzone.2',
      componentId: 'dropzone',
      language: 'dart',
      code: r'''Dropzone(
  showAction: false,
  content: const Text('Drop a folder here to upload it whole.'),
)''',
      tokenClasses:
          'ppppppppppppppppppppppppkkkkkpppppppppppppkkkkkppppppsssssssssssssssssssssssssssssssssssssssspppp',
    ),
  ],
  'file_picker': <DocsSnippet>[
    DocsSnippet(
      id: 'file_picker.0',
      componentId: 'file_picker',
      language: 'dart',
      code: r'''FileUpload(
  pick: (request) => myPlatformPicker.pick(request), // Future<List<FileValue>>
  upload: (file) => myApi.upload(file),              // Stream<double> progress
  constraints: const FileConstraints(
    allowMultiple: true,
    maxFiles: 5,
    maxFileSizeBytes: 10 * 1024 * 1024,
    allowedExtensions: <String>['pdf', 'png'],
  ),
  onComplete: (files) => print('uploaded: $files'),
)''',
      tokenClasses:
          'pppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppccccccccccccccccccccccccccppppppppppppppppppppppppppppppppppppppppppppppppppppppccccccccccccccccccccccccccppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssppssssspppppppppppppppppppppppppppppppppppppppsssssssssssppppppspppp',
    ),
  ],
  'form': <DocsSnippet>[
    DocsSnippet(
      id: 'form.0',
      componentId: 'form',
      language: 'dart',
      code: r'''final controller = FormController();
const emailKey = FormKey<String>('email');

ShadcnForm(
  controller: controller,
  onSubmit: (values) => save(values),
  child: Column(
    children: <Widget>[
      ShadcnFormField<String>(
        key: emailKey,
        label: const Text('Email'),
        validator: const NotEmptyValidator() & const EmailValidator(),
        child: const Input(),
      ),
      Button(
        onPressed: () => controller.submit(context),
        child: const Text('Submit'),
      ),
    ],
  ),
);''',
      tokenClasses:
          'kkkkkppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppsssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppsssssssppppppppppppppppppppppkkkkkpppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppsssssssspppppppppppppppppppppppppp',
    ),
    DocsSnippet(
      id: 'form.1',
      componentId: 'form',
      language: 'dart',
      code:
          r'''FormInline<String>(key: key, label: const Text('Name'), child: const Input());
FormTableLayout(rows: <ShadcnFormField<Object?>>[titleRow, slugRow]);''',
      tokenClasses:
          'ppppppppppppppppppppppppppppppppppppkkkkkppppppssssssppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
    DocsSnippet(
      id: 'form.2',
      componentId: 'form',
      language: 'dart',
      code: r'''ObjectFormField<DateTime>(
  value: date,
  onChanged: (value) => setState(() => date = value),
  placeholder: const Text('Pick a date'),
  builder: (context, value) => Text('$value'),
  editorBuilder: (context, handler) => Calendar(
    onChanged: (value) {
      handler.value = value;
    },
  ),
);''',
      tokenClasses:
          'pppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppssssssssssssspppppppppppppppppppppppppppppppppppppppsppppppspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
  ],
  'formatted_input': <DocsSnippet>[
    DocsSnippet(
      id: 'formatted_input.0',
      componentId: 'formatted_input',
      language: 'dart',
      code: r'''FormattedInput(
  initialValue: const SegmentedValue([
    SegmentPart.editable(length: 3, width: 32, placeholder: Text('555')),
    SegmentPart.separator(' ('),
    SegmentPart.editable(length: 3, width: 32, placeholder: Text('123')),
    SegmentPart.separator(') '),
    SegmentPart.editable(length: 4, width: 36, placeholder: Text('4567')),
  ]),
  validator: (text) => (text ?? '').replaceAll(RegExp(r'[^0-9]'), '').length == 10
      ? null
      : 'Enter a full number.',
);''',
      tokenClasses:
          'ppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssppppppppppppppppppppppppppppppssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssppppppppppppppppppppppppppppppssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssppppppppppppppppppppppppppppppppppppppppppssppppppppppppppppppppssssssssspppsspppppppppppppppppppppppkkkkpppppppppsssssssssssssssssssssspppp',
    ),
    DocsSnippet(
      id: 'formatted_input.1',
      componentId: 'formatted_input',
      language: 'dart',
      code:
          'final controller = FormattedInputController(_phone);\nFormattedInput(controller: controller); // controller.value.text -> \'555 () 4567\'',
      tokenClasses:
          'kkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppccccccccccccccccccccccccccccccccccccccccc',
    ),
  ],
  'formatter': <DocsSnippet>[
    DocsSnippet(
      id: 'formatter.0',
      componentId: 'formatter',
      language: 'dart',
      code: r'''TextField(
  inputFormatters: [
    TextInputFormatters.integerOnly(min: 0, max: 100),
    TextInputFormatters.hex(hashPrefix: true),
  ],
)''',
      tokenClasses:
          'pppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkppppppppp',
    ),
  ],
  'history': <DocsSnippet>[
    DocsSnippet(
      id: 'history.0',
      componentId: 'history',
      language: 'dart',
      code: r'''RecentColorsScope(
  maxRecentColors: 50,
  child: Builder(builder: (context) {
    return ColorHistoryGrid(
      storage: ColorHistoryStorage.of(context),
      onColorPicked: (color) { /* ... */ },
    );
  }),
)''',
      tokenClasses:
          'ppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppkkppppppppppppppppppppppppppppppppppppppppppcccccccccpppppppppppppppppp',
    ),
  ],
  'hsl': <DocsSnippet>[
    DocsSnippet(
      id: 'hsl.0',
      componentId: 'hsl',
      language: 'dart',
      code: r'''HSLColorSlider(
  color: HSLColor.fromAHSL(1, 200, 0.6, 0.5),
  sliderType: HSLColorSliderType.hueSat, // 2D pad
  onChanged: (next) { /* commit */ },
  onChanging: (next) { /* live */ },
)''',
      tokenClasses:
          'pppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppcccccccccpppppppppppppppppppppppccccccccccccpppppppppppppppppppppppppppccccccccccppppp',
    ),
  ],
  'hsv': <DocsSnippet>[
    DocsSnippet(
      id: 'hsv.0',
      componentId: 'hsv',
      language: 'dart',
      code: r'''HSVColorSlider(
  color: HSVColor.fromAHSV(1, 200, 0.6, 0.5),
  sliderType: HSVColorSliderType.hueSat, // 2D pad
  onChanged: (next) { /* commit */ },
  onChanging: (next) { /* live */ },
)''',
      tokenClasses:
          'pppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppcccccccccpppppppppppppppppppppppccccccccccccpppppppppppppppppppppppppppccccccccccppppp',
    ),
  ],
  'input': <DocsSnippet>[
    DocsSnippet(
      id: 'input.0',
      componentId: 'input',
      language: 'dart',
      code: r'''import 'package:<your_app>/ui/shadcn/input/input.dart';

const Input(hintText: 'Email');''',
      tokenClasses:
          'kkkkkkpssssssssssssssssssssssssssssssssssssssssssssssspppkkkkkpppppppppppppppppssssssspp',
    ),
    DocsSnippet(
      id: 'input.1',
      componentId: 'input',
      language: 'dart',
      code:
          r'''import 'package:<your_app>/ui/shadcn/primitives/input_features/adornment_features.dart';

Input(
  hintText: 'Password',
  obscureText: true,
  features: const [
    InputPasswordToggleFeature(),
    InputClearFeature(),
  ],
);''',
      tokenClasses:
          'kkkkkkpssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssppppppppppppppppppppppsssssssssspppppppppppppppppkkkkppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
    DocsSnippet(
      id: 'input.2',
      componentId: 'input',
      language: 'dart',
      code:
          r'''import 'package:<your_app>/ui/shadcn/primitives/input_features/numeric_features.dart';

Input(
  keyboardType: TextInputType.number,
  hintText: 'Quantity',
  features: const [InputSpinnerFeature(min: 0, max: 10)],
  validator: (value) => value == '0' ? 'Pick at least one.' : null,
);''',
      tokenClasses:
          'kkkkkkpssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssssppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssspppsssssssssssssssssssspppkkkkpppp',
    ),
    DocsSnippet(
      id: 'input.3',
      componentId: 'input',
      language: 'dart',
      code: r'''Input(
  features: [
    InputClearFeature(
      visibility:
          InputFeatureVisibility.focused &
          InputFeatureVisibility.textNotEmpty,
    ),
  ],
);''',
      tokenClasses:
          'pppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
  ],
  'input_otp': <DocsSnippet>[
    DocsSnippet(
      id: 'input_otp.0',
      componentId: 'input_otp',
      language: 'dart',
      code: r'''InputOtp(length: 6, onCompleted: (code) => verify(code));''',
      tokenClasses: 'ppppppppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
    DocsSnippet(
      id: 'input_otp.1',
      componentId: 'input_otp',
      language: 'dart',
      code: r'''InputOtp(
  length: 6,
  separatorEvery: 3,
  separator: const Text('-'),
  onChanged: (code) => print(code),
);''',
      tokenClasses:
          'pppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppsssppppppppppppppppppppppppppppppppppppppppp',
    ),
    DocsSnippet(
      id: 'input_otp.2',
      componentId: 'input_otp',
      language: 'dart',
      code: r'''InputOtp(
  length: 8,
  keyboardType: TextInputType.text,
  obscureText: true,
  filter: (character) => RegExp(r'^[a-zA-Z0-9]$').hasMatch(character),
);''',
      tokenClasses:
          'ppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkppppppppppppppppppppppppppppppppppssssssssssssssssppppppppppppppppppppppppp',
    ),
    DocsSnippet(
      id: 'input_otp.3',
      componentId: 'input_otp',
      language: 'dart',
      code: r'''final controller = TextEditingController(text: '123456');
InputOtp(length: 6, controller: controller, onChanged: controller.notifyListeners);''',
      tokenClasses:
          'kkkkkppppppppppppppppppppppppppppppppppppppppppsssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
  ],
  'item_picker': <DocsSnippet>[
    DocsSnippet(
      id: 'item_picker.0',
      componentId: 'item_picker',
      language: 'dart',
      code: r'''ItemPicker<Color>(
  items: ItemList([red, green, blue]),
  value: selected,
  placeholder: const Text('Pick a color'),
  builder: (context, color) => ColorDot(color),
  onChanged: (color) => setState(() => selected = color),
);''',
      tokenClasses:
          'ppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppssssssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
    DocsSnippet(
      id: 'item_picker.1',
      componentId: 'item_picker',
      language: 'dart',
      code: r'''ItemPicker<String>(
  items: const ItemList(['Small', 'Medium', 'Large']),
  layout: ItemPickerLayout.list,
  mode: PromptMode.dialog,
  value: size,
  builder: (context, item) => ItemPickerOption<String>(
    value: item,
    label: Text(item),
    child: const Icon(LucideIcons.tag, size: 16),
  ),
  onChanged: setSize,
);''',
      tokenClasses:
          'pppppppppppppppppppppppppppppkkkkkpppppppppppsssssssppssssssssppsssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
    DocsSnippet(
      id: 'item_picker.2',
      componentId: 'item_picker',
      language: 'dart',
      code: r'''final icon = await showItemPickerDialog<IconData>(
  context,
  title: const Text('Choose icon'),
  items: ItemList(icons),
  builder: (context, icon) => Icon(icon),
);''',
      tokenClasses:
          'kkkkkppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppsssssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
  ],
  'multi_select': <DocsSnippet>[
    DocsSnippet(
      id: 'multi_select.0',
      componentId: 'multi_select',
      language: 'dart',
      code: r'''Iterable<String>? fruits;

MultiSelect<String>(
  value: fruits,
  onChanged: (value) => setState(() => fruits = value),
  placeholder: const Text('Select fruits'),
  itemBuilder: (context, value) =>
      MultiSelectChip<String>(value: value, child: Text(value)),
  items: [
    for (final fruit in options)
      MultiSelectItem<String>(value: fruit, child: Text(fruit)),
  ],
);''',
      tokenClasses:
          'ppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppsssssssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkppkkkkkpppppppkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
    DocsSnippet(
      id: 'multi_select.1',
      componentId: 'multi_select',
      language: 'dart',
      code: r'''// Async + search: `builder` enables the search field.
MultiSelect<Country>(
  value: selected,
  onChanged: (value) => setState(() => selected = value),
  itemBuilder: (context, value) => MultiSelectChip<Country>(
    value: value,
    child: Text(value.name),
  ),
  searchPlaceholder: const Text('Search countries'),
  builder: (context, query) async => [
    for (final c in await repository.find(query))
      MultiSelectItem<Country>(value: c, child: Text(c.name)),
  ],
);''',
      tokenClasses:
          'ccccccccccccccccccccccccccccccccccccccccccccccccccccccppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppsssssssssssssssssspppppppppppppppppppppppppppppppkkkkkppppppppppkkkppkkkkkpppkkpkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
  ],
  'multiple_choice': <DocsSnippet>[
    DocsSnippet(
      id: 'multiple_choice.0',
      componentId: 'multiple_choice',
      language: 'dart',
      code: r'''String? selected = 'sm';

MultipleChoice<String>(
  value: selected,
  onChanged: (value) => setState(() => selected = value),
  child: Wrap(
    children: <Widget>[
      ChoiceButton(value: 'sm'), // any widget that calls Choice.choose
      ChoiceButton(value: 'md'),
    ],
  ),
);''',
      tokenClasses:
          'pppppppppppppppppppsssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssspppccccccccccccccccccccccccccccccccccccccpppppppppppppppppppppppppppssssppppppppppppppppp',
    ),
    DocsSnippet(
      id: 'multiple_choice.1',
      componentId: 'multiple_choice',
      language: 'dart',
      code: r'''Set<String> selected = <String>{'a'};

MultipleAnswer<String>(
  value: selected,
  onChanged: (values) => setState(() => selected = values!.toSet()),
  child: Wrap(children: items),
);''',
      tokenClasses:
          'ppppppppppppppppppppppppppppppppssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
    DocsSnippet(
      id: 'multiple_choice.2',
      componentId: 'multiple_choice',
      language: 'dart',
      code: r'''class ChoiceButton extends StatelessWidget {
  const ChoiceButton({super.key, required this.value});

  final String value;

  @override
  Widget build(BuildContext context) {
    final bool selected =
        Choice.getValue<String>(context)?.contains(value) ?? false;
    return GestureDetector(
      onTap: () => Choice.choose<String>(context, value),
      child: Text('$value${selected ? ' ✓' : ''}'),
    );
  }
}''',
      tokenClasses:
          'kkkkkppppppppppppppkkkkkkkpppppppppppppppppppppkkkkkpppppppppppppppkkkkkppppppkkkkkkkkpkkkkpppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppspppppppppppppppppppsssspppsspsppppppppppppppp',
    ),
  ],
  'object_input': <DocsSnippet>[
    DocsSnippet(
      id: 'object_input.0',
      componentId: 'object_input',
      language: 'dart',
      code: r'''DateInput(
  value: date,
  onChanged: (next) => setState(() => date = next),
);''',
      tokenClasses:
          'pppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
    DocsSnippet(
      id: 'object_input.1',
      componentId: 'object_input',
      language: 'dart',
      code:
          r'''// Force one presentation (default: popover on desktop widths, dialog below).
DateInput(
  value: date,
  onChanged: (next) => setState(() => date = next),
  mode: PromptMode.dialog,
);''',
      tokenClasses:
          'cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
    DocsSnippet(
      id: 'object_input.2',
      componentId: 'object_input',
      language: 'dart',
      code: r'''TimeInput(
  value: time,
  showSeconds: true,
  onChanged: (next) => setState(() => time = next),
);''',
      tokenClasses:
          'pppppppppppppppppppppppppppppppppppppppppkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
    DocsSnippet(
      id: 'object_input.3',
      componentId: 'object_input',
      language: 'dart',
      code: r'''DurationInput(
  initialValue: const Duration(minutes: 90),
  onChanged: (next) => submit(next),
);''',
      tokenClasses:
          'pppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
  ],
  'phone_input': <DocsSnippet>[
    DocsSnippet(
      id: 'phone_input.0',
      componentId: 'phone_input',
      language: 'bash',
      code: r'''flutter_shadcn add phone_input''',
      tokenClasses: 'kkkkkkkkkkkkkkpkkkpppppppppppp',
    ),
    DocsSnippet(
      id: 'phone_input.1',
      componentId: 'phone_input',
      language: 'dart',
      code:
          r'''import 'package:<your_app>/ui/shadcn/phone_input/phone_input.dart';''',
      tokenClasses:
          'kkkkkkpsssssssssssssssssssssssssssssssssssssssssssssssssssssssssssp',
    ),
    DocsSnippet(
      id: 'phone_input.2',
      componentId: 'phone_input',
      language: 'dart',
      code: r'''PhoneInput(
  initialCountry: const Country(dialCode: '+1', code: 'US'),
  onChanged: (value) => setState(() => _phone = value),
)''',
      tokenClasses:
          'ppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppssssppppppppsssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
    DocsSnippet(
      id: 'phone_input.3',
      componentId: 'phone_input',
      language: 'dart',
      code: r'''PhoneInput(
  initialValue: const PhoneNumber(
    Country(dialCode: '+62', code: 'ID'),
    '812345678',
  ),
  onChanged: (value) => setState(() => _phone = value),
)''',
      tokenClasses:
          'ppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppsssssppppppppsssspppppppssssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
    DocsSnippet(
      id: 'phone_input.4',
      componentId: 'phone_input',
      language: 'dart',
      code: r'''ShadcnFormField<PhoneNumber>(
  key: const FormKey<PhoneNumber>('phone'),
  label: const Text('Phone'),
  validator: const PhoneNumberValidator(),
  child: PhoneInput(onChanged: (value) => setState(() => _phone = value)),
)''',
      tokenClasses:
          'pppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppsssssssppppppppppppkkkkkppppppsssssssppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
    DocsSnippet(
      id: 'phone_input.5',
      componentId: 'phone_input',
      language: 'dart',
      code: r'''PhoneInput(
  countries: const <CountryInfo>[
    CountryInfo('GB', '+44', 'GBP', 'United Kingdom'),
    CountryInfo('IE', '+353', 'EUR', 'Ireland'),
  ],
  onChanged: (value) => setState(() => _phone = value),
)''',
      tokenClasses:
          'pppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppssssppsssssppsssssppsssssssssssssssspppppppppppppppppppssssppssssssppsssssppsssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
    DocsSnippet(
      id: 'phone_input.6',
      componentId: 'phone_input',
      language: 'dart',
      code:
          r'''// typing "+44555" selects the first +44 row of the list and reports
// PhoneNumber(Country(dialCode: '+44', code: 'GB'), '555')
PhoneInput(countries: const <CountryInfo>[
  CountryInfo('GB', '+44', 'GBP', 'United Kingdom'),
], onChanged: (value) => setState(() => _phone = value))''',
      tokenClasses:
          'ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppssssppsssssppsssssppssssssssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
  ],
  'radio_group': <DocsSnippet>[
    DocsSnippet(
      id: 'radio_group.0',
      componentId: 'radio_group',
      language: 'dart',
      code: r'''ShadcnRadioGroup<String>(
  value: plan,
  onChanged: (value) => setState(() => plan = value),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: const <Widget>[
      RadioItem<String>(value: 'free', label: Text('Free')),
      RadioItem<String>(value: 'pro', label: Text('Pro')),
    ],
  ),
);''',
      tokenClasses:
          'ppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppssssssppppppppppppppsssssspppppppppppppppppppppppppppppppppppsssssppppppppppppppssssspppppppppppppppppp',
    ),
    DocsSnippet(
      id: 'radio_group.1',
      componentId: 'radio_group',
      language: 'dart',
      code: r'''final controller = ShadcnRadioGroupController<String>('pro');
ShadcnRadioGroup<String>(controller: controller, child: items);
// controller.select('free');''',
      tokenClasses:
          'kkkkkpppppppppppppppppppppppppppppppppppppppppppppppppssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppccccccccccccccccccccccccccccc',
    ),
    DocsSnippet(
      id: 'radio_group.2',
      componentId: 'radio_group',
      language: 'dart',
      code: r'''ShadcnRadioGroup<String>(
  value: plan,
  onChanged: (value) => setState(() => plan = value),
  child: Column(children: <Widget>[
    RadioCard<String>(value: 'pro', child: const Text('Pro — $20/mo')),
  ]),
)''',
      tokenClasses:
          'ppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssspppppppppkkkkkppppppssssssspssssssppppppppppp',
    ),
  ],
  'select': <DocsSnippet>[
    DocsSnippet(
      id: 'select.0',
      componentId: 'select',
      language: 'dart',
      code: r'''String? fruit;

Select<String>(
  value: fruit,
  onChanged: (value) => setState(() => fruit = value),
  placeholder: const Text('Select a fruit'),
  itemBuilder: (context, value) => Text(value),
  items: [
    for (final f in fruits) SelectItem<String>(value: f, child: Text(f)),
  ],
);''',
      tokenClasses:
          'ppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppssssssssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkppkkkkkpppkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
    DocsSnippet(
      id: 'select.1',
      componentId: 'select',
      language: 'dart',
      code:
          r'''// Searchable, backed by an async source; search is enabled by `builder`.
Select<Country>(
  value: country,
  onChanged: (value) => setState(() => country = value),
  itemBuilder: (context, value) => Text(value.name),
  searchPlaceholder: const Text('Search countries'),
  builder: (context, query) async {
    final matches = await repository.find(query);
    return [
      for (final c in matches) SelectItem<Country>(value: c, child: Text(c.name)),
    ];
  },
);''',
      tokenClasses:
          'cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppsssssssssssssssssspppppppppppppppppppppppppppppppkkkkkpppppppkkkkkpppppppppppkkkkkpppppppppppppppppppppppppppppkkkkkkpppppppppkkkppkkkkkpppkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
  ],
  'slider': <DocsSnippet>[
    DocsSnippet(
      id: 'slider.0',
      componentId: 'slider',
      language: 'dart',
      code: r'''Slider(value: 0.4, onChanged: (v) => setState(() => v));
Slider(
  value: 2, min: 0, max: 4,
  snap: const SliderSnap.steps(4),
  variant: SliderVariant.dots,
  onChanged: (v) => setState(() => v),
);
Slider.range(
  value: const SliderValue.ranged(0.2, 0.7),
  minRange: 0.1,
  onRangeChanged: (v) => setState(() => v),
);''',
      tokenClasses:
          'pppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
  ],
  'star_rating': <DocsSnippet>[
    DocsSnippet(
      id: 'star_rating.0',
      componentId: 'star_rating',
      language: 'dart',
      code: r'''double rating = 0;

StarRating(
  value: rating,
  onChanged: (value) => setState(() => rating = value),
);''',
      tokenClasses:
          'ppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
    DocsSnippet(
      id: 'star_rating.1',
      componentId: 'star_rating',
      language: 'dart',
      code: r'''const StarRating(value: 3.5, step: 0.5);
const StarRating(
  value: 4,
  onChanged: onRating,
  theme: StarRatingStyle(size: 30, spacing: 8),
);''',
      tokenClasses:
          'kkkkkppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
    DocsSnippet(
      id: 'star_rating.2',
      componentId: 'star_rating',
      language: 'dart',
      code: r'''final StarRatingController controller = StarRatingController(2);

StarRating(controller: controller);''',
      tokenClasses:
          'kkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
  ],
  'switch': <DocsSnippet>[
    DocsSnippet(
      id: 'switch.0',
      componentId: 'switch',
      language: 'dart',
      code: r'''Switch(
  value: enabled,
  onChanged: (value) => setState(() => enabled = value),
  label: const Text('Airplane mode'),
);''',
      tokenClasses:
          'ppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppsssssssssssssssppppp',
    ),
    DocsSnippet(
      id: 'switch.1',
      componentId: 'switch',
      language: 'dart',
      code: r'''final controller = SwitchController();
Switch(controller: controller, label: const Text('Notifications'));
// controller.toggle();''',
      tokenClasses:
          'kkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppsssssssssssssssppppccccccccccccccccccccccc',
    ),
  ],
  'text_area': <DocsSnippet>[
    DocsSnippet(
      id: 'text_area.0',
      componentId: 'text_area',
      language: 'dart',
      code: r'''TextArea(initialValue: 'Hello, World!');''',
      tokenClasses: 'pppppppppppppppppppppppssssssssssssssspp',
    ),
    DocsSnippet(
      id: 'text_area.1',
      componentId: 'text_area',
      language: 'dart',
      code: r'''TextArea(
  placeholder: const Text('Type your message here...'),
  minLines: 6,
);''',
      tokenClasses:
          'pppppppppppppppppppppppppkkkkkppppppssssssssssssssssssssssssssspppppppppppppppppppp',
    ),
    DocsSnippet(
      id: 'text_area.2',
      componentId: 'text_area',
      language: 'dart',
      code:
          r'''TextArea(hintText: 'Paste a long paragraph', minLines: 2, maxLines: 8);''',
      tokenClasses:
          'pppppppppppppppppppsssssssssssssssssssssssspppppppppppppppppppppppppppp',
    ),
    DocsSnippet(
      id: 'text_area.3',
      componentId: 'text_area',
      language: 'dart',
      code: r'''TextArea(
  minLines: 4,
  validator: (value) => (value ?? '').length < 8 ? 'At least 8 characters' : null,
);''',
      tokenClasses:
          'pppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsspppppppppppppppssssssssssssssssssssssspppkkkkpppp',
    ),
    DocsSnippet(
      id: 'text_area.4',
      componentId: 'text_area',
      language: 'dart',
      code:
          r'''SizedBox(height: 240, child: TextArea(expands: true, maxLines: null, minLines: null));''',
      tokenClasses:
          'pppppppppppppppppppppppppppppppppppppppppppppppkkkkppppppppppppkkkkppppppppppppkkkkppp',
    ),
  ],
  'time_picker': <DocsSnippet>[
    DocsSnippet(
      id: 'time_picker.0',
      componentId: 'time_picker',
      language: 'dart',
      code: r'''TimePicker(
  value: selected,
  onChanged: (next) => setState(() => selected = next),
);''',
      tokenClasses:
          'ppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
    DocsSnippet(
      id: 'time_picker.1',
      componentId: 'time_picker',
      language: 'dart',
      code: r'''// 12-hour clock with seconds.
TimePicker(
  value: selected,
  onChanged: (next) => setState(() => selected = next),
  use24HourFormat: false,
  showSeconds: true,
);''',
      tokenClasses:
          'ccccccccccccccccccccccccccccccpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppkkkkpppp',
    ),
    DocsSnippet(
      id: 'time_picker.2',
      componentId: 'time_picker',
      language: 'dart',
      code: r'''DurationPicker(
  value: length,
  onChanged: (next) => setState(() => length = next),
);''',
      tokenClasses:
          'ppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
  ],
  'accordion': <DocsSnippet>[
    DocsSnippet(
      id: 'accordion.0',
      componentId: 'accordion',
      language: 'dart',
      code: r'''Accordion(
  items: <Widget>[
    AccordionItem(
      trigger: const AccordionTrigger(child: Text('Is it accessible?')),
      content: const Text('Yes.'),
    ),
    AccordionItem(
      trigger: const AccordionTrigger(child: Text('Is it styled?')),
      content: const Text('Yes.'),
      expanded: true, // starts open when no other item is
    ),
  ],
);''',
      tokenClasses:
          'ppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppssssssssssssssssssspppppppppppppppppppkkkkkppppppssssssppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppssssssssssssssspppppppppppppppppppkkkkkppppppsssssspppppppppppppppppppkkkkppccccccccccccccccccccccccccccccccccccppppppppppppppp',
    ),
  ],
  'alert': <DocsSnippet>[
    DocsSnippet(
      id: 'alert.0',
      componentId: 'alert',
      language: 'dart',
      code: r'''Alert(
  leading: const Icon(LucideIcons.info),
  title: const Text('Heads up'),
  content: const Text('You can add components from the registry.'),
);

Alert(
  variant: AlertVariant.destructive,
  title: const Text('Session expired'),
  content: const Text('Please log in again.'),
);''',
      tokenClasses:
          'ppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppkkkkkppppppssssssssssppppppppppppppkkkkkppppppsssssssssssssssssssssssssssssssssssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppsssssssssssssssssppppppppppppppkkkkkppppppssssssssssssssssssssssppppp',
    ),
    DocsSnippet(
      id: 'alert.1',
      componentId: 'alert',
      language: 'dart',
      code: r'''const AlertTheme alertThemeOverrides = AlertTheme(
  destructive: AlertStyle(titleColor: ThemedColor.ref(ColorRef.destructive)),
);''',
      tokenClasses:
          'kkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
  ],
  'app': <DocsSnippet>[
    DocsSnippet(
      id: 'app.0',
      componentId: 'app',
      language: 'dart',
      code: r'''void main() {
  runApp(
    ShadcnApp(
      title: 'My App',
      theme: lightTheme,          // ShadcnThemeData
      darkTheme: darkTheme,       // ShadcnThemeData
      componentThemes: appComponentThemes, // generated `component_themes.dart`
      home: const HomePage(),
    ),
  );
}''',
      tokenClasses:
          'kkkkppppppppppppppppppppppppppppppppppppppppppppppppssssssssppppppppppppppppppppppppppppppppppppccccccccccccccccccpppppppppppppppppppppppppppppppppppccccccccccccccccccppppppppppppppppppppppppppppppppppppppppppppccccccccccccccccccccccccccccccccccccpppppppppppppkkkkkpppppppppppppppppppppppppp',
    ),
  ],
  'card': <DocsSnippet>[
    DocsSnippet(
      id: 'card.0',
      componentId: 'card',
      language: 'dart',
      code: r'''Card(
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      const CardHeader(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            CardTitle(child: Text('Deployments')),
            Gap(4),
            CardDescription(child: Text('Ship a new build.')),
          ],
        ),
      ),
      const Gap(16),
      const CardContent(child: Text('Every deploy is immutable.')),
      const Gap(16),
      CardFooter(
        child: Button(onPressed: () {}, child: const Text('Deploy')),
      ),
    ],
  ),
);''',
      tokenClasses:
          'pppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssssssssssssspppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppkkkkkpppppppppppppppppppppppppssssssssssssssssssssssssssssppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppssssssssppppppppppppppppppppppppppp',
    ),
    DocsSnippet(
      id: 'card.1',
      componentId: 'card',
      language: 'dart',
      code: r'''const Card(child: Text('Body'));''',
      tokenClasses: 'kkkkkppppppppppppppppppssssssppp',
    ),
    DocsSnippet(
      id: 'card.2',
      componentId: 'card',
      language: 'dart',
      code: r'''Card(
  child: Clickable(onPressed: onTap, child: const Text('Open')),
);''',
      tokenClasses:
          'ppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppsssssspppppp',
    ),
  ],
  'card_image': <DocsSnippet>[
    DocsSnippet(
      id: 'card_image.0',
      componentId: 'card_image',
      language: 'dart',
      code: r'''CardImage(
  image: Image.network('https://picsum.photos/200/300', fit: BoxFit.cover),
  title: const Text('Sunset'),
  subtitle: const Text('18:42 · Lisbon'),
  onPressed: () => open(item),
);''',
      tokenClasses:
          'ppppppppppppppppppppppppppppppppppssssssssssssssssssssssssssssssspppppppppppppppppppppppppppppppkkkkkppppppsssssssspppppppppppppppkkkkkppppppsssssssssssssssspppppppppppppppppppppppppppppppppppp',
    ),
    DocsSnippet(
      id: 'card_image.1',
      componentId: 'card_image',
      language: 'dart',
      code: r'''CardImage(
  theme: const CardImageTheme(direction: Axis.horizontal),
  image: thumb,
  title: const Text('Track'),
  trailing: const Icon(LucideIcons.chevronRight, size: 16),
);''',
      tokenClasses:
          'ppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppssssssspppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppp',
    ),
    DocsSnippet(
      id: 'card_image.2',
      componentId: 'card_image',
      language: 'dart',
      code: r'''const CardImage(image: thumb, title: Text('Read only'));''',
      tokenClasses: 'kkkkkpppppppppppppppppppppppppppppppppppppsssssssssssppp',
    ),
  ],
  'collapsible': <DocsSnippet>[
    DocsSnippet(
      id: 'collapsible.0',
      componentId: 'collapsible',
      language: 'dart',
      code: r'''Collapsible(
  children: <Widget>[
    const CollapsibleTrigger(child: Text('Recent activity')),
    CollapsibleContent(child: activityList),
  ],
);''',
      tokenClasses:
          'pppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppssssssssssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
    DocsSnippet(
      id: 'collapsible.1',
      componentId: 'collapsible',
      language: 'dart',
      code: r'''Collapsible(
  isExpanded: open,
  onExpansionChanged: (value) => setState(() => open = value),
  children: children,
);''',
      tokenClasses:
          'pppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
  ],
  'filter_bar': <DocsSnippet>[
    DocsSnippet(
      id: 'filter_bar.0',
      componentId: 'filter_bar',
      language: 'bash',
      code: r'''flutter_shadcn add filter_bar''',
      tokenClasses: 'kkkkkkkkkkkkkkpkkkppppppppppp',
    ),
    DocsSnippet(
      id: 'filter_bar.1',
      componentId: 'filter_bar',
      language: 'dart',
      code:
          r'''import 'package:<your_app>/ui/shadcn/filter_bar/filter_bar.dart';''',
      tokenClasses:
          'kkkkkkpsssssssssssssssssssssssssssssssssssssssssssssssssssssssssp',
    ),
    DocsSnippet(
      id: 'filter_bar.2',
      componentId: 'filter_bar',
      language: 'dart',
      code: r'''FilterBar(
  state: _state,
  sortOptions: const <FilterSortOption>[
    FilterSortOption(id: 'newest', label: 'Newest'),
    FilterSortOption(id: 'oldest', label: 'Oldest'),
  ],
  resultsCount: 42,
  onStateChanged: (next) => setState(() => _state = next),
)''',
      tokenClasses:
          'pppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppsssssssspppppppppssssssssppppppppppppppppppppppppppppsssssssspppppppppsssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
    DocsSnippet(
      id: 'filter_bar.3',
      componentId: 'filter_bar',
      language: 'dart',
      code:
          r'''final controller = FilterBarController(const FilterState(sortId: 'newest'));

FilterBar(controller: controller, sortOptions: _sortOptions)''',
      tokenClasses:
          'kkkkkppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
    DocsSnippet(
      id: 'filter_bar.4',
      componentId: 'filter_bar',
      language: 'dart',
      code:
          r'''final statusField = FilterField<String>(id: 'status', matcher: FilterMatchers.exact());

FilterBar(
  state: _state,
  customFilters: <FilterCustomFilter>[
    FilterCustomFilter.typed<String>(
      field: statusField,
      builder: (context, value, onChanged) => Select<String>(
        value: value,
        canUnselect: true,
        placeholder: const Text('Status'),
        onChanged: onChanged,
        itemBuilder: (context, value) => Text(value),
        items: const <Widget>[
          SelectItem<String>(value: 'open', child: Text('Open')),
          SelectItem<String>(value: 'closed', child: Text('Closed')),
        ],
      ),
    ),
  ],
  onStateChanged: (next) => setState(() => _state = next),
)''',
      tokenClasses:
          'kkkkkpppppppppppppppppppppppppppppppppppppppsssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkpppppppppppppppppppppppkkkkkppppppssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppssssssppppppppppppppssssssppppppppppppppppppppppppppppppppppppppppssssssssppppppppppppppsssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
    DocsSnippet(
      id: 'filter_bar.5',
      componentId: 'filter_bar',
      language: 'dart',
      code: r'''final bindings = <FilterBinding<Order>>[
  TypedFilterBinding<Order, String>(field: emailField, selector: (o) => o.email),
];
final filtered = _state.whereMatches(orders, bindings);''',
      tokenClasses:
          'kkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
    DocsSnippet(
      id: 'filter_bar.6',
      componentId: 'filter_bar',
      language: 'dart',
      code: r'''FilterBar(
  state: _state,
  customFilters: _filters,
  groups: const <FilterGroup>[
    FilterGroup(id: 'catalog', title: 'Catalog', filterIds: <String>['category', 'brand']),
    FilterGroup(id: 'price', title: 'Pricing', filterIds: <String>['price', 'rating']),
  ],
  onStateChanged: (next) => setState(() => _state = next),
)''',
      tokenClasses:
          'pppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppssssssssspppppppppsssssssssppppppppppppppppppppppssssssssssppsssssssppppppppppppppppppppppppssssssspppppppppsssssssssppppppppppppppppppppppsssssssppssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
    DocsSnippet(
      id: 'filter_bar.7',
      componentId: 'filter_bar',
      language: 'dart',
      code: r'''FilterBar(
  state: _state,
  presentation: FilterBarPresentation.autoSheet,
  sheetBreakpoint: 720,
  enableDateRange: true,
  onStateChanged: (next) => setState(() => _state = next),
)''',
      tokenClasses:
          'ppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
  ],
  'group': <DocsSnippet>[
    DocsSnippet(
      id: 'group.0',
      componentId: 'group',
      language: 'dart',
      code: r'''SizedBox(
  width: 260,
  height: 160,
  child: Group(
    children: <Widget>[
      GroupPositioned(top: 12, left: 12, child: Text('top-left')),
      GroupPositioned(top: 12, right: 12, child: Text('top-right')),
      GroupPositioned.fromRect(
        rect: const Rect.fromLTWH(60, 60, 140, 48),
        child: Text('boxed'),
      ),
      GroupPositioned.fill(child: Text('fills the group')),
    ],
  ),
);''',
      tokenClasses:
          'ppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppssssssspppppppppppppppppppppppppppppppppppppppppppppppppppssssssssssssssssspppppppppppppppppp',
    ),
  ],
  'media_query': <DocsSnippet>[
    DocsSnippet(
      id: 'media_query.0',
      componentId: 'media_query',
      language: 'dart',
      code: r'''MediaQueryVisibility(
  minWidth: 768,
  alternateChild: const MobileNav(),
  child: const DesktopNav(),
)''',
      tokenClasses:
          'pppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppkkkkkpppppppppppppppp',
    ),
    DocsSnippet(
      id: 'media_query.1',
      componentId: 'media_query',
      language: 'dart',
      code:
          r'''const MediaQueryVisibilityTheme appBreakpoints = MediaQueryVisibilityTheme(
  minWidth: 640,
  maxWidth: 1280,
);''',
      tokenClasses:
          'kkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
  ],
  'outlined_container': <DocsSnippet>[
    DocsSnippet(
      id: 'outlined_container.0',
      componentId: 'outlined_container',
      language: 'dart',
      code: r'''OutlinedContainer(
  padding: const EdgeInsets.all(16),
  child: const Text('Card body'),
);''',
      tokenClasses:
          'ppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppkkkkkppppppsssssssssssppppp',
    ),
    DocsSnippet(
      id: 'outlined_container.1',
      componentId: 'outlined_container',
      language: 'dart',
      code: r'''OutlinedContainer(
  surfaceOpacity: 0.6,
  surfaceBlur: 12,
  child: const Text('Frosted'),
);''',
      tokenClasses:
          'ppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppsssssssssppppp',
    ),
    DocsSnippet(
      id: 'outlined_container.2',
      componentId: 'outlined_container',
      language: 'dart',
      code: r'''DashedContainer(
  child: Padding(padding: const EdgeInsets.all(16), child: content),
);
DashedLine();''',
      tokenClasses:
          'pppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
  ],
  'overflow_marquee': <DocsSnippet>[
    DocsSnippet(
      id: 'overflow_marquee.0',
      componentId: 'overflow_marquee',
      language: 'dart',
      code: r'''OverflowMarquee(
  duration: Duration(seconds: 8),
  delayDuration: Duration(seconds: 1),
  fadePortion: 0.15,
  child: Text('A very long ticker line ...'),
);

OverflowMarquee(
  direction: Axis.vertical,
  child: SizedBox(height: 96, child: Text('Vertical credits ...')),
);''',
      tokenClasses:
          'pppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssssssssssssssssssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssssssssssssssssssspppppp',
    ),
  ],
  'resizable': <DocsSnippet>[
    DocsSnippet(
      id: 'resizable.0',
      componentId: 'resizable',
      language: 'bash',
      code: r'''flutter_shadcn add resizable''',
      tokenClasses: 'kkkkkkkkkkkkkkpkkkpppppppppp',
    ),
    DocsSnippet(
      id: 'resizable.1',
      componentId: 'resizable',
      language: 'dart',
      code:
          r'''import 'package:<your_app>/ui/shadcn/resizable/resizable.dart';''',
      tokenClasses:
          'kkkkkkpsssssssssssssssssssssssssssssssssssssssssssssssssssssssp',
    ),
    DocsSnippet(
      id: 'resizable.2',
      componentId: 'resizable',
      language: 'dart',
      code: r'''SizedBox(
  width: 400,
  height: 240,
  child: ResizablePanelGroup(
    children: const [
      ResizablePanel(defaultSize: 140, child: Text('Sidebar')),
      ResizableHandle(withHandle: true),
      ResizablePanel(flex: 1, child: Text('Main')),
    ],
  ),
)''',
      tokenClasses:
          'pppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssssssppppppppppppppppppppppppppppppppppppppkkkkpppppppppppppppppppppppppppppppppppppppppppppssssssppppppppppppppppp',
    ),
  ],
  'scaffold': <DocsSnippet>[
    DocsSnippet(
      id: 'scaffold.0',
      componentId: 'scaffold',
      language: 'dart',
      code: r'''Scaffold(
  headers: [AppBar(title: const Text('Inbox'))],
  child: const MessageList(),
);''',
      tokenClasses:
          'ppppppppppppppppppppppppppppppppppppkkkkkppppppsssssssppppppppppppppkkkkkpppppppppppppppppp',
    ),
    DocsSnippet(
      id: 'scaffold.1',
      componentId: 'scaffold',
      language: 'dart',
      code: r'''Scaffold(
  headers: [AppBar(title: const Text('Sync'))],
  footers: [AppBar(subtitle: const Text('Last synced 09:41'))],
  loadingProgress: 0.4,
  showLoadingSparks: true,
  child: const Body(),
);''',
      tokenClasses:
          'ppppppppppppppppppppppppppppppppppppkkkkkppppppssssssppppppppppppppppppppppppppppppppppkkkkkppppppsssssssssssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppkkkkpppppppppppkkkkkppppppppppp',
    ),
    DocsSnippet(
      id: 'scaffold.2',
      componentId: 'scaffold',
      language: 'dart',
      code: r'''AppBar(
  leading: [Button(variant: ButtonVariant.ghost, onPressed: back, child: const Text('Back'))],
  title: const Text('Settings'),
  subtitle: const Text('Workspace'),
  trailing: [Button(onPressed: save, child: const Text('Save'))],
);''',
      tokenClasses:
          'pppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppssssssppppppppppppppkkkkkppppppsssssssssspppppppppppppppkkkkkppppppssssssssssspppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppssssssppppppp',
    ),
  ],
  'scrollable': <DocsSnippet>[
    DocsSnippet(
      id: 'scrollable.0',
      componentId: 'scrollable',
      language: 'dart',
      code: r'''FadedScrollableViewport(
  child: SingleChildScrollView(child: content),
);''',
      tokenClasses:
          'ppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
  ],
  'scrollable_client': <DocsSnippet>[
    DocsSnippet(
      id: 'scrollable_client.0',
      componentId: 'scrollable_client',
      language: 'dart',
      code: r'''ScrollableClient(
  builder: (context, offset, viewportSize, child) {
    return Transform.translate(
      offset: Offset(-offset.dx, -offset.dy),
      child: child,
    );
  },
  child: SizedBox(width: 640, height: 420, child: canvas),
);''',
      tokenClasses:
          'ppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
  ],
  'sortable': <DocsSnippet>[
    DocsSnippet(
      id: 'sortable.0',
      componentId: 'sortable',
      language: 'bash',
      code: r'''flutter_shadcn add sortable''',
      tokenClasses: 'kkkkkkkkkkkkkkpkkkppppppppp',
    ),
    DocsSnippet(
      id: 'sortable.1',
      componentId: 'sortable',
      language: 'dart',
      code:
          r'''import 'package:<your_app>/ui/shadcn/sortable/sortable.dart';''',
      tokenClasses:
          'kkkkkkpsssssssssssssssssssssssssssssssssssssssssssssssssssssp',
    ),
    DocsSnippet(
      id: 'sortable.2',
      componentId: 'sortable',
      language: 'dart',
      code: r'''SortableLayer(
  child: Column(
    children: [
      for (final item in items)
        Sortable<String>(
          key: ValueKey(item),
          data: SortableData(item),
          onAcceptTop: (data) => move(data.data, item, above: true),
          onAcceptBottom: (data) => move(data.data, item, above: false),
          child: Text(item),
        ),
    ],
  ),
)''',
      tokenClasses:
          'ppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkppkkkkkppppppkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
  ],
  'stage_container': <DocsSnippet>[
    DocsSnippet(
      id: 'stage_container.0',
      componentId: 'stage_container',
      language: 'dart',
      code: r'''StageContainer(
  builder: (context, padding) => Padding(
    padding: padding,
    child: const PageContent(),
  ),
)''',
      tokenClasses:
          'pppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppp',
    ),
    DocsSnippet(
      id: 'stage_container.1',
      componentId: 'stage_container',
      language: 'dart',
      code: r'''StageContainer(
  breakpoint: const ConstantBreakpoint(120),
  builder: (context, padding) => Padding(padding: padding, child: body),
)''',
      tokenClasses:
          'ppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
    DocsSnippet(
      id: 'stage_container.2',
      componentId: 'stage_container',
      language: 'dart',
      code: r'''StageContainer(
  breakpoint: const StagedBreakpoint([640, 1024, 1280]),
  builder: (context, padding) => Padding(padding: padding, child: body),
)''',
      tokenClasses:
          'ppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
  ],
  'steps': <DocsSnippet>[
    DocsSnippet(
      id: 'steps.0',
      componentId: 'steps',
      language: 'dart',
      code: r'''Steps(
  children: <Widget>[
    StepItem(title: const Text('Account'), content: const [Text('Email')]),
    StepItem(title: const Text('Profile'), content: const [Text('Name')]),
  ],
);''',
      tokenClasses:
          'pppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppsssssssssppppppppppppkkkkkpppppppssssssspppppppppppppppppppppppppkkkkkppppppsssssssssppppppppppppkkkkkpppppppsssssspppppppppppp',
    ),
    DocsSnippet(
      id: 'steps.1',
      componentId: 'steps',
      language: 'dart',
      code: r'''const Steps(
  theme: StepsTheme(
    indicatorColor: ThemedColor.ref(ColorRef.primary),
    indicatorForeground: ThemedColor.ref(ColorRef.primaryForeground),
  ),
  children: <Widget>[StepItem(title: Text('Done'), content: [])],
);''',
      tokenClasses:
          'kkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssspppppppppppppppppppp',
    ),
  ],
  'table': <DocsSnippet>[
    DocsSnippet(
      id: 'table.0',
      componentId: 'table',
      language: 'dart',
      code: r'''ShadcnTable(
  columnWidths: const {0: FlexTableSize(flex: 2), 2: FixedTableSize(90)},
  rows: <ShadcnTableRow>[
    const ShadcnTableHeader(cells: <ShadcnTableCell>[
      ShadcnTableCell(child: Text('Name')),
      ShadcnTableCell(child: Text('Role')),
      ShadcnTableCell(child: Text('Status')),
    ]),
    const ShadcnTableRow(cells: <ShadcnTableCell>[
      ShadcnTableCell(child: Text('Avery')),
      ShadcnTableCell(child: Text('Designer')),
      ShadcnTableCell(child: Text('Active')),
    ]),
  ],
);''',
      tokenClasses:
          'pppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssppppppppppppppppppppppppppppppppppppppssssssppppppppppppppppppppppppppppppppppppppssssssssppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssssppppppppppppppppppppppppppppppppppppppssssssssssppppppppppppppppppppppppppppppppppppppssssssssppppppppppppppppppp',
    ),
    DocsSnippet(
      id: 'table.1',
      componentId: 'table',
      language: 'dart',
      code: r'''ShadcnTableFooter(cells: <ShadcnTableCell>[
  ShadcnTableCell(columnSpan: 2, child: const Text('2 people')),
  const ShadcnTableCell(child: Text('—')),
]);''',
      tokenClasses:
          'ppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppssssssssssppppppkkkkkpppppppppppppppppppppppppppppsssppppppp',
    ),
    DocsSnippet(
      id: 'table.2',
      componentId: 'table',
      language: 'dart',
      code: r'''final controller = ResizableTableController(
  defaultColumnWidth: 120,
  defaultRowHeight: 40,
);
ShadcnTable(
  resizeController: controller,
  verticalController: scrollController,
  horizontalController: horizontalScrollController,
  rows: rows,
);''',
      tokenClasses:
          'kkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
    DocsSnippet(
      id: 'table.3',
      componentId: 'table',
      language: 'dart',
      code: r'''ShadcnTable(
  frozenCells: const FrozenTableData(frozenRows: <TableRef>[TableRef(0)]),
  verticalController: controller,
  rows: rows,
);''',
      tokenClasses:
          'ppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
  ],
  'timeline': <DocsSnippet>[
    DocsSnippet(
      id: 'timeline.0',
      componentId: 'timeline',
      language: 'dart',
      code: r'''Timeline(
  data: [
    TimelineData(
      time: Text('09:00'),
      title: Text('Kickoff'),
      content: Text('Project kickoff meeting.'),
    ),
    TimelineData(
      time: Text('11:00'),
      title: Text('Design review'),
      color: ThemedColor.value(Color(0xFFE7000B)),
    ),
  ],
);''',
      tokenClasses:
          'pppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssspppppppppppppppppppppssssssssspppppppppppppppppppppppsssssssssssssssssssssssssspppppppppppppppppppppppppppppppppppppppppppppssssssspppppppppppppppppppppssssssssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
  ],
  'window': <DocsSnippet>[
    DocsSnippet(
      id: 'window.0',
      componentId: 'window',
      language: 'dart',
      code:
          r'''final controller = WindowController(bounds: const Rect.fromLTWH(40, 40, 320, 220));

WindowNavigator(
  initialWindows: <Window>[
    Window(
      controller: controller,
      title: const Text('Notes'),
      content: const Text('Drag the title bar; resize from any edge.'),
    ),
  ],
);''',
      tokenClasses:
          'kkkkkpppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppsssssssppppppppppppppppppkkkkkppppppsssssssssssssssssssssssssssssssssssssssssssppppppppppppppppp',
    ),
  ],
  'breadcrumb': <DocsSnippet>[
    DocsSnippet(
      id: 'breadcrumb.0',
      componentId: 'breadcrumb',
      language: 'dart',
      code: r'''const Breadcrumb(
  children: <Widget>[Text('Home'), Text('Components'), Text('Breadcrumb')],
);''',
      tokenClasses:
          'kkkkkpppppppppppppppppppppppppppppppppppppppssssssppppppppssssssssssssppppppppsssssssssssspppppp',
    ),
    DocsSnippet(
      id: 'breadcrumb.1',
      componentId: 'breadcrumb',
      language: 'dart',
      code: r'''const Breadcrumb(
  separator: Breadcrumb.slashSeparator,
  theme: BreadcrumbTheme(spacing: 8),
  children: <Widget>[Text('src'), Text('components')],
);''',
      tokenClasses:
          'kkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssppppppppsssssssssssspppppp',
    ),
  ],
  'navigation_bar': <DocsSnippet>[
    DocsSnippet(
      id: 'navigation_bar.0',
      componentId: 'navigation_bar',
      language: 'dart',
      code: r'''NavigationBar(
  index: selected,
  onSelected: (index) => setState(() => selected = index),
  labelType: NavigationLabelType.selected,
  children: <NavigationBarItem>[
    NavigationItem(child: Icon(RadixIcons.home), label: Text('Home')),
    NavigationItem(child: Icon(RadixIcons.gear), label: Text('Settings')),
    NavigationItem(child: Icon(RadixIcons.exit), onPressed: _logOut),
  ],
)''',
      tokenClasses:
          'ppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
  ],
  'navigation_menu': <DocsSnippet>[
    DocsSnippet(
      id: 'navigation_menu.0',
      componentId: 'navigation_menu',
      language: 'dart',
      code: r'''NavigationMenu(
  children: [
    NavigationMenuItem(onPressed: goHome, child: const Text('Home')),
    NavigationMenuItem(
      content: const NavigationMenuContentList(
        children: [
          NavigationMenuContent(title: Text('Web Apps')),
          NavigationMenuContent(title: Text('Mobile Apps')),
        ],
      ),
      child: const Text('Products'),
    ),
  ],
);''',
      tokenClasses:
          'pppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppsssssspppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssssppppppppppppppppppppppppppppppppppppppppppppppppssssssssssssspppppppppppppppppppppppppppppppppppppkkkkkppppppssssssssssppppppppppppppppp',
    ),
    DocsSnippet(
      id: 'navigation_menu.1',
      componentId: 'navigation_menu',
      language: 'dart',
      code: r'''NavigationMenuContent(
  leading: const Icon(LucideIcons.layoutDashboard, size: 16),
  title: const Text('Dashboard'),
  content: const Text('Analytics and insights'),
  onPressed: openDashboard,
);''',
      tokenClasses:
          'ppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppsssssssssssppppppppppppppkkkkkppppppssssssssssssssssssssssssppppppppppppppppppppppppppppppppp',
    ),
  ],
  'page_route': <DocsSnippet>[
    DocsSnippet(
      id: 'page_route.0',
      componentId: 'page_route',
      language: 'dart',
      code: r'''Navigator.of(context).push(
  ShadcnPageRoute(builder: (context) => const SettingsPage()),
);''',
      tokenClasses:
          'ppppppppppkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppp',
    ),
    DocsSnippet(
      id: 'page_route.1',
      componentId: 'page_route',
      language: 'dart',
      code: r'''ShadcnPage(
  key: const ValueKey('settings'),
  child: const SettingsPage(),
)''',
      tokenClasses:
          'pppppppppppppppppppkkkkkppppppppppssssssssssppppppppppppkkkkkpppppppppppppppppp',
    ),
  ],
  'pagination': <DocsSnippet>[
    DocsSnippet(
      id: 'pagination.0',
      componentId: 'pagination',
      language: 'dart',
      code: r'''Pagination(
  page: current,
  totalPages: 20,
  onPageChanged: (page) => setState(() => current = page),
);''',
      tokenClasses:
          'pppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
    DocsSnippet(
      id: 'pagination.1',
      componentId: 'pagination',
      language: 'dart',
      code: r'''const Pagination(
  page: 5,
  totalPages: 40,
  maxPages: 5,
  showLabel: false,
  onPageChanged: _noop,
);''',
      tokenClasses:
          'kkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppp',
    ),
  ],
  'stepper': <DocsSnippet>[
    DocsSnippet(
      id: 'stepper.0',
      componentId: 'stepper',
      language: 'dart',
      code: r'''final StepperController controller = StepperController();
Stepper(
  controller: controller,
  steps: <StepperStep>[
    StepperStep(title: Text('Account'), content: Text('Email, password')),
    StepperStep(title: Text('Payment'), content: Text('Card, invoice')),
  ],
);
Button(onPressed: controller.next, child: Text('Next'));''',
      tokenClasses:
          'kkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssspppppppppppppppppsssssssssssssssssppppppppppppppppppppppppppppppppssssssssspppppppppppppppppssssssssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssppp',
    ),
    DocsSnippet(
      id: 'stepper.1',
      componentId: 'stepper',
      language: 'dart',
      code: r'''Stepper(
  currentStep: index,
  onStepChanged: (int next) => setState(() => index = next),
  direction: Axis.vertical,
  steps: steps,
);''',
      tokenClasses:
          'pppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
    DocsSnippet(
      id: 'stepper.2',
      componentId: 'stepper',
      language: 'dart',
      code:
          r'''controller.setStepState(1, StepperStepState.failed); // destructive ring + connectors
controller.setStepState(1, null); // cleared''',
      tokenClasses:
          'pppppppppppppppppppppppppppppppppppppppppppppppppppppccccccccccccccccccccccccccccccccppppppppppppppppppppppppppppkkkkpppcccccccccc',
    ),
  ],
  'switcher': <DocsSnippet>[
    DocsSnippet(
      id: 'switcher.0',
      componentId: 'switcher',
      language: 'dart',
      code: r'''Switcher(
  index: currentIndex,
  direction: AxisDirection.right,
  onIndexChanged: (int index) => setState(() => currentIndex = index),
  children: pages,
)''',
      tokenClasses:
          'pppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
    DocsSnippet(
      id: 'switcher.1',
      componentId: 'switcher',
      language: 'dart',
      code:
          r'''KeyedSubtree(key: ValueKey(pages.length), child: Switcher(...))''',
      tokenClasses:
          'ppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
  ],
  'tabs': <DocsSnippet>[
    DocsSnippet(
      id: 'tabs.0',
      componentId: 'tabs',
      language: 'dart',
      code: r'''Tabs(
  index: index,
  onChanged: (i) => setState(() => index = i),
  children: const [
    TabItem(child: Text('Account')),
    TabItem(child: Text('Password')),
  ],
);''',
      tokenClasses:
          'pppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppsssssssssppppppppppppppppppppppppppppssssssssssppppppppppp',
    ),
    DocsSnippet(
      id: 'tabs.1',
      componentId: 'tabs',
      language: 'dart',
      code: r'''TabPane<String>(
  items: tabs,
  focused: focused,
  onFocused: (i) => setState(() => focused = i),
  onSort: (next) => setState(() => tabs = next),
  itemBuilder: (context, item, i) => Text(item.data),
  child: Editor(document: docs[focused]),
);''',
      tokenClasses:
          'pppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
  ],
  'alert_dialog': <DocsSnippet>[
    DocsSnippet(
      id: 'alert_dialog.0',
      componentId: 'alert_dialog',
      language: 'dart',
      code: r'''final confirmed = await showAlertDialog<bool>(
  context: context,
  icon: const Icon(LucideIcons.triangleAlert),
  title: const Text('Delete this project?'),
  description: const Text('This cannot be undone.'),
  actions: <Widget>[
    Button(
      variant: ButtonVariant.outline,
      onPressed: () => Navigator.pop(context, false),
      child: const Text('Cancel'),
    ),
    Button(
      variant: ButtonVariant.destructive,
      onPressed: () => Navigator.pop(context, true),
      child: const Text('Delete'),
    ),
  ],
);''',
      tokenClasses:
          'kkkkkpppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppkkkkkppppppssssssssssssssssssssssppppppppppppppppppkkkkkppppppssssssssssssssssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppkkkkkppppppssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkppppppppppppppppkkkkkppppppssssssssppppppppppppppppp',
    ),
    DocsSnippet(
      id: 'alert_dialog.1',
      componentId: 'alert_dialog',
      language: 'dart',
      code: r'''const AlertDialog(
  title: Text('Heads up'),
  description: Text('Your session expires in five minutes.'),
);''',
      tokenClasses:
          'kkkkkppppppppppppppppppppppppppppsssssssssspppppppppppppppppppppppsssssssssssssssssssssssssssssssssssssssppppp',
    ),
  ],
  'anchor': <DocsSnippet>[
    DocsSnippet(
      id: 'anchor.0',
      componentId: 'anchor',
      language: 'dart',
      code: r'''OverlayAnchor(
  anchor: 'user-menu',
  child: AvatarButton(onPressed: openMenu),
)''',
      tokenClasses:
          'pppppppppppppppppppppppppsssssssssssppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
    DocsSnippet(
      id: 'anchor.1',
      componentId: 'anchor',
      language: 'dart',
      code: r'''const LinkedAnchor anchor = LinkedAnchor('user-menu');

final AnchorSubscription subscription = anchor.resolve(context).subscribe();
addListener(repaintOverlay);
renderObject.addPrePaintCallback((_) => subscription.notify());''',
      tokenClasses:
          'kkkkkppppppppppppppppppppppppppppppppppppsssssssssssppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
    DocsSnippet(
      id: 'anchor.2',
      componentId: 'anchor',
      language: 'dart',
      code: r'''OverlayAnchorScope(child: settingsScreen)''',
      tokenClasses: 'ppppppppppppppppppppppppppppppppppppppppp',
    ),
    DocsSnippet(
      id: 'anchor.3',
      componentId: 'anchor',
      language: 'dart',
      code: r'''showOverlay(anchor: const ContextAnchor(buttonContext));''',
      tokenClasses: 'ppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppp',
    ),
  ],
  'backdrop_transform': <DocsSnippet>[
    DocsSnippet(
      id: 'backdrop_transform.0',
      componentId: 'backdrop_transform',
      language: 'dart',
      code: r'''const BackdropTransform transform = ScaleBackdropTransform();

AnimatedBuilder(
  animation: controller,
  builder: (context, _) => transform.wrapBackdrop(context, appContent, value),
)''',
      tokenClasses:
          'kkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
    DocsSnippet(
      id: 'backdrop_transform.1',
      componentId: 'backdrop_transform',
      language: 'dart',
      code:
          r'''final Size freed = transform.resolveExtraSize(viewportSize, value);''',
      tokenClasses:
          'kkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
  ],
  'context_menu': <DocsSnippet>[
    DocsSnippet(
      id: 'context_menu.0',
      componentId: 'context_menu',
      language: 'dart',
      code: r'''ContextMenu(
  items: [
    MenuButton(child: Text('Copy link'), onPressed: (_) {}),
    MenuSeparator(),
    MenuButton(child: Text('Reload'), onPressed: (_) {}),
  ],
  child: Card(child: Text('Right-click me')),
);''',
      tokenClasses:
          'pppppppppppppppppppppppppppppppppppppppppppppppppppssssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssssssssssssspppppp',
    ),
    DocsSnippet(
      id: 'context_menu.1',
      componentId: 'context_menu',
      language: 'dart',
      code:
          r'''// Explicit position (e.g. from a custom gesture or a canvas hit):
await showShadcnContextMenu<void>(
  context: context,
  position: pointerPosition,
  children: [MenuButton(child: Text('Inspect'), onPressed: (_) {})],
);''',
      tokenClasses:
          'ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpkkkkkpppppppppppppppppppppppkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssspppppppppppppppppppppppppp',
    ),
  ],
  'dialog': <DocsSnippet>[
    DocsSnippet(
      id: 'dialog.0',
      componentId: 'dialog',
      language: 'dart',
      code: r'''await showShadcnDialog<void>(
  context: context,
  builder: (context) => const Text('Hello dialog'),
);''',
      tokenClasses:
          'kkkkkppppppppppppppppppkkkkpppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppssssssssssssssppppp',
    ),
    DocsSnippet(
      id: 'dialog.1',
      componentId: 'dialog',
      language: 'dart',
      code: r'''final confirmed = await showShadcnDialog<bool>(
  context: context,
  builder: (context) => Column(
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      const Text('Delete this project?'),
      MyConfirmButton(onPressed: () => Navigator.pop(context, true)),
      MyCancelButton(onPressed: () => Navigator.pop(context, false)),
    ],
  ),
);''',
      tokenClasses:
          'kkkkkpppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppsssssssssssssssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppp',
    ),
    DocsSnippet(
      id: 'dialog.2',
      componentId: 'dialog',
      language: 'dart',
      code: r'''await showShadcnDialog<void>(
  context: context,
  fullScreen: true,
  theme: const DialogTheme(maxWidth: 640, shadows: <BoxShadow>[]),
  builder: (context) => const SettingsPanel(),
);''',
      tokenClasses:
          'kkkkkppppppppppppppppppkkkkpppppppppppppppppppppppppppppppppppppkkkkpppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppp',
    ),
  ],
  'drawer': <DocsSnippet>[
    DocsSnippet(
      id: 'drawer.0',
      componentId: 'drawer',
      language: 'dart',
      code: r'''await openDrawer<void>(
  context: context,
  position: OverlayPosition.end,
  builder: (context) => DrawerContent(),
);''',
      tokenClasses:
          'kkkkkppppppppppppkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
    DocsSnippet(
      id: 'drawer.1',
      componentId: 'drawer',
      language: 'dart',
      code: r'''openSheet<void>(
  context: context,
  draggable: true,
  maxSize: 240,
  builder: (context) => SheetContent(),
);''',
      tokenClasses:
          'ppppppppppkkkkppppppppppppppppppppppppppppppppppppkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
    DocsSnippet(
      id: 'drawer.2',
      componentId: 'drawer',
      language: 'dart',
      code: r'''closeDrawer(context, 'result');''',
      tokenClasses: 'pppppppppppppppppppppsssssssspp',
    ),
  ],
  'drawer_container': <DocsSnippet>[
    DocsSnippet(
      id: 'drawer_container.0',
      componentId: 'drawer_container',
      language: 'bash',
      code: r'''flutter_shadcn add drawer_container''',
      tokenClasses: 'kkkkkkkkkkkkkkpkkkppppppppppppppppp',
    ),
    DocsSnippet(
      id: 'drawer_container.1',
      componentId: 'drawer_container',
      language: 'dart',
      code:
          r'''import 'package:<your_app>/ui/shadcn/drawer_container/drawer_container.dart';''',
      tokenClasses:
          'kkkkkkpsssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssp',
    ),
    DocsSnippet(
      id: 'drawer_container.2',
      componentId: 'drawer_container',
      language: 'dart',
      code: r'''Data<DrawerContainerData>.inherit(
  data: const DrawerContainerData(
    position: OverlayPosition.bottom,
    isSheet: true,
  ),
  child: const DrawerContainer(child: Text('Sheet content')),
);''',
      tokenClasses:
          'pppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkppppppppppppppppkkkkkpppppppppppppppppppppppppppppssssssssssssssspppppp',
    ),
  ],
  'dropdown_menu': <DocsSnippet>[
    DocsSnippet(
      id: 'dropdown_menu.0',
      componentId: 'dropdown_menu',
      language: 'dart',
      code: r'''// Imperative: anchored to the tapped widget.
await showShadcnDropdown<void>(
  context: context,
  children: [
    MenuButton(child: Text('Profile'), onPressed: (_) {}),
    MenuSeparator(),
    MenuButton(child: Text('Sign out'), onPressed: (_) {}),
  ],
);''',
      tokenClasses:
          'cccccccccccccccccccccccccccccccccccccccccccccpkkkkkppppppppppppppppppppkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssssssspppppppppppppppppppppppppppppp',
    ),
    DocsSnippet(
      id: 'dropdown_menu.1',
      componentId: 'dropdown_menu',
      language: 'dart',
      code: r'''// Standalone surface (own overlay plumbing):
DropdownMenu(
  children: [MenuButton(child: Text('Profile'), onPressed: (_) {})],
);''',
      tokenClasses:
          'cccccccccccccccccccccccccccccccccccccccccccccpppppppppppppppppppppppppppppppppppppppppppppppppppssssssssspppppppppppppppppppppppppp',
    ),
  ],
  'eye_dropper': <DocsSnippet>[
    DocsSnippet(
      id: 'eye_dropper.0',
      componentId: 'eye_dropper',
      language: 'dart',
      code: r'''EyeDropperLayer(child: MyApp());

final Color? color = await pickColorFromScreen(context);''',
      tokenClasses:
          'ppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppkkkkkpppppppppppppppppppppppppppppp',
    ),
    DocsSnippet(
      id: 'eye_dropper.1',
      componentId: 'eye_dropper',
      language: 'dart',
      code:
          r'''final color = await pickColorFromScreen(context, ColorHistoryStorage.of(context));''',
      tokenClasses:
          'kkkkkpppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppkkppppppppppp',
    ),
  ],
  'gooey_toast': <DocsSnippet>[
    DocsSnippet(
      id: 'gooey_toast.0',
      componentId: 'gooey_toast',
      language: 'dart',
      code: r'''ShadcnTheme(
  data: theme,
  child: GooeyToastLayer(child: myApp),
);''',
      tokenClasses:
          'pppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
    DocsSnippet(
      id: 'gooey_toast.1',
      componentId: 'gooey_toast',
      language: 'dart',
      code: r'''showGooeyToast(
  context,
  const GooeyToastOptions(
    title: 'Saved',
    description: 'Your changes are on the server.',
    state: GooeyToastState.success,
    position: GooeyToastPosition.left,
  ),
);''',
      tokenClasses:
          'pppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppssssssspppppppppppppppppppssssssssssssssssssssssssssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
    DocsSnippet(
      id: 'gooey_toast.2',
      componentId: 'gooey_toast',
      language: 'dart',
      code: r'''final controller = GooeyToastController();
GooeyToastLayer(controller: controller, child: myApp);
controller.showGooeyToast(
  const GooeyToastOptions(title: 'Deployed', state: GooeyToastState.info),
  behavior: GooeyToastNewToastBehavior.transition,
);''',
      tokenClasses:
          'kkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
  ],
  'hover_card': <DocsSnippet>[
    DocsSnippet(
      id: 'hover_card.0',
      componentId: 'hover_card',
      language: 'dart',
      code: r'''HoverCard(
  hoverBuilder: (context) => Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('@shadcn'),
      Text('Beautifully designed components.'),
    ],
  ),
  child: Text('@shadcn'),
);''',
      tokenClasses:
          'pppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssssssppppppppppppppsssssssssssssssssssssssssssssssssspppppppppppppppppppppppppppppsssssssssppppp',
    ),
    DocsSnippet(
      id: 'hover_card.1',
      componentId: 'hover_card',
      language: 'dart',
      code: r'''// Instant card.
HoverCard(
  wait: Duration.zero,
  hoverBuilder: (context) => Text('Details'),
  child: Icon(LucideIcons.info),
);''',
      tokenClasses:
          'ccccccccccccccccpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssspppppppppppppppppppppppppppppppppppppp',
    ),
  ],
  'menu': <DocsSnippet>[
    DocsSnippet(
      id: 'menu.0',
      componentId: 'menu',
      language: 'dart',
      code: r'''// A popup menu anchored to a button (needs an Overlay above).
await showShadcnMenu<void>(
  context: context,
  children: [
    MenuButton(child: Text('Cut'), onPressed: (_) {}),
    MenuButton(
      trailing: MenuShortcut(shortcut: '⌘C'),
      child: Text('Copy'),
      onPressed: (_) {},
    ),
    MenuSeparator(),
    MenuSub(
      trigger: Text('Share'),
      children: [
        MenuButton(child: Text('Email'), onPressed: (_) {}),
        MenuButton(child: Text('Link'), onPressed: (_) {}),
      ],
    ),
  ],
);''',
      tokenClasses:
          'ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccpkkkkkppppppppppppppppkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssspppppppppppppppppppppsssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssssppppppppppppppppppppppppppppppppppppppppppppppppppppsssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssspppppppppppppppppppppppppppppppppppppppppppppp',
    ),
    DocsSnippet(
      id: 'menu.1',
      componentId: 'menu',
      language: 'dart',
      code: r'''// Checkbox and radio rows.
MenuCheckboxItem(
  value: checked,
  onChanged: (context, next) => setState(() => checked = next),
  child: Text('Show toolbar'),
);
MenuRadioGroup<String>(
  value: picked,
  onChanged: (context, next) => setState(() => picked = next),
  child: Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      MenuRadioItem(value: 'a', child: Text('Option A')),
      MenuRadioItem(value: 'b', child: Text('Option B')),
    ],
  ),
);''',
      tokenClasses:
          'cccccccccccccccccccccccccccpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssppppppppppppppsssssssssspppppppppppppppppppppppppppppppsssppppppppppppppsssssssssspppppppppppppppppp',
    ),
  ],
  'menubar': <DocsSnippet>[
    DocsSnippet(
      id: 'menubar.0',
      componentId: 'menubar',
      language: 'dart',
      code: r'''Menubar(
  children: [
    MenuButton(
      child: Text('File'),
      subMenu: [
        MenuButton(child: Text('New'), onPressed: (_) {}),
        MenuButton(child: Text('Open'), onPressed: (_) {}),
      ],
    ),
  ],
);''',
      tokenClasses:
          'pppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssspppppppppppppppppppppppppppppppppppppppppppppppppppsssssppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssspppppppppppppppppppppppppppppppppppppppppppppp',
    ),
    DocsSnippet(
      id: 'menubar.1',
      componentId: 'menubar',
      language: 'dart',
      code: r'''// Borderless bar; submenus stay below the bar.
Menubar(
  border: false,
  popoverOffset: const Offset(0, 4),
  children: [...],
);''',
      tokenClasses:
          'cccccccccccccccccccccccccccccccccccccccccccccccppppppppppppppppppppkkkkkpppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppp',
    ),
  ],
  'overlay_configuration': <DocsSnippet>[
    DocsSnippet(
      id: 'overlay_configuration.0',
      componentId: 'overlay_configuration',
      language: 'bash',
      code: r'''flutter_shadcn add overlay_configuration''',
      tokenClasses: 'kkkkkkkkkkkkkkpkkkpppppppppppppppppppppp',
    ),
    DocsSnippet(
      id: 'overlay_configuration.1',
      componentId: 'overlay_configuration',
      language: 'dart',
      code:
          r'''import 'package:<your_app>/ui/shadcn/overlay_configuration/overlay_configuration.dart';''',
      tokenClasses:
          'kkkkkkpsssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssp',
    ),
    DocsSnippet(
      id: 'overlay_configuration.2',
      componentId: 'overlay_configuration',
      language: 'dart',
      code: r'''showOverlay<void>(
  context,
  const PopoverConfiguration(alignment: Alignment.bottomCenter),
  builder: (context) => const Text('Popover'),
);''',
      tokenClasses:
          'ppppppppppppkkkkppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppsssssssssppppp',
    ),
  ],
  'popup': <DocsSnippet>[
    DocsSnippet(
      id: 'popup.0',
      componentId: 'popup',
      language: 'dart',
      code: r'''await showShadcnPopup<void>(
  context: context,
  builder: (context) => Padding(
    padding: const EdgeInsets.all(8),
    child: Text('Signed in as ibrar@example.com'),
  ),
);''',
      tokenClasses:
          'kkkkkpppppppppppppppppkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppsssssssssssssssssssssssssssssssspppppppppp',
    ),
    DocsSnippet(
      id: 'popup.1',
      componentId: 'popup',
      language: 'dart',
      code: r'''// Standalone surface (own overlay plumbing):
MenuPopup(children: [Text('Content')]);''',
      tokenClasses:
          'cccccccccccccccccccccccccccccccccccccccccccccpppppppppppppppppppppppppppssssssssspppp',
    ),
  ],
  'refresh_trigger': <DocsSnippet>[
    DocsSnippet(
      id: 'refresh_trigger.0',
      componentId: 'refresh_trigger',
      language: 'dart',
      code: r'''RefreshTrigger(
  onRefresh: () async => reload(),
  child: ListView(children: rows),
);''',
      tokenClasses:
          'ppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
    DocsSnippet(
      id: 'refresh_trigger.1',
      componentId: 'refresh_trigger',
      language: 'dart',
      code: r'''RefreshTrigger(
  minExtent: 60,
  maxExtent: 120,
  completeDuration: const Duration(milliseconds: 800),
  indicatorBuilder: (context, stage) => MyIndicator(stage: stage),
  onRefresh: () async => reload(),
  child: ListView(children: rows),
);''',
      tokenClasses:
          'pppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
    DocsSnippet(
      id: 'refresh_trigger.2',
      componentId: 'refresh_trigger',
      language: 'dart',
      code: r'''final key = GlobalKey<RefreshTriggerState>();
RefreshTrigger(key: key, onRefresh: reload, child: list);
// later:
await key.currentState!.refresh();''',
      tokenClasses:
          'kkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppcccccccccpkkkkkppppppppppppppppppppppppppppp',
    ),
  ],
  'spell_check_suggestions_toolbar': <DocsSnippet>[
    DocsSnippet(
      id: 'spell_check_suggestions_toolbar.0',
      componentId: 'spell_check_suggestions_toolbar',
      language: 'dart',
      code: r'''// Inside an editable text toolbar builder:
SpellCheckSuggestionsToolbar.editableText(editableTextState: state);''',
      tokenClasses:
          'cccccccccccccccccccccccccccccccccccccccccccppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
    DocsSnippet(
      id: 'spell_check_suggestions_toolbar.1',
      componentId: 'spell_check_suggestions_toolbar',
      language: 'dart',
      code: r'''// Explicit items (the same shape EditableText hands over):
SpellCheckSuggestionsToolbar(
  anchors: state.contextMenuAnchors,
  buttonItems: SpellCheckSuggestionsToolbar.buildButtonItems(state),
);''',
      tokenClasses:
          'cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
  ],
  'swiper': <DocsSnippet>[
    DocsSnippet(
      id: 'swiper.0',
      componentId: 'swiper',
      language: 'dart',
      code: r'''Swiper(
  position: OverlayPosition.left,
  builder: (context) => const DrawerContent(),
  child: const PageBody(),
)''',
      tokenClasses:
          'ppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppkkkkkpppppppppppppp',
    ),
    DocsSnippet(
      id: 'swiper.1',
      componentId: 'swiper',
      language: 'dart',
      code: r'''Swiper(
  position: OverlayPosition.bottom,
  variant: SwiperVariant.sheet,
  builder: (context) => const SheetContent(),
  child: const PageBody(),
)''',
      tokenClasses:
          'ppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppkkkkkpppppppppppppp',
    ),
    DocsSnippet(
      id: 'swiper.2',
      componentId: 'swiper',
      language: 'dart',
      code: r'''final controller = SwiperController();

Swiper(
  controller: controller,
  position: OverlayPosition.end,
  builder: (context) => const DrawerContent(),
  child: PageBody(onMenu: controller.open),
)''',
      tokenClasses:
          'kkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
  ],
  'toast': <DocsSnippet>[
    DocsSnippet(
      id: 'toast.0',
      componentId: 'toast',
      language: 'dart',
      code: r'''ShadcnTheme(
  data: theme,
  child: ToastLayer(child: myApp),
);''',
      tokenClasses:
          'ppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
    DocsSnippet(
      id: 'toast.1',
      componentId: 'toast',
      language: 'dart',
      code:
          r'''showToast(context, builder: (context) => const Text('Saved'));''',
      tokenClasses:
          'pppppppppppppppppppppppppppppppppppppppppkkkkkppppppsssssssppp',
    ),
    DocsSnippet(
      id: 'toast.2',
      componentId: 'toast',
      language: 'dart',
      code: r'''final controller = ToastController();
ToastLayer(controller: controller, child: myApp);
controller.showToast(
  placement: ToastPlacement.topCenter,
  builder: (context) => const Text('Deployed'),
);''',
      tokenClasses:
          'kkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppssssssssssppppp',
    ),
  ],
  'tooltip': <DocsSnippet>[
    DocsSnippet(
      id: 'tooltip.0',
      componentId: 'tooltip',
      language: 'dart',
      code: r'''Tooltip(
  child: Icon(LucideIcons.info, size: 16),
  tooltip: (context) => TooltipContainer(child: const Text('Details')),
);''',
      tokenClasses:
          'ppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppssssssssspppppp',
    ),
    DocsSnippet(
      id: 'tooltip.1',
      componentId: 'tooltip',
      language: 'dart',
      code: r'''Tooltip(
  waitDuration: Duration.zero,
  child: anchor,
  tooltip: (context) => TooltipContainer(child: const Text('Now')),
);''',
      tokenClasses:
          'pppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppssssspppppp',
    ),
    DocsSnippet(
      id: 'tooltip.2',
      componentId: 'tooltip',
      language: 'dart',
      code: r'''const TooltipContainer(child: Text('Label'));''',
      tokenClasses: 'kkkkkppppppppppppppppppppppppppppppsssssssppp',
    ),
    DocsSnippet(
      id: 'tooltip.3',
      componentId: 'tooltip',
      language: 'dart',
      code: r'''TooltipContainer(
  theme: const TooltipTheme(
    background: ThemedColor.ref(ColorRef.accent),
    foreground: ThemedColor.ref(ColorRef.accentForeground),
  ),
  child: const Text('Accent'),
);''',
      tokenClasses:
          'pppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppssssssssppppp',
    ),
  ],
  'alpha': <DocsSnippet>[
    DocsSnippet(
      id: 'alpha.0',
      componentId: 'alpha',
      language: 'dart',
      code: r'''CustomPaint(
  painter: AlphaPainter(),
  size: const Size(220, 48),
)''',
      tokenClasses:
          'ppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppp',
    ),
  ],
  'async': <DocsSnippet>[
    DocsSnippet(
      id: 'async.0',
      componentId: 'async',
      language: 'dart',
      code: r'''import 'package:my_app/ui/shadcn/async/async.dart';

FutureOrBuilder<User>(
  future: repository.load(id),
  initialData: repository.cached(id),
  builder: (context, snapshot) => switch (snapshot.connectionState) {
    ConnectionState.waiting || ConnectionState.none => const SizedBox(),
    _ => Text(snapshot.data?.name ?? 'Unknown'),
  },
)''',
      tokenClasses:
          'kkkkkkpssssssssssssssssssssssssssssssssssssssssssspppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppsssssssssppppppppp',
    ),
  ],
  'color': <DocsSnippet>[
    DocsSnippet(
      id: 'color.0',
      componentId: 'color',
      language: 'dart',
      code:
          r'''final derivative = ColorDerivative.fromColor(const Color(0xFF0080FF));
final muted = derivative.changeToHSVSaturation(0.5);
final shifted = derivative.changeToHSLHue(280);
final hex = colorToHex(muted.toColor()); // theme/color_utils.dart''',
      tokenClasses:
          'kkkkkppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppccccccccccccccccccccccccc',
    ),
  ],
  'error_system': <DocsSnippet>[
    DocsSnippet(
      id: 'error_system.0',
      componentId: 'error_system',
      language: 'dart',
      code: r'''final scope = HubAppScope(AppErrorHub.sessionExpired);
final error = AppError(
  code: AppErrorCode.sessionExpired,
  title: 'Session expired',
  message: 'Please sign in again.',
  actions: <ErrorAction>[ErrorAction.login(signIn)],
);
scope.notifier.value = error;''',
      tokenClasses:
          'kkkkkppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssssssssssspppppppppppppsssssssssssssssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
    DocsSnippet(
      id: 'error_system.1',
      componentId: 'error_system',
      language: 'dart',
      code: r'''final mapper = RuleBasedErrorMapper(
  rules: <ErrorRule>[
    rule<TimeoutException>(
      build: (e, st) => AppError(
        code: AppErrorCode.timeout,
        title: 'Request timed out',
        message: 'The server is taking too long to respond.',
      ),
      priority: 4,
    ),
  ],
  fallback: (e, st) => AppError(
    code: AppErrorCode.unknown,
    title: 'Something went wrong',
    message: 'Please try again.',
  ),
);''',
      tokenClasses:
          'kkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppssssssssssssssssssspppppppppppppppppppsssssssssssssssssssssssssssssssssssssssssssppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssssssssssssssssssssspppppppppppppppsssssssssssssssssssppppppppp',
    ),
    DocsSnippet(
      id: 'error_system.2',
      componentId: 'error_system',
      language: 'dart',
      code:
          r'''await guard(() => repository.load(), scope: scope, mapper: mapper);''',
      tokenClasses:
          'kkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp',
    ),
  ],
  'locale_utils': <DocsSnippet>[
    DocsSnippet(
      id: 'locale_utils.0',
      componentId: 'locale_utils',
      language: 'dart',
      code:
          'SizeUnitLocale.fileBytes.format(1536); // \'1.5 KB\'\nSizeUnitLocale.binaryBytes.format(1024); // \'1 KiB\'',
      tokenClasses:
          'pppppppppppppppppppppppppppppppppppppppcccccccccccppppppppppppppppppppppppppppppppppppppppppcccccccccc',
    ),
    DocsSnippet(
      id: 'locale_utils.1',
      componentId: 'locale_utils',
      language: 'dart',
      code:
          'const SizeUnitLocale decimal = SizeUnitLocale(\n  1000,\n  <String>[\'B\', \'kB\', \'MB\'],\n  separator: \' \',\n);\ndecimal.format(1234567); // \'1.2 MB\'',
      tokenClasses:
          'kkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppsssppssssppssssppppppppppppppppsssppppppppppppppppppppppppppppppccccccccccc',
    ),
  ],
  'timeline_animation': <DocsSnippet>[
    DocsSnippet(
      id: 'timeline_animation.0',
      componentId: 'timeline_animation',
      language: 'dart',
      code: r'''final timeline = TimelineAnimation<double>(keyframes: [
  AbsoluteKeyframe(const Duration(milliseconds: 200), 0.0, 1.0),
  StillKeyframe(const Duration(milliseconds: 100)),
  RelativeKeyframe(const Duration(milliseconds: 300), 0.0),
]);

// Drive it from any controller:
final value = timeline.transform(controller.value);
final view = timeline.drive(controller); // Animatable<double>''',
      tokenClasses:
          'kkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkpppppppppppppppppppppppppppppppppppppppppccccccccccccccccccccccccccccccccpkkkkkpppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppppppppccccccccccccccccccccc',
    ),
    DocsSnippet(
      id: 'timeline_animation.1',
      componentId: 'timeline_animation',
      language: 'dart',
      code: r'''final color = TimelineAnimation<Color?>(
  lerp: Transformers.typeColor,
  keyframes: [
    AbsoluteKeyframe(const Duration(milliseconds: 400), const Color(0xFF000000), const Color(0xFFFFFFFF)),
  ],
);''',
      tokenClasses:
          'kkkkkppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppppppppppppkkkkkppppppppppppppppppppkkkkkpppppppppppppppppppppppppppp',
    ),
  ],
};

/// Note shown next to every manual install file list (user-owned
/// `*_theme.dart` files are never overwritten by the CLI).
const String kUserOwnedNote =
    'User-owned *_theme.dart files are never overwritten.';

/// The exact files the CLI installs for one component.
class DocsFileList {
  /// Creates the list.
  const DocsFileList({
    required this.componentId,
    required this.files,
    required this.userOwned,
  });

  /// Owning component id.
  final String componentId;

  /// Registry-owned files, install-root relative.
  final List<String> files;

  /// User-owned files, install-root relative.
  final List<String> userOwned;
}

/// Install file lists keyed by component id.
const Map<String, DocsFileList> kComponentFileLists = <String, DocsFileList>{
  'button': DocsFileList(
    componentId: 'button',
    files: <String>[
      'lib/ui/shadcn/components/button/button.dart',
      'lib/ui/shadcn/components/button/button_group.dart',
      'lib/ui/shadcn/components/button/button_style.dart',
    ],
    userOwned: <String>['lib/ui/shadcn/components/button/button_theme.dart'],
  ),
  'command': DocsFileList(
    componentId: 'command',
    files: <String>[
      'lib/ui/shadcn/components/command/command.dart',
      'lib/ui/shadcn/components/command/command_style.dart',
    ],
    userOwned: <String>['lib/ui/shadcn/components/command/command_theme.dart'],
  ),
  'patch': DocsFileList(
    componentId: 'patch',
    files: <String>['lib/ui/shadcn/components/patch/patch.dart'],
    userOwned: <String>[],
  ),
  'scrollbar': DocsFileList(
    componentId: 'scrollbar',
    files: <String>[
      'lib/ui/shadcn/components/scrollbar/scrollbar.dart',
      'lib/ui/shadcn/components/scrollbar/scrollbar_style.dart',
    ],
    userOwned: <String>[
      'lib/ui/shadcn/components/scrollbar/scrollbar_theme.dart',
    ],
  ),
  'scrollview': DocsFileList(
    componentId: 'scrollview',
    files: <String>['lib/ui/shadcn/components/scrollview/scrollview.dart'],
    userOwned: <String>[],
  ),
  'toggle': DocsFileList(
    componentId: 'toggle',
    files: <String>[
      'lib/ui/shadcn/components/toggle/toggle.dart',
      'lib/ui/shadcn/components/toggle/toggle_style.dart',
    ],
    userOwned: <String>['lib/ui/shadcn/components/toggle/toggle_theme.dart'],
  ),
  'avatar': DocsFileList(
    componentId: 'avatar',
    files: <String>[
      'lib/ui/shadcn/components/avatar/avatar.dart',
      'lib/ui/shadcn/components/avatar/avatar_style.dart',
    ],
    userOwned: <String>['lib/ui/shadcn/components/avatar/avatar_theme.dart'],
  ),
  'badge': DocsFileList(
    componentId: 'badge',
    files: <String>[
      'lib/ui/shadcn/components/badge/badge.dart',
      'lib/ui/shadcn/components/badge/badge_style.dart',
    ],
    userOwned: <String>['lib/ui/shadcn/components/badge/badge_theme.dart'],
  ),
  'border_loading': DocsFileList(
    componentId: 'border_loading',
    files: <String>[
      'lib/ui/shadcn/components/border_loading/border_loading.dart',
      'lib/ui/shadcn/components/border_loading/border_loading_style.dart',
    ],
    userOwned: <String>[
      'lib/ui/shadcn/components/border_loading/border_loading_theme.dart',
    ],
  ),
  'calendar': DocsFileList(
    componentId: 'calendar',
    files: <String>[
      'lib/ui/shadcn/components/calendar/calendar.dart',
      'lib/ui/shadcn/components/calendar/calendar_style.dart',
    ],
    userOwned: <String>[
      'lib/ui/shadcn/components/calendar/calendar_theme.dart',
    ],
  ),
  'carousel': DocsFileList(
    componentId: 'carousel',
    files: <String>[
      'lib/ui/shadcn/components/carousel/carousel.dart',
      'lib/ui/shadcn/components/carousel/carousel_style.dart',
    ],
    userOwned: <String>[
      'lib/ui/shadcn/components/carousel/carousel_theme.dart',
    ],
  ),
  'chat': DocsFileList(
    componentId: 'chat',
    files: <String>[
      'lib/ui/shadcn/components/chat/chat.dart',
      'lib/ui/shadcn/components/chat/chat_style.dart',
    ],
    userOwned: <String>['lib/ui/shadcn/components/chat/chat_theme.dart'],
  ),
  'chip': DocsFileList(
    componentId: 'chip',
    files: <String>[
      'lib/ui/shadcn/components/chip/chip.dart',
      'lib/ui/shadcn/components/chip/chip_style.dart',
    ],
    userOwned: <String>['lib/ui/shadcn/components/chip/chip_theme.dart'],
  ),
  'code_snippet': DocsFileList(
    componentId: 'code_snippet',
    files: <String>[
      'lib/ui/shadcn/components/code_snippet/code_snippet.dart',
      'lib/ui/shadcn/components/code_snippet/code_snippet_style.dart',
    ],
    userOwned: <String>[
      'lib/ui/shadcn/components/code_snippet/code_snippet_theme.dart',
    ],
  ),
  'country_flag': DocsFileList(
    componentId: 'country_flag',
    files: <String>[
      'lib/ui/shadcn/components/country_flag/country_flag.dart',
      'lib/ui/shadcn/components/country_flag/country_flag_style.dart',
    ],
    userOwned: <String>[
      'lib/ui/shadcn/components/country_flag/country_flag_theme.dart',
    ],
  ),
  'divider': DocsFileList(
    componentId: 'divider',
    files: <String>[
      'lib/ui/shadcn/components/divider/divider.dart',
      'lib/ui/shadcn/components/divider/divider_style.dart',
    ],
    userOwned: <String>['lib/ui/shadcn/components/divider/divider_theme.dart'],
  ),
  'dot_indicator': DocsFileList(
    componentId: 'dot_indicator',
    files: <String>[
      'lib/ui/shadcn/components/dot_indicator/dot_indicator.dart',
      'lib/ui/shadcn/components/dot_indicator/dot_indicator_style.dart',
    ],
    userOwned: <String>[
      'lib/ui/shadcn/components/dot_indicator/dot_indicator_theme.dart',
    ],
  ),
  'empty_state': DocsFileList(
    componentId: 'empty_state',
    files: <String>[
      'lib/ui/shadcn/components/empty_state/empty_state.dart',
      'lib/ui/shadcn/components/empty_state/empty_state_style.dart',
    ],
    userOwned: <String>[
      'lib/ui/shadcn/components/empty_state/empty_state_theme.dart',
    ],
  ),
  'feature_carousel': DocsFileList(
    componentId: 'feature_carousel',
    files: <String>[
      'lib/ui/shadcn/components/feature_carousel/feature_carousel.dart',
      'lib/ui/shadcn/components/feature_carousel/feature_carousel_style.dart',
    ],
    userOwned: <String>[
      'lib/ui/shadcn/components/feature_carousel/feature_carousel_theme.dart',
    ],
  ),
  'file_diff_viewer': DocsFileList(
    componentId: 'file_diff_viewer',
    files: <String>[
      'lib/ui/shadcn/components/file_diff_viewer/file_diff_viewer.dart',
      'lib/ui/shadcn/components/file_diff_viewer/file_diff_viewer_style.dart',
    ],
    userOwned: <String>[
      'lib/ui/shadcn/components/file_diff_viewer/file_diff_viewer_theme.dart',
    ],
  ),
  'icon': DocsFileList(
    componentId: 'icon',
    files: <String>[
      'lib/ui/shadcn/components/icon/icon.dart',
      'lib/ui/shadcn/components/icon/icon_style.dart',
    ],
    userOwned: <String>['lib/ui/shadcn/components/icon/icon_theme.dart'],
  ),
  'image': DocsFileList(
    componentId: 'image',
    files: <String>[
      'lib/ui/shadcn/components/image/image.dart',
      'lib/ui/shadcn/components/image/image_style.dart',
    ],
    userOwned: <String>['lib/ui/shadcn/components/image/image_theme.dart'],
  ),
  'keyboard_shortcut': DocsFileList(
    componentId: 'keyboard_shortcut',
    files: <String>[
      'lib/ui/shadcn/components/keyboard_shortcut/keyboard_shortcut.dart',
      'lib/ui/shadcn/components/keyboard_shortcut/keyboard_shortcut_style.dart',
    ],
    userOwned: <String>[
      'lib/ui/shadcn/components/keyboard_shortcut/keyboard_shortcut_theme.dart',
    ],
  ),
  'markdown': DocsFileList(
    componentId: 'markdown',
    files: <String>[
      'lib/ui/shadcn/components/markdown/markdown.dart',
      'lib/ui/shadcn/components/markdown/markdown_style.dart',
    ],
    userOwned: <String>[
      'lib/ui/shadcn/components/markdown/markdown_theme.dart',
    ],
  ),
  'number_ticker': DocsFileList(
    componentId: 'number_ticker',
    files: <String>[
      'lib/ui/shadcn/components/number_ticker/number_ticker.dart',
      'lib/ui/shadcn/components/number_ticker/number_ticker_style.dart',
    ],
    userOwned: <String>[
      'lib/ui/shadcn/components/number_ticker/number_ticker_theme.dart',
    ],
  ),
  'pinned_sheet': DocsFileList(
    componentId: 'pinned_sheet',
    files: <String>['lib/ui/shadcn/components/pinned_sheet/pinned_sheet.dart'],
    userOwned: <String>[],
  ),
  'progress': DocsFileList(
    componentId: 'progress',
    files: <String>[
      'lib/ui/shadcn/components/progress/progress.dart',
      'lib/ui/shadcn/components/progress/progress_style.dart',
    ],
    userOwned: <String>[
      'lib/ui/shadcn/components/progress/progress_theme.dart',
    ],
  ),
  'selectable': DocsFileList(
    componentId: 'selectable',
    files: <String>[
      'lib/ui/shadcn/components/selectable/selectable.dart',
      'lib/ui/shadcn/components/selectable/selectable_style.dart',
    ],
    userOwned: <String>[
      'lib/ui/shadcn/components/selectable/selectable_theme.dart',
    ],
  ),
  'skeleton': DocsFileList(
    componentId: 'skeleton',
    files: <String>[
      'lib/ui/shadcn/components/skeleton/skeleton.dart',
      'lib/ui/shadcn/components/skeleton/skeleton_style.dart',
    ],
    userOwned: <String>[
      'lib/ui/shadcn/components/skeleton/skeleton_theme.dart',
    ],
  ),
  'spinner': DocsFileList(
    componentId: 'spinner',
    files: <String>[
      'lib/ui/shadcn/components/spinner/spinner.dart',
      'lib/ui/shadcn/components/spinner/spinner_style.dart',
    ],
    userOwned: <String>['lib/ui/shadcn/components/spinner/spinner_theme.dart'],
  ),
  'text_animate': DocsFileList(
    componentId: 'text_animate',
    files: <String>[
      'lib/ui/shadcn/components/text_animate/text_animate.dart',
      'lib/ui/shadcn/components/text_animate/text_animate_style.dart',
    ],
    userOwned: <String>[
      'lib/ui/shadcn/components/text_animate/text_animate_theme.dart',
    ],
  ),
  'tracker': DocsFileList(
    componentId: 'tracker',
    files: <String>[
      'lib/ui/shadcn/components/tracker/tracker.dart',
      'lib/ui/shadcn/components/tracker/tracker_style.dart',
    ],
    userOwned: <String>['lib/ui/shadcn/components/tracker/tracker_theme.dart'],
  ),
  'tree': DocsFileList(
    componentId: 'tree',
    files: <String>[
      'lib/ui/shadcn/components/tree/tree.dart',
      'lib/ui/shadcn/components/tree/tree_style.dart',
    ],
    userOwned: <String>['lib/ui/shadcn/components/tree/tree_theme.dart'],
  ),
  'triple_dots': DocsFileList(
    componentId: 'triple_dots',
    files: <String>[
      'lib/ui/shadcn/components/triple_dots/triple_dots.dart',
      'lib/ui/shadcn/components/triple_dots/triple_dots_style.dart',
    ],
    userOwned: <String>[
      'lib/ui/shadcn/components/triple_dots/triple_dots_theme.dart',
    ],
  ),
  'autocomplete': DocsFileList(
    componentId: 'autocomplete',
    files: <String>[
      'lib/ui/shadcn/components/autocomplete/autocomplete.dart',
      'lib/ui/shadcn/components/autocomplete/autocomplete_style.dart',
    ],
    userOwned: <String>[
      'lib/ui/shadcn/components/autocomplete/autocomplete_theme.dart',
    ],
  ),
  'checkbox': DocsFileList(
    componentId: 'checkbox',
    files: <String>[
      'lib/ui/shadcn/components/checkbox/checkbox.dart',
      'lib/ui/shadcn/components/checkbox/checkbox_style.dart',
    ],
    userOwned: <String>[
      'lib/ui/shadcn/components/checkbox/checkbox_theme.dart',
    ],
  ),
  'chip_input': DocsFileList(
    componentId: 'chip_input',
    files: <String>[
      'lib/ui/shadcn/components/chip_input/chip_input.dart',
      'lib/ui/shadcn/components/chip_input/chip_input_style.dart',
    ],
    userOwned: <String>[
      'lib/ui/shadcn/components/chip_input/chip_input_theme.dart',
    ],
  ),
  'color_field': DocsFileList(
    componentId: 'color_field',
    files: <String>[
      'lib/ui/shadcn/components/color_field/color_field.dart',
      'lib/ui/shadcn/components/color_field/color_field_style.dart',
    ],
    userOwned: <String>[
      'lib/ui/shadcn/components/color_field/color_field_theme.dart',
    ],
  ),
  'color_input': DocsFileList(
    componentId: 'color_input',
    files: <String>[
      'lib/ui/shadcn/components/color_input/color_input.dart',
      'lib/ui/shadcn/components/color_input/color_input_style.dart',
    ],
    userOwned: <String>[
      'lib/ui/shadcn/components/color_input/color_input_theme.dart',
    ],
  ),
  'color_picker': DocsFileList(
    componentId: 'color_picker',
    files: <String>[
      'lib/ui/shadcn/components/color_picker/color_picker.dart',
      'lib/ui/shadcn/components/color_picker/color_picker_style.dart',
    ],
    userOwned: <String>[
      'lib/ui/shadcn/components/color_picker/color_picker_theme.dart',
    ],
  ),
  'date_picker': DocsFileList(
    componentId: 'date_picker',
    files: <String>[
      'lib/ui/shadcn/components/date_picker/date_picker.dart',
      'lib/ui/shadcn/components/date_picker/date_picker_style.dart',
    ],
    userOwned: <String>[
      'lib/ui/shadcn/components/date_picker/date_picker_theme.dart',
    ],
  ),
  'dropzone': DocsFileList(
    componentId: 'dropzone',
    files: <String>[
      'lib/ui/shadcn/components/dropzone/dropzone.dart',
      'lib/ui/shadcn/components/dropzone/dropzone_style.dart',
    ],
    userOwned: <String>[
      'lib/ui/shadcn/components/dropzone/dropzone_theme.dart',
    ],
  ),
  'file_picker': DocsFileList(
    componentId: 'file_picker',
    files: <String>[
      'lib/ui/shadcn/components/file_picker/file_picker.dart',
      'lib/ui/shadcn/components/file_picker/file_picker_style.dart',
    ],
    userOwned: <String>[
      'lib/ui/shadcn/components/file_picker/file_picker_theme.dart',
    ],
  ),
  'form': DocsFileList(
    componentId: 'form',
    files: <String>[
      'lib/ui/shadcn/components/form/form.dart',
      'lib/ui/shadcn/components/form/form_style.dart',
    ],
    userOwned: <String>['lib/ui/shadcn/components/form/form_theme.dart'],
  ),
  'formatted_input': DocsFileList(
    componentId: 'formatted_input',
    files: <String>[
      'lib/ui/shadcn/components/formatted_input/formatted_input.dart',
      'lib/ui/shadcn/components/formatted_input/formatted_input_style.dart',
    ],
    userOwned: <String>[
      'lib/ui/shadcn/components/formatted_input/formatted_input_theme.dart',
    ],
  ),
  'formatter': DocsFileList(
    componentId: 'formatter',
    files: <String>['lib/ui/shadcn/components/formatter/formatter.dart'],
    userOwned: <String>[],
  ),
  'history': DocsFileList(
    componentId: 'history',
    files: <String>[
      'lib/ui/shadcn/components/history/history.dart',
      'lib/ui/shadcn/components/history/history_style.dart',
    ],
    userOwned: <String>['lib/ui/shadcn/components/history/history_theme.dart'],
  ),
  'hsl': DocsFileList(
    componentId: 'hsl',
    files: <String>[
      'lib/ui/shadcn/components/hsl/hsl.dart',
      'lib/ui/shadcn/components/hsl/hsl_style.dart',
    ],
    userOwned: <String>['lib/ui/shadcn/components/hsl/hsl_theme.dart'],
  ),
  'hsv': DocsFileList(
    componentId: 'hsv',
    files: <String>[
      'lib/ui/shadcn/components/hsv/hsv.dart',
      'lib/ui/shadcn/components/hsv/hsv_style.dart',
    ],
    userOwned: <String>['lib/ui/shadcn/components/hsv/hsv_theme.dart'],
  ),
  'input': DocsFileList(
    componentId: 'input',
    files: <String>[
      'lib/ui/shadcn/components/input/input.dart',
      'lib/ui/shadcn/components/input/input_style.dart',
    ],
    userOwned: <String>['lib/ui/shadcn/components/input/input_theme.dart'],
  ),
  'input_otp': DocsFileList(
    componentId: 'input_otp',
    files: <String>[
      'lib/ui/shadcn/components/input_otp/input_otp.dart',
      'lib/ui/shadcn/components/input_otp/input_otp_style.dart',
    ],
    userOwned: <String>[
      'lib/ui/shadcn/components/input_otp/input_otp_theme.dart',
    ],
  ),
  'item_picker': DocsFileList(
    componentId: 'item_picker',
    files: <String>[
      'lib/ui/shadcn/components/item_picker/item_picker.dart',
      'lib/ui/shadcn/components/item_picker/item_picker_style.dart',
    ],
    userOwned: <String>[
      'lib/ui/shadcn/components/item_picker/item_picker_theme.dart',
    ],
  ),
  'multi_select': DocsFileList(
    componentId: 'multi_select',
    files: <String>['lib/ui/shadcn/components/multi_select/multi_select.dart'],
    userOwned: <String>[],
  ),
  'multiple_choice': DocsFileList(
    componentId: 'multiple_choice',
    files: <String>[
      'lib/ui/shadcn/components/multiple_choice/multiple_choice.dart',
      'lib/ui/shadcn/components/multiple_choice/multiple_choice_style.dart',
    ],
    userOwned: <String>[
      'lib/ui/shadcn/components/multiple_choice/multiple_choice_theme.dart',
    ],
  ),
  'object_input': DocsFileList(
    componentId: 'object_input',
    files: <String>['lib/ui/shadcn/components/object_input/object_input.dart'],
    userOwned: <String>[],
  ),
  'phone_input': DocsFileList(
    componentId: 'phone_input',
    files: <String>[
      'lib/ui/shadcn/components/phone_input/phone_input.dart',
      'lib/ui/shadcn/components/phone_input/phone_input_style.dart',
    ],
    userOwned: <String>[
      'lib/ui/shadcn/components/phone_input/phone_input_theme.dart',
    ],
  ),
  'radio_group': DocsFileList(
    componentId: 'radio_group',
    files: <String>[
      'lib/ui/shadcn/components/radio_group/radio_group.dart',
      'lib/ui/shadcn/components/radio_group/radio_group_style.dart',
    ],
    userOwned: <String>[
      'lib/ui/shadcn/components/radio_group/radio_group_theme.dart',
    ],
  ),
  'select': DocsFileList(
    componentId: 'select',
    files: <String>[
      'lib/ui/shadcn/components/select/select.dart',
      'lib/ui/shadcn/components/select/select_style.dart',
    ],
    userOwned: <String>['lib/ui/shadcn/components/select/select_theme.dart'],
  ),
  'slider': DocsFileList(
    componentId: 'slider',
    files: <String>[
      'lib/ui/shadcn/components/slider/slider.dart',
      'lib/ui/shadcn/components/slider/slider_style.dart',
    ],
    userOwned: <String>['lib/ui/shadcn/components/slider/slider_theme.dart'],
  ),
  'star_rating': DocsFileList(
    componentId: 'star_rating',
    files: <String>[
      'lib/ui/shadcn/components/star_rating/star_rating.dart',
      'lib/ui/shadcn/components/star_rating/star_rating_style.dart',
    ],
    userOwned: <String>[
      'lib/ui/shadcn/components/star_rating/star_rating_theme.dart',
    ],
  ),
  'switch': DocsFileList(
    componentId: 'switch',
    files: <String>[
      'lib/ui/shadcn/components/switch/switch.dart',
      'lib/ui/shadcn/components/switch/switch_style.dart',
    ],
    userOwned: <String>['lib/ui/shadcn/components/switch/switch_theme.dart'],
  ),
  'text_area': DocsFileList(
    componentId: 'text_area',
    files: <String>['lib/ui/shadcn/components/text_area/text_area.dart'],
    userOwned: <String>[],
  ),
  'time_picker': DocsFileList(
    componentId: 'time_picker',
    files: <String>[
      'lib/ui/shadcn/components/time_picker/time_picker.dart',
      'lib/ui/shadcn/components/time_picker/time_picker_style.dart',
    ],
    userOwned: <String>[
      'lib/ui/shadcn/components/time_picker/time_picker_theme.dart',
    ],
  ),
  'accordion': DocsFileList(
    componentId: 'accordion',
    files: <String>[
      'lib/ui/shadcn/components/accordion/accordion.dart',
      'lib/ui/shadcn/components/accordion/accordion_style.dart',
    ],
    userOwned: <String>[
      'lib/ui/shadcn/components/accordion/accordion_theme.dart',
    ],
  ),
  'alert': DocsFileList(
    componentId: 'alert',
    files: <String>[
      'lib/ui/shadcn/components/alert/alert.dart',
      'lib/ui/shadcn/components/alert/alert_style.dart',
    ],
    userOwned: <String>['lib/ui/shadcn/components/alert/alert_theme.dart'],
  ),
  'app': DocsFileList(
    componentId: 'app',
    files: <String>['lib/ui/shadcn/components/app/app.dart'],
    userOwned: <String>[],
  ),
  'card': DocsFileList(
    componentId: 'card',
    files: <String>[
      'lib/ui/shadcn/components/card/card.dart',
      'lib/ui/shadcn/components/card/card_style.dart',
    ],
    userOwned: <String>['lib/ui/shadcn/components/card/card_theme.dart'],
  ),
  'card_image': DocsFileList(
    componentId: 'card_image',
    files: <String>[
      'lib/ui/shadcn/components/card_image/card_image.dart',
      'lib/ui/shadcn/components/card_image/card_image_style.dart',
    ],
    userOwned: <String>[
      'lib/ui/shadcn/components/card_image/card_image_theme.dart',
    ],
  ),
  'collapsible': DocsFileList(
    componentId: 'collapsible',
    files: <String>[
      'lib/ui/shadcn/components/collapsible/collapsible.dart',
      'lib/ui/shadcn/components/collapsible/collapsible_style.dart',
    ],
    userOwned: <String>[
      'lib/ui/shadcn/components/collapsible/collapsible_theme.dart',
    ],
  ),
  'filter_bar': DocsFileList(
    componentId: 'filter_bar',
    files: <String>[
      'lib/ui/shadcn/components/filter_bar/filter_bar.dart',
      'lib/ui/shadcn/components/filter_bar/filter_bar_style.dart',
    ],
    userOwned: <String>[
      'lib/ui/shadcn/components/filter_bar/filter_bar_theme.dart',
    ],
  ),
  'group': DocsFileList(
    componentId: 'group',
    files: <String>['lib/ui/shadcn/components/group/group.dart'],
    userOwned: <String>[],
  ),
  'media_query': DocsFileList(
    componentId: 'media_query',
    files: <String>[
      'lib/ui/shadcn/components/media_query/media_query.dart',
      'lib/ui/shadcn/components/media_query/media_query_style.dart',
    ],
    userOwned: <String>[
      'lib/ui/shadcn/components/media_query/media_query_theme.dart',
    ],
  ),
  'outlined_container': DocsFileList(
    componentId: 'outlined_container',
    files: <String>[
      'lib/ui/shadcn/components/outlined_container/outlined_container.dart',
      'lib/ui/shadcn/components/outlined_container/outlined_container_style.dart',
    ],
    userOwned: <String>[
      'lib/ui/shadcn/components/outlined_container/outlined_container_theme.dart',
    ],
  ),
  'overflow_marquee': DocsFileList(
    componentId: 'overflow_marquee',
    files: <String>[
      'lib/ui/shadcn/components/overflow_marquee/overflow_marquee.dart',
      'lib/ui/shadcn/components/overflow_marquee/overflow_marquee_style.dart',
    ],
    userOwned: <String>[
      'lib/ui/shadcn/components/overflow_marquee/overflow_marquee_theme.dart',
    ],
  ),
  'resizable': DocsFileList(
    componentId: 'resizable',
    files: <String>[
      'lib/ui/shadcn/components/resizable/resizable.dart',
      'lib/ui/shadcn/components/resizable/resizable_style.dart',
    ],
    userOwned: <String>[
      'lib/ui/shadcn/components/resizable/resizable_theme.dart',
    ],
  ),
  'scaffold': DocsFileList(
    componentId: 'scaffold',
    files: <String>[
      'lib/ui/shadcn/components/scaffold/scaffold.dart',
      'lib/ui/shadcn/components/scaffold/scaffold_style.dart',
    ],
    userOwned: <String>[
      'lib/ui/shadcn/components/scaffold/scaffold_theme.dart',
    ],
  ),
  'scrollable': DocsFileList(
    componentId: 'scrollable',
    files: <String>[
      'lib/ui/shadcn/components/scrollable/scrollable.dart',
      'lib/ui/shadcn/components/scrollable/scrollable_style.dart',
    ],
    userOwned: <String>[
      'lib/ui/shadcn/components/scrollable/scrollable_theme.dart',
    ],
  ),
  'scrollable_client': DocsFileList(
    componentId: 'scrollable_client',
    files: <String>[
      'lib/ui/shadcn/components/scrollable_client/scrollable_client.dart',
      'lib/ui/shadcn/components/scrollable_client/scrollable_client_style.dart',
    ],
    userOwned: <String>[
      'lib/ui/shadcn/components/scrollable_client/scrollable_client_theme.dart',
    ],
  ),
  'sortable': DocsFileList(
    componentId: 'sortable',
    files: <String>['lib/ui/shadcn/components/sortable/sortable.dart'],
    userOwned: <String>[],
  ),
  'stage_container': DocsFileList(
    componentId: 'stage_container',
    files: <String>[
      'lib/ui/shadcn/components/stage_container/stage_container.dart',
      'lib/ui/shadcn/components/stage_container/stage_container_style.dart',
    ],
    userOwned: <String>[
      'lib/ui/shadcn/components/stage_container/stage_container_theme.dart',
    ],
  ),
  'steps': DocsFileList(
    componentId: 'steps',
    files: <String>[
      'lib/ui/shadcn/components/steps/steps.dart',
      'lib/ui/shadcn/components/steps/steps_style.dart',
    ],
    userOwned: <String>['lib/ui/shadcn/components/steps/steps_theme.dart'],
  ),
  'table': DocsFileList(
    componentId: 'table',
    files: <String>[
      'lib/ui/shadcn/components/table/table.dart',
      'lib/ui/shadcn/components/table/table_style.dart',
    ],
    userOwned: <String>['lib/ui/shadcn/components/table/table_theme.dart'],
  ),
  'timeline': DocsFileList(
    componentId: 'timeline',
    files: <String>[
      'lib/ui/shadcn/components/timeline/timeline.dart',
      'lib/ui/shadcn/components/timeline/timeline_style.dart',
    ],
    userOwned: <String>[
      'lib/ui/shadcn/components/timeline/timeline_theme.dart',
    ],
  ),
  'window': DocsFileList(
    componentId: 'window',
    files: <String>[
      'lib/ui/shadcn/components/window/window.dart',
      'lib/ui/shadcn/components/window/window_style.dart',
    ],
    userOwned: <String>['lib/ui/shadcn/components/window/window_theme.dart'],
  ),
  'breadcrumb': DocsFileList(
    componentId: 'breadcrumb',
    files: <String>[
      'lib/ui/shadcn/components/breadcrumb/breadcrumb.dart',
      'lib/ui/shadcn/components/breadcrumb/breadcrumb_style.dart',
    ],
    userOwned: <String>[
      'lib/ui/shadcn/components/breadcrumb/breadcrumb_theme.dart',
    ],
  ),
  'navigation_bar': DocsFileList(
    componentId: 'navigation_bar',
    files: <String>[
      'lib/ui/shadcn/components/navigation_bar/navigation_bar.dart',
      'lib/ui/shadcn/components/navigation_bar/navigation_bar_style.dart',
    ],
    userOwned: <String>[
      'lib/ui/shadcn/components/navigation_bar/navigation_bar_theme.dart',
    ],
  ),
  'navigation_menu': DocsFileList(
    componentId: 'navigation_menu',
    files: <String>[
      'lib/ui/shadcn/components/navigation_menu/navigation_menu.dart',
      'lib/ui/shadcn/components/navigation_menu/navigation_menu_style.dart',
    ],
    userOwned: <String>[
      'lib/ui/shadcn/components/navigation_menu/navigation_menu_theme.dart',
    ],
  ),
  'page_route': DocsFileList(
    componentId: 'page_route',
    files: <String>['lib/ui/shadcn/components/page_route/page_route.dart'],
    userOwned: <String>[],
  ),
  'pagination': DocsFileList(
    componentId: 'pagination',
    files: <String>[
      'lib/ui/shadcn/components/pagination/pagination.dart',
      'lib/ui/shadcn/components/pagination/pagination_style.dart',
    ],
    userOwned: <String>[
      'lib/ui/shadcn/components/pagination/pagination_theme.dart',
    ],
  ),
  'stepper': DocsFileList(
    componentId: 'stepper',
    files: <String>[
      'lib/ui/shadcn/components/stepper/stepper.dart',
      'lib/ui/shadcn/components/stepper/stepper_style.dart',
    ],
    userOwned: <String>['lib/ui/shadcn/components/stepper/stepper_theme.dart'],
  ),
  'switcher': DocsFileList(
    componentId: 'switcher',
    files: <String>[
      'lib/ui/shadcn/components/switcher/switcher.dart',
      'lib/ui/shadcn/components/switcher/switcher_style.dart',
    ],
    userOwned: <String>[
      'lib/ui/shadcn/components/switcher/switcher_theme.dart',
    ],
  ),
  'tabs': DocsFileList(
    componentId: 'tabs',
    files: <String>[
      'lib/ui/shadcn/components/tabs/tabs.dart',
      'lib/ui/shadcn/components/tabs/tabs_style.dart',
    ],
    userOwned: <String>['lib/ui/shadcn/components/tabs/tabs_theme.dart'],
  ),
  'alert_dialog': DocsFileList(
    componentId: 'alert_dialog',
    files: <String>[
      'lib/ui/shadcn/components/alert_dialog/alert_dialog.dart',
      'lib/ui/shadcn/components/alert_dialog/alert_dialog_style.dart',
    ],
    userOwned: <String>[
      'lib/ui/shadcn/components/alert_dialog/alert_dialog_theme.dart',
    ],
  ),
  'anchor': DocsFileList(
    componentId: 'anchor',
    files: <String>['lib/ui/shadcn/components/anchor/anchor.dart'],
    userOwned: <String>[],
  ),
  'backdrop_transform': DocsFileList(
    componentId: 'backdrop_transform',
    files: <String>[
      'lib/ui/shadcn/components/backdrop_transform/backdrop_transform.dart',
    ],
    userOwned: <String>[],
  ),
  'context_menu': DocsFileList(
    componentId: 'context_menu',
    files: <String>['lib/ui/shadcn/components/context_menu/context_menu.dart'],
    userOwned: <String>[],
  ),
  'dialog': DocsFileList(
    componentId: 'dialog',
    files: <String>[
      'lib/ui/shadcn/components/dialog/dialog.dart',
      'lib/ui/shadcn/components/dialog/dialog_style.dart',
    ],
    userOwned: <String>['lib/ui/shadcn/components/dialog/dialog_theme.dart'],
  ),
  'drawer': DocsFileList(
    componentId: 'drawer',
    files: <String>[
      'lib/ui/shadcn/components/drawer/drawer.dart',
      'lib/ui/shadcn/components/drawer/drawer_style.dart',
    ],
    userOwned: <String>['lib/ui/shadcn/components/drawer/drawer_theme.dart'],
  ),
  'drawer_container': DocsFileList(
    componentId: 'drawer_container',
    files: <String>[
      'lib/ui/shadcn/components/drawer_container/drawer_container.dart',
    ],
    userOwned: <String>[],
  ),
  'dropdown_menu': DocsFileList(
    componentId: 'dropdown_menu',
    files: <String>[
      'lib/ui/shadcn/components/dropdown_menu/dropdown_menu.dart',
    ],
    userOwned: <String>[],
  ),
  'eye_dropper': DocsFileList(
    componentId: 'eye_dropper',
    files: <String>[
      'lib/ui/shadcn/components/eye_dropper/eye_dropper.dart',
      'lib/ui/shadcn/components/eye_dropper/eye_dropper_style.dart',
    ],
    userOwned: <String>[
      'lib/ui/shadcn/components/eye_dropper/eye_dropper_theme.dart',
    ],
  ),
  'gooey_toast': DocsFileList(
    componentId: 'gooey_toast',
    files: <String>[
      'lib/ui/shadcn/components/gooey_toast/gooey_toast.dart',
      'lib/ui/shadcn/components/gooey_toast/gooey_toast_style.dart',
    ],
    userOwned: <String>[
      'lib/ui/shadcn/components/gooey_toast/gooey_toast_theme.dart',
    ],
  ),
  'hover_card': DocsFileList(
    componentId: 'hover_card',
    files: <String>[
      'lib/ui/shadcn/components/hover_card/hover_card.dart',
      'lib/ui/shadcn/components/hover_card/hover_card_style.dart',
    ],
    userOwned: <String>[
      'lib/ui/shadcn/components/hover_card/hover_card_theme.dart',
    ],
  ),
  'menu': DocsFileList(
    componentId: 'menu',
    files: <String>[
      'lib/ui/shadcn/components/menu/menu.dart',
      'lib/ui/shadcn/components/menu/menu_style.dart',
    ],
    userOwned: <String>['lib/ui/shadcn/components/menu/menu_theme.dart'],
  ),
  'menubar': DocsFileList(
    componentId: 'menubar',
    files: <String>['lib/ui/shadcn/components/menubar/menubar.dart'],
    userOwned: <String>[],
  ),
  'overlay_configuration': DocsFileList(
    componentId: 'overlay_configuration',
    files: <String>[
      'lib/ui/shadcn/components/overlay_configuration/overlay_configuration.dart',
    ],
    userOwned: <String>[],
  ),
  'popup': DocsFileList(
    componentId: 'popup',
    files: <String>['lib/ui/shadcn/components/popup/popup.dart'],
    userOwned: <String>[],
  ),
  'refresh_trigger': DocsFileList(
    componentId: 'refresh_trigger',
    files: <String>[
      'lib/ui/shadcn/components/refresh_trigger/refresh_trigger.dart',
      'lib/ui/shadcn/components/refresh_trigger/refresh_trigger_style.dart',
    ],
    userOwned: <String>[
      'lib/ui/shadcn/components/refresh_trigger/refresh_trigger_theme.dart',
    ],
  ),
  'spell_check_suggestions_toolbar': DocsFileList(
    componentId: 'spell_check_suggestions_toolbar',
    files: <String>[
      'lib/ui/shadcn/components/spell_check_suggestions_toolbar/spell_check_suggestions_toolbar.dart',
    ],
    userOwned: <String>[],
  ),
  'swiper': DocsFileList(
    componentId: 'swiper',
    files: <String>[
      'lib/ui/shadcn/components/swiper/swiper.dart',
      'lib/ui/shadcn/components/swiper/swiper_style.dart',
    ],
    userOwned: <String>['lib/ui/shadcn/components/swiper/swiper_theme.dart'],
  ),
  'toast': DocsFileList(
    componentId: 'toast',
    files: <String>[
      'lib/ui/shadcn/components/toast/toast.dart',
      'lib/ui/shadcn/components/toast/toast_style.dart',
    ],
    userOwned: <String>['lib/ui/shadcn/components/toast/toast_theme.dart'],
  ),
  'tooltip': DocsFileList(
    componentId: 'tooltip',
    files: <String>[
      'lib/ui/shadcn/components/tooltip/tooltip.dart',
      'lib/ui/shadcn/components/tooltip/tooltip_style.dart',
    ],
    userOwned: <String>['lib/ui/shadcn/components/tooltip/tooltip_theme.dart'],
  ),
  'alpha': DocsFileList(
    componentId: 'alpha',
    files: <String>['lib/ui/shadcn/components/alpha/alpha.dart'],
    userOwned: <String>[],
  ),
  'async': DocsFileList(
    componentId: 'async',
    files: <String>['lib/ui/shadcn/components/async/async.dart'],
    userOwned: <String>[],
  ),
  'color': DocsFileList(
    componentId: 'color',
    files: <String>['lib/ui/shadcn/components/color/color.dart'],
    userOwned: <String>[],
  ),
  'error_system': DocsFileList(
    componentId: 'error_system',
    files: <String>[
      'lib/ui/shadcn/components/error_system/error_system.dart',
      'lib/ui/shadcn/components/error_system/error_system_style.dart',
    ],
    userOwned: <String>[
      'lib/ui/shadcn/components/error_system/error_system_theme.dart',
    ],
  ),
  'locale_utils': DocsFileList(
    componentId: 'locale_utils',
    files: <String>['lib/ui/shadcn/components/locale_utils/locale_utils.dart'],
    userOwned: <String>[],
  ),
  'timeline_animation': DocsFileList(
    componentId: 'timeline_animation',
    files: <String>[
      'lib/ui/shadcn/components/timeline_animation/timeline_animation.dart',
    ],
    userOwned: <String>[],
  ),
};
