Round 2 for P3-F. Your §1–§3 fixes are accepted and committed. One more real bug (not a harness artifact):
the input's typed text renders without the theme font — EditableText receives a TextStyle with no fontFamily, while
Text widgets inherit the theme's DefaultTextStyle. In a real app the typed text would use the platform default font
instead of the theme font (e.g. Geist). Fix it in `primitives/text_editing/` (so text_area, input_otp, number/
formatted inputs that reuse it are fixed too): the editable style must be built from the ambient text style /
ShadcnTheme typography (fontFamily, fontFamilyFallback, size 14 / `text-sm`, height, colour foreground,
placeholder mutedForeground), merged under any explicit style the caller passes. Add a test asserting the
EditableText style's fontFamily equals the theme's sans family and the placeholder uses mutedForeground.
Then regenerate the input screenshots (the filled values must show real glyphs) and, if feasible, add a generator
for input_menu_*.png (context menu open over a selection) or delete those two stale PNGs.
Outputs: primitives/text_editing/**, components/input/**, their tests, the visual test + PNGs, P3V_VISUAL.md.
Gates: `rearch/qa_batch.sh input primitives/text_editing` and `flutter test test/registry_next/visual`.
