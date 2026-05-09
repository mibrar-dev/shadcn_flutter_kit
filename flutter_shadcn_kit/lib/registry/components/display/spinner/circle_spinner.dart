// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/material.dart' as m;

import 'spinner.dart';

/// Core class used by the spinner component.
class CircleSpinner extends Spinner {
  const CircleSpinner({super.key, super.color, super.size});

  @override
  m.Widget build(m.BuildContext context) {
    final resolvedSize = resolveSize(context, 24);

    final resolvedColor = resolveColor(context);
    return m.SizedBox(
      width: resolvedSize,
      height: resolvedSize,
      child: m.CircularProgressIndicator(
        strokeWidth: resolvedSize / 8,
        valueColor: resolvedColor == null
            ? null
            : m.AlwaysStoppedAnimation<m.Color>(resolvedColor),
      ),
    );
  }
}
