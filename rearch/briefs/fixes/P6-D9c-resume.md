Your previous run was cut off by a network drop (ECONNRESET). Nothing from you was lost on disk except what you
already wrote. Check what exists in your Outputs, then CONTINUE the same brief from where you stopped (do not start
over, do not delete files). Write large files in appended chunks (~150 lines) and verify with `tail -5`.
Finish by running every gate in your brief and printing the `## RESULT` block for THIS unit.

NOTE: the kit uses analyzer ^14 (fragment AST). 'VariableDeclaration.type' no longer exists — read the type from the parent VariableDeclarationList (`(decl.parent as VariableDeclarationList).type`) or use the installed analyzer source as the API reference.
