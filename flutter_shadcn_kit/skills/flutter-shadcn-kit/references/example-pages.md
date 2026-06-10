# Flutter ShadCN Kit — Example Pages

These are complete, production-ready screen implementations using registry components. Each is a self-contained `StatefulWidget` or `StatelessWidget` you can drop into any project that has the shadcn kit installed.

---

## 1. Login / Sign-in Page

```dart
// ignore_for_file: duplicate_import
import 'package:flutter/material.dart' hide Card, TextField;
import '../components/control/button/button.dart';
import '../components/layout/card/card.dart';
import '../components/display/text/text.dart';
import '../components/form/text_field/text_field.dart';
import '../components/display/divider/divider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _loading = true);
    await Future.delayed(const Duration(seconds: 1)); // replace with real auth
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Card(
                padding: const EdgeInsets.all(32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Sign in').semiBold(),
                    const SizedBox(height: 4),
                    const Text('Enter your email and password to continue.').muted().small(),
                    const SizedBox(height: 24),

                    const Text('Email').semiBold().small(),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _emailController,
                      placeholder: const Text('you@example.com'),
                    ),
                    const SizedBox(height: 16),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Password').semiBold().small(),
                        LinkButton(
                          onPressed: () {},
                          child: const Text('Forgot password?').small(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _passwordController,
                      placeholder: const Text('••••••••'),
                      obscureText: true,
                      features: [InputFeature.passwordToggle()],
                    ),
                    const SizedBox(height: 24),

                    SizedBox(
                      width: double.infinity,
                      child: PrimaryButton(
                        onPressed: _loading ? null : _submit,
                        child: Text(_loading ? 'Signing in...' : 'Sign in'),
                      ),
                    ),
                    const SizedBox(height: 16),

                    const Divider(),
                    const SizedBox(height: 16),

                    SizedBox(
                      width: double.infinity,
                      child: OutlineButton(
                        onPressed: () {},
                        child: const Text('Continue with Google'),
                      ),
                    ),
                    const SizedBox(height: 12),

                    Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text("Don't have an account?").muted().small(),
                          const SizedBox(width: 4),
                          LinkButton(
                            onPressed: () {},
                            child: const Text('Sign up').small(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
```

---

## 2. Settings Page with Tabs

```dart
// ignore_for_file: duplicate_import
import 'package:flutter/material.dart' hide Card, TextField;
import '../components/control/button/button.dart';
import '../components/layout/card/card.dart';
import '../components/display/text/text.dart';
import '../components/form/text_field/text_field.dart';
import '../components/form/switch/switch.dart';
import '../components/navigation/tabs/tabs.dart';
import '../components/display/divider/divider.dart';

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
```

---

## 3. Dashboard Overview Page

```dart
// ignore_for_file: duplicate_import
import 'package:flutter/material.dart' hide Card;
import '../components/layout/card/card.dart';
import '../components/display/text/text.dart';
import '../components/display/badge/badge.dart';
import '../components/control/button/button.dart';
import '../components/display/progress/progress.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Dashboard').semiBold(),
                          const Text('Welcome back, Jane.').muted().small(),
                        ],
                      ),
                    ),
                    PrimaryButton(
                      onPressed: () {},
                      child: const Text('New project'),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Stats row
                LayoutBuilder(
                  builder: (context, constraints) {
                    final isWide = constraints.maxWidth > 600;
                    return isWide
                        ? Row(
                            children: [
                              Expanded(child: _StatCard(label: 'Total projects', value: '24', change: '+3 this month')),
                              const SizedBox(width: 16),
                              Expanded(child: _StatCard(label: 'Active users', value: '1,284', change: '+12% from last week')),
                              const SizedBox(width: 16),
                              Expanded(child: _StatCard(label: 'Revenue', value: '\$48,200', change: '+8% from last month')),
                              const SizedBox(width: 16),
                              Expanded(child: _StatCard(label: 'Open issues', value: '7', change: '-2 resolved today')),
                            ],
                          )
                        : Column(
                            children: [
                              _StatCard(label: 'Total projects', value: '24', change: '+3 this month'),
                              const SizedBox(height: 12),
                              _StatCard(label: 'Active users', value: '1,284', change: '+12% from last week'),
                              const SizedBox(height: 12),
                              _StatCard(label: 'Revenue', value: '\$48,200', change: '+8% from last month'),
                              const SizedBox(height: 12),
                              _StatCard(label: 'Open issues', value: '7', change: '-2 resolved today'),
                            ],
                          );
                  },
                ),
                const SizedBox(height: 24),

                // Recent projects
                Card(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(child: const Text('Recent projects').semiBold()),
                          GhostButton(onPressed: () {}, child: const Text('View all').small()),
                        ],
                      ),
                      const SizedBox(height: 16),
                      for (final project in _sampleProjects)
                        _ProjectRow(project: project),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static const _sampleProjects = [
    (name: 'Acme Website Redesign', status: 'active', progress: 0.72),
    (name: 'Mobile App v2.0', status: 'review', progress: 0.45),
    (name: 'API Integration', status: 'paused', progress: 0.30),
    (name: 'Marketing Campaign', status: 'completed', progress: 1.0),
  ];
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final String change;

  const _StatCard({required this.label, required this.value, required this.change});

  @override
  Widget build(BuildContext context) {
    return Card(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label).muted().small(),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text(change).muted().small(),
        ],
      ),
    );
  }
}

class _ProjectRow extends StatelessWidget {
  final ({String name, String status, double progress}) project;

  const _ProjectRow({required this.project});

  @override
  Widget build(BuildContext context) {
    final statusBadge = switch (project.status) {
      'active' => PrimaryBadge(child: const Text('Active')),
      'review' => SecondaryBadge(child: const Text('In Review')),
      'paused' => OutlineBadge(child: const Text('Paused')),
      'completed' => OutlineBadge(child: const Text('Completed')),
      _ => OutlineBadge(child: Text(project.status)),
    };

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(project.name).semiBold().small(),
                const SizedBox(height: 6),
                LinearProgressIndicator(
                  value: project.progress,
                  borderRadius: BorderRadius.circular(4),
                  minHeight: 6,
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          statusBadge,
        ],
      ),
    );
  }
}
```

