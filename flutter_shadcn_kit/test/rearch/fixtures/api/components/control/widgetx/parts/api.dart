export 'extra.dart' show Kept;
export 'hidden.dart' hide HiddenThing;

part 'api_part.dart';

const String version = '1.0';

typedef WidgetCallback = void Function(WidgetX widget);

class WidgetX {
  WidgetX() : count = 0, label = null, flag = false;

  WidgetX.named({required this.count, this.label, this.flag = true});

  final int count;
  final String? label;
  final bool flag;
  final int id = 0;

  static const String kind = 'widgetx';

  void doWork({required num amount}) {}

  int get size => id;

  set size(int value) {}

  static WidgetX create() => WidgetX();
}

int topLevel({required String name}) => name.length;
