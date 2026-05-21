import 'package:flutter/material.dart'
    hide Card, Checkbox, Divider, Slider, Switch;

import '../../ui/shadcn/components/control/button/button.dart'
    as shadcn_buttons;
import '../../ui/shadcn/components/display/badge/badge.dart' as shadcn_badge;
import '../../ui/shadcn/components/display/border_loading/border_loading.dart'
    as shadcn_border_loading;
import '../../ui/shadcn/components/display/divider/divider.dart'
    as shadcn_divider;
import '../../ui/shadcn/components/display/markdown/markdown.dart'
    as shadcn_markdown;
import '../../ui/shadcn/components/display/progress/progress.dart'
    as shadcn_progress;
import '../../ui/shadcn/components/display/text_animate/text_animate.dart'
    as shadcn_text_animate;
import '../../ui/shadcn/components/form/checkbox/checkbox.dart'
    as shadcn_checkbox;
import '../../ui/shadcn/components/form/phone_input/phone_input.dart'
    as shadcn_phone_input;
import '../../ui/shadcn/components/form/slider/slider.dart' as shadcn_slider;
import '../../ui/shadcn/components/form/switch/switch.dart' as shadcn_switch;
import '../../ui/shadcn/components/form/text_field/text_field.dart'
    as shadcn_text_field;
import '../../ui/shadcn/components/layout/accordion/accordion.dart'
    as shadcn_accordion;
import '../../ui/shadcn/components/layout/card/card.dart' as shadcn_card;
import '../../ui/shadcn/shared/icons/lucide_icons.dart';
import '../../ui/shadcn/shared/primitives/text.dart';

typedef ComponentPreviewBuilder = Widget Function(BuildContext context);

const bool enableTextAnimateComponent = bool.fromEnvironment(
  'ENABLE_TEXT_ANIMATE_COMPONENT',
  defaultValue: true,
);
const bool enableMarkdownComponent = bool.fromEnvironment(
  'ENABLE_MARKDOWN_COMPONENT',
  defaultValue: true,
);

const Map<String, String> componentStatusTags = {
  'chat': 'Experimental',
  'file_picker': 'New',
  'filter_bar': 'New',
  'slider': 'New',
  'border_loading': 'New',
  'empty_state': 'New',
  'error_system': 'New',
  'gooey_toast': 'New',
  if (enableMarkdownComponent) 'markdown': 'Experimental',
  if (enableTextAnimateComponent) 'text_animate': 'New',
  'window': 'Experimental',
  'audio_control': 'WIP',
  'video_control': 'WIP',
  'linear_gradient_picker': 'WIP',
  'radial_gradient_picker': 'WIP',
  'sweep_gradient_picker': 'WIP',
};

const Map<String, ComponentPreviewBuilder> componentPreviews = {
  'button': _buttonPreview,
  'badge': _badgePreview,
  'border_loading': _borderLoadingPreview,
  'accordion': _accordionPreview,
  'card': _cardPreview,
  'divider': _dividerPreview,
  'checkbox': _checkboxPreview,
  'input': _inputPreview,
  'phone_input': _phoneInputPreview,
  'slider': _sliderPreview,
  'switch': _switchPreview,
  'progress': _progressPreview,
  if (enableMarkdownComponent) 'markdown': _markdownPreview,
  if (enableTextAnimateComponent) 'text_animate': _textAnimatePreview,
};

const Map<String, IconData> categoryIcons = {
  'control': LucideIcons.textCursorInput,
  'form': LucideIcons.listChecks,
  'layout': LucideIcons.layoutGrid,
  'display': LucideIcons.monitor,
  'navigation': LucideIcons.navigation,
  'overlay': LucideIcons.layers,
  'utility': LucideIcons.wandSparkles,
  'data': LucideIcons.database,
};

IconData iconForCategory(String category) {
  return categoryIcons[category.toLowerCase()] ?? LucideIcons.box;
}

Widget buildComponentPreview(
  BuildContext context,
  String id, {
  String? label,
}) {
  final builder = componentPreviews[id];
  if (builder == null) {
    final displayLabel = label ?? id;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(LucideIcons.box, size: 20),
        const SizedBox(height: 8),
        Text(displayLabel).xSmall().muted(),
      ],
    );
  }
  return builder(context);
}

