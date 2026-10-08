# Stepper

Multi-step flow with numbered indicators and progress connectors, horizontal
or vertical, controlled or controller-driven. Widgets-only, built on
`primitives/clickable` for the indicator rings.

## When to use

- Checkout / onboarding / wizard flows that need a visible position.
- A vertical list of stages the user walks through.

For a static, read-only list of stages use `steps`; for paging use
`pagination`.

## Snippets

Controller-driven (the app owns the navigation):

```dart
final StepperController controller = StepperController();
Stepper(
  controller: controller,
  steps: <StepperStep>[
    StepperStep(title: Text('Account'), content: Text('Email, password')),
    StepperStep(title: Text('Payment'), content: Text('Card, invoice')),
  ],
);
Button(onPressed: controller.next, child: Text('Next'));
```

Controlled:

```dart
Stepper(
  currentStep: index,
  onStepChanged: (int next) => setState(() => index = next),
  direction: Axis.vertical,
  steps: steps,
);
```

Fail a step:

```dart
controller.setStepState(1, StepperStepState.failed); // destructive ring + connectors
controller.setStepState(1, null); // cleared
```

## API

| Type | Notes |
|---|---|
| `Stepper` | `steps` (required), plus `controller` **or** `currentStep`/`onStepChanged`, `direction`, `size`, `theme` |
| `StepperStep` | `title`, `content`, `icon` |
| `StepperController` | `currentStep`, `stepStates`, `next()`, `previous()`, `jumpTo(i)`, `setStepState(i, state)`; `stepCount` is kept in sync by the widget |
| `StepperIndicator` | the themed ring, public so a custom layout can reuse it |
| `StepperSize` | `sm` (36px), `md` (40px, default), `lg` (44px) |
| `StepperPhase` | `pending`, `active`, `completed`, `failed` — picks the glyph |
| `StepperStepState` | `failed` |

## Theme resolution

`widget (theme:) > ComponentTheme<StepperTheme> in tree > app overrides
(stepper_theme.dart through ComponentThemes) > stepperDefaults`, merged per
field with receiver-wins `Mergeable.merge`.

| `StepperTheme` field | Default |
|---|---|
| `direction` | `Axis.horizontal` |
| `size` | `md` |
| `active` | `secondary` fill, `primary` ring, `primary` number |
| `completed` | `primary` fill and ring, `background` check |
| `pending` | `background` fill, `border` ring, `primary` number |
| `failed` | `destructive` fill and ring, `destructiveForeground` cross |
| `connectorColor` / `connectorPendingColor` | `primary` / `border` |
| `connectorThickness` | `2` |
| `gap` | `8` |
| `titleStyle` | the size typography (`text-sm` / `text-base` / `text-large`) |

## Not carried over

The old tree had three `StepperVariant`s. `circle` is the only one left: the
alternative layout (`circleAlt`, the same rows with connectors on both sides
and centred titles) and the progress-bar variant (`line`) are documented in
`rearch/reports/P4-B14.md`; a bar-style stepper can be composed from
`StepperIndicator` and the `progress` component.

## Fixed bugs (old `registry/components/navigation/stepper`)

- `package:flutter/material.dart` is gone: `Divider`, `VerticalDivider`,
  `Colors` and `Icons` are replaced by sized `ColoredBox`es and
  `foundation/icons`.
- Seven `Data.inherit` hops (`StepProperties`, `StepNumberData`) are gone;
  the layout is built from plain arguments, so `StepNumber`/`StepTitle` (public
  in the old tree but unusable outside a `Stepper` — they read that data with
  an `assert` that is stripped in release) are dropped.
- `StepperController.nextStep()`/`previousStep()` walked past the ends; the
  controller clamps (`next()`/`previous()`/`jumpTo()` return `false` at a
  bound) and the widget clamps `currentStep`, so an out-of-range index can no
  longer blank the step content.
- The failed cross was hard-coded white; it now uses `destructiveForeground`.
- The connector after the *active* step was painted as reached
  (`currentStep >= i`); it is now `pending` until the step is passed.
- `StepperTheme.copyWith` silently dropped `themeDensity`/`themeSpacing`/
  `themeShadows`; the class now merges all three legs.
- `StepContainer` was a `StatefulWidget` with an unused `State`; use a plain
  `Column` + `Gap` for step bodies.
- Step `Data.inherit` leaks and the `AnimatedCrossFade` that force-unwrapped a
  null `contentBuilder` (crash for a step without content) are gone.
- Only the active step's content stays mounted, so the content area collapses
  to its real height (the old `IndexedStack` reserved room for every step).

## Getting started

1. Install the component (`flutter_shadcn add stepper`) or copy the folder
   into `lib/ui/shadcn/stepper/`.
2. Import `stepper.dart`; it re-exports `StepperTheme` and `stepperDefaults`.
3. App-wide overrides go in `stepper_theme.dart`; per-subtree overrides use
   `ComponentTheme<StepperTheme>(data: ..., child: ...)`.