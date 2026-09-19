// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

// GENERATED CODE - DO NOT MODIFY BY HAND
//
// Generated from lib/l10n/*.arb by `dart run gen:l10n_generator`.
// Edit the .arb files and rerun the generator instead.

// ignore_for_file: type=lint

import 'package:intl/intl.dart' as intl;

import '../../shadcn_localizations.dart';

/// The translations for French (`fr`).
class ShadcnLocalizationsFr extends ShadcnLocalizations {
  /// Creates the French localizations.
  ShadcnLocalizationsFr([super.locale = 'fr']);

  @override
  String get formNotEmpty => 'Ce champ ne peut pas être vide';

  @override
  String get invalidValue => 'Valeur invalide';

  @override
  String get invalidEmail => 'Adresse e-mail invalide';

  @override
  String get invalidURL => 'URL invalide';

  @override
  String formLessThan(double value) {
    final intl.NumberFormat valueNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String valueString = valueNumberFormat.format(value);

    return 'Doit être inférieur à $valueString';
  }

  @override
  String formGreaterThan(double value) {
    final intl.NumberFormat valueNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String valueString = valueNumberFormat.format(value);

    return 'Doit être supérieur à $valueString';
  }

  @override
  String formLessThanOrEqualTo(double value) {
    final intl.NumberFormat valueNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String valueString = valueNumberFormat.format(value);

    return 'Doit être inférieur ou égal à $valueString';
  }

  String get formPhoneNumberInvalid => 'Le numéro de téléphone est invalide';

  String get formPhoneNumberEmpty => 'Le numéro de téléphone est requis';

  @override
  String formGreaterThanOrEqualTo(double value) {
    final intl.NumberFormat valueNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String valueString = valueNumberFormat.format(value);

    return 'Doit être supérieur ou égal à $valueString';
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

    return 'Doit être compris entre $minString et $maxString (inclus)';
  }

  String formEqualTo(String value) {
    return 'Doit être égal à ${value}';
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

    return 'Doit être compris entre $minString et $maxString (exclus)';
  }

  @override
  String formLengthLessThan(int value) {
    return 'Doit contenir au moins ${value} caractères';
  }

  @override
  String formLengthGreaterThan(int value) {
    return 'Doit contenir au plus ${value} caractères';
  }

  @override
  String get formPasswordDigits => 'Doit contenir au moins un chiffre';

  @override
  String get formPasswordLowercase => 'Doit contenir au moins une lettre minuscule';

  @override
  String get formPasswordUppercase => 'Doit contenir au moins une lettre majuscule';

  @override
  String get formPasswordSpecial => 'Doit contenir au moins un caractère spécial';

  @override
  String get commandSearch => 'Saisissez une commande ou recherchez...';

  @override
  String get commandEmpty => 'Aucun résultat.';

  @override
  String get datePickerSelectYear => 'Sélectionner une année';

  @override
  String get abbreviatedMonday => 'Lu';

  @override
  String get abbreviatedTuesday => 'Ma';

  @override
  String get abbreviatedWednesday => 'Me';

  @override
  String get abbreviatedThursday => 'Je';

  @override
  String get abbreviatedFriday => 'Ve';

  @override
  String get abbreviatedSaturday => 'Sa';

  @override
  String get abbreviatedSunday => 'Di';

  @override
  String get monthJanuary => 'Janvier';

  @override
  String get monthFebruary => 'Février';

  @override
  String get monthMarch => 'Mars';

  @override
  String get monthApril => 'Avril';

  @override
  String get monthMay => 'Mai';

  @override
  String get monthJune => 'Juin';

  @override
  String get monthJuly => 'Juillet';

  @override
  String get monthAugust => 'Août';

  @override
  String get monthSeptember => 'Septembre';

  @override
  String get monthOctober => 'Octobre';

  @override
  String get monthNovember => 'Novembre';

  @override
  String get monthDecember => 'Décembre';

  @override
  String get abbreviatedJanuary => 'Janv.';

  @override
  String get abbreviatedFebruary => 'Févr.';

