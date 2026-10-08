// Gallery preview for the `scaffold` component: headers, body, footers,
// AppBar slots, loading states and a dark subtree. Widgets-only; the docs
// app embeds [ScaffoldPreview] directly.

import 'package:flutter/widgets.dart';

import '../../foundation/gap.dart';
import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';
import '../progress/progress.dart';
import 'scaffold.dart';

/// Renders the scaffold gallery.
class ScaffoldPreview extends StatelessWidget {
  /// Creates the preview.
  const ScaffoldPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: DefaultTextStyle(
        style: const TextStyle(fontSize: 13),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _section(
                'Shell',
                SizedBox(
                  height: 280,
                  child: Scaffold(
                    headers: <Widget>[
                      AppBar(
                        leading: <Widget>[const Text('‹')],
                        title: const Text('My Application'),
                        subtitle: const Text('Dashboard'),
                        trailing: <Widget>[const Text('⋯')],
                      ),
                    ],
                    footers: <Widget>[
                      AppBar(
                        title: const Text('Status'),
                        subtitle: const Text('All systems go'),
                      ),
                    ],
                    child: const Center(child: Text('Main content area')),
                  ),
                ),
              ),
              const Gap(24),
              _section(
                'Loading',
                SizedBox(
                  height: 160,
                  child: Scaffold(
                    headers: <Widget>[const AppBar(title: Text('Syncing'))],
                    loadingProgress: 0.4,
                    showLoadingSparks: true,
                    child: const Center(child: Text('Fetching…')),
                  ),
                ),
              ),
              const Gap(24),
              _section(
                'Floating header over content',
                SizedBox(
                  height: 160,
                  child: Scaffold(
                    floatingHeader: true,
                    headers: <Widget>[
                      AppBar(
                        surfaceOpacity: 0.8,
                        title: const Text('Overlay title'),
                      ),
                    ],
                    child: const ColoredBox(
                      color: Color(0xFF334155),
                      child: Center(child: Text('Full-bleed body')),
                    ),
                  ),
                ),
              ),
              const Gap(24),
              _section(
                'Dark',
                ShadcnTheme(
                  data: const ShadcnThemeData(
                    colors: ShadcnColors.darkFallback,
                  ),
                  child: SizedBox(
                    height: 200,
                    child: Scaffold(
                      headers: <Widget>[
                        const AppBar(title: Text('Dark shell')),
                      ],
                      loadingProgressIndeterminate: true,
                      child: const Center(child: Text('Body')),
                    ),
                  ),
                ),
              ),
              const Gap(24),
              _section(
                'Progress reference',
                const Progress(value: 0.6, showSparks: true),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _section(String title, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const Gap(8),
        child,
      ],
    );
  }
}
