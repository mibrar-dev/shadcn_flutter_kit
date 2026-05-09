import 'package:flutter/material.dart' as m;

import 'circle_spinner.dart';
import '../spinner/spinner.dart';

/// Core class used by the spinner component.
class SpinnerPreview extends m.StatelessWidget {
  const SpinnerPreview({super.key});

  @override
  m.Widget build(m.BuildContext context) {
    return m.Scaffold(
      body: m.Center(
        child: m.Wrap(
          spacing: 32,
          runSpacing: 32,
          children: const [
            CircleSpinner(),

            CircleSpinner(size: 20),

            CircleSpinner(size: 32),

            CircleSpinner(size: 48),

            CircleSpinner(color: m.Colors.blue),

            CircleSpinner(color: m.Colors.green),

            CircleSpinner(color: m.Colors.orange),

            CircleSpinner(color: m.Colors.red),
          ],
        ),
      ),
    );
  }
}
