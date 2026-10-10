// The `dropzone` component: [Dropzone] — the upload surface — plus the
// [DropzoneState] enum and its token table.
//
// Ported from `components/form/dropzone/**` (269 LOC in two files). The bugs it
// fixed are listed in README.md under "Fixed (not ported)".
//
// Three old names are gone deliberately:
//   * `FileDropzone` becomes `Dropzone`: the component id is `dropzone`, and the
//     old name implied it owned a file list, which it never did (that is
//     `primitives/file_value/`);
//   * `hotDropEnabled` / `hotDropping` are replaced by one `DropzoneState`
//     plus `isDragOver`: the old pair could disagree with each other and with
//     `state`, and `_resolveBorderColor` had to reconcile all three;
//   * `OutlineButton` is `Button(variant: ButtonVariant.outline)`.
//
// The widget is presentational on purpose: it takes a state, it does not listen
// to a drag stream. That keeps it testable without a platform drag target.

import 'package:flutter/widgets.dart';

import '../../foundation/gap.dart';
import '../../foundation/icons/radix_icons.dart';
import '../../primitives/localizations/localizations.dart';
import '../../theme/color_tokens.dart';
import '../../theme/density.dart';
import '../../theme/theme.dart';
import '../button/button.dart';
import 'dropzone_style.dart';

export 'dropzone_style.dart';

/// A dashed-look upload surface.
///
/// ```dart
/// Dropzone(
///   state: DropzoneState.uploading,
///   onBrowse: _pickFiles,
/// )
/// ```
class Dropzone extends StatelessWidget {
  /// Creates a dropzone.
  const Dropzone({
    super.key,
    this.state = DropzoneState.idle,
    this.isDragOver = false,
    this.enabled = true,
    this.focused = false,
    this.icon,
    this.hint,
    this.content,
    this.actionLabel,
    this.onBrowse,
    this.actionVariant = ButtonVariant.outline,
    this.showAction = true,
    this.theme,
  });

  /// Current upload state.
  final DropzoneState state;

  /// Whether a drag is hovering over the surface right now. Takes precedence
  /// over [state] for the border and the icon scale, because it is the live
  /// signal while [state] is the last committed outcome.
  final bool isDragOver;

  /// Whether the surface accepts input.
  final bool enabled;

  /// Whether the surface is focused for keyboard interaction.
  final bool focused;

  /// Icon above the status line; null uses the upload glyph.
  final Widget? icon;

  /// Optional helper line under the status line.
  final Widget? hint;

  /// Extra content below the action, or below the status line when
  /// [showAction] is false.
  final Widget? content;

  /// Browse button label; null resolves the localized default.
  final String? actionLabel;

  /// Called when the browse button is pressed.
  final VoidCallback? onBrowse;

  /// Browse button variant.
  final ButtonVariant actionVariant;

  /// Whether to render the browse button at all.
  final bool showAction;

  /// Widget-leg style override.
  final DropzoneTheme? theme;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData shadcnTheme = ShadcnTheme.of(context);
    final ShadcnLocalizations l10n = ShadcnLocalizations.of(context);
    final DropzoneTheme container =
        resolveComponentStyle<DropzoneTheme, DropzoneTheme>(
          context,
          widget: theme,
          select: (DropzoneTheme t) => t,
          defaults: dropzoneDefaults,
        );
    final ShadcnColors colors = shadcnTheme.colors;
    final bool hovering = isDragOver || state == DropzoneState.dragging;
    final bool interactive = enabled && state != DropzoneState.disabled;
    final Duration duration = container.duration ?? dropzoneDefaultDuration;
    final Set<WidgetState> states = <WidgetState>{
      if (hovering) WidgetState.hovered,
      if (focused) WidgetState.focused,
      if (!interactive) WidgetState.disabled,
      if (state == DropzoneState.error) WidgetState.error,
    };

