// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../../shared/utils/util.dart';
import '../../control/button/button.dart';
import '../../layout/card/card.dart';
import '../../../shared/primitives/overlay.dart';
import '../../../shared/theme/theme.dart';
import '../../../shared/utils/style_value.dart';

part '_impl/state/_auto_complete_item_state.dart';
part '_impl/utils/accept_suggestion_intent.dart';
part '_impl/core/auto_complete.dart';
part '_impl/utils/auto_complete_intent.dart';
part '_impl/core/auto_complete_mode.dart';
part '_impl/utils/navigate_suggestion_intent.dart';

part '_impl/core/autocomplete_item.dart';
part '_impl/state/autocomplete_state.dart';

/// Function signature for customizing how autocomplete suggestions are applied.
///
/// Takes a [suggestion] string and returns the final text that should be
/// inserted into the text field. This allows for custom formatting or
/// modification of suggestions before they're applied.
typedef AutoCompleteCompleter = String Function(String suggestion);

/// Theme configuration for [AutoComplete] widget styling and behavior.
///
/// Defines the visual appearance and positioning of the autocomplete popover
/// that displays suggestions. All properties are optional and will fall back
/// to sensible defaults when not specified.
class AutoCompleteTheme extends ComponentThemeData {
  /// Constraints applied to the autocomplete popover container.
  final BoxConstraints? popoverConstraints;

  /// Width constraint strategy for the autocomplete popover.
  final PopoverConstraint? popoverWidthConstraint;

  /// Alignment point on the anchor widget where the popover attaches.
  final AlignmentDirectional? popoverAnchorAlignment;

  /// Alignment point on the popover that aligns with the anchor alignment.
  final AlignmentDirectional? popoverAlignment;

  /// Default mode for how suggestions are applied to text fields.
  final AutoCompleteMode? mode;

  /// Creates an [AutoCompleteTheme].
  const AutoCompleteTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.popoverConstraints,
    this.popoverWidthConstraint,
    this.popoverAnchorAlignment,
    this.popoverAlignment,
    this.mode,
  });

  /// Creates a copy of this theme with specified properties overridden.
  AutoCompleteTheme copyWith({
    ValueGetter<BoxConstraints?>? popoverConstraints,
    ValueGetter<PopoverConstraint?>? popoverWidthConstraint,
    ValueGetter<AlignmentDirectional?>? popoverAnchorAlignment,
    ValueGetter<AlignmentDirectional?>? popoverAlignment,
    ValueGetter<AutoCompleteMode?>? mode,
  }) {
    return AutoCompleteTheme(
      popoverConstraints: popoverConstraints == null
          ? this.popoverConstraints
          : popoverConstraints(),
      popoverWidthConstraint: popoverWidthConstraint == null
          ? this.popoverWidthConstraint
          : popoverWidthConstraint(),
      popoverAnchorAlignment: popoverAnchorAlignment == null
          ? this.popoverAnchorAlignment
          : popoverAnchorAlignment(),
      popoverAlignment: popoverAlignment == null
          ? this.popoverAlignment
          : popoverAlignment(),
      mode: mode == null ? this.mode : mode(),
    );
  }

  /// Compares this object with another for value equality.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AutoCompleteTheme &&
        other.popoverConstraints == popoverConstraints &&
        other.popoverWidthConstraint == popoverWidthConstraint &&
        other.popoverAnchorAlignment == popoverAnchorAlignment &&
        other.popoverAlignment == popoverAlignment &&
        other.mode == mode;
  }

  @override
  int get hashCode => Object.hash(
    popoverConstraints,
    popoverWidthConstraint,
    popoverAnchorAlignment,
    popoverAlignment,
    mode,
  );
}
