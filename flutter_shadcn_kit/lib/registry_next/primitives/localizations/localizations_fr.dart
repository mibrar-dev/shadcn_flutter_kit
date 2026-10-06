import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart' as intl;

import 'localizations.dart';

/// French (`fr`) locale data.
///
/// Translations only: anything this table does not override falls
/// through to the English default on [ShadcnLocalizations]. Text
/// direction is not handled here - Flutter resolves it from
/// [WidgetsLocalizations] and [Directionality].
class ShadcnLocalizationsFr extends ShadcnLocalizations {
  /// Creates the French strings.
  const ShadcnLocalizationsFr([super.locale = const Locale('fr')]);

  /// Formats [value] as a number in this locale, or returns it
  /// verbatim when it is not a number.
  String _number(Object? value) {
    if (value is! num) return '$value';
    return intl.NumberFormat.decimalPattern(localeName).format(value);
  }

  @override
  String get formNotEmpty => 'Ce champ ne peut pas être vide';

  @override
  String get invalidValue => 'Valeur invalide';

  @override
  String get invalidEmail => 'Adresse e-mail invalide';

  @override
  String get invalidURL => 'URL invalide';

  @override
  String formLessThan(Object? value) =>
      'Doit être inférieur à ${_number(value)}';

  @override
  String formGreaterThan(Object? value) =>
      'Doit être supérieur à ${_number(value)}';

  @override
  String formLessThanOrEqualTo(Object? value) =>
      'Doit être inférieur ou égal à ${_number(value)}';

  @override
  String get formPhoneNumberInvalid => 'Le numéro de téléphone est invalide';

  @override
  String get formPhoneNumberEmpty => 'Le numéro de téléphone est requis';

  @override
  String formGreaterThanOrEqualTo(Object? value) =>
      'Doit être supérieur ou égal à ${_number(value)}';

  @override
  String formBetweenInclusively(Object? min, Object? max) =>
      'Doit être compris entre ${_number(min)} et ${_number(max)} (inclus)';

  @override
  String formEqualTo(Object? value) => 'Doit être égal à ${_number(value)}';

  @override
  String formBetweenExclusively(Object? min, Object? max) =>
      'Doit être compris entre ${_number(min)} et ${_number(max)} (exclus)';

  @override
  String formLengthLessThan(int limit) =>
      'Doit contenir au moins $limit caractères';

  @override
  String formLengthGreaterThan(int limit) =>
      'Doit contenir au plus $limit caractères';

  @override
  String get formPasswordDigits => 'Doit contenir au moins un chiffre';

  @override
  String get formPasswordLowercase =>
      'Doit contenir au moins une lettre minuscule';

  @override
  String get formPasswordUppercase =>
      'Doit contenir au moins une lettre majuscule';

  @override
  String get formPasswordSpecial =>
      'Doit contenir au moins un caractère spécial';

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
