// Loads a page from a deferred library.
//
// The docs router's page builder is synchronous, but the heaviest generated
// data (component API tables, README snippets and the per-preset theme
// sources) is only needed on `/docs/components/*` and `/themes`. Importing
// those pages with `deferred as` moves that data into a separate chunk, so the
// landing route no longer ships it (plan §1.8). This widget kicks off
// `loadLibrary()` and swaps in the page once it resolves.

import 'package:flutter/widgets.dart';

import '../ui/shadcn/theme/theme.dart';

/// Builds [builder] after [load] (a deferred `loadLibrary`) completes.
class DeferredPage extends StatefulWidget {
  /// Creates a deferred page.
  const DeferredPage({super.key, required this.load, required this.builder});

  /// The deferred library loader (`<prefix>.loadLibrary`).
  final Future<void> Function() load;

  /// Builds the real page once loaded.
  final Widget Function(BuildContext context) builder;

  @override
  State<DeferredPage> createState() => _DeferredPageState();
}

class _DeferredPageState extends State<DeferredPage> {
  late final Future<void> _loaded = widget.load();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _loaded,
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return widget.builder(context);
        }
        // One-frame placeholder while the chunk downloads; painted with the
        // active preset background so there is no flash.
        return ColoredBox(
          color: ShadcnTheme.of(context).colors.background,
          child: const SizedBox.expand(),
        );
      },
    );
  }
}
