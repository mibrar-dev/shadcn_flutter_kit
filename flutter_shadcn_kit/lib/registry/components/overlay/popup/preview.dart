// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/material.dart';
import '../popup/popup.dart';

/// PopupPreview defines a reusable type for this registry module.
class PopupPreview extends StatelessWidget {
  const PopupPreview({super.key});

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: MenuPopup(
          children: const [
            /// Creates a `Padding` instance.
            Padding(padding: EdgeInsets.all(8), child: Text('Profile')),

            /// Creates a `Padding` instance.
            Padding(padding: EdgeInsets.all(8), child: Text('Settings')),

            /// Creates a `Divider` instance.
            Divider(height: 1),

            /// Creates a `Padding` instance.
            Padding(padding: EdgeInsets.all(8), child: Text('Sign out')),
          ],
        ),
      ),
    );
  }
}
