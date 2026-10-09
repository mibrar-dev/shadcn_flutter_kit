// Gallery preview for the `breadcrumb` component: default chevron, slash
// separator, a single crumb, custom padding and the dark palette.
// Widgets-only; the docs app embeds [BreadcrumbPreview] directly.

import 'package:flutter/widgets.dart';

import '../../foundation/gap.dart';
import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';
import 'breadcrumb.dart';

/// Renders the breadcrumb gallery.
class BreadcrumbPreview extends StatelessWidget {
  /// Creates the preview.
  const BreadcrumbPreview({super.key});

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return Directionality(
      textDirection: TextDirection.ltr,
      child: DefaultTextStyle(
        style: TextStyle(color: theme.colors.foreground, fontSize: 13),
        child: ColoredBox(
          color: theme.colors.background,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _section('Default chevron', _trail()),
                const Gap(24),
                _section('Slash separator', _slash()),
                const Gap(24),
                _section('Single crumb', _single()),
                const Gap(24),
                _section('Padded', _padded()),
                const Gap(24),
                _section('Dark', _dark()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _trail() {
    return const Breadcrumb(
      children: <Widget>[Text('Home'), Text('Components'), Text('Breadcrumb')],
    );
  }

  Widget _slash() {
    return const Breadcrumb(
      separator: Breadcrumb.slashSeparator,
      children: <Widget>[
        Text('src'),
        Text('components'),
        Text('breadcrumb.dart'),
      ],
    );
  }

  Widget _single() {
    return const Breadcrumb(children: <Widget>[Text('Home')]);
  }

  Widget _padded() {
    return const Breadcrumb(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      children: <Widget>[Text('Docs'), Text('Getting started')],
    );
  }

  Widget _dark() {
    return const ShadcnTheme(
      data: ShadcnThemeData(colors: ShadcnColors.darkFallback),
      child: Breadcrumb(
        children: <Widget>[Text('Home'), Text('Account'), Text('Security')],
      ),
    );
  }

  Widget _section(String title, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const Gap(8),
        child,
      ],
    );
  }
}
