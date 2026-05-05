# Flutter CLI Verification Example

This Flutter app is a smoke-test target for `flutter_shadcn_cli` install flows.
Its `.shadcn/config.json` points at the hosted GitHub registry under
`flutter_shadcn_kit/lib` and declares the manifest paths the CLI needs to
resolve components, schemas, the component index, theme index, and folder
structure.

This fixture is also the local contract check for generated consumer font
configuration:

- installed components currently include `button`, `card`, `dialog`, and
  `text_field`
- generated fonts must be declared under `flutter.fonts`, not raw
  `flutter.assets`
- the current selective shared-group install should include `LucideIcons`,
  `NotoSansSymbols2`, `GeistSans`, and `GeistMono`
- the current fixture must not carry `RadixIcons` or `BootstrapIcons`

Do not commit generated component installs from this example unless the smoke
test fixture intentionally changes.
