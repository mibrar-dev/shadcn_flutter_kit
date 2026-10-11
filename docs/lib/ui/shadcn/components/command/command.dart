// The `command` component: a command palette with a debounced async result
// stream, keyboard navigation through `SubFocus`, and a dialog entry point.
//
// The old module spread this over 12 files and four Material imports
// (`command_widget`, `command_dialog`, `command_state`, `command_item_state`).
// The widgets are widgets-only now, the search field is the `input` component,
// the list surface paints from `CommandTheme`, and stream requests cancel
// their predecessors instead of leaking.
//
// Deliberate scope cuts, documented in the README: `CommandItem` is replaced by
// the shared `primitives/subfocus_list_item.dart` row (same behaviour, shared
// with future menu/select lists), and the keyboard-hint footer /
// `CommandKeyboardDisplay` / `CommandCategory` widgets were not ported (the
// component folder is capped at two code files; apps compose headers/footers
// around `Command`). Keyboard navigation itself is unchanged.

import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../foundation/icons/lucide_icons.dart';
import '../../primitives/input_features/adornment_features.dart';
import '../../primitives/input_features/input_features.dart';
import '../../primitives/localizations/localizations.dart';
import '../../primitives/subfocus_scope.dart';
import '../../primitives/text/text_extension.dart';
import '../../theme/color_tokens.dart';
import '../../theme/density.dart';
import '../../theme/theme.dart';
import '../button/button.dart';
import '../dialog/dialog.dart';
import '../dialog/dialog_style.dart';
import '../input/input.dart';
import 'command_style.dart';

export 'command_style.dart';

/// Builds the result widgets for [query]; an empty query is null.
typedef CommandBuilder =
    Stream<List<Widget>> Function(BuildContext context, String? query);

/// Builds the error state of a command palette.
typedef CommandErrorBuilder =
    Widget Function(BuildContext context, Object error, StackTrace? stackTrace);

class _NextItemIntent extends Intent {
  const _NextItemIntent();
}

class _PreviousItemIntent extends Intent {
  const _PreviousItemIntent();
}

/// A command palette with a search field, async results and keyboard support.
class Command extends StatefulWidget {
  /// Creates a command palette.
  const Command({
    super.key,
    required this.builder,
    this.autofocus = true,
    this.debounceDuration = const Duration(milliseconds: 300),
    this.emptyBuilder,
    this.errorBuilder,
    this.loadingBuilder,
    this.searchPlaceholder,
    this.theme,
  });

  /// Builds the results for the current query.
  final CommandBuilder builder;

  /// Delay between typing and running [builder]; each query restarts it.
  final Duration debounceDuration;

  /// Whether the search field takes focus when mounted.
  final bool autofocus;

  /// Shown when the finished result stream is empty.
  final WidgetBuilder? emptyBuilder;

  /// Shown when the result stream errors; defaults to the empty state.
  final CommandErrorBuilder? errorBuilder;

  /// Shown while the debounce/result stream has not produced data.
  final WidgetBuilder? loadingBuilder;

  /// Placeholder of the search field; defaults to the localized hint.
  final Widget? searchPlaceholder;

  /// Widget-leg theme override, merged over the component/app/defaults.
  final CommandTheme? theme;

  @override
  State<Command> createState() => _CommandState();
}

