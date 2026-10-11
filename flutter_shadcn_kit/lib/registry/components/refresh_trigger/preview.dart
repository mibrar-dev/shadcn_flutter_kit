// Named examples for the `refresh_trigger` component (P6-F3 preview contract).
//
// One focused demo per example; the first entry is the default. Spacing comes
// from the ambient theme, so the examples follow the selected preset and the
// site light/dark toggle. Each example carries its own bounded box because
// the pull viewport cannot lay out under unbounded constraints.

import 'package:flutter/widgets.dart';

import '../../foundation/component_preview.dart';
import 'refresh_trigger.dart';

/// A live pull-to-refresh list in a bounded box.
Widget _default(BuildContext context) {
  return SizedBox(
    width: 320,
    height: 200,
    child: RefreshTrigger(
      onRefresh: () async {},
      child: ListView.builder(
        itemCount: 30,
        itemBuilder: (BuildContext context, int index) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Text('Row $index'),
        ),
      ),
    ),
  );
}

/// The pill indicator frozen in its refreshing stage.
Widget _refreshing(BuildContext context) {
  return const DefaultRefreshIndicator(
    stage: RefreshTriggerStage(
      TriggerStage.refreshing,
      AlwaysStoppedAnimation<double>(0.8),
      Axis.vertical,
      false,
    ),
  );
}

/// Named docs examples for `refresh_trigger`; the first entry is the default.
const List<ComponentPreview> refreshTriggerPreviews = <ComponentPreview>[
  ComponentPreview('Default', _default),
  ComponentPreview('Refreshing', _refreshing),
];
