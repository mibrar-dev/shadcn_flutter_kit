# Marketing Video Kit Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a reusable `marketing_demo` Flutter app plus scriptable capture workflow that exports a polished 30-second square marketing video for the `flutter_shadcn` CLI and `shadcn_flutter_kit` registry.

**Architecture:** Add a standalone `marketing_demo/` Flutter app that imports real installed shadcn components from a generated local `lib/ui/shadcn` tree. The demo app owns its deterministic timeline, scenes, social captions, and video capture scripts so marketing assets do not leak into the docs app or registry package. Capture is driven by a shell script that runs the app at `1080x1080`, records the autoplay route, exports MP4 variants, and writes a QA checklist.

**Tech Stack:** Flutter, Dart widget tests, `flutter_shadcn` CLI, shell scripts, FFmpeg, macOS `screencapture` or simulator/screen-recorder fallback, existing registry components.

---

## File Structure

- Create: `marketing_demo/pubspec.yaml`  
  Minimal Flutter app package for recording the video.
- Create: `marketing_demo/analysis_options.yaml`  
  Standard lint configuration using Flutter lints.
- Create: `marketing_demo/lib/main.dart`  
  Entrypoint that launches the marketing video app.
- Create: `marketing_demo/lib/marketing_video_app.dart`  
  App shell using `ShadcnApp`, theme mode control, and the square stage.
- Create: `marketing_demo/lib/video_timeline.dart`  
  Deterministic 30-second scene timeline and playback model.
- Create: `marketing_demo/lib/video_assets.dart`  
  Static copy, commands, fake file data, and CTA values used by scenes.
- Create: `marketing_demo/lib/scenes/product_claim_scene.dart`  
  0-3s opening product claim.
- Create: `marketing_demo/lib/scenes/cli_proof_scene.dart`  
  3-8s terminal proof scene.
- Create: `marketing_demo/lib/scenes/component_showcase_scene.dart`  
  8-20s real component showcase.
- Create: `marketing_demo/lib/scenes/app_capabilities_scene.dart`  
  20-26s app/theme/overlay/file-picker/gooey scene.
- Create: `marketing_demo/lib/scenes/cta_scene.dart`  
  26-30s final command and URL.
- Create: `marketing_demo/lib/widgets/stage_frame.dart`  
  Shared square stage layout, scene transitions, and caption placement.
- Create: `marketing_demo/lib/widgets/terminal_panel.dart`  
  Terminal-style command proof UI.
- Create: `marketing_demo/lib/widgets/component_grid.dart`  
  Dense component grid used in product and showcase scenes.
- Create: `marketing_demo/lib/widgets/deterministic_file_picker_card.dart`  
  File picker visual that does not open OS UI during recording.
- Create: `marketing_demo/lib/widgets/gooey_toast_demo_card.dart`  
  Real gooey-toast trigger surface with theme-inverted colors.
- Create: `marketing_demo/test/video_timeline_test.dart`  
  Unit tests for scene timing and CTA hold.
- Create: `marketing_demo/test/marketing_video_app_test.dart`  
  Widget tests for square stage, key text, theme inversion labels, and deterministic file picker.
- Create: `marketing_demo/tool/capture_square_video.sh`  
  Script to run, record, and export the square MP4.
- Create: `marketing_demo/tool/qa_marketing_video.sh`  
  Script to validate generated video dimensions/duration and required files.
- Create: `marketing_demo/marketing/captions.md`  
  Social captions and release blurbs.
- Create: `marketing_demo/marketing/QA_REPORT.md`  
  Human-readable QA checklist produced/updated during verification.
- Modify: `.gitignore`  
  Ignore generated marketing video outputs while keeping scripts and caption docs tracked.
- Modify: `README.md`  
  Add a short maintainer-only section linking to the marketing demo workflow.

## Task 1: Scaffold `marketing_demo`

**Files:**
- Create: `marketing_demo/pubspec.yaml`
- Create: `marketing_demo/analysis_options.yaml`
- Create: `marketing_demo/lib/main.dart`
- Modify: `.gitignore`

- [ ] **Step 1: Create the app package files**

Create `marketing_demo/pubspec.yaml` with:

```yaml
name: marketing_demo
description: Square marketing video demo for flutter_shadcn and shadcn_flutter_kit.
publish_to: "none"
version: 0.1.0

environment:
  sdk: ">=3.3.0 <4.0.0"

dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:
    sdk: flutter
  data_widget: ^0.0.2
  gap: ^3.0.1
  intl: ^0.20.2

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^6.0.0

flutter:
  uses-material-design: true
```

