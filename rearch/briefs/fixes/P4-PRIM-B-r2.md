QA round 2 for P4-PRIM-B. Good work (93 tests, 14 bugs fixed, globals removed). One fix + decisions:

F1 File size: split `primitives/file_value.dart` (462) and `primitives/toast_queue.dart` (496) into folders like
`primitives/form_core/`: `primitives/file_value/` and `primitives/toast_queue/`, each file ≤ ~400 lines, split by
responsibility (e.g. model/status vs formatting/validation; queue/slots vs timers/dismiss directions). Move tests to
match if useful; every existing test must still exist and pass. No behaviour change.

Decisions: (a) color_input is a stale consumer entry — ignore it. (b) B22 will name its row widget `FileUploadRow`;
keep `FileItem` here. (c) Document the `pauseSlot` auto-dismiss policy in the toast_queue doc comment as THE policy
both `toast` (B09) and `gooey_toast` (B18) must use.

Rerun the gates on your files (other batches are in flight) and finish with the `## RESULT` block.
