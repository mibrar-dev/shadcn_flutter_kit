# Brief P4-T5 — language-aware syntax highlighting (registry primitive + components + docs)

User request: code blocks must show syntax colours depending on the language (Dart, JavaScript, Python, …), like the
shadcn/ui site (shiki, github-light / github-dark style; see rearch/design/shadcn-ref/screens/button-1440-*-state-codeview.png).
Today nothing highlights: `components/code_snippet`, `components/markdown` code blocks and the docs code blocks render plain.

1. New primitive `$APP/lib/registry/primitives/syntax_highlight/` (layer 2; NO new pub dependencies; files ≤ ~400 lines):
   a small, fast, regex/state-machine tokenizer producing `TextSpan`s per token kind (keyword, type/class, function,
   string, number, comment, operator/punctuation, annotation/decorator, variable/property, constant, tag/attribute, …).
   Languages: dart, javascript/typescript (+jsx/tsx basics), python, json, yaml, bash/shell, html, css, kotlin, swift,
   markdown; unknown → plain. Language from an explicit id or a fence tag (```dart) with aliases (js, ts, sh, zsh, py, yml…).
   Correctness first: multi-line strings/comments, string interpolation (Dart `$x`/`${}`, JS template literals),
   raw strings, escapes; never throws on any input (fuzz test with random text + all the kit's own .dart files).
2. Colours from the theme: add a `syntax` token group (light + dark values close to github-light/github-dark) to the theme
   layer with sensible defaults derived for every preset (no per-preset JSON edits required; optional override in schema),
   or a `SyntaxTheme` ComponentThemeData — pick the design that keeps it Studio-editable; document it.
3. Use it in `components/code_snippet` (prop `language`, default auto from fence/plain) and in `components/markdown` fenced
   code blocks (fence tag). Selection/copy still yields plain text.
4. Regenerate the manifest, re-sync the docs mirror, regenerate docs data; then make the DOCS code blocks (component code,
   install snippets, snippet galleries, Get Code dialog) pass the language so they are coloured. Coordinate: another agent
   (D6, then D7) edits docs pages — only change the docs code-block widget(s) (e.g. lib/widgets/code_block.dart / code teaser)
   to accept + pass a language; nothing else in pages.
Tests: tokenizer goldens per language (token kinds for representative snippets), fuzz no-throw, theme colours resolve in
light/dark for all 43 presets, code_snippet + markdown render coloured spans, docs code block colours a Dart sample.
Gates: kit `rearch/qa_gate.sh` + manifest --check; docs analyze/test + codegen/mirror --check; CLI e2e. Report
`$KIT/rearch/reports/P4-T5.md`. `## RESULT` block.