class _CommandState extends State<Command> {
  final TextEditingController _controller = TextEditingController();
  Stream<List<Widget>>? _stream;
  String? _query;
  int _requestId = 0;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onQueryChanged);
    _start(null);
  }

  @override
  void dispose() {
    _controller.removeListener(_onQueryChanged);
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant Command oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.builder != widget.builder ||
        oldWidget.debounceDuration != widget.debounceDuration) {
      setState(() => _start(_query));
    }
  }

  void _onQueryChanged() {
    final String? query = _controller.text.isEmpty ? null : _controller.text;
    if (query != _query) {
      setState(() => _start(query));
    }
  }

  void _start(String? query) {
    _query = query;
    _stream = _request(query);
  }

  /// Emits result batches for [query]; a stale request stops consuming its
  /// builder stream as soon as a newer request starts.
  Stream<List<Widget>> _request(String? query) async* {
    final int id = ++_requestId;
    final Duration debounce = widget.debounceDuration;
    if (debounce > Duration.zero) {
      await Future<void>.delayed(debounce);
    }
    if (!mounted || id != _requestId) {
      return;
    }
    final List<Widget> items = <Widget>[];
    await for (final List<Widget> chunk in widget.builder(context, query)) {
      if (!mounted || id != _requestId) {
        return;
      }
      items.addAll(chunk);
      yield List<Widget>.of(items);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    final CommandTheme resolved =
        resolveComponentStyle<CommandTheme, CommandTheme>(
          context,
          widget: widget.theme,
          select: (t) => t,
          defaults: commandDefaults,
        );
    final ShadcnLocalizations localizations = ShadcnLocalizations.of(context);
    // An inline palette may live outside any Navigator; only offer the close
    // button when a pop is possible.
    final bool canPop = Navigator.maybeOf(context)?.canPop() ?? false;
    final Color background =
        resolved.background?.resolve(theme.colors) ?? theme.colors.popover;
    final Color border =
        resolved.borderColor?.resolve(theme.colors) ?? theme.colors.border;
    final double borderWidth = resolved.borderWidth ?? 1;
    final BorderRadiusGeometry radius =
        resolved.borderRadius ?? theme.borderRadiusLg;
    final double scale = theme.scaling;
    // The result list's `p-1`, density-scaled.
    final EdgeInsets listPadding = resolveEdgeInsets(
      resolved.padding ?? EdgeInsetsDensity.pxAll(4),
      theme.density.baseContentPadding * scale,
    ).resolve(Directionality.of(context));

    return SubFocusScope(
      autofocus: true,
      builder: (context, scope) {
        return Actions(
          actions: <Type, Action<Intent>>{
            _NextItemIntent: CallbackAction<_NextItemIntent>(
              onInvoke: (_) {
                scope.nextFocus();
                return null;
              },
            ),
            _PreviousItemIntent: CallbackAction<_PreviousItemIntent>(
              onInvoke: (_) {
                scope.nextFocus(TraversalDirection.up);
                return null;
              },
            ),
            ActivateIntent: CallbackAction<ActivateIntent>(
              onInvoke: (intent) => scope.invokeActionOnFocused(intent),
            ),
          },
          child: Shortcuts(
            shortcuts: <ShortcutActivator, Intent>{
              const SingleActivator(LogicalKeyboardKey.arrowUp):
                  const _PreviousItemIntent(),
              const SingleActivator(LogicalKeyboardKey.arrowDown):
                  const _NextItemIntent(),
              const SingleActivator(LogicalKeyboardKey.enter):
                  const ActivateIntent(),
            },
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: background,
                border: borderWidth > 0
                    ? Border.all(color: border, width: borderWidth)
                    : null,
                borderRadius: radius,
                boxShadow: resolved.shadows ?? theme.tokens.shadows.shadowLg,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Input(
                    controller: _controller,
                    autofocus: widget.autofocus,
                    placeholder:
                        widget.searchPlaceholder ??
                        Text(localizations.commandSearch),
                    // The search row is h-9 chrome, not a field: transparent
                    // with a bottom border only, so focusing it never draws
                    // a rounded ring inside the palette.
                    decoration: BoxDecoration(
                      color: const Color(0x00000000),
                      border: borderWidth > 0
                          ? Border(
                              bottom: BorderSide(
                                color: border,
                                width: borderWidth,
                              ),
                            )
                          : null,
                    ),
                    borderRadius: BorderRadius.zero,
                    padding: EdgeInsets.symmetric(horizontal: theme.spacing.md),
                    features: <InputFeature>[
                      const InputLeadingFeature(
                        // shadcn `mr-2` on the command search icon. Held as a
                        // density multiplier; `DensityContentPadding` is the
                        // widget that paints it, so it is the one that
                        // resolves it (16 * 0.5 = 8 at the default density).
                        DensityContentPadding(
                          padding: EdgeInsetsDensity.only(
                            right: 8 / Density.pxBase,
                          ),
                          // shadcn `size-4 ... opacity-50`.
                          child: Opacity(
                            opacity: 0.5,
                            child: Icon(LucideIcons.search, size: 16),
                          ),
                        ),
                      ),
                      if (canPop)
                        InputTrailingFeature(
                          Button(
                            variant: ButtonVariant.ghost,
                            size: ButtonSize.icon,
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Icon(LucideIcons.x),
                          ),
                        ),
                    ],
                  ),
                  Flexible(
                    child: ConstrainedBox(
                      // shadcn caps the result list; taller results scroll.
                      constraints: BoxConstraints(maxHeight: 300 * scale),
                      child: _CommandResults(
                        stream: _stream,
                        listPadding: listPadding,
                        emptyBuilder: widget.emptyBuilder,
                        errorBuilder: widget.errorBuilder,
                        loadingBuilder: widget.loadingBuilder,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Renders one result-stream snapshot: loading, error, empty or list.
class _CommandResults extends StatelessWidget {
  const _CommandResults({
    required this.stream,
    required this.listPadding,
    this.emptyBuilder,
    this.errorBuilder,
    this.loadingBuilder,
  });

  final Stream<List<Widget>>? stream;

  /// Padding around the result list (the surface's `p-1`).
  final EdgeInsets listPadding;

  final WidgetBuilder? emptyBuilder;
  final CommandErrorBuilder? errorBuilder;
  final WidgetBuilder? loadingBuilder;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Widget>>(
      stream: stream,
      builder: (context, snapshot) {
        Widget empty() => emptyBuilder?.call(context) ?? const CommandEmpty();
        if (snapshot.hasError) {
          return errorBuilder?.call(
                context,
                snapshot.error!,
                snapshot.stackTrace,
              ) ??
              empty();
        }
        if (snapshot.connectionState == ConnectionState.done) {
          final List<Widget> items = snapshot.data ?? const <Widget>[];
          return items.isEmpty ? empty() : _buildList(items);
        }
        if (!snapshot.hasData) {
          // A loading cap, not a padding: shadcn's command list keeps its
          // minimum height while the stream has not produced data.
          return loadingBuilder?.call(context) ?? const SizedBox(height: 48);
        }
        return _buildList(snapshot.data!);
      },
    );
  }

  Widget _buildList(List<Widget> items) {
    // No separators between rows: apps separate groups themselves (with a
    // heading or a spacer); the list only carries the surface's `p-1`.
    return ListView(shrinkWrap: true, padding: listPadding, children: items);
  }
}

/// Default empty state shown when no command results match.
class CommandEmpty extends StatelessWidget {
  /// Creates the empty state.
  const CommandEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Text(ShadcnLocalizations.of(context).commandEmpty).small.muted,
      ),
    );
  }
}

/// Shows a modal command palette.
Future<T?> showCommandDialog<T>({
  required BuildContext context,
  required CommandBuilder builder,
  BoxConstraints? constraints,
  bool autofocus = true,
  Duration debounceDuration = const Duration(milliseconds: 300),
  WidgetBuilder? emptyBuilder,
  CommandErrorBuilder? errorBuilder,
  WidgetBuilder? loadingBuilder,
  Widget? searchPlaceholder,
  CommandTheme? theme,
}) {
  final CommandTheme resolved =
      resolveComponentStyle<CommandTheme, CommandTheme>(
        context,
        widget: theme,
        select: (t) => t,
        defaults: commandDefaults,
      );
  return showShadcnDialog<T>(
    context: context,
    // The palette paints its own surface, so the dialog contributes only the
    // route, barrier and transitions.
    theme: const DialogTheme(
      background: ThemedColor.value(Color(0x00000000)),
      borderWidth: 0,
      padding: EdgeInsets.zero,
      maxWidth: null,
      shadows: <BoxShadow>[],
    ),
    builder: (context) => ConstrainedBox(
      constraints:
          constraints ??
          BoxConstraints(
            maxWidth: resolved.maxWidth ?? 510,
            maxHeight: resolved.maxHeight ?? 349,
          ),
      child: Command(
        builder: builder,
        autofocus: autofocus,
        debounceDuration: debounceDuration,
        emptyBuilder: emptyBuilder,
        errorBuilder: errorBuilder,
        loadingBuilder: loadingBuilder,
        searchPlaceholder: searchPlaceholder,
        theme: theme,
      ),
    ),
  );
}
