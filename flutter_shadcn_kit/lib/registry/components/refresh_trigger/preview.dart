// Gallery preview for the `refresh_trigger` component: the default pill in
// every stage plus a live trigger around a list. Widgets-only; the docs app
// embeds [RefreshTriggerPreview] directly.

import 'package:flutter/widgets.dart';

import '../../foundation/gap.dart';
import '../../theme/theme.dart';
import 'refresh_trigger.dart';

/// Renders the refresh trigger gallery.
class RefreshTriggerPreview extends StatefulWidget {
  /// Creates the preview.
  const RefreshTriggerPreview({super.key});

  @override
  State<RefreshTriggerPreview> createState() => _RefreshTriggerPreviewState();
}

class _RefreshTriggerPreviewState extends State<RefreshTriggerPreview> {
  TriggerStage _stage = TriggerStage.pulling;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: DefaultTextStyle(
        style: const TextStyle(fontSize: 13),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _section(
                context,
                'Stages',
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    for (final TriggerStage stage in TriggerStage.values)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: DefaultRefreshIndicator(
                          stage: RefreshTriggerStage(
                            stage,
                            const AlwaysStoppedAnimation<double>(0.5),
                            Axis.vertical,
                            false,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Gap(ShadcnTheme.of(context).spacing.xl),
              _section(
                context,
                'Live (pull the list down)',
                SizedBox(
                  height: 220,
                  child: RefreshTrigger(
                    onRefresh: () async {},
                    child: ListView.builder(
                      itemCount: 30,
                      itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Text('Row $index'),
                      ),
                    ),
                  ),
                ),
              ),
              Gap(ShadcnTheme.of(context).spacing.xl),
              _section(
                context,
                'Stage switch',
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    DefaultRefreshIndicator(
                      stage: RefreshTriggerStage(
                        _stage,
                        const AlwaysStoppedAnimation<double>(0.8),
                        Axis.vertical,
                        false,
                      ),
                    ),
                    Gap(ShadcnTheme.of(context).spacing.sm),
                    Wrap(
                      spacing: 8,
                      children: <Widget>[
                        for (final TriggerStage stage in TriggerStage.values)
                          _StageButton(
                            stage: stage,
                            selected: stage == _stage,
                            onPressed: () => setState(() => _stage = stage),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _section(BuildContext context, String title, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        Gap(ShadcnTheme.of(context).spacing.sm),
        child,
      ],
    );
  }
}

/// Stage selector button for the preview.
class _StageButton extends StatelessWidget {
  /// Creates a stage button.
  const _StageButton({
    required this.stage,
    required this.selected,
    required this.onPressed,
  });

  /// Stage selecting this button reports.
  final TriggerStage stage;

  /// Whether this stage is active.
  final bool selected;

  /// Called on tap.
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData ambient = ShadcnTheme.of(context);
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? ambient.colors.primary : ambient.colors.secondary,
          borderRadius: ambient.borderRadiusMd,
        ),
        child: Text(
          stage.name,
          style: TextStyle(
            fontSize: 12,
            color: selected
                ? ambient.colors.primaryForeground
                : ambient.colors.secondaryForeground,
          ),
        ),
      ),
    );
  }
}
