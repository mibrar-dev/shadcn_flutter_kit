import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../docs_page.dart';
import 'blocks.dart';
import '../../ui/shadcn/components/layout/accordion/accordion.dart';
import '../../ui/shadcn/components/control/button/button.dart';
import '../../ui/shadcn/shared/icons/lucide_icons.dart';
import '../../ui/shadcn/shared/primitives/text.dart';

class IntroductionPage extends StatefulWidget {
  const IntroductionPage({super.key});

  @override
  State<IntroductionPage> createState() => _IntroductionPageState();
}

class _IntroductionPageState extends State<IntroductionPage> {
  final OnThisPage featuresKey = OnThisPage();
  final OnThisPage notesKey = OnThisPage();
  final OnThisPage faqKey = OnThisPage();

  @override
  Widget build(BuildContext context) {
    return DocsPage(
      name: 'introduction',
      onThisPage: {
        'Features': featuresKey,
        'Notes': notesKey,
        'Frequently Asked Questions': faqKey,
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('Introduction').h1(),
          const SizedBox(height: 8),
          const Text(
            'A shadcn/ui inspired ecosystem for Flutter: components, tokens, and tooling built to move fast across web, mobile, and desktop.',
          ).lead(),
          const SizedBox(height: 16),
          const DocsParagraph(
            text:
                'This registry focuses on delivering a cohesive UI kit that feels consistent everywhere. It is not a pixel-for-pixel port, but a pragmatic implementation that keeps the spirit of shadcn/ui while staying idiomatic to Flutter.',
          ),
          const DocsParagraph(
            text:
                'You can adopt the registry components incrementally. Keep your existing routing and app shell, and start swapping pieces as you go. The goal is to give you production-ready primitives without forcing a full rewrite. The flutter_shadcn CLI keeps the registry in sync with your project.',
          ),
          const DocsParagraph(
            text:
                'Useful links: grab the CLI, browse the GitHub repo, and inspect the registry source.',
          ),
          const Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              SizedBox(
                width: 320,
                child: DocsLinkCard(
                  icon: LucideIcons.terminal,
                  title: 'CLI on pub.dev',
                  description: 'Install and sync registry components.',
                  url: 'https://pub.dev/packages/flutter_shadcn_cli',
                ),
              ),
              SizedBox(
                width: 320,
                child: DocsLinkCard(
                  icon: LucideIcons.github,
                  title: 'GitHub',
                  description: 'Source repo, issues, and discussions.',
                  url: 'https://github.com/mibrar-dev/shadcn_flutter_kit',
                ),
              ),
              SizedBox(
                width: 320,
                child: DocsLinkCard(
                  icon: LucideIcons.archive,
                  title: 'Registry',
                  description: 'Browse registry sources and metadata.',
                  url:
                      'https://github.com/mibrar-dev/shadcn_flutter_kit/tree/main/flutter_shadcn_kit/lib/registry',
                ),
              ),
            ],
          ),
          DocsSectionTitle(title: 'Features', anchor: featuresKey),
          const SizedBox(height: 12),
          const DocsBulletList(
            items: [
              'Large component catalog with shared primitives and theming.',
              'Registry-first workflow for copy/paste or CLI installs.',
              'Optional interop with Material and Cupertino when needed.',
              'Designed for Flutter on Android, iOS, web, and desktop.',
              'Text and icon extensions for consistent typography.',
            ],
          ),
          const SizedBox(height: 16),
          DocsSectionTitle(title: 'Notes', anchor: notesKey),
          const SizedBox(height: 12),
          const DocsParagraph(
            text:
                'This toolkit is actively evolving. Expect occasional API changes while the registry and docs stabilize.',
          ),
          const DocsParagraph(
            text:
                'This project is community-driven and not affiliated with the original shadcn/ui project.',
          ),
          DocsSectionTitle(title: 'Frequently Asked Questions', anchor: faqKey),
          const SizedBox(height: 12),
          Accordion(
            items: [
              const AccordionItem(
                trigger: AccordionTrigger(
                    child: Text('Does this work with GoRouter?')),
                content: Text(
                    'Yes. GoRouter works well alongside the registry components.'),
              ),
              const AccordionItem(
                trigger: AccordionTrigger(
                    child: Text('Can I use this in production?')),
                content: Text(
                    'Yes. The components are MIT-licensed and can be used commercially.'),
              ),
              AccordionItem(
                trigger: const AccordionTrigger(
                  child: Text('Can I mix with Material or Cupertino?'),
                ),
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Yes. You can drop components into an existing app and migrate screen by screen when it makes sense.',
                    ),
                    const SizedBox(height: 8),
                    LinkButton(
                      onPressed: () => context.goNamed('installation'),
                      child: const Text('See installation guidance'),
                    ),
                  ],
                ),
              ),
              const AccordionItem(
                trigger: AccordionTrigger(
                  child: Text('Is there a default shadcn/ui style option?'),
                ),
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'This registry focuses on the New York look. You can customize tokens in the registry theme or swap preset themes in the docs app.',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
