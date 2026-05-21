// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/material.dart' as m;

import '../../control/button/button.dart';
import '../../layout/card/card.dart';
import '../dialog/dialog.dart' as shadcn;

/// DialogPreview defines a reusable type for this registry module.
class DialogPreview extends m.StatelessWidget {
  const DialogPreview({super.key});

  @override
  m.Widget build(m.BuildContext context) {
    return m.Scaffold(
      body: m.Center(
        child: PrimaryButton(
          onPressed: () {
            shadcn.showDialog<void>(
              context: context,
              builder: (context) {
                return Card(
                  padding: const m.EdgeInsets.all(24),
                  child: m.Column(
                    mainAxisSize: m.MainAxisSize.min,
                    crossAxisAlignment: m.CrossAxisAlignment.start,
                    children: [
                      /// Creates a `m.Text` instance.
                      const m.Text(
                        'Dialog title',
                        style: m.TextStyle(
                          fontSize: 18,
                          fontWeight: m.FontWeight.w600,
                        ),
                      ),

                      /// Creates a `m.SizedBox` instance.
                      const m.SizedBox(height: 12),

                      /// Creates a `m.Text` instance.
                      const m.Text('Use dialogs for important confirmations.'),

                      /// Creates a `m.SizedBox` instance.
                      const m.SizedBox(height: 20),

                      /// Creates a `m.Row` instance.
                      m.Row(
                        children: [
                          /// Creates a `m.Spacer` instance.
                          const m.Spacer(),

                          /// Creates a `OutlineButton` instance.
                          OutlineButton(
                            onPressed: () => m.Navigator.of(context).pop(),
                            child: const m.Text('Close'),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          },
          child: const m.Text('Open Dialog'),
        ),
      ),
    );
  }
}
