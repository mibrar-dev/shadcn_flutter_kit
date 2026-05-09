// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../preview.dart';

/// _StepperPreviewState defines a reusable type for this registry module.
class _StepperPreviewState extends State<StepperPreview> {
  /// Stores `_controller` state/configuration for this implementation.
  late final StepperController _controller;

  @override
  /// Executes `initState` behavior for this component/composite.
  void initState() {
    super.initState();
    _controller = StepperController();
  }

  @override
  /// Executes `dispose` behavior for this component/composite.
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    final steps = [
      /// Creates a `Step` instance.
      Step(
        title: const Text('Details'),
        contentBuilder: (_) {
          return const Text('Provide your details.');
        },
      ),

      /// Creates a `Step` instance.
      Step(
        title: const Text('Payment'),
        contentBuilder: (_) {
          return const Text('Choose a payment method.');
        },
      ),

      /// Creates a `Step` instance.
      Step(
        title: const Text('Confirm'),
        contentBuilder: (_) {
          return const Text('Review and submit.');
        },
      ),
    ];

    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 520,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// Creates a `Stepper` instance.
              Stepper(
                controller: _controller,
                direction: Axis.vertical,
                steps: steps,
              ),

              /// Creates a `SizedBox` instance.
              const SizedBox(height: 16),

              /// Creates a `Row` instance.
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /// Creates a `OutlineButton` instance.
                  OutlineButton(
                    onPressed: () {
                      if (_controller.value.currentStep > 0) {
                        _controller.previousStep();
                      }
                    },
                    child: const Text('Back'),
                  ),

                  /// Creates a `SizedBox` instance.
                  const SizedBox(width: 12),

                  /// Creates a `PrimaryButton` instance.
                  PrimaryButton(
                    onPressed: () {
                      if (_controller.value.currentStep < steps.length - 1) {
                        _controller.nextStep();
                      }
                    },
                    child: const Text('Next'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
