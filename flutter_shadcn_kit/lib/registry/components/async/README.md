# async

Renders a value that may already be available or may still be loading, through a
single builder. Install it alone or as a dependency (the `select` component
declares it).

## When to use

* A screen has a value that is either already cached (render immediately) or
  still loading, and you do not want two build paths.
* You want one builder for `loading` / `error` / `data` so a cached value never
  flashes a spinner.

`FutureBuilder` is still the right call when you always hold a `Future`.

## Getting started

```dart
import 'package:my_app/ui/shadcn/async/async.dart';

FutureOrBuilder<User>(
  future: repository.load(id),
  initialData: repository.cached(id),
  builder: (context, snapshot) => switch (snapshot.connectionState) {
    ConnectionState.waiting || ConnectionState.none => const SizedBox(),
    _ => Text(snapshot.data?.name ?? 'Unknown'),
  },
)
```

## API

| Member | Type | Notes |
|---|---|---|
| `future` | `FutureOr<T>` | A plain value renders once as `ConnectionState.done`; a `Future<T>` is delegated to `FutureBuilder`. |
| `builder` | `AsyncWidgetBuilder<T>` | Flutter's own typedef — runs synchronously for a plain value, on every transition otherwise. |
| `initialData` | `T?` | Reported while a `Future` is pending. Ignored for a synchronous value, which is always complete. |

## Theme

None. The component paints nothing, so there is no `<name>_style.dart` /
`<name>_theme.dart` pair.

## Differences from the old `utility/async`

| Old | New |
|---|---|
| `utility/async/async.dart` with a template suppress-all-lints pragma list | no suppressions |
| public `FutureOrWidgetBuilder<T>` typedef (a second name for `AsyncWidgetBuilder<T>`) | Flutter's `AsyncWidgetBuilder<T>` |
| `preview.dart` importing `material.dart` (`Scaffold`, `CircularProgressIndicator`) | widgets-only preview; the loading state reuses the `spinner` component |
| `async.meta.json` + `theme.schema.json` (no theme class ever existed) | one `meta.json` |