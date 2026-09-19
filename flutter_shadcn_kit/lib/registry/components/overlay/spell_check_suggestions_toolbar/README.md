# Spell Check Suggestions Toolbar (`spell_check_suggestions_toolbar`)

Upstream-parity shadcn spell check suggestions toolbar (`SpellCheckSuggestionsToolbar` + `.editableText`) rendered through registry menu primitives.

---

## When to use

- Use this when:
  - you enable spell check on text fields and want shadcn styling.
  - you need the editableText toolbar constructor for framework integration.
- Avoid when:
  - plain text fields without spell check configuration.

---

## Install

```bash
flutter_shadcn add spell_check_suggestions_toolbar
```

---

## Import

```dart
import 'package:<your_app>/ui/shadcn/overlay/spell_check_suggestions_toolbar/spell_check_suggestions_toolbar.dart';
```

---

## Minimal example

```dart
TextField(
  spellCheckConfiguration: const SpellCheckConfiguration(
    spellCheckService: DefaultSpellCheckService(),
  ),
)
```

---

## Upstream parity

Ports `shadcn_flutter`'s `menu/spell_check_suggestions_toolbar.dart` (`SpellCheckSuggestionsToolbar`, `.editableText`, `buildButtonItems`, replacement logic). Anchor positioning is simplified to an anchor-offset `Stack`/`Positioned` around the same `MenuPopup` chrome (upstream uses its internal `ContextMenuPopup` overlay).
