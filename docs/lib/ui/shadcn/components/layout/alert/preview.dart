// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/material.dart';
import '../alert/alert.dart';

/// AlertPreview defines a reusable type for this registry module.
class AlertPreview extends StatelessWidget {
  const AlertPreview({super.key});

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: 600,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: 16,
                children: [
                  // Basic alert
                  /// Creates a `Alert` instance.
                  const Alert(
                    title: Text('Alert title'),
                    content: Text('This is alert content.'),
                    leading: Icon(Icons.info_outline),
                  ),
                  // Destructive alert
                  /// Creates a `Alert.destructive` instance.
                  const Alert.destructive(
                    title: Text('Error'),
                    content: Text(
                      'Your session has expired. Please log in again.',
                    ),
                    leading: Icon(Icons.error_outline),
                  ),
                  // Alert with trailing action
                  /// Creates a `Alert` instance.
                  Alert(
                    title: const Text('Notification'),
                    content: const Text('You have a new message.'),
                    leading: const Icon(Icons.notifications_outlined),
                    trailing: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
