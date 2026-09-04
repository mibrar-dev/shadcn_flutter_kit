// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../tabs.dart';

// NOTE: Text styling for tabs is provided by the canonical `TextExtension`
// from `registry/components/display/text/text.dart` (imported by `tabs.dart`).
// The former local `TabsTextStyleExtensions` (`muted`/`foreground`/`small`/
// `medium`) was removed because it duplicated `TextExtension` and caused
// `ambiguous_extension_member_access` errors in any file importing both
// `text.dart` and `tabs.dart`.
// Migration: use `TextExtension` instead — e.g. `Text('x').muted().small()`.
// Visual output is identical (same theme color/typography values).