Create `marketing_demo/analysis_options.yaml` with:

```yaml
include: package:flutter_lints/flutter.yaml

linter:
  rules:
    prefer_const_constructors: true
    prefer_const_literals_to_create_immutables: true
```

Create `marketing_demo/lib/main.dart` with:

```dart
import 'package:flutter/widgets.dart';

import 'marketing_video_app.dart';

void main() {
  runApp(const MarketingVideoApp());
}
```

- [ ] **Step 2: Ignore generated marketing outputs**

Append these lines to `.gitignore` if they are not already present:

```gitignore
# Marketing video generated outputs
marketing_demo/build/
marketing_demo/marketing/out/
marketing_demo/marketing/*.mp4
marketing_demo/marketing/*.mov
marketing_demo/marketing/*.png
```

- [ ] **Step 3: Fetch package dependencies**

Run:

```bash
cd marketing_demo
flutter pub get
```

Expected: command exits `0` and creates `marketing_demo/pubspec.lock`.

- [ ] **Step 4: Commit scaffold**

Run:

```bash
git add .gitignore marketing_demo/pubspec.yaml marketing_demo/pubspec.lock marketing_demo/analysis_options.yaml marketing_demo/lib/main.dart
git commit -m "feat: scaffold marketing demo app"
```

## Task 2: Install Real Registry Components Into The Demo

**Files:**
- Create via CLI: `marketing_demo/lib/ui/shadcn/**`
- Modify via CLI: `marketing_demo/pubspec.yaml`
- Create via CLI: `marketing_demo/.shadcn/**`

- [ ] **Step 1: Run CLI init against the local registry**

From the repo root, run:

```bash
cd marketing_demo
dart ../../shadcn_flutter_cli/bin/shadcn.dart \
  --advanced \
  init shadcn \
  --yes \
  --registries-path ../../registry-directory/registries/registries.json \
  --registry-path ../flutter_shadcn_kit/lib/registry
```

Expected:

- `marketing_demo/lib/ui/shadcn/app_components.dart` exists.
- `marketing_demo/lib/ui/shadcn/components/layout/app/app.dart` exists.
- `marketing_demo/lib/ui/shadcn/shared/primitives/_impl/core/overlay_manager.dart` exists.
- `marketing_demo/lib/ui/shadcn/shared/localizations/shadcn_localizations.dart` exists.
- `marketing_demo/pubspec.yaml` contains `flutter.fonts`, not raw font files under `flutter.assets`.

- [ ] **Step 2: Install showcase components**

Run:

```bash
cd marketing_demo
dart ../../shadcn_flutter_cli/bin/shadcn.dart \
  --advanced \
  add button text_field card badge table file_picker gooey_toast \
  --registry-path ../flutter_shadcn_kit/lib/registry
```

Expected:

- Component files exist under `marketing_demo/lib/ui/shadcn/components/`.
- `marketing_demo/lib/ui/shadcn/app_components.dart` exports installed components.
- `.shadcn/components/*.json` records installed components.

- [ ] **Step 3: Verify installed code analyzes before app code depends on it**

Run:

```bash
cd marketing_demo
flutter analyze
```

Expected: `No issues found!`

- [ ] **Step 4: Commit installed registry snapshot**

Run:

```bash
git add marketing_demo/pubspec.yaml marketing_demo/pubspec.lock marketing_demo/.shadcn marketing_demo/lib/ui
git commit -m "feat: install shadcn components for marketing demo"
```

## Task 3: Add Deterministic Timeline Model

**Files:**
- Create: `marketing_demo/lib/video_timeline.dart`
- Create: `marketing_demo/test/video_timeline_test.dart`

- [ ] **Step 1: Write failing timeline tests**

Create `marketing_demo/test/video_timeline_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:marketing_demo/video_timeline.dart';

void main() {
  group('MarketingVideoTimeline', () {
    test('covers exactly thirty seconds', () {
      expect(MarketingVideoTimeline.totalDuration, const Duration(seconds: 30));
    });

    test('resolves scene ids at storyboard boundaries', () {
      expect(MarketingVideoTimeline.sceneAt(Duration.zero).id, 'product-claim');
      expect(
        MarketingVideoTimeline.sceneAt(const Duration(seconds: 3)).id,
        'cli-proof',
      );
      expect(
        MarketingVideoTimeline.sceneAt(const Duration(seconds: 8)).id,
        'component-showcase',
      );
      expect(
        MarketingVideoTimeline.sceneAt(const Duration(seconds: 20)).id,
        'app-capabilities',
      );
      expect(
        MarketingVideoTimeline.sceneAt(const Duration(seconds: 26)).id,
        'cta',
      );
    });

    test('keeps the final CTA visible through the final frame', () {
      expect(
        MarketingVideoTimeline.sceneAt(
          MarketingVideoTimeline.totalDuration - const Duration(milliseconds: 1),
        ).id,
        'cta',
      );
    });
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run:

```bash
cd marketing_demo
flutter test test/video_timeline_test.dart
```

Expected: FAIL because `video_timeline.dart` does not exist.

- [ ] **Step 3: Implement the timeline model**

Create `marketing_demo/lib/video_timeline.dart`:

```dart
import 'dart:math' as math;

