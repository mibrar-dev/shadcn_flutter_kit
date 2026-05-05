part of '../../text_field.dart';

/// _InputHintFeatureState stores and manages mutable widget state.
class _InputHintFeatureState extends InputFeatureState<InputHintFeature> {
  final _popoverController = PopoverController();

  /// Performs `_showPopup` logic for this form component.
  void _showPopup(BuildContext context) {
    _popoverController.show(
      context: context,
      builder: feature.popupBuilder,
      alignment: AlignmentDirectional.topCenter,
      anchorAlignment: AlignmentDirectional.bottomCenter,
    );
  }

  @override
  Iterable<Widget> buildTrailing() sync* {
    if (feature.position == InputFeaturePosition.trailing) {
      yield Builder(
        builder: (context) {
          return IconButton.text(
            icon: feature.icon ?? const Icon(LucideIcons.info),
            onPressed: () => _showPopup(context),
            density: ButtonDensity.compact,
          );
        },
      );
    }
  }

  @override
  Iterable<Widget> buildLeading() sync* {
    if (feature.position == InputFeaturePosition.leading) {
      yield IconButton.text(
        icon: feature.icon ?? const Icon(LucideIcons.info),
        onPressed: () => _showPopup(context),
        density: ButtonDensity.compact,
      );
    }
  }

  @override
  Iterable<MapEntry<ShortcutActivator, Intent>> buildShortcuts() sync* {
    if (feature.enableShortcuts) {
      yield const MapEntry(
        SingleActivator(LogicalKeyboardKey.f1),
        InputShowHintIntent(),
      );
    }
  }

  @override
  Iterable<MapEntry<Type, Action<Intent>>> buildActions() sync* {
    if (feature.enableShortcuts) {
      yield MapEntry(
        InputShowHintIntent,
        CallbackContextAction<InputShowHintIntent>(
          onInvoke: (intent, [context]) {
            if (context == null) {
              throw FlutterError(
                'CallbackContextAction was invoked without a valid BuildContext. '
                'This likely indicates a problem in the action system. '
                'Context must not be null when invoking InputShowHintIntent.',
              );
            }
            _showPopup(context);
            return true;
          },
        ),
      );
    }
  }
}