  @override
  String get abbreviatedMarch => 'Mars';

  @override
  String get abbreviatedApril => 'Avr.';

  @override
  String get abbreviatedMay => 'Mai';

  @override
  String get abbreviatedJune => 'Juin';

  @override
  String get abbreviatedJuly => 'Juil.';

  @override
  String get abbreviatedAugust => 'Août';

  @override
  String get abbreviatedSeptember => 'Sept.';

  @override
  String get abbreviatedOctober => 'Oct.';

  @override
  String get abbreviatedNovember => 'Nov.';

  @override
  String get abbreviatedDecember => 'Déc.';

  @override
  String get buttonCancel => 'Annuler';

  @override
  String get buttonSave => 'Enregistrer';

  @override
  String get timeHour => 'Heure';

  @override
  String get timeMinute => 'Minute';

  @override
  String get timeSecond => 'Seconde';

  @override
  String get timeAM => 'AM';

  @override
  String get timePM => 'PM';

  @override
  String get colorRed => 'Rouge';

  @override
  String get colorGreen => 'Vert';

  @override
  String get colorBlue => 'Bleu';

  @override
  String get colorAlpha => 'Alpha';

  @override
  String get colorHue => 'Teinte';

  @override
  String get colorSaturation => 'Sat';

  @override
  String get colorValue => 'Val';

  @override
  String get colorLightness => 'Lum';

  @override
  String get menuCut => 'Couper';

  @override
  String get menuCopy => 'Copier';

  @override
  String get menuPaste => 'Coller';

  @override
  String get menuSelectAll => 'Tout sélectionner';

  String get noSpellCheckReplacements => 'Aucune suggestion trouvée';

  @override
  String get menuUndo => 'Annuler';

  @override
  String get menuRedo => 'Rétablir';

  @override
  String get menuDelete => 'Supprimer';

  @override
  String get menuShare => 'Partager';

  @override
  String get menuSearchWeb => 'Rechercher sur le Web';

  @override
  String get menuLiveTextInput => 'Texte en direct';

  @override
  String get placeholderDatePicker => 'Sélectionner une date';

  @override
  String get placeholderTimePicker => 'Sélectionner une heure';

  @override
  String get placeholderColorPicker => 'Sélectionner une couleur';

  @override
  String get buttonPrevious => 'Précédent';

  @override
  String get buttonNext => 'Suivant';

  @override
  String get refreshTriggerPull => 'Tirez pour actualiser';

  @override
  String get refreshTriggerRelease => 'Relâchez pour actualiser';

  @override
  String get refreshTriggerRefreshing => 'Actualisation...';

  @override
  String get refreshTriggerComplete => 'Actualisation terminée';

  @override
  String get colorPickerTabRecent => 'Récents';

  @override
  String get colorPickerTabRGB => 'RVB';

  @override
  String get colorPickerTabHSV => 'TSV';

  @override
  String get colorPickerTabHSL => 'TSL';

  @override
  String get colorPickerTabHEX => 'HEX';

  @override
  String get commandMoveUp => 'Monter';

  @override
  String get commandMoveDown => 'Descendre';

  @override
  String get commandActivate => 'Sélectionner';

  @override
  String dataTableSelectedRows(int count, int total) {
    return '${count} ligne(s) sur ${total} sélectionnée(s).';
  }

  @override
  String get dataTableNext => 'Suivant';

  @override
  String get dataTablePrevious => 'Précédent';

  @override
  String get dataTableColumns => 'Colonnes';

  @override
  String get timeDaysAbbreviation => 'JJ';

  @override
  String get timeHoursAbbreviation => 'HH';

  @override
  String get timeMinutesAbbreviation => 'MM';

  @override
  String get timeSecondsAbbreviation => 'SS';

  @override
  String get placeholderDurationPicker => 'Sélectionner une durée';

  @override
  String get durationDay => 'Jour';

  @override
  String get durationHour => 'Heure';

  @override
  String get durationMinute => 'Minute';

  @override
  String get durationSecond => 'Seconde';
}
