// GENERATED CODE - DO NOT MODIFY BY HAND.
//
// Sources:
//   * flutter_shadcn_kit/lib/registry/manifests/registry.json
//   * flutter_shadcn_kit/lib/registry/blocks/<id>/meta.json
//
// Regenerate: dart run tool/gen_docs_data.dart
//
// Every block, block family and block file list is derived from the
// registry manifest; the Blocks pages never hard-code block facts.
// Block sources (code view) live in lib/blocks/block_sources.dart,
// loaded with the deferred Blocks pages.

/// One installable block, generated from the registry manifest.
class DocsBlock {
  /// Creates a block entry.
  const DocsBlock({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.viewport,
    required this.install,
    required this.import,
    required this.files,
    required this.deps,
    required this.tags,
  });

  /// Registry id / route segment (`/blocks/<id>`).
  final String id;

  /// Display name (`Dashboard 01`).
  final String name;

  /// Block family (`Dashboard`, `Sidebar`, …).
  final String category;

  /// One-line description from the manifest.
  final String description;

  /// Viewport hint from `meta.json` (`desktop`, `mobile`).
  final String viewport;

  /// `flutter_shadcn add <id>` from the manifest.
  final String install;

  /// Corrected import line for the installed layout.
  final String import;

  /// Install-root-relative Dart files, entry first.
  final List<String> files;

  /// Component ids the block composes (manifest `deps`).
  final List<String> deps;

  /// Manifest tags, sorted.
  final List<String> tags;

  /// Route slug of the block family (`settings-account`).
  String get categorySlug => blockCategorySlug(category);

  /// Whether the block targets a phone viewport.
  bool get isMobile => viewport == 'mobile';
}

/// One block family (dashboard, sidebar, …) with its blocks.
class DocsBlockCategory {
  /// Creates a family entry.
  const DocsBlockCategory({required this.id, required this.blocks});

  /// Family name as written in `meta.json` (`Authentication`).
  final String id;

  /// Route slug (lower-case, hyphenated).
  String get slug => blockCategorySlug(id);

  /// The family's blocks, ordered by id.
  final List<DocsBlock> blocks;

  /// Number of blocks in the family.
  int get count => blocks.length;
}

/// Route slug of a block family (`Settings & Account`
/// → `settings-account`).
String blockCategorySlug(String id) {
  return id
      .toLowerCase()
      .replaceAll(RegExp('[^a-z0-9]+'), '-')
      .replaceAll(RegExp(r'^-|-$'), '');
}

