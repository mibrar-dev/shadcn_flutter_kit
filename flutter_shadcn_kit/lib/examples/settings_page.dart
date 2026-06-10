// ignore_for_file: duplicate_import, unnecessary_import
// Example: Settings Page with Tabs
// Uses: Tabs/TabItem, Card, TextField, Switch, Button, Text extensions, Divider

import 'package:flutter/material.dart' hide Card, TextField, Switch;
import '../registry/components/control/button/button.dart';
import '../registry/components/layout/card/card.dart';
import '../registry/components/display/text/text.dart';
import '../registry/components/form/text_field/text_field.dart';
import '../registry/components/form/switch/switch.dart';
import '../registry/components/navigation/tabs/tabs.dart';
import '../registry/components/display/divider/divider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  int _tabIndex = 0;
  bool _emailNotifications = true;
  bool _pushNotifications = false;
  bool _twoFactor = false;
  final _nameController = TextEditingController(text: 'Jane Doe');
  final _emailController = TextEditingController(text: 'jane@example.com');

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Settings').semiBold(),
                const SizedBox(height: 4),
                const Text('Manage your account and preferences.').muted().small(),
                const SizedBox(height: 24),

                Tabs(
                  index: _tabIndex,
                  onChanged: (i) => setState(() => _tabIndex = i),
                  children: const [
                    TabItem(child: Text('Profile')),
                    TabItem(child: Text('Notifications')),
                    TabItem(child: Text('Security')),
                  ],
                ),
                const SizedBox(height: 16),

                IndexedStack(
                  index: _tabIndex,
                  children: [
                    _ProfileTab(
                      nameController: _nameController,
                      emailController: _emailController,
                    ),
                    _NotificationsTab(
                      emailNotifications: _emailNotifications,
                      pushNotifications: _pushNotifications,
                      onEmailChanged: (v) => setState(() => _emailNotifications = v),
                      onPushChanged: (v) => setState(() => _pushNotifications = v),
                    ),
                    _SecurityTab(
                      twoFactor: _twoFactor,
                      onTwoFactorChanged: (v) => setState(() => _twoFactor = v),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfileTab extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;

  const _ProfileTab({required this.nameController, required this.emailController});

  @override
  Widget build(BuildContext context) {
    return Card(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Profile').semiBold(),
          const SizedBox(height: 4),
          const Text('Update your personal information.').muted().small(),
          const SizedBox(height: 20),

          const Text('Display name').semiBold().small(),
          const SizedBox(height: 6),
          TextField(
            controller: nameController,
            placeholder: const Text('Your name'),
          ),
          const SizedBox(height: 16),

          const Text('Email').semiBold().small(),
          const SizedBox(height: 6),
          TextField(
            controller: emailController,
            placeholder: const Text('you@example.com'),
          ),
          const SizedBox(height: 24),

          Row(
            children: [
              const Spacer(),
              OutlineButton(onPressed: () {}, child: const Text('Cancel')),
              const SizedBox(width: 8),
              PrimaryButton(onPressed: () {}, child: const Text('Save changes')),
            ],
          ),
        ],
      ),
    );
  }
}

class _NotificationsTab extends StatelessWidget {
  final bool emailNotifications;
  final bool pushNotifications;
  final ValueChanged<bool> onEmailChanged;
  final ValueChanged<bool> onPushChanged;

  const _NotificationsTab({
    required this.emailNotifications,
    required this.pushNotifications,
    required this.onEmailChanged,
    required this.onPushChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Notifications').semiBold(),
          const SizedBox(height: 4),
          const Text('Choose how you want to be notified.').muted().small(),
          const SizedBox(height: 20),

          _SwitchRow(
            label: 'Email notifications',
            description: 'Receive updates and alerts via email.',
            value: emailNotifications,
            onChanged: onEmailChanged,
          ),
          const Divider(),
          _SwitchRow(
            label: 'Push notifications',
            description: 'Receive real-time alerts on your device.',
            value: pushNotifications,
            onChanged: onPushChanged,
          ),
        ],
      ),
    );
  }
}

class _SecurityTab extends StatelessWidget {
  final bool twoFactor;
  final ValueChanged<bool> onTwoFactorChanged;

  const _SecurityTab({required this.twoFactor, required this.onTwoFactorChanged});

  @override
  Widget build(BuildContext context) {
    return Card(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Security').semiBold(),
          const SizedBox(height: 4),
          const Text('Manage your account security settings.').muted().small(),
          const SizedBox(height: 20),

          _SwitchRow(
            label: 'Two-factor authentication',
            description: 'Add an extra layer of security to your account.',
            value: twoFactor,
            onChanged: onTwoFactorChanged,
          ),
          const SizedBox(height: 20),
          const Divider(),
          const SizedBox(height: 20),

          const Text('Danger zone').semiBold().small(),
          const SizedBox(height: 12),
          OutlineButton(
            onPressed: () {},
            child: const Text('Change password'),
          ),
          const SizedBox(height: 8),
          DestructiveButton(
            onPressed: () {},
            child: const Text('Delete account'),
          ),
        ],
      ),
    );
  }
}

class _SwitchRow extends StatelessWidget {
  final String label;
  final String description;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SwitchRow({
    required this.label,
    required this.description,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label).semiBold().small(),
                const SizedBox(height: 2),
                Text(description).muted().small(),
              ],
            ),
          ),
          Switch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}
