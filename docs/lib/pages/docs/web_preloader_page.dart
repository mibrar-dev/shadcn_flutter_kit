import 'package:flutter/material.dart';

import '../docs_page.dart';
import 'blocks.dart';
import '../../ui/shadcn/components/layout/steps/steps.dart';
import '../../ui/shadcn/shared/primitives/text.dart';

class WebPreloaderPage extends StatelessWidget {
  const WebPreloaderPage({super.key});

  @override
  Widget build(BuildContext context) {
    final OnThisPage stepsKey = OnThisPage();
    return DocsPage(
      name: 'web_preloader',
      onThisPage: {
        'Setup steps': stepsKey,
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Web Preloader').h1(),
          const SizedBox(height: 8),
          const DocsParagraph(
            text: 'Customize how Flutter loads your web application.',
          ),
          DocsSectionTitle(title: 'Setup steps', anchor: stepsKey),
          const SizedBox(height: 12),
          const Steps(
            children: [
              StepItem(
                title: Text('Create a web directory'),
                content: [
                  DocsParagraph(
                    text:
                        'If your project does not yet have a web directory, generate one with Flutter tools.',
                  ),
                  DocsCodeBlock(
                    code: 'flutter create . --platforms=web',
                    mode: 'bash',
                  ),
                ],
              ),
              StepItem(
                title: Text('Add a preloader script'),
                content: [
                  DocsParagraph(
                    text:
                        'Copy the standard preloader script and include it in your HTML head.',
                  ),
                  DocsCodeBlock(
                    code:
                        '<script src="https://mibrar-dev.github.io/shadcn_flutter_kit/standard.js"></script>',
                    mode: 'html',
                  ),
                ],
              ),
              StepItem(
                title: Text('Paste in index.html'),
                content: [
                  DocsParagraph(
                    text:
                        'Open web/index.html and place the script tag inside <head>.',
                  ),
                  DocsCodeBlock(
                    code: '''<!DOCTYPE html>
<html>
  <head>
    ...
    <script src="https://mibrar-dev.github.io/shadcn_flutter_kit/standard.js"></script>
    ...
  </head>
</html>''',
                    mode: 'html',
                  ),
                ],
              ),
              StepItem(
                title: Text('Run the app'),
                content: [
                  DocsParagraph(text: 'Start the app in Chrome.'),
                  DocsCodeBlock(
                    code: 'flutter run -d chrome',
                    mode: 'bash',
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
