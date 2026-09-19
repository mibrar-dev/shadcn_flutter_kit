// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/material.dart';

import '../page_route/page_route.dart';

/// PageRoutePreview defines a reusable type for this registry module.
class PageRoutePreview extends StatelessWidget {
  const PageRoutePreview({super.key});

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: () {
          Navigator.of(context).push(
            ShadcnPageRoute(
              builder: (context) => const _PageRouteDemoPage(),
            ),
          );
        },
        child: const Text('Open page'),
      ),
    );
  }
}

/// Simple destination page for the [PageRoutePreview] demo.
class _PageRouteDemoPage extends StatelessWidget {
  const _PageRouteDemoPage();

  @override
  Widget build(BuildContext context) {
    return const Directionality(
      textDirection: TextDirection.ltr,
      child: Center(child: Text('Pushed via ShadcnPageRoute')),
    );
  }
}
