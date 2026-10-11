// The landing announcement badge (spec §2.1): rounded-full secondary badge,
// 12/500, arrow icon, links to the docs.

import 'package:flutter/widgets.dart';

import '../ui/shadcn/components/badge/badge.dart';
import '../ui/shadcn/foundation/icons/lucide_icons.dart';

/// A pill badge with a trailing arrow, used at the top of the landing page.
class Announcement extends StatelessWidget {
  /// Creates the announcement.
  const Announcement({super.key, required this.label, required this.onPressed});

  /// Badge text.
  final String label;

  /// Tap target (navigates to the docs).
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: Badge(
        variant: BadgeVariant.secondary,
        onPressed: onPressed,
        theme: const BadgeStyle(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
          textStyle: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            height: 16 / 12,
          ),
        ),
        trailing: const Icon(LucideIcons.arrowRight, size: 12),
        child: SizedBox(
          // Keeps the pill single-line on narrow screens (test fonts are
          // wider than Geist); real Geist needs ~200 px.
          width: 260,
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            softWrap: false,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
