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
