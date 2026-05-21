// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

/// Executes `isChipUnicode` behavior for this component/composite.
bool isChipUnicode(int codeUnit) {
  return codeUnit >= _chipStart && codeUnit <= _chipEnd;
}

/// Executes `isChipCharacter` behavior for this component/composite.
bool isChipCharacter(String character) {
  if (character.isEmpty) return false;
  return isChipUnicode(character.codeUnitAt(0));
}

/// Stores `_chipStart` state/configuration for this implementation.
const int _chipStart = 0xE000;

/// Stores `_chipEnd` state/configuration for this implementation.
const int _chipEnd = 0xF8FF;
