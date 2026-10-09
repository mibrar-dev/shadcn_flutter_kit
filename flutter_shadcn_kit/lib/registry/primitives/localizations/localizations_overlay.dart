// Dialog, menu and command-palette strings for [ShadcnLocalizations].

/// Overlay text for [ShadcnLocalizations]: dialogs, menus, the command palette
/// and popover affordances.
///
/// Applied by `ShadcnLocalizations`; every getter has an English default and
/// translated locale tables may override it.
mixin ShadcnLocalizationsOverlay {
  String get commandEmpty => 'No results found';

  String get commandSearch => 'Type a command or search...';

  String get commandMoveUp => 'Move up';

  String get commandMoveDown => 'Move down';

  String get commandActivate => 'Activate';

  /// Label of a dialog's dismiss control and of dismiss actions.
  ///
  /// Copied from Flutter's `modalBarrierDismissLabel`.
  String get dialogDismiss => 'Dismiss';

  String get menuCut => 'Cut';

  String get menuCopy => 'Copy';

  String get menuPaste => 'Paste';

  String get menuSelectAll => 'Select all';

  String get menuShare => 'Share';

  String get menuSearchWeb => 'Search web';

  String get menuLiveTextInput => 'Live text input';

  String get menuUndo => 'Undo';

  String get menuRedo => 'Redo';

  String get menuDelete => 'Delete';

  /// Shown by the spell check suggestions toolbar when the misspelled word
  /// has no replacement suggestion.
  ///
  /// English fallback: Flutter's material/cupertino ARB tables carry no
  /// equivalent string, so no translations are copied.
  String get spellCheckNoSuggestions => 'No suggestions';
}
