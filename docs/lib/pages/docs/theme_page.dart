import 'package:docs/shadcn_ui.dart';
import 'package:docs/ui/shadcn/components/form/slider/_impl/core/shad_slider_models.dart'
    show ShadRangeValue;
import 'package:docs/ui/shadcn/components/overlay/menu/menu.dart'
    show MenuButton;

import '../../theme/theme_controller.dart';
import '../../ui/shadcn/shared/theme/preset_themes.dart';
import '../docs_page.dart';
import 'blocks.dart';

const Map<String, String> _themeModes = {
  'Light': 'light',
  'Dark': 'dark',
};

const Map<String, double> _radiusOptions = {
  'Sharp': 0.0,
  'Subtle': 0.25,
  'Default': 0.5,
  'Rounded': 0.75,
  'Pill': 1.5,
};

const Map<String, double> _scalingOptions = {
  'Compact': 0.85,
  'Default': 1.0,
  'Large': 1.15,
};

const Map<String, Density> _densityOptions = {
  'Compact': Density.compactDensity,
  'Reduced': Density.reducedDensity,
  'Default': Density.defaultDensity,
  'Spacious': Density.spaciousDensity,
};

const Map<String, double> _surfaceOpacityOptions = {
  'Solid': 1.0,
  'Frosted': 0.94,
  'Translucent': 0.86,
  'Ghosted': 0.78,
};

const Map<String, double> _surfaceBlurOptions = {
  'None': 0.0,
  'Soft': 4.0,
  'Medium': 8.0,
  'Strong': 12.0,
};

class ThemePage extends StatefulWidget {
  const ThemePage({super.key});

  @override
  State<ThemePage> createState() => _ThemePageState();
}

class _ThemePageState extends State<ThemePage> {
  late String _basePresetId;
  late String _accentPresetId;
  bool _presetSelectionsReady = false;

  final ValueNotifier<bool> _previewSwitch = ValueNotifier(true);
  final ValueNotifier<CheckboxState> _previewCheckbox =
      ValueNotifier(CheckboxState.checked);
  final ValueNotifier<ShadRangeValue> _priceRange =
      ValueNotifier(const ShadRangeValue(320, 800));
  final ValueNotifier<int> _gpuCount = ValueNotifier(8);
  final ValueNotifier<String> _composerMode = ValueNotifier('Auto');

  static const double _kitchenColumnGap = 24;
  static const double _kitchenSectionGap = 20;