---

## 4. Create / Edit Form Page

```dart
// ignore_for_file: duplicate_import
import 'package:flutter/material.dart' hide Card, TextField;
import '../components/control/button/button.dart';
import '../components/layout/card/card.dart';
import '../components/display/text/text.dart';
import '../components/form/text_field/text_field.dart';
import '../components/form/text_area/text_area.dart';
import '../components/form/select/select.dart';
import '../components/overlay/dialog/dialog.dart' as shadcn_dialog;
import '../components/layout/alert/alert.dart';

class CreateProjectPage extends StatefulWidget {
  const CreateProjectPage({super.key});

  @override
  State<CreateProjectPage> createState() => _CreateProjectPageState();
}

class _CreateProjectPageState extends State<CreateProjectPage> {
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  String? _selectedCategory;
  bool _saved = false;

  void _confirmDiscard() {
    shadcn_dialog.showDialog<void>(
      context: context,
      builder: (ctx) => Card(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Discard changes?').semiBold(),
            const SizedBox(height: 8),
            const Text('All unsaved changes will be lost. This cannot be undone.').muted().small(),
            const SizedBox(height: 20),
            Row(
              children: [
                const Spacer(),
                OutlineButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: const Text('Keep editing'),
                ),
                const SizedBox(width: 8),
                DestructiveButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    Navigator.of(context).pop();
                  },
                  child: const Text('Discard'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back button
                GhostButton(
                  onPressed: _confirmDiscard,
                  leading: const Icon(Icons.arrow_back, size: 16),
                  child: const Text('Back'),
                ),
                const SizedBox(height: 16),

                const Text('Create project').semiBold(),
                const SizedBox(height: 4),
                const Text('Fill in the details to create a new project.').muted().small(),
                const SizedBox(height: 24),

                if (_saved) ...[
                  const Alert(
                    title: Text('Project saved!'),
                    description: Text('Your project has been created successfully.'),
                  ),
                  const SizedBox(height: 16),
                ],

                Card(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Project name').semiBold().small(),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _nameController,
                        placeholder: const Text('e.g. Acme Website Redesign'),
                        features: [InputFeature.clear()],
                      ),
                      const SizedBox(height: 16),

                      const Text('Description').semiBold().small(),
                      const SizedBox(height: 6),
                      TextArea(
                        controller: _descController,
                        placeholder: const Text('Briefly describe the project goals...'),
                        minLines: 3,
                        maxLines: 6,
                      ),
                      const SizedBox(height: 16),

                      const Text('Category').semiBold().small(),
                      const SizedBox(height: 6),
                      Select<String>(
                        value: _selectedCategory,
                        onChanged: (v) => setState(() => _selectedCategory = v),
                        items: const [
                          SelectItem(value: 'design', child: Text('Design')),
                          SelectItem(value: 'engineering', child: Text('Engineering')),
                          SelectItem(value: 'marketing', child: Text('Marketing')),
                          SelectItem(value: 'research', child: Text('Research')),
                        ],
                        placeholder: const Text('Select a category'),
                      ),
                      const SizedBox(height: 24),

                      Row(
                        children: [
                          const Spacer(),
                          OutlineButton(
                            onPressed: _confirmDiscard,
                            child: const Text('Cancel'),
                          ),
                          const SizedBox(width: 8),
                          PrimaryButton(
                            onPressed: () => setState(() => _saved = true),
                            child: const Text('Create project'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
```

