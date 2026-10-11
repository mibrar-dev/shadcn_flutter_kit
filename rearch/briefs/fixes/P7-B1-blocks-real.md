# Brief P7-B1 — make every block production-quality: no clipping, no stretching, real validated forms

KIT=/Users/ibrar/Desktop/infinora.noworkspace/shadcn_copy_paste/shadcn_flutter_kit, APP=$KIT/flutter_shadcn_kit,
DOCS=$KIT/docs. Orchestrator visual audit of all 16 blocks at 1440 (dark): `rearch/design/ours/screens/
blocks-audit-2026-10-11/blocks-montage-{1,2}.png` (do NOT open PNGs yourself — model crashes on images; findings below).
Reference: ui.shadcn.com/blocks (agent-browser, SHORT commands) — match their composition, max-widths and spacing.

User (2026-10-11): blocks look stretched and not usable as-is; a block must be a fully WORKING block, and every form
must use the kit's shadcn-style form validation (registry `form` component: `ShadcnForm`, `ShadcnFormField`,
`FormFieldMessages`, validators in `primitives/form_core/validators*.dart`).

## Findings to fix
1. Docs viewport CLIPS blocks: frames use static per-block heights (P6-P2), so account-01 (Save changes button cut),
   account-02, dashboard-01 (transactions table cut), dashboard-02 (traffic/devices cut) are truncated. The frame must
   size to the block's intrinsic height at the chosen viewport width (measure; min ~360, no max for desktop page
   blocks, or a max with internal scroll + fade for very tall ones) — nothing ever clipped. Remove the static table.
2. Stretched layouts: account-01 settings spans 1200px+ with half-width Name/Username inputs and full-width Bio;
   login-02 form stretches across half the page. Apply shadcn max-widths: auth cards max-w-sm (384px) centred; split
   auth (login-02) = two equal columns with the form column centred at max-w-xs; settings pages max-w-3xl/4xl with a
   consistent 2-col grid (equal widths) or single column; dashboards full width but cards in a proper responsive grid.
   No control stretched beyond its sensible width; consistent label→control gaps (8px) and section gaps (24px).
3. login-02 right panel is a garish red/green/blue stretched placeholder image. Replace with a tasteful theme-token
   panel (muted background, subtle pattern/gradient from tokens, logo + testimonial quote) — no network images, works
   in light/dark and every preset.
4. Sidebars: sidebar-02/03 main areas are mostly empty; sidebar-01 fine. Fill with realistic content (cards/table/
   activity) like shadcn's sidebar blocks; sidebar height fills the frame; mobile (375) collapses to a sheet/drawer
   with a trigger.
5. REAL forms everywhere (login-01/02/03, signup-01/02, otp-01, account-01/02, pricing contact if any, sidebar search
   as applicable): wrap in `ShadcnForm`, every field a `ShadcnFormField` with validators — required, email format,
   password min length (8) + strength meter wired to the field (signup-02), confirm/match where present, terms
   checkbox required, OTP exactly 6 digits, username pattern, bio max length. Submit button validates; invalid →
   inline error messages under fields (FormFieldMessages, destructive token) and focus the first invalid field;
   valid → loading state on the button (disabled + spinner) for a short simulated async call, then a success toast or
   inline success alert; Enter submits; errors clear on edit. Expose `onSubmit` callbacks (typed data) so an installed
   block is wired by the app, with sensible demo defaults. If the registry form API lacks something, report it (do not
   edit registry components — agents P7-U1/U2 own them); you may edit `lib/registry/blocks/**` freely.
6. Every block must look right at desktop / tablet / mobile viewports in light + dark, neutral + claude.
## Tests
Per form block: invalid submit shows the expected messages and does not call onSubmit; valid submit calls onSubmit
once with typed data and shows loading → success. Layout: no block wider than its max-width; no overflow at 375/768/
1440; docs frame height == block intrinsic height (no clipping) for every block.
## Gates
`cd $KIT && rearch/qa_gate.sh`; manifest + blocks generators regenerate then --check; docs format/analyze/test/
codegen --check/sync (run)/--check/build web --release. (If docs/registry fails to compile on P7-U1/U2 files, report and
run your targeted tests.) Captures → `rearch/design/ours/screens/p7b1-*.png` (all 16 at 1440 dark, 5 at 375 light).
Report `$KIT/rearch/reports/P7-B1.md`, `## RESULT`. Append progress after each block. No git ops.
