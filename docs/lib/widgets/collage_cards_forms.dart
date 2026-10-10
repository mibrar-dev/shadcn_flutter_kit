// Collage form cards: inputs, goal, tabs, switches, radio (P6-P1 split).
//
// Split from `collage_cards.dart` to keep every docs widget file under the
// ~400-line rule. Shares the [CollageCard] shell from that file.

import 'package:flutter/widgets.dart';

import '../ui/shadcn/components/button/button.dart';
import '../ui/shadcn/components/input/input.dart';
import '../ui/shadcn/components/radio_group/radio_group.dart';
import '../ui/shadcn/components/switch/switch.dart';
import '../ui/shadcn/components/tabs/tabs.dart';
import '../ui/shadcn/foundation/gap.dart';
import '../ui/shadcn/theme/theme.dart';
import 'collage_cards.dart';
import 'docs_tokens.dart';

class CollageInputsCard extends StatelessWidget {
  const CollageInputsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const CollageCard(
      children: <Widget>[
        Input(hintText: 'Name'),
        Gap(12),
        Input(hintText: 'Message', maxLines: 3),
      ],
    );
  }
}

class CollageGoalCard extends StatelessWidget {
  const CollageGoalCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const CollageCard(
      title: 'Set a goal',
      subtitle: 'Small forms built from the same primitives',
      children: <Widget>[
        Input(hintText: 'Goal name'),
        Gap(8),
        Row(
          children: <Widget>[
            Expanded(child: Input(hintText: 'Target')),
            Gap(8),
            Expanded(child: Input(hintText: 'Date')),
          ],
        ),
        Gap(12),
        SizedBox(
          width: double.infinity,
          child: Button(
            size: ButtonSize.sm,
            onPressed: collageNoop,
            child: Text('Create Goal'),
          ),
        ),
        Gap(8),
        SizedBox(
          width: double.infinity,
          child: Button(
            variant: ButtonVariant.outline,
            size: ButtonSize.sm,
            onPressed: collageNoop,
            child: Text('Cancel'),
          ),
        ),
      ],
    );
  }
}

class CollageTabsCard extends StatefulWidget {
  const CollageTabsCard({super.key});

  @override
  State<CollageTabsCard> createState() => CollageTabsCardState();
}

class CollageTabsCardState extends State<CollageTabsCard> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return CollageCard(
      children: <Widget>[
        Tabs(
          index: _index,
          onChanged: (int index) => setState(() => _index = index),
          // The 3-column collage narrows this card to ~263 px at 1024, where
          // intrinsic-width tabs overflow by ~9 px; expanded tabs share the
          // width instead (responsive audit finding).
          expand: true,
          children: const <TabItem>[
            TabItem(child: Text('Preview')),
            TabItem(child: Text('Code')),
            TabItem(child: Text('Usage')),
          ],
        ),
        const Gap(12),
        Text(
          switch (_index) {
            0 => 'Live component preview.',
            1 => 'Copy the source you install.',
            _ => 'Compose it with your own data.',
          },
          style: docsText(
            context,
            size: 13,
            color: theme.colors.mutedForeground,
          ),
        ),
      ],
    );
  }
}

class CollageSwitchesCard extends StatefulWidget {
  const CollageSwitchesCard({super.key});

  @override
  State<CollageSwitchesCard> createState() => CollageSwitchesCardState();
}

class CollageSwitchesCardState extends State<CollageSwitchesCard> {
  bool _first = true;
  bool _second = false;
  bool _third = true;

  @override
  Widget build(BuildContext context) {
    return CollageCard(
      title: 'Switches',
      children: <Widget>[
        Switch(
          value: _first,
          onChanged: (bool value) => setState(() => _first = value),
          label: const Text('Notifications'),
        ),
        const Gap(8),
        Switch(
          value: _second,
          onChanged: (bool value) => setState(() => _second = value),
          label: const Text('Weekly digest'),
        ),
        const Gap(8),
        Switch(
          value: _third,
          onChanged: (bool value) => setState(() => _third = value),
          label: const Text('Beta features'),
        ),
      ],
    );
  }
}

class CollageRadioCard extends StatefulWidget {
  const CollageRadioCard({super.key});

  @override
  State<CollageRadioCard> createState() => CollageRadioCardState();
}

class CollageRadioCardState extends State<CollageRadioCard> {
  String _value = 'pro';

  @override
  Widget build(BuildContext context) {
    return CollageCard(
      title: 'Choose a plan',
      children: <Widget>[
        ShadcnRadioGroup<String>(
          value: _value,
          onChanged: (String value) => setState(() => _value = value),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              RadioItem<String>(value: 'free', label: Text('Free')),
              RadioItem<String>(value: 'pro', label: Text('Pro')),
              RadioItem<String>(value: 'team', label: Text('Team')),
            ],
          ),
        ),
      ],
    );
  }
}
