# Toast (`toast`)

Overlay toast notifications with configurable timing.

---

## When to use

- Use this when:
  - you need transient feedback that does not block interaction.
  - you want stacked toasts with consistent styling.
- Avoid when:
  - user input is required (use dialog or inline errors).

---

## Install

```bash
flutter_shadcn add toast
```

---

## Import

```dart
import 'package:<your_app>/ui/shadcn/overlay/toast/toast.dart';
```

---

## Minimal example

```dart
final controller = ToastController();

controller.show(
  context: context,
  builder: (context) => const Text('Saved'),
);
```

---

## API

### Types

- `ToastController`
- `ToastEntry`
- `ToastTheme`

### Upstream compat (dual-model)

Upstream `shadcn_flutter` models toasts as `ToastEntry` values shown through
a `ToastLayer` ancestor (`ToastLayer`, `ExpandMode`, `ToastBuilder`,
`showToast` defaulting to bottomRight/5s and asserting the layer). The
registry redesign uses a `ToastController` singleton (`topRight`/3s). Both
models coexist here — the registry toast is **not** deleted:

- `ToastLayer` — opt into upstream defaults (`bottomRight`/5s) by placing it
  high in the tree. `showToast` honors those defaults when a layer is
  present and falls back to the `ToastController` path otherwise.
- `ExpandMode`, `ToastBuilder` — upstream-parity types (stack expansion is
  accepted/stored; the registry keeps one toast per position group).
- `UpstreamToastEntry` — upstream-shaped entry (`builder`/`location`/
  `dismissible`/`curve`/`duration`/`onClosed`/`showDuration`) with a `.show()`
  adapter onto `showToast`.
- `showToast` also accepts `dismissible`, `curve`, `entryDuration`,
  `onClosed`, and `showDuration` (upstream names); explicit arguments always
  win in either model.

```dart
ToastLayer(
  child: MyAppContent(),
);

// Upstream-style call site (bottomRight/5s via the layer):
showToast(
  context: context,
  builder: (context, overlay) => const Text('Saved'),
);
```

---

## Theming

- `ToastTheme` controls padding, width, background color, and animation curve.

---

## Accessibility

- Keep toast messages short and easy to scan.

---

## Do / Don’t

**Do**
- ✅ Use for non-blocking success or info feedback.

**Don’t**
- ❌ Use for errors that require explicit action.

---

## Related components

- `dialog`
- `error_system`

---

## Registry rules

- One public class per file
- Helpers under `_impl/`
