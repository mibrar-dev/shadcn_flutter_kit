// User-owned overrides for the `file_picker` component theme.
//
// Values only: CLI updates never overwrite this file and Studio rewrites it
// deterministically. Unset fields fall through to `fileUploadDefaults` and the
// global tokens, so an empty override keeps the exact token look.
//
// Sparse example (uncomment and complete to restyle the tile):
//
//   const FileUploadTheme fileUploadThemeOverrides = FileUploadTheme(
//     borderColor: ThemedColor.ref(ColorRef.primary, alpha: 0.5),
//     minHeight: 64,
//   );
//
// Row styling is the separate `FileUploadRowTheme` primitive
// (`primitives/file_value/file_upload_row_theme.dart`), themed through
// `ComponentThemes` or a tree `ComponentTheme<FileUploadRowTheme>`.

import 'package:flutter/widgets.dart';

import '../../theme/color_tokens.dart';
import 'file_picker_style.dart';

/// File picker overrides applied app-wide through `ComponentThemes`.
const FileUploadTheme fileUploadThemeOverrides = FileUploadTheme();
