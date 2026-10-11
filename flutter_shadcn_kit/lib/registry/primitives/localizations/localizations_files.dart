// File picker, dropzone and upload strings for [ShadcnLocalizations].

/// File-picker, dropzone and upload text for [ShadcnLocalizations].
///
/// Flutter's ARB files have no file-upload equivalents, so these are English
/// fallbacks only: a locale may override them, but nothing else is copied in
/// here.
///
/// Applied by `ShadcnLocalizations`.
mixin ShadcnLocalizationsFiles {
  /// `dropzone` status line while nothing is happening.
  ///
  /// No Flutter ARB equivalent exists, so this is the English fallback only.
  String get dropzoneIdle => 'Browse to upload files';

  /// `dropzone` status line while a drag hovers over the surface.
  ///
  /// No Flutter ARB equivalent exists, so this is the English fallback only.
  String get dropzoneDragging => 'Drop files to upload';

  /// `dropzone` status line while the files are being written.
  ///
  /// No Flutter ARB equivalent exists, so this is the English fallback only.
  String get dropzoneUploading => 'Uploading files...';

  /// `dropzone` status line after a successful upload.
  ///
  /// No Flutter ARB equivalent exists, so this is the English fallback only.
  String get dropzoneSuccess => 'Files ready';

  /// `dropzone` status line after a failed upload.
  ///
  /// No Flutter ARB equivalent exists, so this is the English fallback only.
  String get dropzoneError => 'Fix errors to continue';

  /// `dropzone` status line while the surface is disabled.
  ///
  /// No Flutter ARB equivalent exists, so this is the English fallback only.
  String get dropzoneDisabled => 'File uploads disabled';

  /// Default `dropzone` browse action label.
  ///
  /// No Flutter ARB equivalent exists, so this is the English fallback only.
  String get dropzoneBrowse => 'Browse files';

  // File upload strings (the `file_picker` component and `FileUploadRow`).
  //
  // Flutter's ARB files have no file-upload equivalents, so these are English
  // fallbacks only.

  /// Pick/browse label of the file surfaces.
  String get fileUploadChoose => 'Choose file';

  /// Tile label while nothing is selected.
  String get fileUploadNoFile => 'No file chosen';

  /// Error shown when the platform picker threw.
  String get fileUploadPickFailed => 'File picking failed.';

  /// Validation: more files than the constraint allows.
  String get fileUploadTooMany => 'Too many files selected.';

  /// Validation: one file is over the size limit.
  String get fileUploadTooLarge => 'File is too large.';

  /// Validation: extension or MIME type not allowed.
  String get fileUploadInvalidType => 'File type is not allowed.';

  /// Upload failure without a file (e.g. the picker failed).
  String get fileUploadUploadFailed => 'Upload failed.';

  /// Upload failure for one file.
  String fileUploadUploadFailedFor(String name) => 'Upload failed for $name.';

  /// Status label for [FileStatus.queued].
  String get fileUploadStatusQueued => 'Queued';

  /// Status label for [FileStatus.uploading].
  String get fileUploadStatusUploading => 'Uploading';

  /// Status label for [FileStatus.success].
  String get fileUploadStatusCompleted => 'Completed';

  /// Status label for [FileStatus.error].
  String get fileUploadStatusFailed => 'Failed';

  /// Type label for a file without an extension.
  String get fileUploadUnknownType => 'File';

  /// Row action: remove the file.
  String get fileUploadRemove => 'Remove file';

  /// Row action: retry the upload.
  String get fileUploadRetry => 'Retry upload';

  /// Row action: preview the file.
  String get fileUploadPreview => 'Preview file';

  /// Row action: download the file.
  String get fileUploadDownload => 'Download file';
}
