// Widgets-only preview gallery for the `async` component.
//
// Shows the synchronous path (one `done` snapshot), the pending path and the
// error path, plus a dark-token subtree.

import 'package:flutter/widgets.dart';

import '../../primitives/clickable.dart';
import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';
import '../spinner/spinner.dart';
import 'async.dart';

/// Preview entry point used by the docs gallery.
class AsyncPreview extends StatefulWidget {
  /// Creates the preview.
  const AsyncPreview({super.key});

  @override
  State<AsyncPreview> createState() => _AsyncPreviewState();
}

class _AsyncPreviewState extends State<AsyncPreview> {
  int _generation = 0;
  bool _fails = false;

  Future<String> _delayed() {
    final int generation = _generation;
    final bool fails = _fails;
    return Future<String>.delayed(const Duration(milliseconds: 600), () {
      if (fails) {
        throw StateError('load failed');
      }
      return 'loaded #$generation';
    });
  }

  @override
  Widget build(BuildContext context) {
    return ShadcnTheme(
      data: const ShadcnThemeData(),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: _body(context),
      ),
    );
  }

  Widget _body(BuildContext context) {
    final ShadcnColors colors = ShadcnTheme.of(context).colors;
    return ColoredBox(
      color: colors.background,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text('synchronous value'),
            FutureOrBuilder<String>(
              future: 'ready',
              builder: (context, snapshot) =>
                  Text('${snapshot.connectionState.name} / ${snapshot.data}'),
            ),
            const SizedBox(height: 20),
            const Text('pending future'),
            FutureOrBuilder<String>(
              future: _delayed(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text(snapshot.data!);
                }
                return const Spinner(size: 20);
              },
            ),
            const SizedBox(height: 20),
            const Text('error future'),
            FutureOrBuilder<String>(
              future: _delayed(),
              builder: (context, snapshot) =>
                  Text(snapshot.hasError ? 'error' : 'pending'),
            ),
            const SizedBox(height: 20),
            Clickable(
              onPressed: () => setState(() {
                _generation++;
                _fails = !_fails;
              }),
              child: const Text('reload futures'),
            ),
            SizedBox(height: ShadcnTheme.of(context).spacing.xl),
            ShadcnTheme(
              data: const ShadcnThemeData(colors: ShadcnColors.darkFallback),
              child: Builder(
                builder: (context) => ColoredBox(
                  color: ShadcnTheme.of(context).colors.card,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: FutureOrBuilder<int>(
                      future: 42,
                      builder: (context, snapshot) =>
                          Text('dark tokens / ${snapshot.data}'),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
