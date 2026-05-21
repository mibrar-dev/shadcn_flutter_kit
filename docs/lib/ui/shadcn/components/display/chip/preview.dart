// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/material.dart' as m;

import '../../control/button/button.dart' as shadcn_button;
import '../chip/chip.dart' as shadcn_chip;

/// Core class used by the chip component.
class ChipPreview extends m.StatelessWidget {
  const ChipPreview({super.key});

  @override
  m.Widget build(m.BuildContext context) {
    return m.Scaffold(
      body: m.Center(
        child: m.Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            // Default chips with remove button
            shadcn_chip.Chip(
              trailing: shadcn_chip.ChipButton(
                onPressed: () {},
                child: const m.Icon(m.Icons.close),
              ),
              child: const m.Text('Apple'),
            ),

            shadcn_chip.Chip(
              trailing: shadcn_chip.ChipButton(
                onPressed: () {},
                child: const m.Icon(m.Icons.close),
              ),
              child: const m.Text('Banana'),
            ),
            // Primary style chip
            shadcn_chip.Chip(
              style: const shadcn_button.ButtonStyle.primary(),
              trailing: shadcn_chip.ChipButton(
                onPressed: () {},
                child: const m.Icon(m.Icons.close),
              ),
              child: const m.Text('Orange'),
            ),
            // Destructive style chip
            shadcn_chip.Chip(
              style: const shadcn_button.ButtonStyle.destructive(),
              trailing: shadcn_chip.ChipButton(
                onPressed: () {},
                child: const m.Icon(m.Icons.close),
              ),
              child: const m.Text('Remove'),
            ),
          ],
        ),
      ),
    );
  }
}
