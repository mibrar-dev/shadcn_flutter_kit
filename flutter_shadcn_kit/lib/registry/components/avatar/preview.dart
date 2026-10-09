// Gallery preview for the `avatar` component.
//
// Widgets-only, like the component itself. Shows initials, image, sizes,
// badges, groups, dark tokens and a scoped theme override.

import 'package:flutter/widgets.dart';

import '../../foundation/icons/lucide_icons.dart';
import '../../primitives/text/text_extension.dart';
import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';
import 'avatar.dart';

/// Preview entry point used by the docs gallery.
class AvatarPreview extends StatelessWidget {
  /// Creates the preview.
  const AvatarPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return ShadcnTheme(
      data: const ShadcnThemeData(),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: ColoredBox(
          color: const ShadcnThemeData().colors.background,
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text('Initials, sizes and badges').small,
                  const SizedBox(height: 12),
                  const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Avatar(initials: 'IB'),
                      SizedBox(width: 12),
                      Avatar(initials: 'IB', size: 56),
                      SizedBox(width: 12),
                      Avatar(
                        initials: 'AC',
                        badge: AvatarBadge(
                          child: Icon(LucideIcons.check, size: 8),
                        ),
                      ),
                      SizedBox(width: 12),
                      Avatar(
                        initials: 'AC',
                        badge: AvatarBadge(),
                        badgeAlignment: AlignmentDirectional.topEnd,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text('Group and theme override').small,
                  const SizedBox(height: 12),
                  const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      AvatarGroup(
                        children: <Widget>[
                          Avatar(initials: 'IB'),
                          Avatar(initials: 'AC'),
                          Avatar(initials: 'MK'),
                          Avatar(initials: '+4'),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  ComponentTheme<AvatarTheme>(
                    data: const AvatarTheme(
                      backgroundColor: ThemedColor.ref(ColorRef.secondary),
                      foregroundColor: ThemedColor.ref(
                        ColorRef.secondaryForeground,
                      ),
                    ),
                    child: const Avatar(initials: 'TM', size: 48),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
