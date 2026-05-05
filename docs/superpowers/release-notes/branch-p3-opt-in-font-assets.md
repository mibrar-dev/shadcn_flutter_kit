# Release Notes: branch-p3-opt-in-font-assets

Date: 2026-05-06

## Summary

This branch moves shared font binaries into explicit opt-in shared groups so
copy-paste consumers install only the typography and icon fonts their selected
components actually require.

## Consumer Impact

The consumer verification harness still builds after the selective asset split.

Generated consumer `pubspec.yaml` files must express installed fonts through
`flutter.fonts`, not raw `flutter.assets`, because installed widgets reference
concrete font families.

## Shared Font Group Contract

The current shared font contract is:

- `theme` carries `GeistSans`, `GeistMono`, and `NotoSansSymbols2`
- `lucide_icons` carries `LucideIcons`
- `radix_icons` carries `RadixIcons`
- `bootstrap_icons` carries `BootstrapIcons`

Consumers that install only components using `theme` plus `lucide_icons`
should not receive `RadixIcons` or `BootstrapIcons` in generated output.

## Verification Coverage

The branch adds a regression test at
`flutter_shadcn_kit/test/registry/consumer_fixture_font_pubspec_alignment_test.dart`
that compares:

- manifest-selected shared font assets
- the consumer fixture `flutter.fonts` declarations
- the consumer fixture copied `assets/fonts/**` tree

This keeps the generated install contract stable even when shared-group or
manifest logic changes later.
