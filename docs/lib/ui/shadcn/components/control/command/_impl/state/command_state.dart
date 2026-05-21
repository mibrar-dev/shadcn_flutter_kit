// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/material.dart' hide Theme, TextField;
import 'package:flutter/services.dart';

import '../../../button/button.dart';
import '../../../../overlay/dialog/dialog.dart' as shadcn_dialog;
import '../../../../form/text_field/text_field.dart';
import '../../../../../shared/icons/lucide_icons.dart';
import '../../../../../shared/primitives/clickable.dart';
import '../../../../../shared/primitives/focus_outline.dart';
import '../../../../../shared/primitives/outlined_container.dart';
import '../../../../../shared/primitives/subfocus.dart';
import '../../../../../shared/theme/theme.dart';
import '../../../../../shared/utils/border_utils.dart';
import '../../../../../shared/utils/constants.dart';
import '../../../../../shared/utils/color_extensions.dart';
import '../../../../../shared/primitives/text.dart';
import '../../../../../shared/utils/util.dart';
import '../../../../../shared/primitives/icon_extensions.dart';
import '../../../../../shared/utils/color_extensions.dart';
import '../../../../../shared/localizations/shadcn_localizations.dart';
import '../core/command_empty.dart';
import '../core/command_keyboard_display.dart';
import 'command_query.dart';
import '../core/command_widget.dart';
import '../utils/next_item_intent.dart';
import '../utils/previous_item_intent.dart';

/// CommandState defines a reusable type for this registry module.
class CommandState extends State<Command> {
  final TextEditingController _controller = TextEditingController();

  /// Stores `_currentRequest` state/configuration for this implementation.
  late CommandQuery _currentRequest;

  /// Stores `requestCount` state/configuration for this implementation.
  int requestCount = 0;

  Stream<List<Widget>> _request(BuildContext context, String? query) async* {
    /// Stores `currentRequest` state/configuration for this implementation.
    int currentRequest = ++requestCount;
    yield [];
    await Future.delayed(widget.debounceDuration);
    if (!context.mounted || currentRequest != requestCount) return;

    /// Stores `resultItems` state/configuration for this implementation.
    List<Widget> resultItems = [];
    await for (final items in widget.builder(context, query)) {
      if (currentRequest != requestCount) continue;
      resultItems.addAll(items);

      /// Stores `resultItems` state/configuration for this implementation.
      yield resultItems;
    }
  }

