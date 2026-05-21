// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:data_widget/data_widget.dart';
import 'package:flutter/widgets.dart';

import '../../../shared/theme/theme.dart';
part '_impl/core/tab_container_2.dart';
part '_impl/core/tab_item.dart';
part '_impl/core/tab_child_widget.dart';
part '_impl/core/tab_container_data.dart';
part '_impl/core/keyed_tab_child_widget.dart';
part '_impl/core/keyed_tab_item.dart';

/// {@template tab_container_theme}
/// Theme data for [TabContainer] providing default builders.
/// {@endtemplate}
class TabContainerTheme extends ComponentThemeData {
  /// Default builder for laying out tab children.
  final TabBuilder? builder;

  /// Default builder for wrapping each tab child.
  final TabChildBuilder? childBuilder;

  /// {@macro tab_container_theme}
  const TabContainerTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.builder,
    this.childBuilder,
  });

  /// Creates a copy of this theme with the given fields replaced.
  TabContainerTheme copyWith({
    ValueGetter<TabBuilder?>? builder,
    ValueGetter<TabChildBuilder?>? childBuilder,
  }) {
    return TabContainerTheme(
      builder: builder == null ? this.builder : builder(),
      childBuilder: childBuilder == null ? this.childBuilder : childBuilder(),
    );
  }

  @override
  int get hashCode => Object.hash(builder, childBuilder);

  @override
  /// Executes `operator ==` behavior for this component/composite.
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TabContainerTheme &&
        other.builder == builder &&
        other.childBuilder == childBuilder;
  }

  @override
  /// Executes `toString` behavior for this component/composite.
  String toString() {
    return 'TabContainerTheme(builder: $builder, childBuilder: $childBuilder)';
  }
}

/// Internal data class holding tab container state and callbacks.
///
/// Provides context information to child tabs including the current
/// selection state, tab index, and selection callback. Used internally
/// by the tab system to coordinate between container and children.
///
/// Accessed via [TabContainerData.of] from within tab child widgets.

/// Mixin for widgets that can be used as tab children.
///
/// Provides the interface for tab child widgets, indicating whether
/// the child participates in indexed tab selection.
mixin TabChild on Widget {
  /// Whether this tab child uses indexed positioning.
  ///
  /// When `true`, the tab's position in the list determines its index.
  /// When `false`, the tab may use a custom key for identification.
  bool get indexed;
}

/// Mixin for keyed tab children that use custom keys for identification.
///
/// Extends [TabChild] to support tab children identified by custom keys
/// of type [T] rather than positional indices.
///
/// Type parameter [T] is the type of the key used to identify this tab.
mixin KeyedTabChild<T> on TabChild {
  /// The unique key identifying this tab.
  ///
  /// Used instead of positional index for tab selection and tracking.
  T get tabKey;
}

/// A simple tab child widget wrapping arbitrary content.
///
/// Implements [TabChild] to make any widget usable within a tab container.
/// The wrapped child is rendered directly without additional decoration.

/// A keyed tab child widget identified by a custom key value.
///
/// Extends [TabChildWidget] with [KeyedTabChild] to support tab identification
/// via custom keys rather than positional indices. The key value determines
/// tab selection and tracking.
///
/// Type parameter [T] is the type of the key value.

/// A basic tab item widget.
///
/// Represents a single tab item with content that can be displayed
/// in a [TabContainer].

/// A keyed tab item widget.
///
/// Similar to [TabItem] but includes a unique key for identification.

/// Builder function for creating tab layout.
///
/// Parameters:
/// - [context] (`BuildContext`): build context
/// - [children] (`List<Widget>`): list of tab widgets
///
/// Returns: `Widget` — the tab layout widget
typedef TabBuilder =
    Widget Function(BuildContext context, List<Widget> children);

/// Builder function for creating individual tab child widgets.
///
/// Parameters:
/// - [context] (`BuildContext`): build context
/// - [data] (`TabContainerData`): tab container data
/// - [child] (`Widget`): child widget to wrap
///
/// Returns: `Widget` — the wrapped child widget
typedef TabChildBuilder =
    Widget Function(BuildContext context, TabContainerData data, Widget child);

/// Container widget for managing multiple tabs.
///
/// Provides tab selection and content display with customizable builders.
