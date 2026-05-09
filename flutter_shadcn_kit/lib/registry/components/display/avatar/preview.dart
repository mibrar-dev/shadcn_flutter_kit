// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/material.dart';
import '../avatar/avatar.dart';

/// Core class used by the avatar component.
class AvatarPreview extends StatelessWidget {
  const AvatarPreview({super.key});

  /// Builds the widget tree for avatar.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              spacing: 24,
              children: [
                // Avatar with image and initials fallback
                Avatar(
                  backgroundColor: Colors.red,
                  initials: Avatar.getInitials('M Ibrar'),
                  provider: const NetworkImage(
                    'https://avatars.githubusercontent.com/u/64018564?v=4',
                  ),
                ),
                // Avatar with initials only
                Avatar(
                  backgroundColor: Colors.blue,
                  initials: Avatar.getInitials('John Doe'),
                ),
                // Avatar group
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Avatar(
                      backgroundColor: Colors.purple,
                      initials: Avatar.getInitials('Alice'),
                    ),

                    Avatar(
                      backgroundColor: Colors.green,
                      initials: Avatar.getInitials('Bob'),
                    ),

                    Avatar(
                      backgroundColor: Colors.orange,
                      initials: Avatar.getInitials('Charlie'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