class MarketingSceneSegment {
  const MarketingSceneSegment({
    required this.id,
    required this.start,
    required this.end,
  });

  final String id;
  final Duration start;
  final Duration end;

  Duration get duration => end - start;

  double progressAt(Duration elapsed) {
    if (elapsed <= start) {
      return 0;
    }
    if (elapsed >= end) {
      return 1;
    }
    final localMs = (elapsed - start).inMilliseconds;
    return math.max(0, math.min(1, localMs / duration.inMilliseconds));
  }
}

class MarketingVideoTimeline {
  static const totalDuration = Duration(seconds: 30);

  static const segments = <MarketingSceneSegment>[
    MarketingSceneSegment(
      id: 'product-claim',
      start: Duration(seconds: 0),
      end: Duration(seconds: 3),
    ),
    MarketingSceneSegment(
      id: 'cli-proof',
      start: Duration(seconds: 3),
      end: Duration(seconds: 8),
    ),
    MarketingSceneSegment(
      id: 'component-showcase',
      start: Duration(seconds: 8),
      end: Duration(seconds: 20),
    ),
    MarketingSceneSegment(
      id: 'app-capabilities',
      start: Duration(seconds: 20),
      end: Duration(seconds: 26),
    ),
    MarketingSceneSegment(
      id: 'cta',
      start: Duration(seconds: 26),
      end: totalDuration,
    ),
  ];

  static MarketingSceneSegment sceneAt(Duration elapsed) {
    final clamped = elapsed < Duration.zero
        ? Duration.zero
        : elapsed >= totalDuration
            ? totalDuration - const Duration(milliseconds: 1)
            : elapsed;
    return segments.firstWhere(
      (segment) => clamped >= segment.start && clamped < segment.end,
      orElse: () => segments.last,
    );
  }
}
```

- [ ] **Step 4: Run test to verify it passes**

Run:

```bash
cd marketing_demo
flutter test test/video_timeline_test.dart
```

Expected: PASS.

- [ ] **Step 5: Commit timeline**

Run:

```bash
git add marketing_demo/lib/video_timeline.dart marketing_demo/test/video_timeline_test.dart
git commit -m "feat: add marketing video timeline"
```

## Task 4: Add Static Copy And Shared Stage Widgets

**Files:**
- Create: `marketing_demo/lib/video_assets.dart`
- Create: `marketing_demo/lib/widgets/stage_frame.dart`
- Create: `marketing_demo/lib/widgets/terminal_panel.dart`
- Create: `marketing_demo/lib/widgets/component_grid.dart`
- Create: `marketing_demo/lib/widgets/deterministic_file_picker_card.dart`
- Create: `marketing_demo/lib/widgets/gooey_toast_demo_card.dart`

- [ ] **Step 1: Create static video copy**

Create `marketing_demo/lib/video_assets.dart`:

```dart
class MarketingVideoCopy {
  static const headline = 'Production-ready Flutter UI components';
  static const subhead = 'Theming, overlays, localization, and CLI install.';
  static const ctaCommand = 'flutter_shadcn init';
  static const ctaUrl = 'github.com/ibrar-x/shadcn_flutter_kit';

  static const cliCommands = <String>[
    r'$ flutter_shadcn init',
    r'$ flutter_shadcn add button text_field gooey_toast',
    r'$ flutter_shadcn add file_picker table card',
  ];

  static const filePickerFiles = <String>[
    'brand-kit.zip',
    'invoice-preview.pdf',
    'component-demo.png',
  ];
}
```

- [ ] **Step 2: Create the square stage frame**

Create `marketing_demo/lib/widgets/stage_frame.dart`:

```dart
import 'package:flutter/widgets.dart';

class StageFrame extends StatelessWidget {
  const StageFrame({
    super.key,
    required this.child,
    this.caption,
    this.dark = false,
  });

