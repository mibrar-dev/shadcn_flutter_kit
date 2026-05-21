// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../context_menu.dart';

/// MobileEditableTextContextMenu defines a reusable type for this registry module.
class MobileEditableTextContextMenu extends StatelessWidget {
  /// Build context for positioning the menu.
  final BuildContext anchorContext;

  /// State of the editable text field.
  final EditableTextState editableTextState;

  /// Optional controller for undo/redo functionality.
  final UndoHistoryController? undoHistoryController;

  /// Creates a [MobileEditableTextContextMenu].
  ///
  /// Parameters:
  /// - [anchorContext] (`BuildContext`, required): Anchor context.
  /// - [editableTextState] (`EditableTextState`, required): Text field state.
  /// - [undoHistoryController] (`UndoHistoryController?`, optional): Undo controller.
  const MobileEditableTextContextMenu({
    super.key,
    required this.anchorContext,
    required this.editableTextState,
    this.undoHistoryController,
  });

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    /// Stores `scaling` state/configuration for this implementation.
    final scaling = theme.scaling;
    final localizations = ShadcnLocalizations.of(context);

    /// Stores `undoHistoryController` state/configuration for this implementation.
    var undoHistoryController = this.undoHistoryController;
    var contextMenuButtonItems = List.of(
      editableTextState.contextMenuButtonItems,
    );

    /// Executes `take` behavior for this component/composite.
    ContextMenuButtonItem? take(ContextMenuButtonType type) {
      var item = contextMenuButtonItems
          .where((element) => element.type == type)
          .firstOrNull;
      if (item != null) {
        contextMenuButtonItems.remove(item);
      }
      return item;
    }

    var deleteButton = take(ContextMenuButtonType.delete);
    var cutButton = take(ContextMenuButtonType.cut);
    var copyButton = take(ContextMenuButtonType.copy);
    var pasteButton = take(ContextMenuButtonType.paste);
    var selectAllButton = take(ContextMenuButtonType.selectAll);
    var shareButton = take(ContextMenuButtonType.share);
    var searchWebButton = take(ContextMenuButtonType.searchWeb);
    var liveTextInput = take(ContextMenuButtonType.liveTextInput);

    /// Stores `modificationCategory` state/configuration for this implementation.
    List<MenuItem> modificationCategory = [];
    if (cutButton != null) {
      /// Creates a `modificationCategory.add` instance.
      modificationCategory.add(
        /// Creates a `MenuButton` instance.
        MenuButton(
          onPressed: (context) {
            cutButton.onPressed?.call();
          },
          child: Text(localizations.menuCut),
        ),
      );
    }
    if (copyButton != null) {
      /// Creates a `modificationCategory.add` instance.
      modificationCategory.add(
        /// Creates a `MenuButton` instance.
        MenuButton(
          onPressed: (context) {
            copyButton.onPressed?.call();
          },
          child: Text(localizations.menuCopy),
        ),
      );
    }
    if (pasteButton != null) {
      /// Creates a `modificationCategory.add` instance.
      modificationCategory.add(
        /// Creates a `MenuButton` instance.
        MenuButton(
          onPressed: (context) {
            pasteButton.onPressed?.call();
          },
          child: Text(localizations.menuPaste),
        ),
      );
    }
    if (selectAllButton != null) {
      /// Creates a `modificationCategory.add` instance.
      modificationCategory.add(
        /// Creates a `MenuButton` instance.
        MenuButton(
          onPressed: (context) {
            selectAllButton.onPressed?.call();
          },
          child: Text(localizations.menuSelectAll),
        ),
      );
    }

    /// Stores `destructiveCategory` state/configuration for this implementation.
    List<MenuItem> destructiveCategory = [];
    if (deleteButton != null) {
      /// Creates a `destructiveCategory.add` instance.
      destructiveCategory.add(
        /// Creates a `MenuButton` instance.
        MenuButton(
          onPressed: (context) {
            deleteButton.onPressed?.call();
          },
          child: Text(localizations.menuDelete),
        ),
      );
    }

    if (shareButton != null) {
      /// Creates a `destructiveCategory.add` instance.
      destructiveCategory.add(
        /// Creates a `MenuButton` instance.
        MenuButton(
          onPressed: (context) {
            shareButton.onPressed?.call();
          },
          child: Text(localizations.menuShare),
        ),
      );
    }

    if (searchWebButton != null) {
      /// Creates a `destructiveCategory.add` instance.
      destructiveCategory.add(
        /// Creates a `MenuButton` instance.
        MenuButton(
          onPressed: (context) {
            searchWebButton.onPressed?.call();
          },
          child: Text(localizations.menuSearchWeb),
        ),
      );
    }

    if (liveTextInput != null) {
      /// Creates a `destructiveCategory.add` instance.
      destructiveCategory.add(
        /// Creates a `MenuButton` instance.
        MenuButton(
          onPressed: (context) {
            liveTextInput.onPressed?.call();
          },
          child: Text(localizations.menuLiveTextInput),
        ),
      );
    }

