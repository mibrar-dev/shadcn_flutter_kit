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
