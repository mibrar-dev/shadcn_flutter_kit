// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/widgets.dart';

import '../../layout/scaffold/scaffold.dart';
import '../../../shared/icons/radix_icons.dart';
import '../../../shared/theme/theme.dart';
import 'empty_state.dart';

/// Core class used by the empty state component.
class EmptyStatePreview extends StatelessWidget {
  const EmptyStatePreview({super.key});

  /// Builds the widget tree for empty state.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      headers: const [AppBar(title: Text('Empty State'))],
      child: Builder(
        builder: (context) {
          final theme = Theme.of(context);

          final scaling = theme.scaling;
          final sectionStyle = theme.typography.medium.merge(
            theme.typography.semiBold,
          );
          return ListView(
            padding: EdgeInsets.all(24 * scaling),
            children: [
              Text('Simple (No Actions)', style: sectionStyle),

              const DensityGap(gapMd),

              const EmptyState(
                icon: Icon(RadixIcons.archive),
                title: Text('Nothing Here Yet'),
                description: Text('Create your first item to get started.'),
              ),

              const DensityGap(gap2xl),

              Text('Compact Card', style: sectionStyle),

              const DensityGap(gapMd),

              const EmptyState(
                size: EmptyStateSize.compact,
                icon: Icon(RadixIcons.magnifyingGlass),
                title: Text('No Results'),
                description: Text(
                  'Try adjusting your filters or search for a different keyword.',
                ),
                showIconContainer: false,
              ),

              const DensityGap(gap2xl),

              Text('Single Action', style: sectionStyle),

              const DensityGap(gapMd),

              const EmptyState(
                variant: EmptyStateVariant.errorFallback,
                title: Text('Something Went Wrong'),
                description: Text(
                  'We could not load this content right now. Please try again.',
                ),
                primaryAction: EmptyStateAction(label: 'Retry'),
              ),

              const DensityGap(gap2xl),

              Text('Two Actions', style: sectionStyle),

              const DensityGap(gapMd),

              const EmptyState(
                icon: Icon(RadixIcons.upload),
                title: Text('No Files Uploaded'),
                description: Text(
                  'Upload your first file or import from cloud storage.',
                ),
                primaryAction: EmptyStateAction(label: 'Upload Files'),
                secondaryAction: EmptyStateAction(
                  label: 'Import',
                  style: EmptyStateActionStyle.secondary,
                ),
              ),

              const DensityGap(gap2xl),

              Text('Complex / Product Empty Screen', style: sectionStyle),

              const DensityGap(gapMd),

              const EmptyState(
                icon: Icon(RadixIcons.filePlus),
                title: Text('No Projects Yet'),
                description: Text(
                  "You haven't created any projects yet. Get started by creating your first project.",
                ),
                primaryAction: EmptyStateAction(label: 'Create Project'),
                secondaryAction: EmptyStateAction(
                  label: 'Import Project',
                  style: EmptyStateActionStyle.secondary,
                ),
                footerAction: EmptyStateAction(
                  label: 'Learn More',
                  style: EmptyStateActionStyle.link,
                  trailingIcon: Icon(RadixIcons.arrowTopRight),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
