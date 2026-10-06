import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart' as intl;

import 'localizations.dart';

/// Spanish (`es`) locale data.
///
/// Translations only: anything this table does not override falls
/// through to the English default on [ShadcnLocalizations]. Text
/// direction is not handled here - Flutter resolves it from
/// [WidgetsLocalizations] and [Directionality].
class ShadcnLocalizationsEs extends ShadcnLocalizations {
  /// Creates the Spanish strings.
  const ShadcnLocalizationsEs([super.locale = const Locale('es')]);

  /// Formats [value] as a number in this locale, or returns it
  /// verbatim when it is not a number.
  String _number(Object? value) {
    if (value is! num) return '$value';
    return intl.NumberFormat.decimalPattern(localeName).format(value);
  }

  @override
  String get formNotEmpty => 'Este campo no puede estar vacío';

  @override
  String get invalidValue => 'Valor no válido';

  @override
  String get invalidEmail => 'Correo electrónico no válido';

  @override
  String get invalidURL => 'URL no válida';

  @override
  String formLessThan(Object? value) => 'Debe ser menor que ${_number(value)}';

  @override
  String formGreaterThan(Object? value) =>
      'Debe ser mayor que ${_number(value)}';

  @override
  String formLessThanOrEqualTo(Object? value) =>
      'Debe ser menor o igual que ${_number(value)}';

  @override
  String get formPhoneNumberInvalid => 'El número de teléfono no es válido';

  @override
  String get formPhoneNumberEmpty => 'El número de teléfono es obligatorio';

  @override
  String formGreaterThanOrEqualTo(Object? value) =>
      'Debe ser mayor o igual que ${_number(value)}';

  @override
  String formBetweenInclusively(Object? min, Object? max) =>
      'Debe estar entre ${_number(min)} y ${_number(max)} (inclusive)';

  @override
  String formEqualTo(Object? value) => 'Debe ser igual a ${_number(value)}';

  @override
  String formBetweenExclusively(Object? min, Object? max) =>
      'Debe estar entre ${_number(min)} y ${_number(max)} (exclusive)';

  @override
  String formLengthLessThan(int limit) =>
      'Debe tener al menos $limit caracteres';

  @override
  String formLengthGreaterThan(int limit) =>
      'Debe tener como máximo $limit caracteres';

  @override
  String get formPasswordDigits => 'Debe contener al menos un dígito';

  @override
  String get formPasswordLowercase =>
      'Debe contener al menos una letra minúscula';

  @override
  String get formPasswordUppercase =>
      'Debe contener al menos una letra mayúscula';

  @override
  String get formPasswordSpecial =>
      'Debe contener al menos un carácter especial';

  @override
  String get commandSearch => 'Escribe un comando o busca...';

  @override
  String get commandEmpty => 'No se encontraron resultados.';

  @override
  String get datePickerSelectYear => 'Selecciona un año';

  @override
  String get abbreviatedMonday => 'Lu';

  @override
  String get abbreviatedTuesday => 'Ma';

  @override
  String get abbreviatedWednesday => 'Mi';

  @override
  String get abbreviatedThursday => 'Ju';

  @override
  String get abbreviatedFriday => 'Vi';

  @override
  String get abbreviatedSaturday => 'Sá';

  @override
  String get abbreviatedSunday => 'Do';

  @override
  String get monthJanuary => 'Enero';

  @override
  String get monthFebruary => 'Febrero';

  @override
  String get monthMarch => 'Marzo';

  @override
  String get monthApril => 'Abril';

  @override
  String get monthMay => 'Mayo';

  @override
  String get monthJune => 'Junio';

  @override
  String get monthJuly => 'Julio';

  @override
  String get monthAugust => 'Agosto';

  @override
  String get monthSeptember => 'Septiembre';

  @override
  String get monthOctober => 'Octubre';

  @override
  String get monthNovember => 'Noviembre';

  @override
  String get monthDecember => 'Diciembre';

  @override
  String get abbreviatedJanuary => 'Ene';

  @override
  String get abbreviatedFebruary => 'Feb';

  @override
  String get abbreviatedMarch => 'Mar';

  @override
  String get abbreviatedApril => 'Abr';

  @override
  String get abbreviatedMay => 'May';

  @override
  String get abbreviatedJune => 'Jun';

  @override
  String get abbreviatedJuly => 'Jul';

  @override
  String get abbreviatedAugust => 'Ago';

  @override
  String get abbreviatedSeptember => 'Sep';

  @override
  String get abbreviatedOctober => 'Oct';

  @override
  String get abbreviatedNovember => 'Nov';

  @override
  String get abbreviatedDecember => 'Dic';

  @override
  String get dialogDismiss => 'Cerrar';

  @override
  String get buttonCancel => 'Cancelar';

  @override
  String get buttonSave => 'Guardar';

  @override
  String get timeHour => 'Hora';

  @override
  String get timeMinute => 'Minuto';

  @override
  String get timeSecond => 'Segundo';

  @override
  String get timeAM => 'a. m.';

  @override
  String get timePM => 'p. m.';

  @override
  String get colorRed => 'Rojo';

  @override
  String get colorGreen => 'Verde';

  @override
  String get colorBlue => 'Azul';

  @override
  String get colorAlpha => 'Alfa';

  @override
  String get colorHue => 'Tono';

  @override
  String get colorSaturation => 'Sat';

  @override
  String get colorValue => 'Val';

  @override
  String get colorLightness => 'Lum';

  @override
  String get menuCut => 'Cortar';

  @override
  String get menuCopy => 'Copiar';

  @override
  String get menuPaste => 'Pegar';

  @override
  String get menuSelectAll => 'Seleccionar todo';

  @override
  String get menuUndo => 'Deshacer';

  @override
  String get menuRedo => 'Rehacer';

  @override
  String get menuDelete => 'Eliminar';

  @override
  String get menuShare => 'Compartir';

  @override
  String get menuSearchWeb => 'Buscar en la web';

  @override
  String get menuLiveTextInput => 'Texto en vivo';

  @override
  String get placeholderDatePicker => 'Selecciona una fecha';

  @override
  String get placeholderTimePicker => 'Selecciona una hora';

  @override
  String get placeholderColorPicker => 'Selecciona un color';

  @override
  String get buttonPrevious => 'Anterior';

  @override
  String get buttonNext => 'Siguiente';

  @override
  String get refreshTriggerPull => 'Desliza para actualizar';

  @override
  String get refreshTriggerRelease => 'Suelta para actualizar';

  @override
  String get refreshTriggerRefreshing => 'Actualizando...';

  @override
  String get refreshTriggerComplete => 'Actualización completada';

  @override
  String get colorPickerTabRGB => 'RGB';

  @override
  String get colorPickerTabHSV => 'HSV';

  @override
  String get colorPickerTabHSL => 'HSL';

  @override
  String get colorPickerTabHEX => 'HEX';

  @override
  String get commandMoveUp => 'Subir';

  @override
  String get commandMoveDown => 'Bajar';

  @override
  String get commandActivate => 'Seleccionar';

  @override
  String get timeDaysAbbreviation => 'DD';

  @override
  String get timeHoursAbbreviation => 'HH';

  @override
  String get timeMinutesAbbreviation => 'MM';

  @override
  String get timeSecondsAbbreviation => 'SS';

  @override
  String get placeholderDurationPicker => 'Selecciona una duración';

  @override
  String get durationDay => 'Día';

  @override
  String get durationHour => 'Hora';

  @override
  String get durationMinute => 'Minuto';

  @override
  String get durationSecond => 'Segundo';
}
