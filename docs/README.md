# docs

Flutter web documentation app for the shadcn Flutter kit.

The user-facing install and command walkthrough lives in the website at
`/#/complete-guide`. Keep that page aligned with the CLI markdown guide in
`flutter_shadcn_cli/docs/user/complete-guide.md` when command behavior changes.

## Registry docs workflow

The docs app consumes the production registry layout:

- Per-component `meta.json` lives at the component top level.
- README-derived `<id>.meta.json` lives beside the component README.
- Per-component `theme.schema.json` lives at the component top level.
- Nested component `registry/` metadata directories are legacy compatibility output and should be removed when no longer needed.
- `docs/lib/ui/shadcn` is a generated mirror of the registry. Do not edit files there directly.

Refresh registry metadata and docs snapshots from the package root:

```bash
dart run tool/registry/registry_readme_meta.dart
dart run tool/registry/registry_sync_all.dart --force
dart run tool/registry/registry_index_generate.dart
dart run tool/registry/registry_verify.dart
```

Install registry components into this docs app when the generated mirror needs to be rebuilt:

```bash
make docs-install
```

Generate the registry barrel and docs component pages:

```bash
make docs-barrel
make docs-generate
```

Or run everything in one step:

```bash
make docs-refresh
```
