// The `account-01` block: an account settings screen with validated forms.
//
// A block is layer 4 of the registry: it may import foundation, theme,
// primitives and components, never another block. Its public widget is the
// preview - the docs page renders it exactly as an app would.
//
// The shell is capped at 768px (max-w-3xl). The Profile tab is a validated
// form (name, username pattern, bio max length) in an equal-width 2-column
// grid that collapses to one column below 560px; the Password tab is a
// validated password-change form with a confirm-match check; the Team tab is
// a member list. The content shrink-wraps so the docs frame sizes to its
// intrinsic height, and scrolls internally when the host is bounded.

import 'dart:async';

import 'package:flutter/widgets.dart';

import '../../components/tabs/tabs.dart';
import '../../foundation/gap.dart';
import '../../theme/theme.dart';
import 'account_01_password.dart';
import 'account_01_profile.dart';
import 'account_01_team.dart';

/// Values submitted by the [Account01] profile form.

/// An account settings screen: tabbed profile, password and team sections.
class Account01 extends StatefulWidget {
  /// Creates the block.
  const Account01({
    super.key,
    this.onSubmitProfile,
    this.onSubmitPassword,
    this.onUploadAvatar,
    this.onInvite,
  });

  /// Called once with the typed values after a valid profile submit.
  final FutureOr<void> Function(Account01ProfileData data)? onSubmitProfile;

  /// Called once with the typed values after a valid password submit.
  final FutureOr<void> Function(Account01PasswordData data)? onSubmitPassword;

  /// Called when "Upload image" is tapped.
  final VoidCallback? onUploadAvatar;

  /// Called when "Invite member" is tapped.
  final VoidCallback? onInvite;

  @override
  State<Account01> createState() => _Account01State();
}

class _Account01State extends State<Account01> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    // Align loosens the width: a bare ConstrainedBox under the scroll view
    // would receive tight width and its maxWidth cap would be clamped away.
    final Widget body = Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 768),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text('Settings', style: theme.typography.h2),
            Gap(theme.spacing.xs),
            Text(
              'Manage your account settings and set your email preferences.',
              style: theme.typography.textMuted.copyWith(
                color: theme.colors.mutedForeground,
              ),
            ),
            Gap(theme.spacing.lg),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Tabs(
                index: _tab,
                onChanged: (int value) => setState(() => _tab = value),
                children: const <TabItem>[
                  TabItem(child: Text('Profile')),
                  TabItem(child: Text('Password')),
                  TabItem(child: Text('Team')),
                ],
              ),
            ),
            Gap(theme.spacing.lg),
            switch (_tab) {
              0 => Account01ProfileForm(
                onSubmit: widget.onSubmitProfile,
                onUploadAvatar: widget.onUploadAvatar,
              ),
              1 => Account01PasswordForm(onSubmit: widget.onSubmitPassword),
              _ => Account01Team(onInvite: widget.onInvite),
            },
          ],
        ),
      ),
    );
    return ColoredBox(
      color: theme.colors.background,
      child: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            if (!constraints.maxHeight.isFinite) {
              return Padding(
                padding: EdgeInsets.all(theme.spacing.lg),
                child: body,
              );
            }
            return SingleChildScrollView(
              padding: EdgeInsets.all(theme.spacing.lg),
              child: body,
            );
          },
        ),
      ),
    );
  }
}