/// All 16 installable blocks, ordered by family then id.
const List<DocsBlock> kBlocks = <DocsBlock>[
  DocsBlock(
    id: 'login-01',
    name: 'Login 01',
    category: 'Authentication',
    description:
        'A centred sign-in card with email, password and a create-account link.',
    viewport: 'desktop',
    install: 'flutter_shadcn add login-01',
    import:
        "import 'package:<your_app>/ui/shadcn/blocks/login-01/login_01.dart';",
    files: <String>['lib/ui/shadcn/blocks/login-01/login_01.dart'],
    deps: <String>[
      'alert',
      'button',
      'card',
      'checkbox',
      'divider',
      'form',
      'input',
      'spinner',
    ],
    tags: <String>['login', 'login01'],
  ),
  DocsBlock(
    id: 'login-02',
    name: 'Login 02',
    category: 'Authentication',
    description:
        'A split sign-in page: a validated form beside a testimonial panel.',
    viewport: 'desktop',
    install: 'flutter_shadcn add login-02',
    import:
        "import 'package:<your_app>/ui/shadcn/blocks/login-02/login_02.dart';",
    files: <String>[
      'lib/ui/shadcn/blocks/login-02/login_02.dart',
      'lib/ui/shadcn/blocks/login-02/login_02_panel.dart',
    ],
    deps: <String>['alert', 'button', 'form', 'input', 'spinner'],
    tags: <String>['login', 'login02'],
  ),
  DocsBlock(
    id: 'login-03',
    name: 'Login 03',
    category: 'Authentication',
    description:
        'A sign-in card with social provider buttons and an email form.',
    viewport: 'desktop',
    install: 'flutter_shadcn add login-03',
    import:
        "import 'package:<your_app>/ui/shadcn/blocks/login-03/login_03.dart';",
    files: <String>['lib/ui/shadcn/blocks/login-03/login_03.dart'],
    deps: <String>[
      'alert',
      'button',
      'card',
      'divider',
      'form',
      'input',
      'spinner',
    ],
    tags: <String>['login', 'login03'],
  ),
  DocsBlock(
    id: 'otp-01',
    name: 'Verify Email 01',
    category: 'Authentication',
    description: 'A one-time-code verification card with a resend countdown.',
    viewport: 'desktop',
    install: 'flutter_shadcn add otp-01',
    import: "import 'package:<your_app>/ui/shadcn/blocks/otp-01/otp_01.dart';",
    files: <String>['lib/ui/shadcn/blocks/otp-01/otp_01.dart'],
    deps: <String>[
      'alert',
      'button',
      'card',
      'divider',
      'form',
      'input_otp',
      'spinner',
    ],
    tags: <String>['otp', 'otp01'],
  ),
  DocsBlock(
    id: 'signup-01',
    name: 'Signup 01',
    category: 'Authentication',
    description:
        'A create-account card with name, email, password and a terms checkbox.',
    viewport: 'desktop',
    install: 'flutter_shadcn add signup-01',
    import:
        "import 'package:<your_app>/ui/shadcn/blocks/signup-01/signup_01.dart';",
    files: <String>['lib/ui/shadcn/blocks/signup-01/signup_01.dart'],
    deps: <String>[
      'alert',
      'button',
      'card',
      'checkbox',
      'form',
      'input',
      'spinner',
    ],
    tags: <String>['signup', 'signup01'],
  ),
  DocsBlock(
    id: 'signup-02',
    name: 'Signup 02',
    category: 'Authentication',
    description:
        'A two-column sign-up with a plan summary and a password strength meter.',
    viewport: 'desktop',
    install: 'flutter_shadcn add signup-02',
    import:
        "import 'package:<your_app>/ui/shadcn/blocks/signup-02/signup_02.dart';",
    files: <String>[
      'lib/ui/shadcn/blocks/signup-02/signup_02.dart',
      'lib/ui/shadcn/blocks/signup-02/signup_02_aside.dart',
      'lib/ui/shadcn/blocks/signup-02/signup_02_form.dart',
    ],
    deps: <String>[
      'alert',
      'button',
      'card',
      'checkbox',
      'divider',
      'form',
      'input',
      'progress',
      'spinner',
    ],
    tags: <String>['signup', 'signup02'],
  ),
  DocsBlock(
    id: 'calendar-01',
    name: 'Calendar 01',
    category: 'Calendar & Scheduling',
    description:
        'A date-range picker card with a two-month calendar and footer actions.',
    viewport: 'desktop',
    install: 'flutter_shadcn add calendar-01',
    import:
        "import 'package:<your_app>/ui/shadcn/blocks/calendar-01/calendar_01.dart';",
    files: <String>['lib/ui/shadcn/blocks/calendar-01/calendar_01.dart'],
    deps: <String>['button', 'calendar', 'card', 'divider'],
    tags: <String>['calendar', 'calendar01'],
  ),
  DocsBlock(
    id: 'calendar-02',
    name: 'Calendar 02',
    category: 'Calendar & Scheduling',
    description:
        "A scheduling panel: a month calendar beside the selected day's slots.",
    viewport: 'desktop',
    install: 'flutter_shadcn add calendar-02',
    import:
        "import 'package:<your_app>/ui/shadcn/blocks/calendar-02/calendar_02.dart';",
    files: <String>['lib/ui/shadcn/blocks/calendar-02/calendar_02.dart'],
    deps: <String>['button', 'calendar', 'card', 'divider'],
    tags: <String>['calendar', 'calendar02'],
  ),
  DocsBlock(
    id: 'dashboard-01',
    name: 'Dashboard 01',
    category: 'Dashboard',
    description:
        'A dashboard with stat tiles, a bar chart and a recent transactions table.',
    viewport: 'desktop',
    install: 'flutter_shadcn add dashboard-01',
    import:
        "import 'package:<your_app>/ui/shadcn/blocks/dashboard-01/dashboard_01.dart';",
    files: <String>[
      'lib/ui/shadcn/blocks/dashboard-01/dashboard_01.dart',
      'lib/ui/shadcn/blocks/dashboard-01/dashboard_01_table.dart',
    ],
    deps: <String>['avatar', 'button', 'card', 'divider', 'input', 'table'],
    tags: <String>['dashboard', 'dashboard01'],
  ),
  DocsBlock(
    id: 'dashboard-02',
    name: 'Dashboard 02',
    category: 'Dashboard',
    description:
        'An analytics workspace with a visitors chart, a device split and traffic sources.',
    viewport: 'desktop',
    install: 'flutter_shadcn add dashboard-02',
    import:
        "import 'package:<your_app>/ui/shadcn/blocks/dashboard-02/dashboard_02.dart';",
    files: <String>[
      'lib/ui/shadcn/blocks/dashboard-02/dashboard_02.dart',
      'lib/ui/shadcn/blocks/dashboard-02/dashboard_02_sections.dart',
    ],
    deps: <String>['button', 'card', 'divider', 'input', 'progress', 'tabs'],
    tags: <String>['dashboard', 'dashboard02'],
  ),
  DocsBlock(
    id: 'pricing-01',
    name: 'Pricing 01',
    category: 'Marketing',
    description:
        'A pricing section with three plans, a highlighted middle tier and a validated promo-code form.',
    viewport: 'desktop',
    install: 'flutter_shadcn add pricing-01',
    import:
        "import 'package:<your_app>/ui/shadcn/blocks/pricing-01/pricing_01.dart';",
    files: <String>[
      'lib/ui/shadcn/blocks/pricing-01/pricing_01.dart',
      'lib/ui/shadcn/blocks/pricing-01/pricing_01_promo.dart',
    ],
    deps: <String>[
      'alert',
      'badge',
      'button',
      'card',
      'divider',
      'form',
      'input_otp',
      'spinner',
    ],
    tags: <String>['pricing', 'pricing01'],
  ),
  DocsBlock(
    id: 'account-01',
    name: 'Account 01',
    category: 'Settings & Account',
    description:
        'An account settings screen with tabbed, validated profile and password forms.',
    viewport: 'desktop',
    install: 'flutter_shadcn add account-01',
    import:
        "import 'package:<your_app>/ui/shadcn/blocks/account-01/account_01.dart';",
    files: <String>[
      'lib/ui/shadcn/blocks/account-01/account_01.dart',
      'lib/ui/shadcn/blocks/account-01/account_01_password.dart',
      'lib/ui/shadcn/blocks/account-01/account_01_profile.dart',
      'lib/ui/shadcn/blocks/account-01/account_01_team.dart',
    ],
    deps: <String>[
      'alert',
      'avatar',
      'button',
      'card',
      'divider',
      'form',
      'input',
      'spinner',
      'tabs',
    ],
    tags: <String>['account', 'account01'],
  ),
  DocsBlock(
    id: 'account-02',
    name: 'Account 02',
    category: 'Settings & Account',
    description:
        'A notifications preferences screen with per-channel switches.',
    viewport: 'desktop',
    install: 'flutter_shadcn add account-02',
    import:
        "import 'package:<your_app>/ui/shadcn/blocks/account-02/account_02.dart';",
    files: <String>['lib/ui/shadcn/blocks/account-02/account_02.dart'],
    deps: <String>[
      'alert',
      'breadcrumb',
      'button',
      'card',
      'divider',
      'form',
      'spinner',
      'switch',
    ],
    tags: <String>['account', 'account02'],
  ),
  DocsBlock(
    id: 'sidebar-01',
    name: 'Sidebar 01',
    category: 'Sidebar',
    description:
        'A navigation rail beside a sample mailbox screen; a drawer on phones.',
    viewport: 'desktop',
    install: 'flutter_shadcn add sidebar-01',
    import:
        "import 'package:<your_app>/ui/shadcn/blocks/sidebar-01/sidebar_01.dart';",
    files: <String>[
      'lib/ui/shadcn/blocks/sidebar-01/sidebar_01.dart',
      'lib/ui/shadcn/blocks/sidebar-01/sidebar_01_content.dart',
    ],
    deps: <String>['button', 'card', 'divider', 'drawer'],
    tags: <String>['sidebar', 'sidebar01'],
  ),
  DocsBlock(
    id: 'sidebar-02',
    name: 'Sidebar 02',
    category: 'Sidebar',
    description:
        'An inset sidebar with grouped navigation and live search; a drawer on phones.',
    viewport: 'desktop',
    install: 'flutter_shadcn add sidebar-02',
    import:
        "import 'package:<your_app>/ui/shadcn/blocks/sidebar-02/sidebar_02.dart';",
    files: <String>[
      'lib/ui/shadcn/blocks/sidebar-02/sidebar_02.dart',
      'lib/ui/shadcn/blocks/sidebar-02/sidebar_02_content.dart',
      'lib/ui/shadcn/blocks/sidebar-02/sidebar_02_panel.dart',
    ],
    deps: <String>[
      'avatar',
      'badge',
      'button',
      'card',
      'divider',
      'drawer',
      'input',
      'progress',
    ],
    tags: <String>['sidebar', 'sidebar02'],
  ),
  DocsBlock(
    id: 'sidebar-03',
    name: 'Sidebar 03',
    category: 'Sidebar',
    description:
        'A full app shell: header with breadcrumb and search, grouped sidebar and content; the sidebar becomes a drawer on phones.',
    viewport: 'desktop',
    install: 'flutter_shadcn add sidebar-03',
    import:
        "import 'package:<your_app>/ui/shadcn/blocks/sidebar-03/sidebar_03.dart';",
    files: <String>[
      'lib/ui/shadcn/blocks/sidebar-03/sidebar_03.dart',
      'lib/ui/shadcn/blocks/sidebar-03/sidebar_03_content.dart',
    ],
    deps: <String>[
      'avatar',
      'badge',
      'breadcrumb',
      'button',
      'card',
      'divider',
      'drawer',
      'input',
      'progress',
    ],
    tags: <String>['sidebar', 'sidebar03'],
  ),
];

