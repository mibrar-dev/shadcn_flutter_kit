// The `Open Preset` dialog (spec §2.7 requirement 3): paste a schema-v2 preset
// document, validate it against the registry's own rules, and apply it.
//
// Validation is not a docs-side approximation — `ThemeDocument.fromJson`
// enforces the same contract as `themes.schema.json` (all 32 colour tokens in
// both modes, `schemaVersion` 2, six shadow atoms per mode, hex colours) and
// names the offending field, which the dialog shows verbatim. An invalid paste
// leaves the live theme untouched.

import 'dart:convert';

import 'package:flutter/widgets.dart';

import '../state/site_theme_model.dart';
import '../theme/theme_document.dart';
import '../ui/shadcn/components/button/button.dart';
import '../ui/shadcn/components/dialog/dialog.dart';
import '../ui/shadcn/components/text_area/text_area.dart';
import '../ui/shadcn/foundation/gap.dart';
import '../ui/shadcn/theme/theme.dart';

/// Shows the `Open Preset` paste dialog; resolves true when a document was
/// applied.
Future<bool> showOpenPresetDialog(
  BuildContext context,
  SiteThemeModel model,
) async {
  final bool? applied = await showShadcnDialog<bool>(
    context: context,
    builder: (BuildContext context) => _OpenPresetDialog(model: model),
  );
  return applied ?? false;
}

class _OpenPresetDialog extends StatefulWidget {
  const _OpenPresetDialog({required this.model});

  final SiteThemeModel model;

  @override
  State<_OpenPresetDialog> createState() => _OpenPresetDialogState();
}

class _OpenPresetDialogState extends State<_OpenPresetDialog> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.model.json,
  );
  String? _error;

  @override
  void initState() {
    super.initState();
    // The Apply button follows the parsed shape, so every keystroke has to
    // re-run the cheap decode check.
    _controller.addListener(_onChanged);
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_onChanged)
      ..dispose();
    super.dispose();
  }

  void _onChanged() {
    if (mounted) {
      setState(() => _error = null);
    }
  }

  void _apply() {
    try {
      widget.model.applyPresetJson(_controller.text);
      Navigator.of(context, rootNavigator: true).pop(true);
    } on FormatException catch (error) {
      setState(() => _error = 'Invalid JSON: ${error.message}');
    } on ThemeDocumentException catch (error) {
      setState(() => _error = error.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    final Object? decoded = _tryDecode(_controller.text);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Open Preset', style: theme.typography.h4),
          const Gap(8),
          Text(
            'Paste a schema-v2 preset document (the JSON tab of Get Code).',
            style: theme.typography.small.copyWith(
              color: theme.colors.mutedForeground,
            ),
          ),
          const Gap(12),
          SizedBox(
            width: 640,
            child: TextArea(
              key: const ValueKey<String>('open-preset-input'),
              controller: _controller,
              minLines: 8,
              maxLines: 12,
              hintText: '{ "id": "my-theme", … }',
            ),
          ),
          const Gap(8),
          if (_error != null)
            Text(
              _error!,
              style: theme.typography.small.copyWith(
                color: theme.colors.destructive,
              ),
            ),
          const Gap(12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Button(
                variant: ButtonVariant.ghost,
                size: ButtonSize.sm,
                onPressed: () =>
                    Navigator.of(context, rootNavigator: true).pop(false),
                child: const Text('Cancel'),
              ),
              const Gap(8),
              Button(
                key: const ValueKey<String>('open-preset-apply'),
                variant: ButtonVariant.primary,
                size: ButtonSize.sm,
                onPressed: decoded is Map ? _apply : null,
                child: const Text('Apply'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Object? _tryDecode(String source) {
  try {
    return jsonDecode(source);
  } on FormatException {
    return null;
  }
}