    return Container(
      key: dropzoneSurfaceKey,
      width: double.infinity,
      decoration: BoxDecoration(
        color: container.background?.resolve(colors),
        borderRadius:
            container.borderRadius ??
            BorderRadius.circular(shadcnTheme.radiusLg * shadcnTheme.scaling),
        border: Border.all(
          color:
              _borderColor(container, states, colors) ??
              const Color(0x00000000),
          width: container.borderWidth ?? 1,
        ),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: (container.minHeight ?? 0) * shadcnTheme.scaling,
        ),
        child: Padding(
          padding: resolveEdgeInsets(
            container.padding ?? dropzoneDefaults.padding!,
            shadcnTheme.density.baseContentPadding * shadcnTheme.scaling,
          ),
          // No `Center` here: `Align` expands to fill a bounded parent, which
          // made the surface swallow the whole page instead of hugging its
          // content. `Column` already centres its children horizontally.
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: _buildChildren(
              context,
              container,
              shadcnTheme,
              l10n,
              interactive,
              hovering,
              duration,
            ),
          ),
        ),
      ),
    );
  }

  /// The border colour for [states]: the state's own token wins, then the
  /// theme's `borderColor` row, then nothing (an idle dropzone has no colour
  /// of its own and lets the ambient `border` show through the empty value).
  Color? _borderColor(
    DropzoneTheme container,
    Set<WidgetState> states,
    ShadcnColors colors,
  ) {
    final ThemedColor? token = switch (state) {
      DropzoneState.dragging => ThemedColor.ref(ColorRef.primary),
      DropzoneState.uploading => ThemedColor.ref(ColorRef.primary),
      DropzoneState.success => ThemedColor.ref(ColorRef.accent),
      DropzoneState.error => ThemedColor.ref(ColorRef.destructive),
      DropzoneState.idle => null,
      DropzoneState.disabled => null,
    };
    // A live drag outranks the committed state: it is the only signal the user
    // is acting on right now.
    if (isDragOver && enabled) {
      return (container.dragBorder ?? token)?.resolve(colors);
    }
    final ThemedColor? resolved =
        token ?? container.borderColor?.resolve(states);
    return resolved?.resolve(colors);
  }

  List<Widget> _buildChildren(
    BuildContext context,
    DropzoneTheme container,
    ShadcnThemeData shadcnTheme,
    ShadcnLocalizations l10n,
    bool interactive,
    bool hovering,
    Duration duration,
  ) {
    final double gap = container.gap ?? 16;
    final Widget? hint = this.hint;
    final Widget? content = this.content;
    return <Widget>[
      AnimatedScale(
        key: dropzoneIconKey,
        scale: hovering ? (container.hoverScale ?? 1.05) : 1,
        duration: duration,
        curve: Curves.easeOut,
        child:
            icon ??
            Icon(
              RadixIcons.upload,
              size: (container.iconSize ?? 28) * shadcnTheme.scaling,
              color: (container.iconColor ?? dropzoneDefaults.iconColor)
                  ?.resolve(shadcnTheme.colors),
            ),
      ),
      Gap(gap),
      AnimatedOpacity(
        opacity: interactive ? 1 : 0.6,
        duration: duration,
        child: DefaultTextStyle.merge(
          style: (container.statusStyle ?? dropzoneDefaults.statusStyle!)
              .copyWith(color: shadcnTheme.colors.mutedForeground),
          textAlign: TextAlign.center,
          child: Text(
            _status(l10n),
            textAlign: TextAlign.center,
            key: dropzoneStatusKey,
          ),
        ),
      ),
      if (hint != null) ...<Widget>[
        Gap((container.hintGap ?? 4) * shadcnTheme.scaling),
        AnimatedOpacity(
          opacity: interactive ? 1 : 0.6,
          duration: duration,
          child: DefaultTextStyle.merge(
            style: (container.hintStyle ?? dropzoneDefaults.hintStyle!)
                .copyWith(color: shadcnTheme.colors.mutedForeground),
            textAlign: TextAlign.center,
            child: hint,
          ),
        ),
      ],
      if (showAction) ...<Widget>[
        Gap((container.actionGap ?? 24) * shadcnTheme.scaling),
        AnimatedOpacity(
          opacity: interactive ? 1 : 0.6,
          duration: duration,
          child: Button(
            key: dropzoneActionKey,
            variant: actionVariant,
            size: ButtonSize.md,
            onPressed: interactive ? onBrowse : null,
            child: Text(actionLabel ?? l10n.dropzoneBrowse),
          ),
        ),
      ],
      if (content != null) ...<Widget>[Gap(gap), content],
    ];
  }

  String _status(ShadcnLocalizations l10n) {
    if (!enabled || state == DropzoneState.disabled) {
      return l10n.dropzoneDisabled;
    }
    if (isDragOver) {
      return l10n.dropzoneDragging;
    }
    return switch (state) {
      DropzoneState.idle => l10n.dropzoneIdle,
      DropzoneState.dragging => l10n.dropzoneDragging,
      DropzoneState.uploading => l10n.dropzoneUploading,
      DropzoneState.success => l10n.dropzoneSuccess,
      DropzoneState.error => l10n.dropzoneError,
      DropzoneState.disabled => l10n.dropzoneDisabled,
    };
  }
}

/// Lookup key of the dropzone surface.
const ValueKey<String> dropzoneSurfaceKey = ValueKey<String>(
  'shadcn.dropzone.surface',
);

/// Lookup key of the upload icon.
const ValueKey<String> dropzoneIconKey = ValueKey<String>(
  'shadcn.dropzone.icon',
);

/// Lookup key of the status line.
const ValueKey<String> dropzoneStatusKey = ValueKey<String>(
  'shadcn.dropzone.status',
);

/// Lookup key of the browse action.
const ValueKey<String> dropzoneActionKey = ValueKey<String>(
  'shadcn.dropzone.action',
);