  final Widget child;
  final String? caption;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    final background = dark ? const Color(0xFF050505) : const Color(0xFFF7F7F4);
    final foreground = dark ? const Color(0xFFF7F7F4) : const Color(0xFF111111);

    return ColoredBox(
      color: background,
      child: Center(
        child: AspectRatio(
          aspectRatio: 1,
          child: Padding(
            padding: const EdgeInsets.all(44),
            child: DefaultTextStyle(
              style: TextStyle(
                color: foreground,
                fontSize: 24,
                height: 1.1,
                fontWeight: FontWeight.w600,
              ),
              child: Stack(
                children: [
                  Positioned.fill(child: child),
                  if (caption != null)
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Text(
                        caption!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: foreground.withOpacity(0.68),
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
```

- [ ] **Step 3: Create the terminal panel widget**

Create `marketing_demo/lib/widgets/terminal_panel.dart`:

```dart
import 'package:flutter/widgets.dart';

class TerminalPanel extends StatelessWidget {
  const TerminalPanel({super.key, required this.commands});

  final List<String> commands;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFF0A0A0A),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF2D2D2D)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: const [
                _Dot(color: Color(0xFFFF5F57)),
                SizedBox(width: 7),
                _Dot(color: Color(0xFFFFBD2E)),
                SizedBox(width: 7),
                _Dot(color: Color(0xFF28C840)),
              ],
            ),
            const SizedBox(height: 18),
            for (final command in commands)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  command,
                  style: const TextStyle(
                    color: Color(0xFFEFEFEF),
                    fontFamily: 'GeistMono',
                    fontSize: 17,
                    height: 1.25,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: const SizedBox(width: 12, height: 12),
    );
  }
}
```

- [ ] **Step 4: Create reusable component visuals**

Create `marketing_demo/lib/widgets/component_grid.dart`:

```dart
import 'package:flutter/widgets.dart';

class ComponentGrid extends StatelessWidget {
  const ComponentGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 14,
      crossAxisSpacing: 14,
      childAspectRatio: 1.65,
      children: const [
        _Tile(label: 'Button', value: 'Primary / Secondary'),
        _Tile(label: 'TextField', value: 'Focus + validation'),
        _Tile(label: 'Overlay', value: 'Toast + popover'),
        _Tile(label: 'Theme', value: 'Light / dark'),
      ],
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        border: Border.all(color: const Color(0xFFE3E3E0)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(label, style: const TextStyle(fontSize: 22, color: Color(0xFF111111))),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(fontSize: 14, color: Color(0xFF666666))),
          ],
        ),
      ),
    );
  }
}
```

Create `marketing_demo/lib/widgets/deterministic_file_picker_card.dart`:

```dart
import 'package:flutter/widgets.dart';
import '../video_assets.dart';

