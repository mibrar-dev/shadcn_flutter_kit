# Install the Flutter ShadCN Kit Skill for Claude Code

This skill gives Claude Code deep knowledge of the `flutter_shadcn_kit` component registry — all 133 components, import patterns, theming, and example pages — so it can build Flutter UI screens without re-exploring the project each session.

## Prerequisites

- [Claude Code](https://claude.ai/code) installed
- `flutter_shadcn_cli` activated globally:
  ```bash
  dart pub global activate flutter_shadcn_cli
  ```

## Install

```bash
flutter_shadcn --advanced install-skill --available
flutter_shadcn --advanced install-skill --skill flutter-shadcn-kit --model claude
```

This copies the skill files into `~/.claude/skills/flutter-shadcn-kit/`. Claude Code picks them up automatically on the next session.

## Verify

```bash
flutter_shadcn --advanced install-skill --list
```

You should see `flutter-shadcn-kit` listed as installed for the `claude` model target.

## For local repo development

```bash
dart run bin/flutter_shadcn.dart --advanced install-skill --skill flutter-shadcn-kit --model claude
```

## Remote source fallback

```bash
flutter_shadcn --advanced install-skill \
  --skills-url https://raw.githubusercontent.com/ibrar-x/shadcn_flutter_kit/main/flutter_shadcn_kit/skills \
  --skill flutter-shadcn-kit \
  --model claude
```

## What gets installed

```
~/.claude/skills/flutter-shadcn-kit/
├── SKILL.md                          # Core skill — always loaded when triggered
└── references/
    ├── components-catalog.md         # Full API reference for all 133 components
    └── example-pages.md              # 5 complete example screens
```

## What the skill does

Once installed, when you work in any Flutter project that uses `flutter_shadcn_kit`, Claude will:

- Know the correct import patterns (including `hide Card, TextField`)
- Know all component APIs without needing to read preview files
- Follow the correct `Select`, `Dialog`, `Tabs`, and `Alert` patterns
- Build complete pages using the standard layout shell
- Read `references/` when you ask about a specific component or want a full example

## Uninstall

```bash
rm -rf ~/.claude/skills/flutter-shadcn-kit
```
