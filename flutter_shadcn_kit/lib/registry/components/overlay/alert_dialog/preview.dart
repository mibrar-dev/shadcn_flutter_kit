// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/material.dart' as m;

import '../alert_dialog/alert_dialog.dart' as shadcn;
import '../../control/button/button.dart' as shadcn;

/// AlertDialogPreview defines a reusable type for this registry module.
class AlertDialogPreview extends m.StatelessWidget {
  const AlertDialogPreview({super.key});

  @override
  m.Widget build(m.BuildContext context) {
    return m.Scaffold(
      body: m.Center(
        child: shadcn.PrimaryButton(
          onPressed: () {
            /// Creates a `m.showDialog` instance.
            m.showDialog(
              context: context,
              builder: (context) {
                return shadcn.AlertDialog(
                  title: const m.Text('Alert title'),
                  content: const m.Text(
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
                  ),
                  actions: [
                    /// Creates a `shadcn.OutlineButton` instance.
                    shadcn.OutlineButton(
                      onPressed: () {
                        m.Navigator.pop(context);
                      },
                      child: const m.Text('Cancel'),
                    ),

                    /// Creates a `shadcn.PrimaryButton` instance.
                    shadcn.PrimaryButton(
                      onPressed: () {
                        m.Navigator.pop(context);
                      },
                      child: const m.Text('OK'),
                    ),
                  ],
                );
              },
            );
          },
          child: const m.Text('Show Alert Dialog'),
        ),
      ),
    );
  }
}