/// The 6 block families, alphabetical, with their blocks.
const List<DocsBlockCategory> kBlockCategories = <DocsBlockCategory>[
  DocsBlockCategory(
    id: 'Authentication',
    blocks: <DocsBlock>[
      DocsBlock(
        id: 'login-01',
        name: 'Login 01',
        category: 'Authentication',
        description:
            'A centred sign-in card with email, password and a create-account link.',
        viewport: 'desktop',
        install: 'flutter_shadcn add login-01',
        import:
            "import 'package:<your_app>/ui/shadcn/blocks/login-01/login_01.dart';",
        files: <String>['lib/ui/shadcn/blocks/login-01/login_01.dart'],
        deps: <String>[
          'alert',
          'button',
          'card',
          'checkbox',
          'divider',
          'form',
          'input',
          'spinner',
        ],
        tags: <String>['login', 'login01'],
      ),
      DocsBlock(
        id: 'login-02',
        name: 'Login 02',
        category: 'Authentication',
        description:
            'A split sign-in page: a validated form beside a testimonial panel.',
        viewport: 'desktop',
        install: 'flutter_shadcn add login-02',
        import:
            "import 'package:<your_app>/ui/shadcn/blocks/login-02/login_02.dart';",
        files: <String>[
          'lib/ui/shadcn/blocks/login-02/login_02.dart',
          'lib/ui/shadcn/blocks/login-02/login_02_panel.dart',
        ],
        deps: <String>['alert', 'button', 'form', 'input', 'spinner'],
        tags: <String>['login', 'login02'],
      ),
      DocsBlock(
        id: 'login-03',
        name: 'Login 03',
        category: 'Authentication',
        description:
            'A sign-in card with social provider buttons and an email form.',
        viewport: 'desktop',
        install: 'flutter_shadcn add login-03',
        import:
            "import 'package:<your_app>/ui/shadcn/blocks/login-03/login_03.dart';",
        files: <String>['lib/ui/shadcn/blocks/login-03/login_03.dart'],
        deps: <String>[
          'alert',
          'button',
          'card',
          'divider',
          'form',
          'input',
          'spinner',
        ],
        tags: <String>['login', 'login03'],
      ),
      DocsBlock(
        id: 'otp-01',
        name: 'Verify Email 01',
        category: 'Authentication',
        description:
            'A one-time-code verification card with a resend countdown.',
        viewport: 'desktop',
        install: 'flutter_shadcn add otp-01',
        import:
            "import 'package:<your_app>/ui/shadcn/blocks/otp-01/otp_01.dart';",
        files: <String>['lib/ui/shadcn/blocks/otp-01/otp_01.dart'],
        deps: <String>[
          'alert',
          'button',
          'card',
          'divider',
          'form',
          'input_otp',
          'spinner',
        ],
        tags: <String>['otp', 'otp01'],
      ),
      DocsBlock(
        id: 'signup-01',
        name: 'Signup 01',
        category: 'Authentication',
        description:
            'A create-account card with name, email, password and a terms checkbox.',
        viewport: 'desktop',
        install: 'flutter_shadcn add signup-01',
        import:
            "import 'package:<your_app>/ui/shadcn/blocks/signup-01/signup_01.dart';",
        files: <String>['lib/ui/shadcn/blocks/signup-01/signup_01.dart'],
        deps: <String>[
          'alert',
          'button',
          'card',
          'checkbox',
          'form',
          'input',
          'spinner',
        ],
        tags: <String>['signup', 'signup01'],
      ),
      DocsBlock(
        id: 'signup-02',
        name: 'Signup 02',
        category: 'Authentication',
        description:
            'A two-column sign-up with a plan summary and a password strength meter.',
        viewport: 'desktop',
        install: 'flutter_shadcn add signup-02',
        import:
            "import 'package:<your_app>/ui/shadcn/blocks/signup-02/signup_02.dart';",
        files: <String>[
          'lib/ui/shadcn/blocks/signup-02/signup_02.dart',
          'lib/ui/shadcn/blocks/signup-02/signup_02_aside.dart',
          'lib/ui/shadcn/blocks/signup-02/signup_02_form.dart',
        ],
        deps: <String>[
          'alert',
          'button',
          'card',
          'checkbox',
          'divider',
          'form',
          'input',
          'progress',
          'spinner',
        ],
        tags: <String>['signup', 'signup02'],
      ),
    ],
  ),
  DocsBlockCategory(
    id: 'Calendar & Scheduling',
    blocks: <DocsBlock>[
      DocsBlock(
        id: 'calendar-01',
        name: 'Calendar 01',
        category: 'Calendar & Scheduling',
        description:
            'A date-range picker card with a two-month calendar and footer actions.',
        viewport: 'desktop',
        install: 'flutter_shadcn add calendar-01',
        import:
            "import 'package:<your_app>/ui/shadcn/blocks/calendar-01/calendar_01.dart';",
        files: <String>['lib/ui/shadcn/blocks/calendar-01/calendar_01.dart'],
        deps: <String>['button', 'calendar', 'card', 'divider'],
        tags: <String>['calendar', 'calendar01'],
      ),
      DocsBlock(
        id: 'calendar-02',
        name: 'Calendar 02',
        category: 'Calendar & Scheduling',
        description:
            "A scheduling panel: a month calendar beside the selected day's slots.",
        viewport: 'desktop',
        install: 'flutter_shadcn add calendar-02',
        import:
            "import 'package:<your_app>/ui/shadcn/blocks/calendar-02/calendar_02.dart';",
        files: <String>['lib/ui/shadcn/blocks/calendar-02/calendar_02.dart'],
        deps: <String>['button', 'calendar', 'card', 'divider'],
        tags: <String>['calendar', 'calendar02'],
      ),
    ],
  ),
  DocsBlockCategory(
    id: 'Dashboard',
    blocks: <DocsBlock>[
      DocsBlock(
        id: 'dashboard-01',
        name: 'Dashboard 01',
        category: 'Dashboard',
        description:
            'A dashboard with stat tiles, a bar chart and a recent transactions table.',
        viewport: 'desktop',
        install: 'flutter_shadcn add dashboard-01',
        import:
            "import 'package:<your_app>/ui/shadcn/blocks/dashboard-01/dashboard_01.dart';",
        files: <String>[
          'lib/ui/shadcn/blocks/dashboard-01/dashboard_01.dart',
          'lib/ui/shadcn/blocks/dashboard-01/dashboard_01_table.dart',
        ],
        deps: <String>['avatar', 'button', 'card', 'divider', 'input', 'table'],
        tags: <String>['dashboard', 'dashboard01'],
      ),
      DocsBlock(
        id: 'dashboard-02',
        name: 'Dashboard 02',
        category: 'Dashboard',
        description:
            'An analytics workspace with a visitors chart, a device split and traffic sources.',
        viewport: 'desktop',
        install: 'flutter_shadcn add dashboard-02',
        import:
            "import 'package:<your_app>/ui/shadcn/blocks/dashboard-02/dashboard_02.dart';",
        files: <String>[
          'lib/ui/shadcn/blocks/dashboard-02/dashboard_02.dart',
          'lib/ui/shadcn/blocks/dashboard-02/dashboard_02_sections.dart',
        ],
        deps: <String>[
          'button',
          'card',
          'divider',
          'input',
          'progress',
          'tabs',
        ],
        tags: <String>['dashboard', 'dashboard02'],
      ),
    ],
  ),
  DocsBlockCategory(
    id: 'Marketing',
    blocks: <DocsBlock>[
      DocsBlock(
        id: 'pricing-01',
        name: 'Pricing 01',
        category: 'Marketing',
        description:
            'A pricing section with three plans, a highlighted middle tier and a validated promo-code form.',
        viewport: 'desktop',
        install: 'flutter_shadcn add pricing-01',
        import:
            "import 'package:<your_app>/ui/shadcn/blocks/pricing-01/pricing_01.dart';",
        files: <String>[
          'lib/ui/shadcn/blocks/pricing-01/pricing_01.dart',
          'lib/ui/shadcn/blocks/pricing-01/pricing_01_promo.dart',
        ],
        deps: <String>[
          'alert',
          'badge',
          'button',
          'card',
          'divider',
          'form',
          'input_otp',
          'spinner',
        ],
        tags: <String>['pricing', 'pricing01'],
      ),
    ],
  ),
  DocsBlockCategory(
    id: 'Settings & Account',
    blocks: <DocsBlock>[
      DocsBlock(
        id: 'account-01',
        name: 'Account 01',
        category: 'Settings & Account',
        description:
            'An account settings screen with tabbed, validated profile and password forms.',
        viewport: 'desktop',
        install: 'flutter_shadcn add account-01',
        import:
            "import 'package:<your_app>/ui/shadcn/blocks/account-01/account_01.dart';",
        files: <String>[
          'lib/ui/shadcn/blocks/account-01/account_01.dart',
          'lib/ui/shadcn/blocks/account-01/account_01_password.dart',
          'lib/ui/shadcn/blocks/account-01/account_01_profile.dart',
          'lib/ui/shadcn/blocks/account-01/account_01_team.dart',
        ],
        deps: <String>[
          'alert',
          'avatar',
          'button',
          'card',
          'divider',
          'form',
          'input',
          'spinner',
          'tabs',
        ],
        tags: <String>['account', 'account01'],
      ),
      DocsBlock(
        id: 'account-02',
        name: 'Account 02',
        category: 'Settings & Account',
        description:
            'A notifications preferences screen with per-channel switches.',
        viewport: 'desktop',
        install: 'flutter_shadcn add account-02',
        import:
            "import 'package:<your_app>/ui/shadcn/blocks/account-02/account_02.dart';",
        files: <String>['lib/ui/shadcn/blocks/account-02/account_02.dart'],
        deps: <String>[
          'alert',
          'breadcrumb',
          'button',
          'card',
          'divider',
          'form',
          'spinner',
          'switch',
        ],
        tags: <String>['account', 'account02'],
      ),
    ],
  ),
  DocsBlockCategory(
    id: 'Sidebar',
    blocks: <DocsBlock>[
      DocsBlock(
        id: 'sidebar-01',
        name: 'Sidebar 01',
        category: 'Sidebar',
        description:
            'A navigation rail beside a sample mailbox screen; a drawer on phones.',
        viewport: 'desktop',
        install: 'flutter_shadcn add sidebar-01',
        import:
            "import 'package:<your_app>/ui/shadcn/blocks/sidebar-01/sidebar_01.dart';",
        files: <String>[
          'lib/ui/shadcn/blocks/sidebar-01/sidebar_01.dart',
          'lib/ui/shadcn/blocks/sidebar-01/sidebar_01_content.dart',
        ],
        deps: <String>['button', 'card', 'divider', 'drawer'],
        tags: <String>['sidebar', 'sidebar01'],
      ),
      DocsBlock(
        id: 'sidebar-02',
        name: 'Sidebar 02',
        category: 'Sidebar',
        description:
            'An inset sidebar with grouped navigation and live search; a drawer on phones.',
        viewport: 'desktop',
        install: 'flutter_shadcn add sidebar-02',
        import:
            "import 'package:<your_app>/ui/shadcn/blocks/sidebar-02/sidebar_02.dart';",
        files: <String>[
          'lib/ui/shadcn/blocks/sidebar-02/sidebar_02.dart',
          'lib/ui/shadcn/blocks/sidebar-02/sidebar_02_content.dart',
          'lib/ui/shadcn/blocks/sidebar-02/sidebar_02_panel.dart',
        ],
        deps: <String>[
          'avatar',
          'badge',
          'button',
          'card',
          'divider',
          'drawer',
          'input',
          'progress',
        ],
        tags: <String>['sidebar', 'sidebar02'],
      ),
      DocsBlock(
        id: 'sidebar-03',
        name: 'Sidebar 03',
        category: 'Sidebar',
        description:
            'A full app shell: header with breadcrumb and search, grouped sidebar and content; the sidebar becomes a drawer on phones.',
        viewport: 'desktop',
        install: 'flutter_shadcn add sidebar-03',
        import:
            "import 'package:<your_app>/ui/shadcn/blocks/sidebar-03/sidebar_03.dart';",
        files: <String>[
          'lib/ui/shadcn/blocks/sidebar-03/sidebar_03.dart',
          'lib/ui/shadcn/blocks/sidebar-03/sidebar_03_content.dart',
        ],
        deps: <String>[
          'avatar',
          'badge',
          'breadcrumb',
          'button',
          'card',
          'divider',
          'drawer',
          'input',
          'progress',
        ],
        tags: <String>['sidebar', 'sidebar03'],
      ),
    ],
  ),
];
