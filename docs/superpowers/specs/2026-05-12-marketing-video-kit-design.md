# Marketing Video Kit Design

## Goal

Create a reusable marketing video kit for the `flutter_shadcn` CLI and `shadcn_flutter_kit` component registry. The first output is a polished 30-second square social video that shows real Flutter components, CLI installation, theming, overlays, and production-ready app setup.

The video should feel credible and product-led, not like a slow tutorial. It should prove that the CLI installs real Flutter UI components while still being visually strong enough for social feeds.

## Primary Output

- Format: square `1080x1080`
- Duration: about 30 seconds
- Tone: Studio Product
- Message: "Production-ready Flutter UI components with theming, overlays, and CLI install."
- Footage source: real Flutter components rendered from the registry, not fake UI mockups
- Primary audience: Flutter developers evaluating whether to try the CLI and library

Secondary exports can be derived later for vertical `9:16` and landscape `16:9`.

## Storyboard

### 0-3s: Product Claim

Open with a clean component grid and the primary message. The first frame must clearly identify the product category:

> Production-ready Flutter UI components

Supporting text can mention theming, overlays, and CLI install. The design should be quiet, sharp, and high contrast.

### 3-8s: CLI Proof

Show a terminal-style panel with real commands:

```bash
flutter_shadcn init
flutter_shadcn add button text_field gooey_toast
```

The CLI section should move quickly. Its job is proof, not instruction.

### 8-20s: Component Showcase

Show real Flutter scenes using installed registry components:

- buttons with multiple states
- text fields and form validation states
- cards, badges, table/form surface examples
- theme-aware typography and color
- file picker preview card
- gooey toast trigger surface

Scenes should be dense enough to feel useful but not crowded.

### 20-26s: App Capabilities

Show the system-level pieces that make the library production-ready:

- `ShadcnApp`
- theme switching
- overlay manager behavior
- gooey toast animation
- file picker example behavior
- localization readiness

The gooey toast must invert colors against the current mode: dark gooey visuals in light mode and light gooey visuals in dark mode.

### 26-30s: CTA

End with a clean command and destination:

```bash
flutter_shadcn init
```

Default CTA target for the first pass:

```text
github.com/ibrar-x/shadcn_flutter_kit
```

## Demo App Design

Build a dedicated marketing demo route or app that uses real registry components installed through the CLI. It should not be a static mockup.

The default implementation should be a new `marketing_demo` Flutter app. A separate app keeps video timing, capture dependencies, and demo-only assets out of the docs product. Reusing the docs app is acceptable only if implementation discovery shows it is significantly cheaper without compromising isolation.

The demo should include an autoplay video mode so the capture is deterministic. In video mode:

- scenes advance on timers
- focus, hover, typing, validation, toast, and theme states are simulated
- the file picker example has a deterministic display path suitable for recording
- the final frame holds long enough to read

The app should be reusable for future videos and screenshots.

## Capture Workflow

The capture should be scriptable:

1. Run the Flutter demo at a fixed square viewport.
2. Start the autoplay video route.
3. Record the 30-second sequence.
4. Export with FFmpeg.
5. Save the final MP4 and thumbnail.

Expected outputs:

- `shadcn-flutter-launch-square.mp4`
- `shadcn-flutter-launch-square-social.mp4`
- `shadcn-flutter-launch-thumbnail.png`

## Caption Pack

Prepare short posting copy with the final video:

- X/LinkedIn caption
- Instagram/Reels caption
- GitHub release blurb

The copy should emphasize real Flutter components, CLI install, theming, overlays, and production-ready setup.

## QA Checklist

Before delivery, verify:

- video exports at `1080x1080`
- duration is about 30 seconds
- all visible UI is rendered from real Flutter components
- CLI commands are readable
- captions and labels do not overlap
- dark and light modes are legible
- gooey toast visibly animates
- gooey colors invert against theme mode
- file picker example visibly works in a deterministic way
- `ShadcnApp`, overlay manager, and localization support are represented
- final CTA is readable
- thumbnail frame is clear at feed size

## Non-Goals

- Do not build a full tutorial video for the first pass.
- Do not create fake component footage if real Flutter rendering is feasible.
- Do not target every platform first. Start with square and derive other formats later.
- Do not hand-record a one-off workflow if a scriptable capture path is practical.

## Implementation Defaults

- CTA URL: `github.com/ibrar-x/shadcn_flutter_kit`
- Preferred app location: new `marketing_demo` Flutter app
- First showcase components: `app`, `button`, `text_field`, `card`, `badge`, `table`, `file_picker`, and `gooey_toast`
- First export only: square `1080x1080`; vertical and landscape are follow-up adaptations
