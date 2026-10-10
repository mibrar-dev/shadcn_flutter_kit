// Named examples for the `pagination` component (P6-F3 preview contract).
//
// One focused demo per example; the first entry is the default. Spacing comes
// from the ambient theme, so the examples follow the selected preset and the
// site light/dark toggle.
//
// The control collapses to prev/ellipsis/current/next in narrow columns by
// itself, so the examples need no horizontal scroll view.

import 'package:flutter/widgets.dart';

import '../../foundation/component_preview.dart';
import 'pagination.dart';

/// An interactive labelled pager; the page lives in this example's state.
class _LabelledPagination extends StatefulWidget {
  const _LabelledPagination();

  @override
  State<_LabelledPagination> createState() => _LabelledPaginationState();
}

class _LabelledPaginationState extends State<_LabelledPagination> {
  int _page = 1;

  @override
  Widget build(BuildContext context) {
    return Pagination(
      page: _page,
      totalPages: 10,
      onPageChanged: (int page) => setState(() => _page = page),
    );
  }
}

Widget _labelled(BuildContext context) => const _LabelledPagination();

/// Page buttons without the "Page x of y" label.
Widget _iconOnly(BuildContext context) {
  return const Pagination(
    page: 5,
    totalPages: 12,
    showLabel: false,
    onPageChanged: _noop,
  );
}

void _noop(int page) {}

/// Named docs examples for `pagination`; the first entry is the default.
const List<ComponentPreview> paginationPreviews = <ComponentPreview>[
  ComponentPreview('Labelled', _labelled),
  ComponentPreview('Icon only', _iconOnly),
];
