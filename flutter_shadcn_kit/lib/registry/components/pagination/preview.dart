// Gallery preview for the `pagination` component: labelled, icon-only, edge
// windows and the dark palette. Widgets-only; the docs app embeds
// [PaginationPreview] directly.

import 'package:flutter/widgets.dart';

import '../../foundation/gap.dart';
import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';
import 'pagination.dart';

/// Renders the pagination gallery.
class PaginationPreview extends StatefulWidget {
  /// Creates the preview.
  const PaginationPreview({super.key});

  @override
  State<PaginationPreview> createState() => _PaginationPreviewState();
}

class _PaginationPreviewState extends State<PaginationPreview> {
  int _page = 1;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return Directionality(
      textDirection: TextDirection.ltr,
      child: DefaultTextStyle(
        style: TextStyle(color: theme.colors.foreground, fontSize: 13),
        child: ColoredBox(
          color: theme.colors.background,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _section('Labelled (interactive)', _labelled()),
                const Gap(24),
                _section('Icon only', _iconOnly()),
                const Gap(24),
                _section('First window', _firstWindow()),
                const Gap(24),
                _section('Last window', _lastWindow()),
                const Gap(24),
                _section('Dark', _dark()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _labelled() {
    return Pagination(
      page: _page,
      totalPages: 20,
      onPageChanged: (int page) => setState(() => _page = page),
    );
  }

  Widget _iconOnly() {
    return const Pagination(
      page: 5,
      totalPages: 12,
      showLabel: false,
      onPageChanged: _noop,
    );
  }

  Widget _firstWindow() {
    return const Pagination(page: 1, totalPages: 20, onPageChanged: _noop);
  }

  Widget _lastWindow() {
    return const Pagination(page: 20, totalPages: 20, onPageChanged: _noop);
  }

  Widget _dark() {
    return const ShadcnTheme(
      data: ShadcnThemeData(colors: ShadcnColors.darkFallback),
      child: Pagination(
        page: 3,
        totalPages: 8,
        showLabel: false,
        onPageChanged: _noop,
      ),
    );
  }

  static void _noop(int page) {}

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