---

## 5. Onboarding / Steps Page

```dart
// ignore_for_file: duplicate_import
import 'package:flutter/material.dart' hide Card, TextField;
import '../components/control/button/button.dart';
import '../components/layout/card/card.dart';
import '../components/display/text/text.dart';
import '../components/form/text_field/text_field.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  int _step = 0;
  final _steps = ['Welcome', 'Profile', 'Preferences', 'Done'];
  final _nameController = TextEditingController();
  final _roleController = TextEditingController();

  void _next() {
    if (_step < _steps.length - 1) setState(() => _step++);
  }

  void _back() {
    if (_step > 0) setState(() => _step--);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: Column(
                children: [
                  // Step indicators
                  Row(
                    children: List.generate(_steps.length, (i) {
                      final isDone = i < _step;
                      final isActive = i == _step;
                      return Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 4,
                                decoration: BoxDecoration(
                                  color: (isDone || isActive)
                                      ? Theme.of(context).colorScheme.primary
                                      : Theme.of(context).colorScheme.outline,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ),
                            if (i < _steps.length - 1) const SizedBox(width: 4),
                          ],
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Step ${_step + 1} of ${_steps.length}').muted().small(),
                      Text(_steps[_step]).muted().small(),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Step content
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: KeyedSubtree(
                      key: ValueKey(_step),
                      child: _buildStep(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStep() {
    return switch (_step) {
      0 => Card(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('👋').large(),
              const SizedBox(height: 16),
              const Text('Welcome to the app').semiBold(),
              const SizedBox(height: 8),
              const Text("We're excited to have you. Let's get you set up in just a few steps.").muted().small(),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: PrimaryButton(onPressed: _next, child: const Text('Get started')),
              ),
            ],
          ),
        ),
      1 => Card(
          padding: const EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Your profile').semiBold(),
              const SizedBox(height: 4),
              const Text('Tell us a little about yourself.').muted().small(),
              const SizedBox(height: 20),
              const Text('Full name').semiBold().small(),
              const SizedBox(height: 6),
              TextField(
                controller: _nameController,
                placeholder: const Text('Jane Doe'),
              ),
              const SizedBox(height: 16),
              const Text('Job role').semiBold().small(),
              const SizedBox(height: 6),
              TextField(
                controller: _roleController,
                placeholder: const Text('e.g. Product Designer'),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  OutlineButton(onPressed: _back, child: const Text('Back')),
                  const Spacer(),
                  PrimaryButton(onPressed: _next, child: const Text('Continue')),
                ],
              ),
            ],
          ),
        ),
      2 => Card(
          padding: const EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Preferences').semiBold(),
              const SizedBox(height: 4),
              const Text('Customize your experience.').muted().small(),
              const SizedBox(height: 20),
              const Text('We'll use these to personalize your dashboard.').muted().small(),
              const SizedBox(height: 24),
              Row(
                children: [
                  OutlineButton(onPressed: _back, child: const Text('Back')),
                  const Spacer(),
                  PrimaryButton(onPressed: _next, child: const Text('Continue')),
                ],
              ),
            ],
          ),
        ),
      _ => Card(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('🎉').large(),
              const SizedBox(height: 16),
              const Text("You're all set!").semiBold(),
              const SizedBox(height: 8),
              const Text('Your account is ready. Start exploring the app.').muted().small(),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: PrimaryButton(onPressed: () {}, child: const Text('Go to dashboard')),
              ),
            ],
          ),
        ),
    };
  }
}
```

---

## Usage notes

- All examples use `hide Card, TextField` from `package:flutter/material.dart` to avoid naming conflicts with shadcn versions.
- Import paths shown are relative to the component's position in the registry — adjust to match your project structure.
- For a consuming app with CLI-installed components, replace paths with `package:<your_app>/ui/shadcn/components/...`.
- Text extension methods (`.semiBold()`, `.muted()`, `.small()`) require importing `components/display/text/text.dart`.
- Dialog requires aliased import: `import '..../dialog/dialog.dart' as shadcn_dialog;` to avoid conflict with Flutter's `showDialog`.
