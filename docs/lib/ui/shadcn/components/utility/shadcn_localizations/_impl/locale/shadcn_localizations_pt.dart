// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

// GENERATED CODE - DO NOT MODIFY BY HAND
//
// Generated from lib/l10n/*.arb by `dart run gen:l10n_generator`.
// Edit the .arb files and rerun the generator instead.

// ignore_for_file: type=lint

import 'package:intl/intl.dart' as intl;

import '../../shadcn_localizations.dart';

/// The translations for Portuguese (`pt`).
class ShadcnLocalizationsPt extends ShadcnLocalizations {
  /// Creates the Portuguese localizations.
  ShadcnLocalizationsPt([super.locale = 'pt']);

  @override
  String get formNotEmpty => 'Este campo não pode ficar vazio';

  @override
  String get invalidValue => 'Valor inválido';

  @override
  String get invalidEmail => 'E-mail inválido';

  @override
  String get invalidURL => 'URL inválido';

  @override
  String formLessThan(double value) {
    final intl.NumberFormat valueNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String valueString = valueNumberFormat.format(value);

    return 'Deve ser menor que $valueString';
  }

  @override
  String formGreaterThan(double value) {
    final intl.NumberFormat valueNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String valueString = valueNumberFormat.format(value);

    return 'Deve ser maior que $valueString';
  }

  @override
  String formLessThanOrEqualTo(double value) {
    final intl.NumberFormat valueNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String valueString = valueNumberFormat.format(value);

    return 'Deve ser menor ou igual a $valueString';
  }

  String get formPhoneNumberInvalid => 'O número de telefone é inválido';

  String get formPhoneNumberEmpty => 'O número de telefone é obrigatório';

  @override
  String formGreaterThanOrEqualTo(double value) {
    final intl.NumberFormat valueNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String valueString = valueNumberFormat.format(value);

    return 'Deve ser maior ou igual a $valueString';
  }

  @override
  String formBetweenInclusively(double min, double max) {
    final intl.NumberFormat minNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String minString = minNumberFormat.format(min);
    final intl.NumberFormat maxNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String maxString = maxNumberFormat.format(max);

    return 'Deve estar entre $minString e $maxString (inclusive)';
  }

  String formEqualTo(String value) {
    return 'Deve ser igual a ${value}';
  }

  @override
  String formBetweenExclusively(double min, double max) {
    final intl.NumberFormat minNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String minString = minNumberFormat.format(min);
    final intl.NumberFormat maxNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String maxString = maxNumberFormat.format(max);

    return 'Deve estar entre $minString e $maxString (exclusive)';
  }

  @override
  String formLengthLessThan(int value) {
    return 'Deve ter pelo menos ${value} caracteres';
  }

  @override
  String formLengthGreaterThan(int value) {
    return 'Deve ter no máximo ${value} caracteres';
  }

  @override
  String get formPasswordDigits => 'Deve conter pelo menos um dígito';

  @override
  String get formPasswordLowercase => 'Deve conter pelo menos uma letra minúscula';

  @override
  String get formPasswordUppercase => 'Deve conter pelo menos uma letra maiúscula';

  @override
  String get formPasswordSpecial => 'Deve conter pelo menos um caractere especial';

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

  String get noSpellCheckReplacements => 'Nenhuma sugestão encontrada';

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
  String get colorPickerTabRecent => 'Recentes';

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
  String dataTableSelectedRows(int count, int total) {
    return '${count} de ${total} linha(s) selecionada(s).';
  }

  @override
  String get dataTableNext => 'Próximo';

  @override
  String get dataTablePrevious => 'Anterior';

  @override
  String get dataTableColumns => 'Colunas';

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
