# Install The Flutter shadcn UI Skill

This skill ships with `flutter_shadcn_cli` and can be installed into AI model folders from any Flutter project.

```bash
dart pub global activate flutter_shadcn_cli
flutter_shadcn --advanced install-skill --available
flutter_shadcn --advanced install-skill --skill flutter-shadcn-ui --model .codex
```

For local repo development:

```bash
dart run bin/flutter_shadcn.dart --advanced install-skill --skill flutter-shadcn-ui --model .codex
```

Remote kit source fallback:

```bash
flutter_shadcn --advanced install-skill \
  --skills-url https://raw.githubusercontent.com/mibrar-dev/shadcn_flutter_kit/main/flutter_shadcn_kit/skills \
  --skill flutter-shadcn-ui \
  --model .codex
```

Verify:

```bash
flutter_shadcn --advanced install-skill --list
```