  @override
  /// Executes `initState` behavior for this component/composite.
  void initState() {
    super.initState();
    _currentRequest = CommandQuery(stream: _request(context, null));

    /// Creates a `_controller.addListener` instance.
    _controller.addListener(() {
      /// Stores `newQuery` state/configuration for this implementation.
      String? newQuery = _controller.text;
      if (newQuery.isEmpty) newQuery = null;
      if (newQuery != _currentRequest.query) {
        /// Creates a `setState` instance.
        setState(() {
          _currentRequest = CommandQuery(
            stream: _request(context, newQuery),
            query: newQuery,
          );
        });
      }
    });
  }

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final canPop = Navigator.of(context).canPop();
    final localization = ShadcnLocalizations.of(context);
    return SubFocusScope(
      autofocus: true,
      builder: (context, state) {
        return Actions(
          actions: {
            NextItemIntent: CallbackAction<NextItemIntent>(
              onInvoke: (intent) {
                state.nextFocus();
                return null;
              },
            ),
            PreviousItemIntent: CallbackAction<PreviousItemIntent>(
              onInvoke: (intent) {
                state.nextFocus(TraversalDirection.up);
                return null;
              },
            ),
            ActivateIntent: CallbackAction<ActivateIntent>(
              onInvoke: (intent) {
                state.invokeActionOnFocused(intent);
                return null;
              },
            ),
          },
          child: Shortcuts(
            shortcuts: {
              /// Creates a `LogicalKeySet` instance.
              LogicalKeySet(LogicalKeyboardKey.arrowUp):
                  /// Creates a `PreviousItemIntent` instance.
                  const PreviousItemIntent(),

              /// Creates a `LogicalKeySet` instance.
              LogicalKeySet(LogicalKeyboardKey.arrowDown):
                  /// Creates a `NextItemIntent` instance.
                  const NextItemIntent(),

              /// Creates a `LogicalKeySet` instance.
              LogicalKeySet(LogicalKeyboardKey.enter): const ActivateIntent(),
            },
            child: IntrinsicWidth(
              child: OutlinedContainer(
                clipBehavior: Clip.hardEdge,
                backgroundColor: theme.colorScheme.popover,
                borderColor: theme.colorScheme.border,
                surfaceBlur: widget.surfaceBlur ?? theme.surfaceBlur,
                surfaceOpacity: widget.surfaceOpacity ?? theme.surfaceOpacity,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    /// Creates a `ComponentTheme` instance.
                    ComponentTheme(
                      data: const FocusOutlineTheme(
                        border: Border.fromBorderSide(BorderSide.none),
                      ),
                      child: TextField(
                        autofocus: widget.autofocus,
                        border: const Border.fromBorderSide(BorderSide.none),
                        borderRadius: BorderRadius.zero,
                        controller: _controller,
                        placeholder:
                            widget.searchPlaceholder ??
                            /// Creates a `Text` instance.
                            Text(localization.commandSearch),
                        features: [
                          /// Creates a `InputFeature.leading` instance.
                          InputFeature.leading(
                            /// Creates a `Icon` instance.
                            const Icon(
                              LucideIcons.search,
                            ).iconSmall().iconMutedForeground(),
                          ),
                          if (canPop)
                            /// Creates a `InputFeature.trailing` instance.
                            InputFeature.trailing(
                              /// Creates a `GhostButton` instance.
                              GhostButton(
                                density: ButtonDensity.iconDense,
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Icon(LucideIcons.x).iconSmall(),
                              ),
                            ),
                        ],
                      ),
                    ),

                    /// Creates a `Divider` instance.
                    const Divider(),

                    /// Creates a `Expanded` instance.
                    Expanded(
                      child: StreamBuilder<List<Widget>>(
                        stream: _currentRequest.stream,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            List<Widget> items = List.of(snapshot.data!);
                            if (snapshot.connectionState ==
                                ConnectionState.active) {
                              /// Creates a `items.add` instance.
                              items.add(
                                /// Creates a `IconTheme.merge` instance.
                                IconTheme.merge(
                                  data: IconThemeData(
                                    color: theme.colorScheme.mutedForeground,
                                  ),
                                  child:
                                      /// Creates a `Center` instance.
                                      Center(
                                        child: CircularProgressIndicator(),
                                      ).withPadding(
                                        vertical:
                                            theme.density.baseGap *
                                            theme.scaling *
                                            gap2xl,
                                      ),
                                ),
                              );
                            } else if (items.isEmpty) {
                              return widget.emptyBuilder?.call(context) ??
                                  const CommandEmpty();
                            }
                            return ListView.separated(
                              separatorBuilder: (context, index) =>
                                  /// Creates a `Divider` instance.
                                  const Divider(),
                              padding: EdgeInsets.symmetric(
                                vertical: theme.scaling * 2,
                              ),
                              shrinkWrap: true,
                              itemCount: items.length,
                              itemBuilder: (context, index) => items[index],
                            );
                          }
                          return widget.loadingBuilder?.call(context) ??
                              /// Creates a `Center` instance.
                              const Center(
                                child: CircularProgressIndicator(),
                              ).withPadding(
                                vertical:
                                    theme.density.baseGap *
                                    theme.scaling *
                                    gap2xl,
                              );
                        },
                      ),
                    ),

                    /// Creates a `Divider` instance.
                    const Divider(),

                    /// Creates a `Container` instance.
                    Container(
                      color: theme.colorScheme.muted.scaleAlpha(0.35),
                      padding: EdgeInsets.symmetric(
                        horizontal:
                            theme.density.baseGap * theme.scaling * gapMd,
                        vertical: theme.density.baseGap * theme.scaling * 0.75,
                      ),
                      child: IntrinsicHeight(
                        child: Row(
                          spacing:
                              theme.density.baseGap * theme.scaling * gapSm,
                          children: [
                            /// Creates a `CommandKeyboardDisplay.fromActivator` instance.
                            CommandKeyboardDisplay.fromActivator(
                              activator: SingleActivator(
                                LogicalKeyboardKey.arrowUp,
                              ),
                            ).xSmall().muted(),

                            /// Creates a `Text` instance.
                            Text(localization.commandMoveUp).muted().small(),

                            /// Creates a `VerticalDivider` instance.
                            const VerticalDivider(),

                            /// Creates a `CommandKeyboardDisplay.fromActivator` instance.
                            CommandKeyboardDisplay.fromActivator(
                              activator: SingleActivator(
                                LogicalKeyboardKey.arrowDown,
                              ),
                            ).xSmall().muted(),

                            /// Creates a `Text` instance.
                            Text(localization.commandMoveDown).muted().small(),

                            /// Creates a `VerticalDivider` instance.
                            const VerticalDivider(),

                            /// Creates a `CommandKeyboardDisplay.fromActivator` instance.
                            CommandKeyboardDisplay.fromActivator(
                              activator: SingleActivator(
                                LogicalKeyboardKey.enter,
                              ),
                            ).xSmall().muted(),

                            /// Creates a `Text` instance.
                            Text(localization.commandActivate).muted().small(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
