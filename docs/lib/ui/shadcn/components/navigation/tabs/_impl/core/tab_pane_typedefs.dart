// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../tabs.dart';

/// Type alias for `TabPaneItemBuilder` used by public or internal APIs.
typedef TabPaneItemBuilder<T> =
    TabChild Function(BuildContext context, TabPaneData<T> item, int index);

/// A comprehensive tab pane widget with sortable tabs and integrated content display.
///
/// TabPane provides a complete tab interface that combines a sortable tab bar with
/// a content display area. It supports drag-and-drop reordering of tabs, scrollable
/// tab overflow, and customizable leading/trailing elements in the tab bar.
///
/// The widget manages both the tab selection state and the tab ordering, providing
/// callbacks for both focus changes and sort operations. The tab bar is horizontally
/// scrollable when tabs exceed the available width, with fade effects at the edges.
///
/// Features:
/// - Drag-and-drop sortable tabs with visual feedback
/// - Horizontal scrolling with edge fade effects for tab overflow
/// - Integrated content area with customizable styling
/// - Leading and trailing widget support in the tab bar
/// - Custom tab rendering through builder patterns
/// - Comprehensive theming and styling options
/// - Automatic focus management during sorting operations
///
/// The content area is styled as a card-like container that appears above the
/// tab bar, creating a cohesive tabbed interface suitable for complex applications.
///
/// Example:
/// ```dart
/// TabPane<String>(
///   items: [
///     TabPaneData('tab1'),
///     TabPaneData('tab2'),
///     TabPaneData('tab3'),
///   ],
///   focused: currentTab,
///   onFocused: (index) => setState(() => currentTab = index),
///   onSort: (newOrder) => setState(() => tabOrder = newOrder),
///   itemBuilder: (context, item, index) => TabChild(
///     child: Text(item.data),
///   ),
///   child: IndexedStack(
///     index: currentTab,
///     children: tabContent,
///   ),
/// )
/// ```
