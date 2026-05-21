// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../preview.dart';

/// _FadeScrollPreviewState defines a reusable type for this registry module.
class _FadeScrollPreviewState extends State<FadeScrollPreview> {
  final ScrollController _controller = ScrollController();

  @override
  /// Executes `dispose` behavior for this component/composite.
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          height: 200,
          width: 260,
          child: FadeScroll(
            controller: _controller,
            child: ListView.builder(
              controller: _controller,
              itemCount: 20,
              itemBuilder: (context, index) {
                return ListTile(title: Text('Item ${index + 1}'));
              },
            ),
          ),
        ),
      ),
    );
  }
}