    var primaryAnchor =
        (editableTextState.contextMenuAnchors.secondaryAnchor ??
            editableTextState.contextMenuAnchors.primaryAnchor) +
        const Offset(-8, 8) * scaling;
    if (undoHistoryController == null) {
      List<List<MenuItem>> categories = [
        if (modificationCategory.isNotEmpty) modificationCategory,
        if (destructiveCategory.isNotEmpty) destructiveCategory,
      ];
      return TextFieldTapRegion(
        child: _ContextMenuScope(
          child: ContextMenuPopup(
            anchorSize: Size.zero,
            anchorContext: anchorContext,
            position: primaryAnchor,
            direction: Axis.horizontal,
            children: categories
                .expand((element) => [...element])
                .toList()
                .joinSeparator(const MenuDivider()),
          ),
        ),
      );
    }

    return TextFieldTapRegion(
      child: _ContextMenuScope(
        child: AnimatedBuilder(
          animation: undoHistoryController,
          builder: (context, child) {
            /// Stores `historyCategory` state/configuration for this implementation.
            List<MenuItem> historyCategory = [];
            if (undoHistoryController.value.canUndo) {
              /// Creates a `historyCategory.add` instance.
              historyCategory.add(
                /// Creates a `MenuButton` instance.
                MenuButton(
                  enabled: undoHistoryController.value.canUndo,
                  onPressed: (context) {
                    undoHistoryController.undo();
                  },
                  child: Text(localizations.menuUndo),
                ),
              );
            }
            if (undoHistoryController.value.canRedo) {
              /// Creates a `historyCategory.add` instance.
              historyCategory.add(
                /// Creates a `MenuButton` instance.
                MenuButton(
                  enabled: undoHistoryController.value.canRedo,
                  onPressed: (context) {
                    undoHistoryController.redo();
                  },
                  child: Text(localizations.menuRedo),
                ),
              );
            }
            List<List<MenuItem>> categories = [
              if (historyCategory.isNotEmpty) historyCategory,
              if (modificationCategory.isNotEmpty) modificationCategory,
              if (destructiveCategory.isNotEmpty) destructiveCategory,
            ];

            return ContextMenuPopup(
              direction: Axis.horizontal,
              anchorContext: anchorContext,
              position: primaryAnchor,
              anchorSize: Size.zero,
              children: categories
                  .expand((element) => [...element])
                  .toList()
                  .joinSeparator(const MenuDivider()),
            );
          },
        ),
      ),
    );
  }
}

/// Builds an appropriate context menu for editable text based on platform.
///
/// Automatically selects between desktop and mobile context menu implementations
/// based on the current platform.
///
/// Parameters:
/// - [innerContext] (`BuildContext`, required): Build context.
/// - [editableTextState] (`EditableTextState`, required): Text field state.
/// - [undoHistoryController] (`UndoHistoryController?`, optional): Undo controller.
/// - [platform] (`TargetPlatform?`, optional): Override platform detection.
///
/// Note: If [platform] is not provided, it will be inferred from the theme, and
/// on web, it may be treated as mobile on small screens (width < height * 0.8).
///
/// Returns: Platform-appropriate context menu widget.
Widget buildEditableTextContextMenu(
  BuildContext innerContext,
  EditableTextState editableTextState, {
  UndoHistoryController? undoHistoryController,
  TargetPlatform? platform,
}) {
  if (platform == null) {
    // First we check if the user specified a platform via the theme.
    // When set, this one is favored.
    platform ??= Theme.of(innerContext).specifiedPlatform;

    // If the user did not specify a platform, we do some heuristics for web.
    // On web, we may treat it as mobile on small screens.
    if (kIsWeb && platform == null) {
      final size = MediaQuery.of(innerContext).size;
      // that is, if the width is significantly smaller than height
      if (size.width < size.height * 0.8) {
        // Treat as mobile on small web screens
        platform = TargetPlatform.iOS;
      }
    }

    // Finally, if still null, fall back to default platform.
    platform ??= defaultTargetPlatform;
  }

  switch (platform) {
    case TargetPlatform.android:
    case TargetPlatform.iOS:
      return MobileEditableTextContextMenu(
        anchorContext: innerContext,
        editableTextState: editableTextState,
        undoHistoryController: undoHistoryController,
      );
    case TargetPlatform.macOS:
    case TargetPlatform.windows:
    case TargetPlatform.linux:
    case TargetPlatform.fuchsia:
      return DesktopEditableTextContextMenu(
        anchorContext: innerContext,
        editableTextState: editableTextState,
        undoHistoryController: undoHistoryController,
      );
    // flutter forks might have some additional platforms
    // (e.g. flutter ohos has ohos platforms in TargetPlatform enum)
    // ignore: unreachable_switch_default
    default:
      return DesktopEditableTextContextMenu(
        anchorContext: innerContext,
        editableTextState: editableTextState,
        undoHistoryController: undoHistoryController,
      );
  }
}

/// A widget that shows a context menu when right-clicked or long-pressed.
///
/// Wraps a child widget and displays a customizable menu on context menu triggers.
///
/// Example:
/// ```dart
/// ContextMenu(
///   items: [
///     MenuButton(onPressed: (_) => print('Edit'), child: Text('Edit')),
///     MenuButton(onPressed: (_) => print('Delete'), child: Text('Delete')),
///   ],
///   child: Container(child: Text('Right-click me')),
/// )
/// ```
