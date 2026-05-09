// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

// Network rules entry point with conditional exports.
// Uses dart:io mapping on IO platforms; returns an empty list on web via stub.

export 'network_rules_stub.dart' if (dart.library.io) 'network_rules_io.dart';
