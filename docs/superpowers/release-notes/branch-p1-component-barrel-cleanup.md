# Release Notes: branch-p1-component-barrel-cleanup

Date: 2026-05-05

## Summary

This branch reduces root-package export leakage by pushing some symbol filtering
into component libraries and by internalizing helper symbols that were never
intended to be public API.

## Consumer Impact

The consumer verification harness still builds without changes.

No top-level import-path changes were required for normal component usage.

## Consumer-Visible Export Changes

The following symbols are no longer exported from their component libraries:

- `formatFileSize` from `registry/components/form/file_picker/file_picker.dart`
- `NextItemIntent` from `registry/components/form/radio_group/radio_group.dart`
- `PreviousItemIntent` from `registry/components/form/radio_group/radio_group.dart`
- `FutureVoidCallback` from `registry/components/overlay/refresh_trigger/refresh_trigger.dart`
- `ErrorWidgetBuilder` from `registry/components/layout/flex/flex.dart`
- `Form` from `registry/components/layout/flex/flex.dart`
- `FormField` from `registry/components/layout/flex/flex.dart`
- `FormState` from `registry/components/layout/flex/flex.dart`
- `RadioGroup` from `registry/components/layout/flex/flex.dart`
- `TableCell` from `registry/components/layout/flex/flex.dart`

These were internal helper symbols and intent/typedef plumbing, not supported
component API. The `flex.dart` removals were transitive Flutter/sibling symbol
leaks rather than intended flex API. Consumers that were importing any of these
symbols directly from component barrels will need to stop depending on them.

## Root Barrel Cleanup

The generated root barrel no longer needs `hide` clauses for:

- `file_picker`
- `radio_group`
- `flex`
- `refresh_trigger`

Remaining `hide` clauses still exist for:

- `text_field`
- `scrollable`
- `table`
- `tabs`
- `menu`