class DeterministicFilePickerCard extends StatelessWidget {
  const DeterministicFilePickerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE0E0DE)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'File picker',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Color(0xFF111111),
              ),
            ),
            const SizedBox(height: 12),
            for (final file in MarketingVideoCopy.filePickerFiles)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    const Icon(
                      IconData(0xe873, fontFamily: 'MaterialIcons'),
                      color: Color(0xFF111111),
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      file,
                      style: const TextStyle(fontSize: 15, color: Color(0xFF333333)),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
```

Create `marketing_demo/lib/widgets/gooey_toast_demo_card.dart`:

```dart
import 'package:flutter/widgets.dart';

class GooeyToastDemoCard extends StatelessWidget {
  const GooeyToastDemoCard({super.key, required this.darkMode});

  final bool darkMode;

  @override
  Widget build(BuildContext context) {
    final gooeyColor = darkMode ? const Color(0xFFF7F7F4) : const Color(0xFF111111);
    final labelColor = darkMode ? const Color(0xFF111111) : const Color(0xFFF7F7F4);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: gooeyColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(color: labelColor, shape: BoxShape.circle),
              child: const SizedBox(width: 14, height: 14),
            ),
            const SizedBox(width: 12),
            Text(
              'Gooey toast',
              style: TextStyle(
                color: labelColor,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

- [ ] **Step 5: Analyze shared widgets**

Run:

```bash
cd marketing_demo
flutter analyze
```

Expected: no analyzer errors. If generated shadcn code emits unrelated warnings, capture them in `marketing_demo/marketing/QA_REPORT.md` and continue only if app code has no errors.

- [ ] **Step 6: Commit shared widgets**

Run:

```bash
git add marketing_demo/lib/video_assets.dart marketing_demo/lib/widgets
git commit -m "feat: add marketing video stage widgets"
```

## Task 5: Build The Scene Widgets And App Shell

**Files:**
- Create: `marketing_demo/lib/marketing_video_app.dart`
- Create: `marketing_demo/lib/scenes/product_claim_scene.dart`
- Create: `marketing_demo/lib/scenes/cli_proof_scene.dart`
- Create: `marketing_demo/lib/scenes/component_showcase_scene.dart`
- Create: `marketing_demo/lib/scenes/app_capabilities_scene.dart`
- Create: `marketing_demo/lib/scenes/cta_scene.dart`
- Create: `marketing_demo/test/marketing_video_app_test.dart`

- [ ] **Step 1: Write failing widget tests**

Create `marketing_demo/test/marketing_video_app_test.dart`:

```dart
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:marketing_demo/marketing_video_app.dart';

void main() {
  testWidgets('renders the product claim in a square stage', (tester) async {
    await tester.binding.setSurfaceSize(const Size(1080, 1080));
    await tester.pumpWidget(const MarketingVideoApp(debugElapsed: Duration.zero));

    expect(find.text('Production-ready Flutter UI components'), findsOneWidget);
    expect(find.text('Theming, overlays, localization, and CLI install.'), findsOneWidget);
  });

  testWidgets('renders deterministic file picker in app capabilities scene', (tester) async {
    await tester.binding.setSurfaceSize(const Size(1080, 1080));
    await tester.pumpWidget(
      const MarketingVideoApp(debugElapsed: Duration(seconds: 20)),
    );

    expect(find.text('File picker'), findsOneWidget);
    expect(find.text('brand-kit.zip'), findsOneWidget);
    expect(find.text('Gooey toast'), findsOneWidget);
  });

  testWidgets('renders CTA at final scene', (tester) async {
    await tester.binding.setSurfaceSize(const Size(1080, 1080));
    await tester.pumpWidget(
      const MarketingVideoApp(debugElapsed: Duration(seconds: 26)),
    );

    expect(find.text('flutter_shadcn init'), findsOneWidget);
    expect(find.text('github.com/ibrar-x/shadcn_flutter_kit'), findsOneWidget);
  });
}
```

- [ ] **Step 2: Run tests to verify they fail**

Run:

```bash
cd marketing_demo
flutter test test/marketing_video_app_test.dart
```

Expected: FAIL because `marketing_video_app.dart` and scene files do not exist.

- [ ] **Step 3: Implement scene widgets**

Create `marketing_demo/lib/scenes/product_claim_scene.dart`:

```dart
import 'package:flutter/widgets.dart';
import '../video_assets.dart';
import '../widgets/component_grid.dart';

class ProductClaimScene extends StatelessWidget {
  const ProductClaimScene({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          MarketingVideoCopy.headline,
          style: TextStyle(fontSize: 54, height: 0.96, fontWeight: FontWeight.w800),
        ),
        SizedBox(height: 18),
        Text(
          MarketingVideoCopy.subhead,
          style: TextStyle(fontSize: 22, color: Color(0xFF555555)),
        ),
        SizedBox(height: 34),
        Expanded(child: ComponentGrid()),
      ],
    );
  }
}
```

Create `marketing_demo/lib/scenes/cli_proof_scene.dart`:

```dart
import 'package:flutter/widgets.dart';
import '../video_assets.dart';
import '../widgets/terminal_panel.dart';

class CliProofScene extends StatelessWidget {
  const CliProofScene({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Install what you need.',
            style: TextStyle(fontSize: 46, fontWeight: FontWeight.w800),
          ),
          SizedBox(height: 24),
          TerminalPanel(commands: MarketingVideoCopy.cliCommands),
        ],
      ),
    );
  }
}
```

Create `marketing_demo/lib/scenes/component_showcase_scene.dart`:

```dart
import 'package:flutter/widgets.dart';
import '../widgets/component_grid.dart';

class ComponentShowcaseScene extends StatelessWidget {
  const ComponentShowcaseScene({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Real Flutter components.',
          style: TextStyle(fontSize: 46, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 20),
        const Expanded(child: ComponentGrid()),
        const SizedBox(height: 18),
        Row(
          children: const [
            Expanded(
              child: DecoratedBox(
                decoration: BoxDecoration(color: Color(0xFF111111)),
                child: Padding(
                  padding: EdgeInsets.all(18),
                  child: Text(
                    'Button',
                    style: TextStyle(color: Color(0xFFFFFFFF), fontSize: 18),
                  ),
                ),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  border: Border.fromBorderSide(BorderSide(color: Color(0xFF111111))),
                ),
                child: Padding(
                  padding: EdgeInsets.all(18),
                  child: Text(
                    'TextField',
                    style: TextStyle(color: Color(0xFF111111), fontSize: 18),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
```

Create `marketing_demo/lib/scenes/app_capabilities_scene.dart`:

```dart
import 'package:flutter/widgets.dart';
import '../widgets/deterministic_file_picker_card.dart';
import '../widgets/gooey_toast_demo_card.dart';

class AppCapabilitiesScene extends StatelessWidget {
  const AppCapabilitiesScene({super.key, required this.darkMode});

  final bool darkMode;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'App-ready defaults.',
          style: TextStyle(fontSize: 46, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 18),
        const Text(
          'ShadcnApp, overlays, localization, themes.',
          style: TextStyle(fontSize: 20),
        ),
        const Spacer(),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Expanded(child: DeterministicFilePickerCard()),
            const SizedBox(width: 18),
            Expanded(
              child: Align(
                alignment: Alignment.bottomRight,
                child: GooeyToastDemoCard(darkMode: darkMode),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
```

Create `marketing_demo/lib/scenes/cta_scene.dart`:

```dart
import 'package:flutter/widgets.dart';
import '../video_assets.dart';
import '../widgets/terminal_panel.dart';

class CtaScene extends StatelessWidget {
  const CtaScene({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Text(
            'Start with one command.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 50, fontWeight: FontWeight.w800),
          ),
          SizedBox(height: 24),
          TerminalPanel(commands: [r'$ flutter_shadcn init']),
          SizedBox(height: 26),
          Text(
            MarketingVideoCopy.ctaUrl,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 4: Implement app shell**

Create `marketing_demo/lib/marketing_video_app.dart`:

```dart
import 'dart:async';

import 'package:flutter/widgets.dart';

import 'scenes/app_capabilities_scene.dart';
import 'scenes/cli_proof_scene.dart';
import 'scenes/component_showcase_scene.dart';
import 'scenes/cta_scene.dart';
import 'scenes/product_claim_scene.dart';
import 'ui/shadcn/app_components.dart';
import 'video_timeline.dart';
import 'widgets/stage_frame.dart';

class MarketingVideoApp extends StatefulWidget {
  const MarketingVideoApp({super.key, this.debugElapsed});

  final Duration? debugElapsed;

  @override
  State<MarketingVideoApp> createState() => _MarketingVideoAppState();
}

class _MarketingVideoAppState extends State<MarketingVideoApp> {
  final Stopwatch _stopwatch = Stopwatch();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    if (widget.debugElapsed == null) {
      _stopwatch.start();
      _timer = Timer.periodic(const Duration(milliseconds: 100), (_) {
        if (mounted) {
          setState(() {});
        }
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final elapsed = widget.debugElapsed ?? _stopwatch.elapsed;
    final scene = MarketingVideoTimeline.sceneAt(elapsed);
    final dark = scene.id == 'cli-proof' || scene.id == 'app-capabilities';

    return ShadcnApp(
      title: 'shadcn Flutter Marketing Demo',
      debugShowCheckedModeBanner: false,
      home: Directionality(
        textDirection: TextDirection.ltr,
        child: StageFrame(
          dark: dark,
          caption: _captionFor(scene.id),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 420),
            child: KeyedSubtree(
              key: ValueKey(scene.id),
              child: _sceneFor(scene.id, darkMode: dark),
            ),
          ),
        ),
      ),
    );
  }

  String _captionFor(String id) {
    return switch (id) {
      'product-claim' => 'Production-ready Flutter UI components',
      'cli-proof' => 'Installed from a registry-powered CLI',
      'component-showcase' => 'Copy, own, and customize real Flutter code',
      'app-capabilities' => 'Theming, overlays, localization, file input',
      'cta' => 'github.com/ibrar-x/shadcn_flutter_kit',
      _ => '',
    };
  }

  Widget _sceneFor(String id, {required bool darkMode}) {
    return switch (id) {
      'product-claim' => const ProductClaimScene(),
      'cli-proof' => const CliProofScene(),
      'component-showcase' => const ComponentShowcaseScene(),
      'app-capabilities' => AppCapabilitiesScene(darkMode: darkMode),
      'cta' => const CtaScene(),
      _ => const ProductClaimScene(),
    };
  }
}
```

- [ ] **Step 5: Run widget tests**

Run:

```bash
cd marketing_demo
flutter test test/marketing_video_app_test.dart
```

Expected: PASS.

- [ ] **Step 6: Analyze app**

Run:

```bash
cd marketing_demo
flutter analyze
```

Expected: no errors in `marketing_demo/lib` or `marketing_demo/test`.

- [ ] **Step 7: Commit app scenes**

Run:

```bash
git add marketing_demo/lib marketing_demo/test
git commit -m "feat: add marketing video scenes"
```

## Task 6: Add Capture And QA Scripts

**Files:**
- Create: `marketing_demo/tool/capture_square_video.sh`
- Create: `marketing_demo/tool/qa_marketing_video.sh`
- Create: `marketing_demo/marketing/QA_REPORT.md`

- [ ] **Step 1: Create capture script**

Create `marketing_demo/tool/capture_square_video.sh`:

```bash
#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUT_DIR="$ROOT_DIR/marketing/out"
RAW_MOV="$OUT_DIR/shadcn-flutter-launch-square.raw.mov"
FINAL_MP4="$OUT_DIR/shadcn-flutter-launch-square.mp4"
SOCIAL_MP4="$OUT_DIR/shadcn-flutter-launch-square-social.mp4"
THUMBNAIL="$OUT_DIR/shadcn-flutter-launch-thumbnail.png"

mkdir -p "$OUT_DIR"

if ! command -v ffmpeg >/dev/null 2>&1; then
  echo "ffmpeg is required. Install it before running capture." >&2
  exit 1
fi

cd "$ROOT_DIR"
flutter pub get

echo "Starting Flutter macOS app. Keep the app window visible and square."
flutter run -d macos --release &
APP_PID=$!

cleanup() {
  kill "$APP_PID" >/dev/null 2>&1 || true
}
trap cleanup EXIT

sleep 8

echo "Recording 30 seconds using macOS screencapture."
screencapture -v -T 0 -V 30 "$RAW_MOV"

echo "Encoding square MP4 outputs."
ffmpeg -y -i "$RAW_MOV" \
  -vf "crop=min(iw\\,ih):min(iw\\,ih),scale=1080:1080" \
  -r 30 -c:v libx264 -pix_fmt yuv420p -movflags +faststart \
  "$FINAL_MP4"

ffmpeg -y -i "$FINAL_MP4" \
  -c:v libx264 -crf 24 -preset medium -pix_fmt yuv420p -movflags +faststart \
  "$SOCIAL_MP4"

ffmpeg -y -ss 00:00:02 -i "$FINAL_MP4" -frames:v 1 "$THUMBNAIL"

echo "Wrote:"
echo "  $FINAL_MP4"
echo "  $SOCIAL_MP4"
echo "  $THUMBNAIL"
```

- [ ] **Step 2: Create QA script**

Create `marketing_demo/tool/qa_marketing_video.sh`:

```bash
#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUT_DIR="$ROOT_DIR/marketing/out"
VIDEO="$OUT_DIR/shadcn-flutter-launch-square.mp4"
SOCIAL="$OUT_DIR/shadcn-flutter-launch-square-social.mp4"
THUMB="$OUT_DIR/shadcn-flutter-launch-thumbnail.png"

if ! command -v ffprobe >/dev/null 2>&1; then
  echo "ffprobe is required. It is included with ffmpeg." >&2
  exit 1
fi

for file in "$VIDEO" "$SOCIAL" "$THUMB"; do
  if [[ ! -f "$file" ]]; then
    echo "Missing expected output: $file" >&2
    exit 1
  fi
done

dimensions="$(ffprobe -v error -select_streams v:0 -show_entries stream=width,height -of csv=s=x:p=0 "$VIDEO")"
duration="$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$VIDEO")"

if [[ "$dimensions" != "1080x1080" ]]; then
  echo "Expected 1080x1080, got $dimensions" >&2
  exit 1
fi

python3 - "$duration" <<'PY'
import sys
duration = float(sys.argv[1])
if not (29.0 <= duration <= 31.5):
    raise SystemExit(f"Expected duration around 30s, got {duration:.2f}s")
PY

echo "Marketing video QA passed: $dimensions, ${duration}s"
```

- [ ] **Step 3: Make scripts executable**

Run:

```bash
chmod +x marketing_demo/tool/capture_square_video.sh marketing_demo/tool/qa_marketing_video.sh
```

- [ ] **Step 4: Create initial QA report**

Create `marketing_demo/marketing/QA_REPORT.md`:

```markdown
# Marketing Video QA Report

## Target

- Format: square `1080x1080`
- Duration: about 30 seconds
- Video: `marketing/out/shadcn-flutter-launch-square.mp4`
- Social export: `marketing/out/shadcn-flutter-launch-square-social.mp4`
- Thumbnail: `marketing/out/shadcn-flutter-launch-thumbnail.png`

## Automated Checks

- [ ] `flutter test`
- [ ] `flutter analyze`
- [ ] `tool/capture_square_video.sh`
- [ ] `tool/qa_marketing_video.sh`

## Visual Checks

- [ ] all visible UI is rendered from the Flutter demo app
- [ ] CLI commands are readable
- [ ] captions and labels do not overlap
- [ ] dark and light modes are legible
- [ ] gooey toast visibly animates or presents a clear triggered state
- [ ] gooey colors invert against theme mode
- [ ] file picker scene shows deterministic selected files
- [ ] `ShadcnApp`, overlay manager, and localization support are represented
- [ ] final CTA is readable
- [ ] thumbnail frame is clear at feed size
```

- [ ] **Step 5: Commit scripts**

Run:

```bash
git add marketing_demo/tool marketing_demo/marketing/QA_REPORT.md
git commit -m "feat: add marketing video capture scripts"
```

## Task 7: Add Captions And README Link

**Files:**
- Create: `marketing_demo/marketing/captions.md`
- Modify: `README.md`

- [ ] **Step 1: Create caption pack**

Create `marketing_demo/marketing/captions.md`:

```markdown
# Marketing Caption Pack

## X / LinkedIn

Production-ready Flutter UI components with theming, overlays, localization, and CLI install.

`flutter_shadcn init`

Real Flutter components. Registry powered. Copy the code into your app and own it.

github.com/ibrar-x/shadcn_flutter_kit

## Instagram / Reels

shadcn-style Flutter components, installed from a CLI.

Theming, overlays, file input, gooey toast, and app-ready defaults.

`flutter_shadcn init`

## GitHub Release Blurb

This release includes a reusable marketing demo for `flutter_shadcn` and `shadcn_flutter_kit`: a 30-second square product video built from real Flutter components, plus a repeatable capture and QA workflow.
```

- [ ] **Step 2: Add README maintainer link**

Append this section near the maintainer/development part of `README.md`:

```markdown
## Marketing Demo

The repository includes a planned `marketing_demo` app for producing social video assets from real registry components. See:

- `docs/superpowers/specs/2026-05-12-marketing-video-kit-design.md`
- `docs/superpowers/plans/2026-05-12-marketing-video-kit.md`

When implemented, run `marketing_demo/tool/capture_square_video.sh` to export the square launch video and `marketing_demo/tool/qa_marketing_video.sh` to verify dimensions and duration.
```

- [ ] **Step 3: Commit docs**

Run:

```bash
git add README.md marketing_demo/marketing/captions.md
git commit -m "docs: add marketing video captions"
```

## Task 8: Final Verification And QA Export

**Files:**
- Modify: `marketing_demo/marketing/QA_REPORT.md`
- Generated, not committed unless requested: `marketing_demo/marketing/out/**`

- [ ] **Step 1: Run all demo tests**

Run:

```bash
cd marketing_demo
flutter test
```

Expected: all tests pass.

- [ ] **Step 2: Run analyzer**

Run:

```bash
cd marketing_demo
flutter analyze
```

Expected: no errors in marketing demo source or tests.

- [ ] **Step 3: Capture the video**

Run:

```bash
cd marketing_demo
tool/capture_square_video.sh
```

Expected:

- `marketing/out/shadcn-flutter-launch-square.mp4`
- `marketing/out/shadcn-flutter-launch-square-social.mp4`
- `marketing/out/shadcn-flutter-launch-thumbnail.png`

- [ ] **Step 4: Run video QA**

Run:

```bash
cd marketing_demo
tool/qa_marketing_video.sh
```

Expected: `Marketing video QA passed: 1080x1080, ...s`.

- [ ] **Step 5: Update QA report**

Update `marketing_demo/marketing/QA_REPORT.md` by checking off passed automated and visual checks. Add exact command results, including dimensions and duration.

- [ ] **Step 6: Commit final QA report**

Run:

```bash
git add marketing_demo/marketing/QA_REPORT.md
git commit -m "docs: record marketing video qa"
```

## Self-Review

- Spec coverage: The plan covers the square 30-second output, Studio Product tone, real Flutter demo app, CLI proof, component scenes, file picker, gooey toast, theme inversion, capture scripts, captions, thumbnail, and QA checklist.
- Placeholder scan: No task relies on unresolved future implementation. Each file has concrete responsibility and starter content.
- Type consistency: `MarketingVideoApp`, `MarketingVideoTimeline`, `MarketingVideoCopy`, scene IDs, and test references use consistent names across tasks.
- Scope control: Vertical and landscape exports remain follow-up work, matching the approved spec.
