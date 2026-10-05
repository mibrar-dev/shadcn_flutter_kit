# Brief P1-D — Theme token & preset audit (verifier)

## Goal
Verify the 42 preset JSONs against shadcn token naming and look for conversion bugs.

## Tasks
1. Read $REG/manifests/themes.schema.json and every file in $REG/themes_preset/*.json.
2. Token naming: for each preset, list keys in light, dark, tokens. Report any preset whose key set differs from
   the others (missing / extra keys). Compare against the shadcn CSS variable list:
   background, foreground, card, card-foreground, popover, popover-foreground, primary, primary-foreground,
   secondary, secondary-foreground, muted, muted-foreground, accent, accent-foreground, destructive,
   destructive-foreground, border, input, ring, chart-1..chart-5, sidebar, sidebar-foreground, sidebar-primary,
   sidebar-primary-foreground, sidebar-accent, sidebar-accent-foreground, sidebar-border, sidebar-ring, radius,
   font-sans, font-serif, font-mono, tracking-normal, spacing, shadow-color, shadow-opacity, shadow-blur,
   shadow-spread, shadow-offset-x, shadow-offset-y, shadow-2xs..shadow-2xl.
   Rule: JSON key must equal camelCase of the CSS name (chart-1 → chart1, shadow-2xs → shadow2xs).
   Report which CSS variables have no JSON home (e.g. font-*, letter spacing) — these are gaps to add.
3. Shadow bug: in claude.json all 8 shadow sizes are identical. For every preset, report whether shadow sizes
   are all identical. shadcn/tweakcn derives each size from the base shadow values (different opacity multipliers,
   2 layers for sm..xl). If $CSS or the CLI repo contains the source CSS or the converter, find the converter code
   (grep CLI and $KIT for "shadow2xs" / "shadow-2xs") and explain the root cause with file:line.
4. Colors: for 3 presets that also exist in $CSS (match by name, e.g. neutral/zinc/slate/rose if present), convert
   the CSS color values to ARGB and compare with the JSON. Report mismatches > 1 unit per channel.
5. Validate every preset against themes.schema.json (write a throwaway validator in /tmp; report failures).

## Outputs (only this)
- $KIT/rearch/reports/TOKENS_AUDIT.md — tables: key-set diffs, missing shadcn tokens, shadow-identical presets,
  root cause of the shadow bug (file:line), color mismatches, schema failures.

## Acceptance
- All 42 presets covered. Every claim cites a file (and line where relevant).
