// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../tabs.dart';

/// Type alias for `TabBuilder` used by public or internal APIs.
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
