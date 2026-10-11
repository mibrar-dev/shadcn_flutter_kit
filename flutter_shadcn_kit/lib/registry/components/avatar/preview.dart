// Named examples for the `avatar` component (P6-F3 preview contract).
//
// One focused demo per example; the first entry is the default. Spacing comes
// from the ambient theme, so the examples follow the selected preset and the
// site light/dark toggle.

import 'dart:convert';

import 'package:flutter/widgets.dart';

import '../../foundation/component_preview.dart';
import '../../foundation/gap.dart';
import '../../foundation/icons/lucide_icons.dart';
import '../../theme/theme.dart';
import 'avatar.dart';

/// A 48x48 PNG decoded from memory: the preview never hits the network, so it
/// renders identically offline and inside a widget test.
const String _avatarPhotoBase64 =
    'iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAIAAADYYG7QAAAAWElEQVR42u3OoRGAMBBFwdPURBHoFIaj'
    'KTS9hBL+ROTUzjz/ts7xxZ73js1x5eqIFRAQEBAQ0CKoczarYkBAQEBAQKugzhkQEBAQENAWUOMMCAgIC'
    'AhoQz/vbpR28UARAAAAAABJRU5ErkJggg==';

/// Local photo provider shared by the avatar examples.
final ImageProvider _avatarPhoto = MemoryImage(
  base64Decode(_avatarPhotoBase64),
);

/// A photo avatar, with the initials fallback next to it.
Widget _avatarImage(BuildContext context) {
  final spacing = ShadcnTheme.of(context).spacing;
  return Row(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: <Widget>[
      Avatar(initials: 'IB', image: _avatarPhoto, size: 56),
      Gap(spacing.md),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Avatar(initials: 'AC', image: _avatarPhoto),
          Gap(spacing.sm),
          Avatar(initials: 'MK', image: _avatarPhoto, size: 40),
        ],
      ),
    ],
  );
}

/// Initials-only avatars at three sizes.
Widget _avatarInitials(BuildContext context) {
  final spacing = ShadcnTheme.of(context).spacing;
  return Row(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: <Widget>[
      const Avatar(initials: 'IB'),
      Gap(spacing.md),
      const Avatar(initials: 'AC', size: 40),
      Gap(spacing.md),
      const Avatar(initials: 'MK', size: 56),
    ],
  );
}

/// An avatar carrying a status badge.
Widget _avatarBadge(BuildContext context) {
  final spacing = ShadcnTheme.of(context).spacing;
  return Row(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: <Widget>[
      Avatar(
        initials: 'AC',
        badge: AvatarBadge(child: Icon(LucideIcons.check, size: 8)),
      ),
      Gap(spacing.md),
      const Avatar(
        initials: 'AC',
        badge: AvatarBadge(),
        badgeAlignment: AlignmentDirectional.topEnd,
      ),
    ],
  );
}

/// A stack of avatars.
Widget _avatarGroup(BuildContext context) {
  return const AvatarGroup(
    children: <Widget>[
      Avatar(initials: 'IB'),
      Avatar(initials: 'AC'),
      Avatar(initials: 'MK'),
      Avatar(initials: '+4'),
    ],
  );
}

/// Named docs examples for `avatar`; the first entry is the default.
const List<ComponentPreview> avatarPreviews = <ComponentPreview>[
  ComponentPreview('Image', _avatarImage),
  ComponentPreview('Initials', _avatarInitials),
  ComponentPreview('Badge', _avatarBadge),
  ComponentPreview('Group', _avatarGroup),
];
