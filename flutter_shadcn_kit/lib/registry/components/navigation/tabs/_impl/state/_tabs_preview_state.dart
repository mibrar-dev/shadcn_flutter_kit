// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../preview.dart';

/// _TabsPreviewState defines a reusable type for this registry module.
class _TabsPreviewState extends State<TabsPreview> {
  /// Stores `index` state/configuration for this implementation.
  int index = 0;

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                /// Creates a `Tabs` instance.
                Tabs(
                  index: index,
                  children: const [
                    /// Creates a `TabItem` instance.
                    TabItem(child: Text('Tab 1')),

                    /// Creates a `TabItem` instance.
                    TabItem(child: Text('Tab 2')),

                    /// Creates a `TabItem` instance.
                    TabItem(child: Text('Tab 3')),
                  ],
                  onChanged: (int value) {
                    /// Creates a `setState` instance.
                    setState(() {
                      index = value;
                    });
                  },
                ),

                /// Creates a `SizedBox` instance.
                const SizedBox(height: 8),

                /// Creates a `IndexedStack` instance.
                IndexedStack(
                  index: index,
                  children: [
                    /// Creates a `Container` instance.
                    Container(
                      height: 300,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            /// Creates a `Text` instance.
                            Text(
                              'Tab 1 Content',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            /// Creates a `SizedBox` instance.
                            SizedBox(height: 8),

                            /// Creates a `Text` instance.
                            Text('This is the content for tab 1'),
                          ],
                        ),
                      ),
                    ),

                    /// Creates a `Container` instance.
                    Container(
                      height: 300,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            /// Creates a `Text` instance.
                            Text(
                              'Tab 2 Content',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            /// Creates a `SizedBox` instance.
                            SizedBox(height: 8),

                            /// Creates a `Text` instance.
                            Text('This is the content for tab 2'),
                          ],
                        ),
                      ),
                    ),

                    /// Creates a `Container` instance.
                    Container(
                      height: 300,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            /// Creates a `Text` instance.
                            Text(
                              'Tab 3 Content',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            /// Creates a `SizedBox` instance.
                            SizedBox(height: 8),

                            /// Creates a `Text` instance.
                            Text('This is the content for tab 3'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