  List<DocsThemePreset> get _presetOptions => DocsThemeController.presets;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_presetSelectionsReady) return;
    _initializePresetSelections(context.docsThemeController);
  }

  @override
  void dispose() {
    _previewSwitch.dispose();
    _previewCheckbox.dispose();
    _priceRange.dispose();
    _gpuCount.dispose();
    _composerMode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.docsThemeController;
    final showInlineOptions =
        MediaQuery.of(context).size.width < breakpointWidth2;

    if (!_presetSelectionsReady) {
      _initializePresetSelections(controller);
    }

    return DocsPage(
      name: 'theme',
      onThisPage: const {},
      sidebar: SizedBox(
        width: 252,
        child: _buildOptionsPanel(context),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('Theme').h1(),
              const SizedBox(height: 12),
              const DocsParagraph(
                text:
                    'Pick registry presets, mix base and accent from different themes, and preview the result in a full component kitchen.',
              ),
              const SizedBox(height: 20),
              if (showInlineOptions) ...[
                _buildOptionsPanel(context),
                const SizedBox(height: 24),
              ],
              _buildKitchenPreview(context),
              const SizedBox(height: 28),
              const Text('Code').h2(),
              const SizedBox(height: 12),
              const Text('Generated Theme Preset').semiBold(),
              const SizedBox(height: 8),
              DocsCodeBlock(code: _buildPresetCodeSnippet(controller)),
              const SizedBox(height: 16),
              const Text('ShadcnApp Usage').semiBold(),
              const SizedBox(height: 8),
              DocsCodeBlock(code: _buildAppCodeSnippet(controller)),
            ],
          );
        },
      ),
    );
  }

  void _initializePresetSelections(DocsThemeController controller) {
    final currentBrightness = controller.brightness;

    if (controller.presetId != 'custom' && _hasPreset(controller.presetId)) {
      _basePresetId = controller.presetId;
      _accentPresetId = controller.presetId;
    } else {
      _basePresetId = _closestBasePresetId(
        scheme: controller.data.colorScheme,
        brightness: currentBrightness,
      );
      _accentPresetId = _closestAccentPresetId(
        scheme: controller.data.colorScheme,
        brightness: currentBrightness,
      );
    }

    _presetSelectionsReady = true;
  }

  bool _hasPreset(String id) {
    return _presetOptions.any((preset) => preset.id == id);
  }

  DocsThemePreset _presetForId(String id) {
    return _presetOptions.firstWhere(
      (preset) => preset.id == id,
      orElse: () => _presetOptions.first,
    );
  }

  ColorScheme _schemeForPreset(String id, Brightness brightness) {
    final preset = _presetForId(id);
    return brightness == Brightness.dark ? preset.dark : preset.light;
  }

  RegistryThemePresetTokens _tokensForPreset(String id, Brightness brightness) {
    final preset = _presetForId(id);
    return brightness == Brightness.dark
        ? preset.darkTokens
        : preset.lightTokens;
  }

  ColorScheme _mixedScheme({
    required ColorScheme baseScheme,
    required ColorScheme accentScheme,
  }) {
    return baseScheme.copyWith(
      primary: () => accentScheme.primary,
      primaryForeground: () => accentScheme.primaryForeground,
      accent: () => accentScheme.accent,
      accentForeground: () => accentScheme.accentForeground,
      ring: () => accentScheme.ring,
      chart1: () => accentScheme.chart1,
      chart2: () => accentScheme.chart2,
      chart3: () => accentScheme.chart3,
      chart4: () => accentScheme.chart4,
      chart5: () => accentScheme.chart5,
      sidebarPrimary: () => accentScheme.sidebarPrimary,
      sidebarPrimaryForeground: () => accentScheme.sidebarPrimaryForeground,
      sidebarAccent: () => accentScheme.sidebarAccent,
      sidebarAccentForeground: () => accentScheme.sidebarAccentForeground,
      sidebarRing: () => accentScheme.sidebarRing,
    );
  }

  ColorScheme _schemeForSelection(Brightness brightness) {
    final baseScheme = _schemeForPreset(_basePresetId, brightness);
    if (_basePresetId == _accentPresetId) {
      return baseScheme;
    }
    final accentScheme = _schemeForPreset(_accentPresetId, brightness);
    return _mixedScheme(baseScheme: baseScheme, accentScheme: accentScheme);
  }

  void _updateThemeMode(DocsThemeController controller, bool isDark) {
    controller.setBrightness(isDark ? Brightness.dark : Brightness.light);
    _applyPresetSelections(controller, baseChanged: false);
  }

  void _updateBasePreset(
      DocsThemeController controller, String nextBasePresetId) {
    if (_basePresetId == nextBasePresetId) return;
    setState(() {
      _basePresetId = nextBasePresetId;
    });
    _applyPresetSelections(controller, baseChanged: true);
  }

  void _updateAccentPreset(
      DocsThemeController controller, String nextAccentPresetId) {
    if (_accentPresetId == nextAccentPresetId) return;
    setState(() {
      _accentPresetId = nextAccentPresetId;
    });
    _applyPresetSelections(controller, baseChanged: false);
  }

  void _applyPresetSelections(
    DocsThemeController controller, {
    required bool baseChanged,
  }) {
    if (baseChanged) {
      controller.setPreset(_basePresetId);
    }

    if (_basePresetId == _accentPresetId) {
      if (controller.presetId != _basePresetId) {
        controller.setPreset(_basePresetId);
      }
      return;
    }

    final mixedScheme = _schemeForSelection(controller.brightness);
    controller.setCustomScheme(mixedScheme);
  }

  String _closestBasePresetId({
    required ColorScheme scheme,
    required Brightness brightness,
  }) {
    var bestPreset = _presetOptions.first.id;
    var bestDistance = double.infinity;

    for (final preset in _presetOptions) {
      final candidate =
          brightness == Brightness.dark ? preset.dark : preset.light;
      final distance = _baseSchemeDistance(scheme, candidate);
      if (distance < bestDistance) {
        bestDistance = distance;
        bestPreset = preset.id;
      }
    }

    return bestPreset;
  }

  String _closestAccentPresetId({
    required ColorScheme scheme,
    required Brightness brightness,
  }) {
    var bestPreset = _presetOptions.first.id;
    var bestDistance = double.infinity;

    for (final preset in _presetOptions) {
      final candidate =
          brightness == Brightness.dark ? preset.dark : preset.light;
      final distance = _accentSchemeDistance(scheme, candidate);
      if (distance < bestDistance) {
        bestDistance = distance;
        bestPreset = preset.id;
      }
    }

    return bestPreset;
  }

  double _baseSchemeDistance(ColorScheme lhs, ColorScheme rhs) {
    return _colorDistance(lhs.background, rhs.background) +
        _colorDistance(lhs.foreground, rhs.foreground) +
        _colorDistance(lhs.card, rhs.card) +
        _colorDistance(lhs.cardForeground, rhs.cardForeground) +
        _colorDistance(lhs.muted, rhs.muted) +
        _colorDistance(lhs.mutedForeground, rhs.mutedForeground) +
        _colorDistance(lhs.border, rhs.border) +
        _colorDistance(lhs.input, rhs.input) +
        _colorDistance(lhs.sidebar, rhs.sidebar) +
        _colorDistance(lhs.sidebarForeground, rhs.sidebarForeground);
  }

  double _accentSchemeDistance(ColorScheme lhs, ColorScheme rhs) {
    return _colorDistance(lhs.primary, rhs.primary) +
        _colorDistance(lhs.primaryForeground, rhs.primaryForeground) +
        _colorDistance(lhs.accent, rhs.accent) +
        _colorDistance(lhs.accentForeground, rhs.accentForeground) +
        _colorDistance(lhs.ring, rhs.ring) +
        _colorDistance(lhs.chart1, rhs.chart1) +
        _colorDistance(lhs.chart2, rhs.chart2) +
        _colorDistance(lhs.chart3, rhs.chart3) +
        _colorDistance(lhs.chart4, rhs.chart4) +
        _colorDistance(lhs.chart5, rhs.chart5) +
        _colorDistance(lhs.sidebarPrimary, rhs.sidebarPrimary) +
        _colorDistance(lhs.sidebarAccent, rhs.sidebarAccent) +
        _colorDistance(lhs.sidebarRing, rhs.sidebarRing);
  }

  double _colorDistance(Color lhs, Color rhs) {
    final lhsValue = lhs.toARGB32();
    final rhsValue = rhs.toARGB32();
    final lhsRed = (lhsValue >> 16) & 0xFF;
    final lhsGreen = (lhsValue >> 8) & 0xFF;
    final lhsBlue = lhsValue & 0xFF;
    final rhsRed = (rhsValue >> 16) & 0xFF;
    final rhsGreen = (rhsValue >> 8) & 0xFF;
    final rhsBlue = rhsValue & 0xFF;

    final dr = (lhsRed - rhsRed).toDouble();
    final dg = (lhsGreen - rhsGreen).toDouble();
    final db = (lhsBlue - rhsBlue).toDouble();

    return (dr * dr) + (dg * dg) + (db * db);
  }

  void _updateGpuCount(int next) {
    _gpuCount.value = next < 0
        ? 0
        : next > 64
            ? 64
            : next;
  }

  void _changeGpuCount(int delta) {
    _updateGpuCount(_gpuCount.value + delta);
  }

  Widget _buildKitchenPreview(BuildContext context) {
    return MediaQueryVisibility(
      minWidth: 1350,
      alternateChild: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildKitchenPaymentMethod(context),
          const SizedBox(height: _kitchenSectionGap),
          _buildKitchenInputs(context),
          const SizedBox(height: _kitchenSectionGap),
          _buildKitchenAppearanceSettings(context),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: _buildKitchenPaymentMethod(context)),
          const SizedBox(width: _kitchenColumnGap),
          Expanded(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: _buildKitchenInputs(context),
            ),
          ),
          const SizedBox(width: _kitchenColumnGap),
          Expanded(child: _buildKitchenAppearanceSettings(context)),
        ],
      ),
    );
  }

  Widget _buildKitchenPaymentMethod(BuildContext context) {
    final theme = Theme.of(context);
    final currentYear = DateTime.now().year;
    return Card(
      child: Padding(
        padding: EdgeInsets.all(padLg * theme.scaling),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Payment Method').medium(),
            const DensityGap(gapXs),
            const Text('All transactions are secure and encrypted.')
                .muted()
                .small(),
            const DensityGap(gapXl),
            const Text('Name on Card').medium(),
            const DensityGap(gapSm),
            const TextField(
              placeholder: Text('John Doe'),
            ),
            const DensityGap(gapXl),
            Row(
              children: [
                Flexible(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Card Number').medium(),
                      const DensityGap(gapSm),
                      const TextField(
                        placeholder: Text('1234 5678 9012 3456'),
                      ),
                    ],
                  ),
                ),
                const DensityGap(gapXl),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('CVV').medium(),
                      const DensityGap(gapSm),
                      const TextField(
                        placeholder: Text('123'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const DensityGap(gapMd),
            const Text('Enter your 16-digit number.').muted(),
            const DensityGap(gapLg),
            Row(
              children: [
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text('Month').medium(),
                      const DensityGap(gapSm),
                      Select<String>(
                        placeholder: const Text('MM'),
                        itemBuilder: (context, item) => Text(item),
                        value: null,
                        onChanged: (value) {},
                        popup: SelectPopup.noVirtualization(
                          items: SelectItemList(
                            children: [
                              for (var month = 1; month <= 12; month++)
                                SelectItemButton(
                                  value: month.toString().padLeft(2, '0'),
                                  child: Text(month.toString().padLeft(2, '0')),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const DensityGap(gapXl),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text('Year').medium(),
                      const DensityGap(gapSm),
                      Select<String>(
                        placeholder: const Text('YYYY'),
                        itemBuilder: (context, item) => Text(item),
                        value: null,
                        onChanged: (value) {},
                        popup: SelectPopup.noVirtualization(
                          items: SelectItemList(
                            children: [
                              for (var yearOffset = 0;
                                  yearOffset < 12;
                                  yearOffset++)
                                SelectItemButton(
                                  value: (currentYear + yearOffset).toString(),
                                  child: Text(
                                      (currentYear + yearOffset).toString()),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const DensityGap(gapXl),
            const Divider(),
            const DensityGap(gapXl),
            const Text('Billing Address').medium(),
            const DensityGap(gapXs),
            const Text(
                    'The billing address associated with your payment method')
                .muted()
                .small(),
            const DensityGap(gapMd),
            ValueListenableBuilder<CheckboxState>(
              valueListenable: _previewCheckbox,
              builder: (context, checkboxState, child) {
                return Checkbox(
                  state: checkboxState,
                  onChanged: (value) {
                    _previewCheckbox.value = value;
                  },
                  trailing: child,
                );
              },
              child: const Text('Same as shipping address'),
            ),
            const DensityGap(gapXl),
            const Divider(),
            const DensityGap(gapXl),
            const Text('Comments').medium(),
            const DensityGap(gapSm),
            const TextArea(
              placeholder: Text('Add any additional comments'),
              expandableHeight: true,
              minHeight: 90,
              maxHeight: 150,
            ),
            const DensityGap(gapLg),
            Row(
              children: [
                PrimaryButton(
                  onPressed: () {},
                  child: const Text('Submit'),
                ),
                const DensityGap(gapMd),
                OutlineButton(
                  onPressed: () {},
                  child: const Text('Cancel'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKitchenInputs(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildKitchenMembers(),
        const SizedBox(height: _kitchenSectionGap),
        _buildKitchenBadges(),
        const SizedBox(height: _kitchenSectionGap),
        _buildKitchenChatBox(),
        const SizedBox(height: _kitchenSectionGap),
        _buildKitchenPriceRange(),
        const SizedBox(height: _kitchenSectionGap),
        _buildKitchenSearch(),
        const SizedBox(height: _kitchenSectionGap),
        _buildKitchenUrlField(),
        const SizedBox(height: _kitchenSectionGap),
        _buildKitchenAiComposer(),
        const SizedBox(height: _kitchenSectionGap),
        _buildKitchenMentions(),
      ],
    );
  }

  Widget _buildKitchenAppearanceSettings(BuildContext context) {
    return RadioGroup<bool>(
      value: true,
      onChanged: (value) {},
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            child: Row(
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Two-factor authentication'),
                      DensityGap(gapXs),
                      Text('Verify via email or phone number.'),
                    ],
                  ),
                ),
                PrimaryButton(
                  density: ButtonDensity.dense,
                  onPressed: () {},
                  child: const Text('Enable'),
                ),
              ],
            ),
          ),
          const DensityGap(gapMd),
          const Card(
            child: Row(
              children: [
                Icon(LucideIcons.badgeCheck),
                DensityGap(gapSm),
                Expanded(child: Text('Your profile has been verified.')),
                Icon(Icons.chevron_right),
              ],
            ),
          ),
          const DensityGap(gapXl),
          Divider(
            child: const Text('Appearance Settings').muted().small(),
          ),
          const DensityGap(gapXl),
          const Text('Compute Environment').medium(),
          const DensityGap(gapXs),
          const Text('Select the compute environment for your cluster.')
              .muted()
              .small(),
          const DensityGap(gapMd),
          const RadioCard(
            value: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('Kubernetes'),
                    Spacer(),
                    Radio(value: true),
                  ],
                ),
                DensityGap(gapSm),
                Text(
                  'Run GPU workloads on a K8s configured cluster. This is the default.',
                ),
              ],
            ),
          ),
          const DensityGap(gapSm),
          const RadioCard(
            value: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('Virtual Machine'),
                    Spacer(),
                    Radio(value: false),
                  ],
                ),
                DensityGap(gapSm),
                Text(
                  'Access a VM configured cluster to run workloads. (Coming soon)',
                ),
              ],
            ),
          ),
          const DensityGap(gapXl),
          const Divider(),
          const DensityGap(gapXl),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Number of GPUs'),
                    DensityGap(gapXs),
                    Text('You can add more later.'),
                  ],
                ),
              ),
              SizedBox(
                width: 148,
                child: ValueListenableBuilder<int>(
                  valueListenable: _gpuCount,
                  builder: (context, gpuCount, child) {
                    return ButtonGroup(
                      children: [
                        SizedBox(
                          width: 64,
                          child: TextField(
                            key: ValueKey<int>(gpuCount),
                            initialValue: gpuCount.toString(),
                            textAlign: TextAlign.center,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            onChanged: (value) {
                              final parsed = int.tryParse(value);
                              if (parsed != null) {
                                _updateGpuCount(parsed);
                              }
                            },
                          ),
                        ),
                        IconButton.outline(
                          density: ButtonDensity.iconDense,
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            _changeGpuCount(1);
                          },
                        ),
                        IconButton.outline(
                          density: ButtonDensity.iconDense,
                          icon: const Icon(Icons.remove),
                          onPressed: () {
                            _changeGpuCount(-1);
                          },
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
          const DensityGap(gapXl),
          const Divider(),
          const DensityGap(gapXl),
          Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Wallpaper Tinting'),
                    DensityGap(gapXs),
                    Text('Allow the wallpaper to be tinted.'),
                  ],
                ),
              ),
              ValueListenableBuilder<bool>(
                valueListenable: _previewSwitch,
                builder: (context, previewSwitch, child) {
                  return Switch(
                    value: previewSwitch,
                    onChanged: (value) {
                      _previewSwitch.value = value;
                    },
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildKitchenMembers() {
    return DashedContainer(
      child: DensityContainerPadding(
        padding: const EdgeInsetsDensity.all(padLg),
        child: Column(
          children: [
            AvatarGroup.toLeft(
              gap: 2,
              offset: 0.7,
              children: const [
                Avatar(initials: 'MJ'),
                Avatar(initials: 'JS'),
                Avatar(initials: 'ST'),
              ],
            ),
            const DensityGap(gapXl),
            const Text('No Team Members').small(),
            const DensityGap(gapSm),
            const Text('Invite your team to collaborate on this project.')
                .muted()
                .small()
                .center(),
            const DensityGap(gapMd),
            SecondaryButton(
              leading: const Icon(Icons.add),
              density: ButtonDensity.dense,
              onPressed: () {},
              child: const Text('Invite Members').small(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKitchenBadges() {
    return const RepaintBoundary(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            PrimaryBadge(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(
                    onSurface: true,
                    size: 10,
                  ),
                  DensityGap(gapSm),
                  Text('Syncing'),
                ],
              ),
            ),
            DensityGap(gapSm),
            SecondaryBadge(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(size: 10),
                  DensityGap(gapSm),
                  Text('Updating'),
                ],
              ),
            ),
            DensityGap(gapSm),
            OutlineBadge(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(size: 10),
                  DensityGap(gapSm),
                  Text('Loading'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKitchenChatBox() {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          IconButton.outline(icon: const Icon(Icons.add), onPressed: () {}),
          const DensityGap(gapSm),
          Expanded(
            child: TextField(
              placeholder: const Text('Send a message...'),
              padding: const DirectionalEdgeInsetsDensity.only(
                start: padSm,
                end: padXs,
                top: 0,
                bottom: 0,
              ),
              features: [
                InputFeature.trailing(
                  WidgetStatesProvider.boundary(
                    child: Tooltip(
                      tooltip: const TooltipContainer(child: Text('Voice mode'))
                          .call,
                      child: IconButton.ghost(
                        icon: const Icon(LucideIcons.audioLines),
                        onPressed: () {},
                        shape: ButtonShape.circle,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKitchenPriceRange() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('Price Range').medium(),
        const DensityGap(gapXs),
        const Text('Set your budget range (\$320 - \$800)').muted(),
        const DensityGap(gapMd),
        ValueListenableBuilder<ShadRangeValue>(
          valueListenable: _priceRange,
          builder: (context, priceRange, child) {
            return Slider.range(
              min: 0,
              max: 1000,
              rangeValue: priceRange,
              onChanged: (value) {
                _priceRange.value = value;
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildKitchenSearch() {
    return const TextField(
      placeholder: Text('Search...'),
      features: [
        InputFeature.leading(Icon(Icons.search)),
        InputFeature.trailing(Text('12 Results')),
      ],
    );
  }

  Widget _buildKitchenUrlField() {
    return TextField(
      placeholder: const Text('example.com'),
      features: [
        const InputFeature.leading(Text('https://')),
        InputFeature.hint(
          popupBuilder: const TooltipContainer(
            child: Text('This is content in a tooltip'),
          ).call,
        ),
      ],
    );
  }

  Widget _buildKitchenAiComposer() {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const TextArea(
            minHeight: 80,
            maxHeight: 100,
            placeholder: Text('Ask, Search, or Chat...'),
          ),
          const DensityGap(gapMd),
          const Divider(),
          const DensityGap(gapMd),
          LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxWidth < 260;
              final tight = constraints.maxWidth < 220;
              return IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    IconButton.outline(
                      density: ButtonDensity.iconDense,
                      icon: const Icon(Icons.add),
                      onPressed: () {},
                    ),
                    DensityGap(compact ? gapXs : gapSm),
                    if (!tight)
                      ValueListenableBuilder<String>(
                        valueListenable: _composerMode,
                        builder: (context, composerMode, child) {
                          return SecondaryButton(
                            density: ButtonDensity.dense,
                            onPressed: () {
                              showDropdown(
                                context: context,
                                anchorAlignment: Alignment.bottomLeft,
                                alignment: Alignment.topLeft,
                                offset: const Offset(0, 8),
                                builder: (context) {
                                  return DropdownMenu(
                                    children: [
                                      MenuButton(
                                        child: const Text('Auto'),
                                        onPressed: (context) {
                                          _composerMode.value = 'Auto';
                                        },
                                      ),
                                      MenuButton(
                                        child: const Text('Agent'),
                                        onPressed: (context) {
                                          _composerMode.value = 'Agent';
                                        },
                                      ),
                                      MenuButton(
                                        child: const Text('Manual'),
                                        onPressed: (context) {
                                          _composerMode.value = 'Manual';
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: Text(composerMode),
                          );
                        },
                      ),
                    const Spacer(),
                    if (!compact) ...[
                      const Text('52% Used').muted().small().center(),
                      const DensityGap(gapSm),
                      const VerticalDivider(),
                      const DensityGap(gapSm),
                    ],
                    IconButton.primary(
                      density: ButtonDensity.iconDense,
                      icon: const Icon(Icons.arrow_upward),
                      onPressed: () {},
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildKitchenMentions() {
    return TextField(
      placeholder: const Text('@ibrar-x'),
      features: [
        InputFeature.trailing(
          IconButton.primary(
            density: ButtonDensity.iconDense,
            size: ButtonSize.small,
            shape: ButtonShape.circle,
            icon: const Icon(Icons.check),
            onPressed: () {},
          ),
        ),
      ],
    );
  }

  Widget _buildOptionsPanel(BuildContext context) {
    final controller = context.docsThemeController;
    final data = controller.data;
    final isDark = controller.brightness == Brightness.dark;
    final presetTokens = _tokensForPreset(_basePresetId, controller.brightness);
    final theme = Theme.of(context);

    final radiusKey = _radiusOptions.entries
        .firstWhere(
          (entry) => entry.value == data.radius,
          orElse: () => const MapEntry('Default', 0.5),
        )
        .key;
    final scalingKey = _scalingOptions.entries
        .firstWhere(
          (entry) => entry.value == data.scaling,
          orElse: () => const MapEntry('Default', 1.0),
        )
        .key;
    final surfaceOpacityKey = _surfaceOpacityOptions.entries
        .firstWhere(
          (entry) => entry.value == data.surfaceOpacity,
          orElse: () => const MapEntry('Solid', 1.0),
        )
        .key;
    final surfaceBlurKey = _surfaceBlurOptions.entries
        .firstWhere(
          (entry) => entry.value == data.surfaceBlur,
          orElse: () => const MapEntry('None', 0.0),
        )
        .key;
    final densityLabel = _densityLabel(
      density: data.density,
      presetDensity: presetTokens.density,
    );
    final panelForeground = isDark
        ? const Color(0xFFF5F5F5)
        : theme.colorScheme.foreground;
    final panelMutedForeground = isDark
        ? const Color(0xFFB8B8B8)
        : theme.colorScheme.mutedForeground;

    return OutlinedContainer(
      backgroundColor: isDark
          ? const Color(0xFF141414)
          : theme.colorScheme.card,
      borderColor: theme.colorScheme.border,
      surfaceOpacity: isDark ? 0.98 : 1,
      surfaceBlur: isDark ? 10 : 0,
      padding: const EdgeInsetsDensity.all(padLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Theme options',
            style: theme.typography.h2.copyWith(
              color: panelForeground,
            ),
          ),
          const SizedBox(height: 14),
          _panelLabel(context, 'Theme mode', panelForeground),
          _stringSelect(
            value: isDark ? 'Dark' : 'Light',
            values: _themeModes.keys.toList(),
            itemIconBuilder: (item) {
              return item == 'Dark' ? Icons.dark_mode : Icons.light_mode;
            },
            onChanged: (value) {
              if (value == null) return;
              _updateThemeMode(controller, value == 'Dark');
            },
          ),
          const SizedBox(height: 12),
          _panelLabel(
            context,
            'Base preset (surface + tokens)',
            panelForeground,
          ),
          _presetSelect(
            value: _basePresetId,
            brightness: controller.brightness,
            onChanged: (value) {
              if (value == null) return;
              _updateBasePreset(controller, value);
            },
          ),
          const SizedBox(height: 12),
          _panelLabel(
            context,
            'Accent preset (primary + charts)',
            panelForeground,
          ),
          _presetSelect(
            value: _accentPresetId,
            brightness: controller.brightness,
            onChanged: (value) {
              if (value == null) return;
              _updateAccentPreset(controller, value);
            },
          ),
          const SizedBox(height: 6),
          Text(
            _basePresetId == _accentPresetId
                ? 'Using one preset for both base and accent.'
                : 'Mix & match active: base and accent come from different presets.',
            style: theme.typography.small.copyWith(
              color: panelMutedForeground,
            ),
          ),
          const SizedBox(height: 12),
          _panelLabel(context, 'Radius', panelForeground),
          _stringSelect(
            value: radiusKey,
            values: _radiusOptions.keys.toList(),
            icon: Icons.rounded_corner,
            onChanged: (value) {
              if (value == null) return;
              final next = _radiusOptions[value];
              if (next != null) {
                controller.setRadius(next);
              }
            },
          ),
          const SizedBox(height: 12),
          _panelLabel(context, 'Density', panelForeground),
          _stringSelect(
            value: densityLabel,
            values: ['Preset', ..._densityOptions.keys],
            icon: Icons.line_weight,
            onChanged: (value) {
              if (value == null) return;
              if (value == 'Preset') {
                controller.setDensity(presetTokens.density);
                return;
              }
              final next = _densityOptions[value];
              if (next != null) {
                controller.setDensity(next);
              }
            },
          ),
          const SizedBox(height: 12),
          _panelLabel(context, 'Scaling', panelForeground),
          _stringSelect(
            value: scalingKey,
            values: _scalingOptions.keys.toList(),
            icon: Icons.zoom_in,
            onChanged: (value) {
              if (value == null) return;
              final next = _scalingOptions[value];
              if (next != null) {
                controller.setScaling(next);
              }
            },
          ),
          const SizedBox(height: 12),
          _panelLabel(context, 'Surface opacity', panelForeground),
          _stringSelect(
            value: surfaceOpacityKey,
            values: _surfaceOpacityOptions.keys.toList(),
            icon: Icons.opacity,
            onChanged: (value) {
              if (value == null) return;
              final next = _surfaceOpacityOptions[value];
              if (next != null) {
                controller.setSurfaceOpacity(next);
              }
            },
          ),
          const SizedBox(height: 12),
          _panelLabel(context, 'Surface blur', panelForeground),
          _stringSelect(
            value: surfaceBlurKey,
            values: _surfaceBlurOptions.keys.toList(),
            icon: Icons.blur_on,
            onChanged: (value) {
              if (value == null) return;
              final next = _surfaceBlurOptions[value];
              if (next != null) {
                controller.setSurfaceBlur(next);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _panelLabel(BuildContext context, String text, Color color) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: theme.typography.small.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _presetSelect({
    required String value,
    required Brightness brightness,
    required ValueChanged<String?> onChanged,
  }) {
    return Select<String>(
      value: value,
      onChanged: onChanged,
      itemBuilder: (context, item) {
        final preset = _presetForId(item);
        final scheme = _schemeForPreset(item, brightness);
        return Row(
          children: [
            Icon(Icons.circle, size: 12, color: scheme.primary),
            const SizedBox(width: 8),
            Flexible(child: Text(preset.name)),
          ],
        );
      },
      popup: SelectPopup.noVirtualization(
        items: SelectItemList(
          children: [
            for (final preset in _presetOptions)
              SelectItemButton(
                value: preset.id,
                child: Row(
                  children: [
                    Icon(
                      Icons.circle,
                      size: 12,
                      color: _schemeForPreset(preset.id, brightness).primary,
                    ),
                    const SizedBox(width: 8),
                    Flexible(child: Text(preset.name)),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _stringSelect({
    required String value,
    required List<String> values,
    IconData? icon,
    IconData Function(String item)? itemIconBuilder,
    ValueChanged<String?>? onChanged,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final iconColor = colorScheme.brightness == Brightness.light
        ? colorScheme.foreground
        : colorScheme.secondaryForeground;

    return Select<String>(
      value: value,
      onChanged: onChanged,
      itemBuilder: (context, item) {
        final resolvedIcon = itemIconBuilder?.call(item) ?? icon;
        if (resolvedIcon == null) {
          return Text(item);
        }
        return Row(
          children: [
            Icon(resolvedIcon, size: 14, color: iconColor),
            const SizedBox(width: 8),
            Flexible(child: Text(item)),
          ],
        );
      },
      popup: SelectPopup.noVirtualization(
        items: SelectItemList(
          children: [
            for (final item in values)
              SelectItemButton(
                value: item,
                child: Builder(
                  builder: (context) {
                    final resolvedIcon = itemIconBuilder?.call(item) ?? icon;
                    if (resolvedIcon == null) {
                      return Text(item);
                    }
                    return Row(
                      children: [
                        Icon(resolvedIcon, size: 14, color: iconColor),
                        const SizedBox(width: 8),
                        Flexible(child: Text(item)),
                      ],
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _densityLabel({
    required Density density,
    required Density presetDensity,
  }) {
    if (density == presetDensity) {
      return 'Preset';
    }
    return _densityOptions.entries
        .firstWhere(
          (entry) => entry.value == density,
          orElse: () => const MapEntry('Default', Density.defaultDensity),
        )
        .key;
  }

  String _buildPresetCodeSnippet(DocsThemeController controller) {
    final data = controller.data;
    final currentTokens =
        _tokensForPreset(_basePresetId, controller.brightness);
    final lightTokenSource = _tokensForPreset(_basePresetId, Brightness.light);
    final darkTokenSource = _tokensForPreset(_basePresetId, Brightness.dark);
    final lightScheme = _schemeForSelection(Brightness.light);
    final darkScheme = _schemeForSelection(Brightness.dark);

    final usesPresetRadius = data.radius == currentTokens.radius;
    final usesPresetDensity = data.density == currentTokens.density;
    final selectedSpacingBase = data.density.toSpacingScale().base;

    final lightRadius =
        usesPresetRadius ? lightTokenSource.radius : data.radius;
    final darkRadius = usesPresetRadius ? darkTokenSource.radius : data.radius;
    final lightSpacingBase =
        usesPresetDensity ? lightTokenSource.spacing.base : selectedSpacingBase;
    final darkSpacingBase =
        usesPresetDensity ? darkTokenSource.spacing.base : selectedSpacingBase;

    final lines = <String>[
      '// Paste into your preset_themes.dart file.',
      '// Keep model classes once. If they already exist, do not duplicate them.',
      '',
      _buildRegistryPresetModelCode(),
      '',
      'final RegistryThemePreset appThemePreset = RegistryThemePreset(',
      "  id: 'app-theme',",
      "  name: 'App Theme',",
      ..._colorSchemeLiteralLines(fieldName: 'light', scheme: lightScheme),
      ..._colorSchemeLiteralLines(fieldName: 'dark', scheme: darkScheme),
      ..._tokenLiteralLines(
        fieldName: 'lightTokens',
        radius: lightRadius,
        spacingBase: lightSpacingBase,
        tokenSource: lightTokenSource,
      ),
      ..._tokenLiteralLines(
        fieldName: 'darkTokens',
        radius: darkRadius,
        spacingBase: darkSpacingBase,
        tokenSource: darkTokenSource,
      ),
      ');',
    ];
    return lines.join('\n');
  }

  String _buildAppCodeSnippet(DocsThemeController controller) {
    final data = controller.data;
    return [
      '// Use in main.dart (or your app entrypoint).',
      'final bool isDarkMode = ${controller.brightness == Brightness.dark};',
      'final ColorScheme activeScheme = isDarkMode',
      '    ? appThemePreset.dark',
      '    : appThemePreset.light;',
      'final RegistryThemePresetTokens activeTokens = isDarkMode',
      '    ? appThemePreset.darkTokens',
      '    : appThemePreset.lightTokens;',
      '',
      'ShadcnApp(',
      '  scaling: const AdaptiveScaling(${_formatNumber(data.scaling)}),',
      '  theme: ThemeData(',
      '    colorScheme: activeScheme,',
      '    radius: activeTokens.radius,',
      '    density: activeTokens.density,',
      '    tracking: activeTokens.tracking,',
      '    shadows: activeTokens.shadows,',
      '    surfaceOpacity: ${_formatNumber(data.surfaceOpacity)},',
      '    surfaceBlur: ${_formatNumber(data.surfaceBlur)},',
      '  ),',
      '  child: const AppRoot(),',
      ');',
    ].join('\n');
  }

  String _buildRegistryPresetModelCode() {
    return [
      'class RegistryThemePresetTokens {',
      '  final double radius;',
      '  final SpacingScale spacing;',
      '  final TrackingScale tracking;',
      '  final ShadowScale shadows;',
      '  final String? fontSans;',
      '  final String? fontSerif;',
      '  final String? fontMono;',
      '',
      '  RegistryThemePresetTokens({',
      '    required this.radius,',
      '    required this.spacing,',
      '    required this.tracking,',
      '    required this.shadows,',
      '    this.fontSans,',
      '    this.fontSerif,',
      '    this.fontMono,',
      '  });',
      '',
      '  Density get density => Density.fromSpacingScale(spacing);',
      '}',
      '',
      'class RegistryThemePreset {',
      '  final String id;',
      '  final String name;',
      '  final ColorScheme light;',
      '  final ColorScheme dark;',
      '  final RegistryThemePresetTokens lightTokens;',
      '  final RegistryThemePresetTokens darkTokens;',
      '',
      '  RegistryThemePreset({',
      '    required this.id,',
      '    required this.name,',
      '    required this.light,',
      '    required this.dark,',
      '    required this.lightTokens,',
      '    required this.darkTokens,',
      '  });',
      '}',
    ].join('\n');
  }

  List<String> _colorSchemeLiteralLines({
    required String fieldName,
    required ColorScheme scheme,
  }) {
    return [
      '  $fieldName: ColorScheme(',
      '    brightness: Brightness.${scheme.brightness == Brightness.dark ? 'dark' : 'light'},',
      '    background: ${_colorCode(scheme.background)},',
      '    foreground: ${_colorCode(scheme.foreground)},',
      '    card: ${_colorCode(scheme.card)},',
      '    cardForeground: ${_colorCode(scheme.cardForeground)},',
      '    popover: ${_colorCode(scheme.popover)},',
      '    popoverForeground: ${_colorCode(scheme.popoverForeground)},',
      '    primary: ${_colorCode(scheme.primary)},',
      '    primaryForeground: ${_colorCode(scheme.primaryForeground)},',
      '    secondary: ${_colorCode(scheme.secondary)},',
      '    secondaryForeground: ${_colorCode(scheme.secondaryForeground)},',
      '    muted: ${_colorCode(scheme.muted)},',
      '    mutedForeground: ${_colorCode(scheme.mutedForeground)},',
      '    accent: ${_colorCode(scheme.accent)},',
      '    accentForeground: ${_colorCode(scheme.accentForeground)},',
      '    destructive: ${_colorCode(scheme.destructive)},',
      '    destructiveForeground: ${_colorCode(scheme.destructiveForeground)},',
      '    border: ${_colorCode(scheme.border)},',
      '    input: ${_colorCode(scheme.input)},',
      '    ring: ${_colorCode(scheme.ring)},',
      '    chart1: ${_colorCode(scheme.chart1)},',
      '    chart2: ${_colorCode(scheme.chart2)},',
      '    chart3: ${_colorCode(scheme.chart3)},',
      '    chart4: ${_colorCode(scheme.chart4)},',
      '    chart5: ${_colorCode(scheme.chart5)},',
      '    sidebar: ${_colorCode(scheme.sidebar)},',
      '    sidebarForeground: ${_colorCode(scheme.sidebarForeground)},',
      '    sidebarPrimary: ${_colorCode(scheme.sidebarPrimary)},',
      '    sidebarPrimaryForeground: ${_colorCode(scheme.sidebarPrimaryForeground)},',
      '    sidebarAccent: ${_colorCode(scheme.sidebarAccent)},',
      '    sidebarAccentForeground: ${_colorCode(scheme.sidebarAccentForeground)},',
      '    sidebarBorder: ${_colorCode(scheme.sidebarBorder)},',
      '    sidebarRing: ${_colorCode(scheme.sidebarRing)},',
      '  ),',
    ];
  }

  List<String> _tokenLiteralLines({
    required String fieldName,
    required double radius,
    required double spacingBase,
    required RegistryThemePresetTokens tokenSource,
  }) {
    return [
      '  $fieldName: RegistryThemePresetTokens(',
      '    radius: ${_formatNumber(radius)},',
      '    spacing: SpacingScale(${_formatNumber(spacingBase)}),',
      '    tracking: TrackingScale(normal: ${_formatNumber(tokenSource.tracking.normal)}),',
      '    shadows: ShadowScale(',
      ..._shadowScaleLiteralLines(tokenSource.shadows),
      '    ),',
      '    fontSans: ${_stringLiteral(tokenSource.fontSans)},',
      '    fontSerif: ${_stringLiteral(tokenSource.fontSerif)},',
      '    fontMono: ${_stringLiteral(tokenSource.fontMono)},',
      '  ),',
    ];
  }

  List<String> _shadowScaleLiteralLines(ShadowScale shadows) {
    return [
      '      shadow2xs: ${_boxShadowListCode(shadows.shadow2xs)},',
      '      shadowXs: ${_boxShadowListCode(shadows.shadowXs)},',
      '      shadowSm: ${_boxShadowListCode(shadows.shadowSm)},',
      '      shadow: ${_boxShadowListCode(shadows.shadow)},',
      '      shadowMd: ${_boxShadowListCode(shadows.shadowMd)},',
      '      shadowLg: ${_boxShadowListCode(shadows.shadowLg)},',
      '      shadowXl: ${_boxShadowListCode(shadows.shadowXl)},',
      '      shadow2xl: ${_boxShadowListCode(shadows.shadow2xl)},',
    ];
  }

  String _boxShadowListCode(List<BoxShadow> shadows) {
    if (shadows.isEmpty) {
      return 'const <BoxShadow>[]';
    }
    return '[${shadows.map(_boxShadowCode).join(', ')}]';
  }

  String _boxShadowCode(BoxShadow shadow) {
    final blurStyle = shadow.blurStyle != BlurStyle.normal
        ? ', blurStyle: BlurStyle.${shadow.blurStyle.name}'
        : '';
    return 'BoxShadow(offset: Offset(${_formatNumber(shadow.offset.dx)}, ${_formatNumber(shadow.offset.dy)}), blurRadius: ${_formatNumber(shadow.blurRadius)}, spreadRadius: ${_formatNumber(shadow.spreadRadius)}, color: ${_colorCode(shadow.color)}$blurStyle)';
  }

  String _colorCode(Color color) {
    final hex =
        color.toARGB32().toRadixString(16).toUpperCase().padLeft(8, '0');
    return 'Color(0x$hex)';
  }

  String _stringLiteral(String? value) {
    if (value == null) {
      return 'null';
    }
    final escaped = value.replaceAll('\\', '\\\\').replaceAll("'", r"\'");
    return "'$escaped'";
  }

  String _formatNumber(num value) {
    final rounded = value.toDouble();
    if (rounded == rounded.roundToDouble()) {
      return rounded.toStringAsFixed(1);
    }
    final text = rounded.toStringAsFixed(6);
    return text
        .replaceFirst(RegExp(r'0+$'), '')
        .replaceFirst(RegExp(r'\.$'), '');
  }
}
