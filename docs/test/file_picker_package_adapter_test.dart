import 'package:docs/pages/docs/components/file_picker/file_picker_package_adapter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('normalizes package file picker extensions for custom filtering', () {
    expect(
      normalizeFilePickerAllowedExtensions(['.PNG', ' jpg ', '', '.pdf']),
      ['png', 'jpg', 'pdf'],
    );
    expect(normalizeFilePickerAllowedExtensions(null), isNull);
    expect(normalizeFilePickerAllowedExtensions(const []), isNull);
  });
}
