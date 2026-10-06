import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart' as intl;

import 'localizations.dart';

/// Portuguese (`pt`) locale data.
///
/// Translations only: anything this table does not override falls
/// through to the English default on [ShadcnLocalizations]. Text
/// direction is not handled here - Flutter resolves it from
/// [WidgetsLocalizations] and [Directionality].
class ShadcnLocalizationsPt extends ShadcnLocalizations {
  /// Creates the Portuguese strings.
  const ShadcnLocalizationsPt([super.locale = const Locale('pt')]);

  /// Formats [value] as a number in this locale, or returns it
  /// verbatim when it is not a number.
  String _number(Object? value) {
    if (value is! num) return '$value';
    return intl.NumberFormat.decimalPattern(localeName).format(value);
  }

  @override
  String get formNotEmpty => 'Este campo não pode ficar vazio';

  @override
  String get invalidValue => 'Valor inválido';

  @override
  String get invalidEmail => 'E-mail inválido';

  @override
  String get invalidURL => 'URL inválido';

  @override
  String formLessThan(Object? value) => 'Deve ser menor que ${_number(value)}';

  @override
  String formGreaterThan(Object? value) =>
      'Deve ser maior que ${_number(value)}';

  @override
  String formLessThanOrEqualTo(Object? value) =>
      'Deve ser menor ou igual a ${_number(value)}';

  @override
  String get formPhoneNumberInvalid => 'O número de telefone é inválido';

  @override
  String get formPhoneNumberEmpty => 'O número de telefone é obrigatório';

  @override
  String formGreaterThanOrEqualTo(Object? value) =>
      'Deve ser maior ou igual a ${_number(value)}';

  @override
  String formBetweenInclusively(Object? min, Object? max) =>
      'Deve estar entre ${_number(min)} e ${_number(max)} (inclusive)';

  @override
  String formEqualTo(Object? value) => 'Deve ser igual a ${_number(value)}';

  @override
  String formBetweenExclusively(Object? min, Object? max) =>
      'Deve estar entre ${_number(min)} e ${_number(max)} (exclusive)';

  @override
  String formLengthLessThan(int limit) =>
      'Deve ter pelo menos $limit caracteres';

  @override
  String formLengthGreaterThan(int limit) =>
      'Deve ter no máximo $limit caracteres';

  @override
  String get formPasswordDigits => 'Deve conter pelo menos um dígito';

  @override
  String get formPasswordLowercase =>
      'Deve conter pelo menos uma letra minúscula';

  @override
  String get formPasswordUppercase =>
      'Deve conter pelo menos uma letra maiúscula';

  @override
  String get formPasswordSpecial =>
      'Deve conter pelo menos um caractere especial';

  @override
  String get commandSearch => 'Digite um comando ou pesquise...';

  @override
  String get commandEmpty => 'Nenhum resultado encontrado.';

  @override
  String get datePickerSelectYear => 'Selecione um ano';

  @override
  String get abbreviatedMonday => 'Seg';

  @override
  String get abbreviatedTuesday => 'Ter';

  @override
  String get abbreviatedWednesday => 'Qua';

  @override
  String get abbreviatedThursday => 'Qui';

  @override
  String get abbreviatedFriday => 'Sex';

  @override
  String get abbreviatedSaturday => 'Sáb';

  @override
  String get abbreviatedSunday => 'Dom';

  @override
  String get monthJanuary => 'Janeiro';

  @override
  String get monthFebruary => 'Fevereiro';

  @override
  String get monthMarch => 'Março';

  @override
  String get monthApril => 'Abril';

  @override
  String get monthMay => 'Maio';

  @override
  String get monthJune => 'Junho';

  @override
  String get monthJuly => 'Julho';

  @override
  String get monthAugust => 'Agosto';

  @override
  String get monthSeptember => 'Setembro';

  @override
  String get monthOctober => 'Outubro';

  @override
  String get monthNovember => 'Novembro';

  @override
  String get monthDecember => 'Dezembro';

  @override
  String get abbreviatedJanuary => 'Jan';

  @override
  String get abbreviatedFebruary => 'Fev';

  @override
  String get abbreviatedMarch => 'Mar';

  @override
  String get abbreviatedApril => 'Abr';

  @override
  String get abbreviatedMay => 'Mai';

  @override
  String get abbreviatedJune => 'Jun';

  @override
  String get abbreviatedJuly => 'Jul';

  @override
  String get abbreviatedAugust => 'Ago';

  @override
  String get abbreviatedSeptember => 'Set';

  @override
  String get abbreviatedOctober => 'Out';

  @override
  String get abbreviatedNovember => 'Nov';

  @override
  String get abbreviatedDecember => 'Dez';

  @override
  String get buttonCancel => 'Cancelar';

  @override
  String get buttonSave => 'Salvar';

  @override
  String get timeHour => 'Hora';

  @override
  String get timeMinute => 'Minuto';

  @override
  String get timeSecond => 'Segundo';

  @override
  String get timeAM => 'AM';

  @override
  String get timePM => 'PM';

  @override
  String get colorRed => 'Vermelho';

  @override
  String get colorGreen => 'Verde';

  @override
  String get colorBlue => 'Azul';

  @override
  String get colorAlpha => 'Alfa';

  @override
  String get colorHue => 'Matiz';

  @override
  String get colorSaturation => 'Sat';

  @override
  String get colorValue => 'Val';

  @override
  String get colorLightness => 'Lum';

  @override
  String get menuCut => 'Recortar';

  @override
  String get menuCopy => 'Copiar';

  @override
  String get menuPaste => 'Colar';

  @override
  String get menuSelectAll => 'Selecionar tudo';

  @override
  String get menuUndo => 'Desfazer';

  @override
  String get menuRedo => 'Refazer';

  @override
  String get menuDelete => 'Excluir';

  @override
  String get menuShare => 'Compartilhar';

  @override
  String get menuSearchWeb => 'Pesquisar na web';

  @override
  String get menuLiveTextInput => 'Texto ao vivo';

  @override
  String get placeholderDatePicker => 'Selecione uma data';

  @override
  String get placeholderTimePicker => 'Selecione um horário';

  @override
  String get placeholderColorPicker => 'Selecione uma cor';

  @override
  String get buttonPrevious => 'Anterior';

  @override
  String get buttonNext => 'Próximo';

  @override
  String get refreshTriggerPull => 'Puxe para atualizar';

  @override
  String get refreshTriggerRelease => 'Solte para atualizar';

  @override
  String get refreshTriggerRefreshing => 'Atualizando...';

  @override
  String get refreshTriggerComplete => 'Atualização concluída';

  @override
  String get colorPickerTabRGB => 'RGB';

  @override
  String get colorPickerTabHSV => 'HSV';

  @override
  String get colorPickerTabHSL => 'HSL';

  @override
  String get colorPickerTabHEX => 'HEX';

  @override
  String get commandMoveUp => 'Mover para cima';

  @override
  String get commandMoveDown => 'Mover para baixo';

  @override
  String get commandActivate => 'Selecionar';

  @override
  String get timeDaysAbbreviation => 'DD';

  @override
  String get timeHoursAbbreviation => 'HH';

  @override
  String get timeMinutesAbbreviation => 'MM';

  @override
  String get timeSecondsAbbreviation => 'SS';

  @override
  String get placeholderDurationPicker => 'Selecione uma duração';

  @override
  String get durationDay => 'Dia';

  @override
  String get durationHour => 'Hora';

  @override
  String get durationMinute => 'Minuto';

  @override
  String get durationSecond => 'Segundo';
}
