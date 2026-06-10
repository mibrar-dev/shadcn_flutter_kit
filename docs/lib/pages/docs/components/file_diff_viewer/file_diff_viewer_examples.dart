import 'package:flutter/widgets.dart';
import '../../component_example_models.dart';
import 'file_diff_viewer_example_1.dart';
import 'file_diff_viewer_example_2.dart';
import 'file_diff_viewer_example_3.dart';

const ComponentExample fileDiffViewerExample1 = ComponentExample(
  title: 'Unified layout',
  builder: _buildExample1,
  code: "import 'package:docs/shadcn_ui.dart';\n\n"
      "/// Unified diff layout — additions and deletions in a single column.\n"
      "class FileDiffViewerExample1 extends StatelessWidget {\n"
      "  const FileDiffViewerExample1({super.key});\n\n"
      "  @override\n"
      "  Widget build(BuildContext context) {\n"
      "    return const FileDiffViewer(\n"
      "      files: [\n"
      "        FileDiff(\n"
      "          path: 'lib/src/auth/login.dart',\n"
      "          status: 'modified',\n"
      "          hunks: [\n"
      "            FileDiffHunk(\n"
      "              header: '@@ -1,6 +1,10 @@',\n"
      "              lines: [\n"
      "                FileDiffLine.deletion(\n"
      "                  oldLineNumber: 2,\n"
      "                  content: 'class LoginScreen extends StatelessWidget {',\n"
      "                ),\n"
      "                FileDiffLine.addition(\n"
      "                  newLineNumber: 2,\n"
      "                  content: 'class LoginScreen extends StatefulWidget {',\n"
      "                ),\n"
      "              ],\n"
      "            ),\n"
      "          ],\n"
      "        ),\n"
      "      ],\n"
      "      maxHeight: 320,\n"
      "    );\n"
      "  }\n"
      "}\n",
);

Widget _buildExample1(BuildContext context) => const FileDiffViewerExample1();

const ComponentExample fileDiffViewerExample2 = ComponentExample(
  title: 'Split (side-by-side) layout',
  builder: _buildExample2,
  code: "import 'package:docs/shadcn_ui.dart';\n\n"
      "/// Split layout — old version on the left, new on the right.\n"
      "class FileDiffViewerExample2 extends StatelessWidget {\n"
      "  const FileDiffViewerExample2({super.key});\n\n"
      "  @override\n"
      "  Widget build(BuildContext context) {\n"
      "    return const FileDiffViewer(\n"
      "      layout: FileDiffLayout.split,\n"
      "      files: [ /* ... same FileDiff as example 1 ... */ ],\n"
      "      maxHeight: 320,\n"
      "    );\n"
      "  }\n"
      "}\n",
);

Widget _buildExample2(BuildContext context) => const FileDiffViewerExample2();

const ComponentExample fileDiffViewerExample3 = ComponentExample(
  title: 'Multiple files with status badges',
  builder: _buildExample3,
  code: "import 'package:docs/shadcn_ui.dart';\n\n"
      "/// Multi-file diff — added, renamed, and deleted files in one viewer.\n"
      "class FileDiffViewerExample3 extends StatelessWidget {\n"
      "  const FileDiffViewerExample3({super.key});\n\n"
      "  @override\n"
      "  Widget build(BuildContext context) {\n"
      "    return const FileDiffViewer(\n"
      "      files: [\n"
      "        FileDiff(path: 'lib/src/utils/logger.dart', status: 'added', hunks: []),\n"
      "        FileDiff(\n"
      "          path: 'lib/src/utils/helpers.dart',\n"
      "          oldPath: 'lib/src/helpers.dart',\n"
      "          status: 'renamed',\n"
      "          hunks: [],\n"
      "        ),\n"
      "        FileDiff(path: 'lib/src/legacy/old_api.dart', status: 'deleted', hunks: []),\n"
      "      ],\n"
      "      maxHeight: 420,\n"
      "    );\n"
      "  }\n"
      "}\n",
);

Widget _buildExample3(BuildContext context) => const FileDiffViewerExample3();

const List<ComponentExample> fileDiffViewerExamples = [
  fileDiffViewerExample1,
  fileDiffViewerExample2,
  fileDiffViewerExample3,
];
