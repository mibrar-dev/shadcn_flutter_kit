// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/widgets.dart';

/// CommandQuery defines a reusable type for this registry module.
class CommandQuery {
  /// Stores `stream` state/configuration for this implementation.
  final Stream<List<Widget>> stream;

  /// Stores `query` state/configuration for this implementation.
  final String? query;

  CommandQuery({required this.stream, this.query});
}