Widget buildStatusBadge(String status) {
  switch (status) {
    case 'Experimental':
      return const shadcn_badge.PrimaryBadge(child: Text('Experimental'));
    case 'New':
      return const shadcn_badge.SecondaryBadge(child: Text('New'));
    case 'WIP':
      return const shadcn_badge.OutlineBadge(child: Text('WIP'));
    default:
      return const shadcn_badge.SecondaryBadge(child: Text('Info'));
  }
}

Widget _buttonPreview(BuildContext context) {
  return shadcn_buttons.PrimaryButton(
    onPressed: () {},
    child: const Text('Primary'),
  );
}

Widget _badgePreview(BuildContext context) {
  return const shadcn_badge.PrimaryBadge(child: Text('Badge'));
}

Widget _borderLoadingPreview(BuildContext context) {
  return shadcn_border_loading.BorderLoading(
    mode: shadcn_border_loading.BorderLoadingMode.sweepGradient,
    spec: const shadcn_border_loading.BorderGradientSpec(
      type: shadcn_border_loading.BorderGradientType.sweep,
      colors: [
        Color(0x00000000),
        Color(0xFF3B82F6),
        Color(0xFF22C55E),
        Color(0x00000000),
      ],
      gap: 0.3,
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: const Text('Loading').xSmall(),
    ),
  );
}

Widget _accordionPreview(BuildContext context) {
  return const shadcn_accordion.Accordion(
    items: [
      shadcn_accordion.AccordionItem(
        trigger:
            shadcn_accordion.AccordionTrigger(child: Text('Accordion item')),
        content: Text('Accordion content'),
      ),
    ],
  );
}

Widget _cardPreview(BuildContext context) {
  return shadcn_card.Card(
    padding: const EdgeInsets.all(8),
    child: const Text('Card').xSmall().semiBold(),
  );
}

Widget _dividerPreview(BuildContext context) {
  return const Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      shadcn_divider.Divider(child: Text('Divider')),
    ],
  );
}

Widget _checkboxPreview(BuildContext context) {
  return shadcn_checkbox.Checkbox(
    state: shadcn_checkbox.CheckboxState.checked,
    onChanged: (_) {},
  );
}

Widget _inputPreview(BuildContext context) {
  return const SizedBox(
    width: 160,
    child: shadcn_text_field.TextField(
      hintText: 'Search...',
    ),
  );
}

Widget _phoneInputPreview(BuildContext context) {
  return SizedBox(
    width: 220,
    child: IgnorePointer(
      child: shadcn_phone_input.PhoneInput(onChanged: (_) {}),
    ),
  );
}

Widget _sliderPreview(BuildContext context) {
  return SizedBox(
    width: 160,
    child: shadcn_slider.Slider.single(
      value: 0.6,
      enabled: false,
      onChanged: (_) {},
    ),
  );
}

Widget _switchPreview(BuildContext context) {
  return shadcn_switch.Switch(
    value: true,
    onChanged: (_) {},
  );
}

Widget _progressPreview(BuildContext context) {
  return const SizedBox(
    width: 160,
    child: shadcn_progress.Progress(progress: 0.62),
  );
}

Widget _markdownPreview(BuildContext context) {
  return const SizedBox(
    width: 190,
    child: shadcn_markdown.Markdown(
      data: '### Markdown\n- **Bold**\n- `Code`',
      selectable: false,
      followLinks: false,
    ),
  );
}

Widget _textAnimatePreview(BuildContext context) {
  return const SizedBox(
    width: 170,
    child: shadcn_text_animate.StreamingText(
      text: 'Streaming blur preview',
      typewriter: shadcn_text_animate.TypewriterEffect(enabled: false),
      effect: shadcn_text_animate.BlurInEffect(
        duration: Duration(milliseconds: 700),
        maxBlurSigma: 12,
        fadeIn: true,
        slideUpPx: 6,
      ),
      cursor: shadcn_text_animate.StreamingCursor.none(),
    ),
  );
}
