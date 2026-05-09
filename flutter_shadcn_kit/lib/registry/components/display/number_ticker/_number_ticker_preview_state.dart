// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of 'preview.dart';

/// _NumberTickerPreviewState holds mutable state for the number ticker implementation.
class _NumberTickerPreviewState extends State<NumberTickerPreview> {
  /// Input parameter used by `_NumberTickerPreviewState` during rendering and behavior handling.
  int _number = 0;

  /// Input parameter used by `_NumberTickerPreviewState` during rendering and behavior handling.
  int _currentNumber = 100;

  /// Controller dependency used to coordinate number ticker behavior.
  final TextEditingController _controller = TextEditingController();

  /// Disposes resources allocated by this number ticker state.
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Builds the widget tree for number ticker.
  @override
  Widget build(BuildContext context) {
    final random = Random();
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Example 1',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),

            const DensityGap(gapSm),

            NumberTicker(
              initialNumber: 0,
              number: _number,
              style: const TextStyle(fontSize: 32),
              formatter: (number) {
                return NumberFormat.compact().format(number);
              },
            ),

            const DensityGap(gap2xl),

            TextField(
              initialValue: _number.toString(),
              controller: _controller,
              onEditingComplete: () {
                final number = int.tryParse(_controller.text);
                if (number != null) {
                  /// Implements `setState` behavior for number ticker.
                  setState(() {
                    _number = number;
                  });
                }
              },
            ),

            const DensityGap(gap2xl),

            const Divider(),

            const DensityGap(gap2xl),

            const Text(
              'Example 2',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),

            const DensityGap(gapSm),

            NumberTicker(
              initialNumber: 100,
              number: _currentNumber,
              style: const TextStyle(
                fontSize: 32,
                fontFamily: 'monospace',
                fontWeight: FontWeight.w600,
              ),
              formatter: (value) => value.toInt().toString(),
            ),

            const DensityGap(gapLg),

            ElevatedButton(
              onPressed: () {
                /// Implements `setState` behavior for number ticker.
                setState(() {
                  _currentNumber = random.nextInt(9000) + 1000;
                });
              },
              child: const Text('Next Random Number'),
            ),
          ],
        ),
      ),
    );
  }
}
