// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/material.dart';
import '../accordion/accordion.dart';

/// AccordionPreview defines a reusable type for this registry module.
class AccordionPreview extends StatelessWidget {
  const AccordionPreview({super.key});

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: 600,
              child: const Accordion(
                items: [
                  /// Creates a `AccordionItem` instance.
                  AccordionItem(
                    trigger: AccordionTrigger(child: Text('Is it accessible?')),
                    content: Text(
                      'Yes. It adheres to the WAI-ARIA design pattern.',
                    ),
                  ),

                  /// Creates a `AccordionItem` instance.
                  AccordionItem(
                    trigger: AccordionTrigger(child: Text('Is it styled?')),
                    content: Text(
                      'Yes. It comes with default styles that you can customize.',
                    ),
                  ),

                  /// Creates a `AccordionItem` instance.
                  AccordionItem(
                    trigger: AccordionTrigger(child: Text('Is it animated?')),
                    content: Text(
                      'Yes. It is animated by default. You can disable it if you prefer.',
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
}
