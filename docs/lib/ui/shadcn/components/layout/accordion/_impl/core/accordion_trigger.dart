// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../accordion.dart';

/// Tappable header that controls its parent [AccordionItem].
class AccordionTrigger extends StatefulWidget {
  /// Creates a trigger for the accordion section.
  const AccordionTrigger({super.key, required this.child});

  /// Content displayed inside the trigger row.
  final Widget child;

  @override
  /// Executes `createState` behavior for this component/composite.
  State<AccordionTrigger> createState() => _AccordionTriggerState();
}
