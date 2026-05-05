// GENERATED CODE - DO NOT MODIFY BY HAND.
// Run: dart run tool/theme/component_theme_global_configs_generate.dart

import '../shared/theme/component_theme_global_registry.dart';
import 'control/button/_impl/themes/config/button_theme_config.dart' as c0;
import 'control/hover/_impl/themes/config/hover_theme_config.dart' as c1;
import 'control/scrollbar/_impl/themes/config/scrollbar_theme_config.dart' as c2;
import 'display/avatar/_impl/themes/config/avatar_theme_config.dart' as c3;
import 'display/badge/_impl/themes/config/badge_theme_config.dart' as c4;
import 'display/calendar/_impl/themes/config/calendar_theme_config.dart' as c5;
import 'display/carousel/_impl/themes/config/carousel_theme_config.dart' as c6;
import 'display/chip/_impl/themes/config/chip_theme_config.dart' as c7;
import 'display/circular_progress_indicator/_impl/themes/config/circular_progress_indicator_theme_config.dart' as c8;
import 'display/code_snippet/_impl/themes/config/code_snippet_theme_config.dart' as c9;
import 'display/divider/_impl/themes/config/divider_theme_config.dart' as c10;
import 'display/dot_indicator/_impl/themes/config/dot_indicator_theme_config.dart' as c11;
import 'display/empty_state/_impl/themes/config/empty_state_theme_config.dart' as c12;
import 'display/feature_carousel/_impl/themes/config/feature_carousel_theme_config.dart' as c13;
import 'display/keyboard_shortcut/_impl/themes/config/keyboard_shortcut_theme_config.dart' as c14;
import 'display/linear_progress_indicator/_impl/themes/config/linear_progress_indicator_theme_config.dart' as c15;
import 'display/markdown/_impl/themes/config/markdown_theme_config.dart' as c16;
import 'display/number_ticker/_impl/themes/config/number_ticker_theme_config.dart' as c17;
import 'display/progress/_impl/themes/config/progress_theme_config.dart' as c18;
import 'display/skeleton/_impl/themes/config/skeleton_theme_config.dart' as c19;
import 'display/spinner/_impl/themes/config/spinner_theme_config.dart' as c20;
import 'display/text_animate/_impl/themes/config/text_animate_theme_config.dart' as c21;
import 'display/tracker/_impl/themes/config/tracker_theme_config.dart' as c22;
import 'form/checkbox/_impl/themes/config/checkbox_theme_config.dart' as c23;
import 'form/chip_input/_impl/themes/config/chip_input_theme_config.dart' as c24;
import 'form/color_input/_impl/themes/config/color_input_theme_config.dart' as c25;
import 'form/color_picker/_impl/themes/config/color_picker_theme_config.dart' as c26;
import 'form/date_picker/_impl/themes/config/date_picker_theme_config.dart' as c27;
import 'form/file_picker/_impl/themes/config/file_picker_theme_config.dart' as c28;
import 'form/formatted_input/_impl/themes/config/formatted_input_theme_config.dart' as c29;
import 'form/input_otp/_impl/themes/config/input_otp_theme_config.dart' as c30;
import 'form/multiple_choice/_impl/themes/config/multiple_choice_theme_config.dart' as c31;
import 'form/phone_input/_impl/themes/config/phone_input_theme_config.dart' as c32;
import 'form/radio_group/_impl/themes/config/radio_group_theme_config.dart' as c33;
import 'form/select/_impl/themes/config/select_theme_config.dart' as c34;
import 'form/slider/_impl/themes/config/slider_theme_config.dart' as c35;
import 'form/star_rating/_impl/themes/config/star_rating_theme_config.dart' as c36;
import 'form/switch/_impl/themes/config/switch_theme_config.dart' as c37;
import 'form/text_field/_impl/themes/config/text_field_theme_config.dart' as c38;
import 'form/time_picker/_impl/themes/config/time_picker_theme_config.dart' as c39;
import 'layout/accordion/_impl/themes/config/accordion_theme_config.dart' as c40;
import 'layout/alert/_impl/themes/config/alert_theme_config.dart' as c41;
import 'layout/card/_impl/themes/config/card_theme_config.dart' as c42;
import 'layout/collapsible/_impl/themes/config/collapsible_theme_config.dart' as c43;
import 'layout/filter_bar/_impl/themes/config/filter_bar_theme_config.dart' as c44;
import 'layout/hidden/_impl/themes/config/hidden_theme_config.dart' as c45;
import 'layout/outlined_container/_impl/themes/config/outlined_container_theme_config.dart' as c46;
import 'layout/scrollable/_impl/themes/config/scrollable_theme_config.dart' as c47;
import 'layout/stage_container/_impl/themes/config/stage_container_theme_config.dart' as c48;
import 'layout/table/_impl/themes/config/table_theme_config.dart' as c49;
import 'navigation/navigation_bar/_impl/themes/config/navigation_bar_theme_config.dart' as c50;
import 'navigation/stepper/_impl/themes/config/stepper_theme_config.dart' as c51;
import 'navigation/tabs/_impl/themes/config/tabs_theme_config.dart' as c52;
import 'overlay/context_menu/_impl/themes/config/context_menu_theme_config.dart' as c53;
import 'overlay/dialog/_impl/themes/config/dialog_theme_config.dart' as c54;
import 'overlay/drawer/_impl/themes/config/drawer_theme_config.dart' as c55;
import 'overlay/dropdown_menu/_impl/themes/config/dropdown_menu_theme_config.dart' as c56;
import 'overlay/gooey_toast/_impl/themes/config/gooey_toast_theme_config.dart' as c57;
import 'overlay/hover_card/_impl/themes/config/hover_card_theme_config.dart' as c58;
import 'overlay/menu/_impl/themes/config/menu_theme_config.dart' as c59;
import 'overlay/menubar/_impl/themes/config/menubar_theme_config.dart' as c60;
import 'overlay/popup/_impl/themes/config/popup_theme_config.dart' as c61;
import 'overlay/refresh_trigger/_impl/themes/config/refresh_trigger_theme_config.dart' as c62;
import 'overlay/swiper/_impl/themes/config/swiper_theme_config.dart' as c63;
import 'overlay/toast/_impl/themes/config/toast_theme_config.dart' as c64;
import 'overlay/tooltip/_impl/themes/config/tooltip_theme_config.dart' as c65;
import 'utility/error_system/_impl/themes/config/error_system_theme_config.dart' as c66;
import 'utility/focus_outline/_impl/themes/config/focus_outline_theme_config.dart' as c67;

bool _componentThemeGlobalsRegistered = false;

bool _buttonThemeGlobalsRegistered = false;

/// Registers button theme globals once.
void registerButtonThemeGlobals() {
  if (_buttonThemeGlobalsRegistered) return;
  ComponentThemeGlobalRegistry.register(
    () => c0.ButtonThemeConfig.primaryButtonTheme,
  );
  ComponentThemeGlobalRegistry.register(
    () => c0.ButtonThemeConfig.secondaryButtonTheme,
  );
  ComponentThemeGlobalRegistry.register(
    () => c0.ButtonThemeConfig.outlineButtonTheme,
  );
  ComponentThemeGlobalRegistry.register(
    () => c0.ButtonThemeConfig.ghostButtonTheme,
  );
  ComponentThemeGlobalRegistry.register(
    () => c0.ButtonThemeConfig.linkButtonTheme,
  );
  ComponentThemeGlobalRegistry.register(
    () => c0.ButtonThemeConfig.textButtonTheme,
  );
  ComponentThemeGlobalRegistry.register(
    () => c0.ButtonThemeConfig.destructiveButtonTheme,
  );
  ComponentThemeGlobalRegistry.register(
    () => c0.ButtonThemeConfig.fixedButtonTheme,
  );
  ComponentThemeGlobalRegistry.register(
    () => c0.ButtonThemeConfig.menuButtonTheme,
  );
  ComponentThemeGlobalRegistry.register(
    () => c0.ButtonThemeConfig.menubarButtonTheme,
  );
  ComponentThemeGlobalRegistry.register(
    () => c0.ButtonThemeConfig.mutedButtonTheme,
  );
  ComponentThemeGlobalRegistry.register(
    () => c0.ButtonThemeConfig.cardButtonTheme,
  );
  _buttonThemeGlobalsRegistered = true;
}

bool _hoverThemeGlobalsRegistered = false;

/// Registers hover theme globals once.
void registerHoverThemeGlobals() {
  if (_hoverThemeGlobalsRegistered) return;
  ComponentThemeGlobalRegistry.register(
    () => c1.HoverThemeConfig.global,
  );
  _hoverThemeGlobalsRegistered = true;
}

bool _scrollbarThemeGlobalsRegistered = false;

/// Registers scrollbar theme globals once.
void registerScrollbarThemeGlobals() {
  if (_scrollbarThemeGlobalsRegistered) return;
  ComponentThemeGlobalRegistry.register(
    () => c2.ScrollbarThemeConfig.global,
  );
  _scrollbarThemeGlobalsRegistered = true;
}

bool _avatarThemeGlobalsRegistered = false;

/// Registers avatar theme globals once.
void registerAvatarThemeGlobals() {
  if (_avatarThemeGlobalsRegistered) return;
  ComponentThemeGlobalRegistry.register(
    () => c3.AvatarThemeConfig.global,
  );
  _avatarThemeGlobalsRegistered = true;
}

bool _badgeThemeGlobalsRegistered = false;

/// Registers badge theme globals once.
void registerBadgeThemeGlobals() {
  if (_badgeThemeGlobalsRegistered) return;
  ComponentThemeGlobalRegistry.register(
    () => c4.BadgeThemeConfig.global,
  );
  _badgeThemeGlobalsRegistered = true;
}

bool _calendarThemeGlobalsRegistered = false;

/// Registers calendar theme globals once.
void registerCalendarThemeGlobals() {
  if (_calendarThemeGlobalsRegistered) return;
  ComponentThemeGlobalRegistry.register(
    () => c5.CalendarThemeConfig.global,
  );
  _calendarThemeGlobalsRegistered = true;
}

bool _carouselThemeGlobalsRegistered = false;

/// Registers carousel theme globals once.
void registerCarouselThemeGlobals() {
  if (_carouselThemeGlobalsRegistered) return;
  ComponentThemeGlobalRegistry.register(
    () => c6.CarouselThemeConfig.global,
  );
  _carouselThemeGlobalsRegistered = true;
}

bool _chipThemeGlobalsRegistered = false;

/// Registers chip theme globals once.
void registerChipThemeGlobals() {
  if (_chipThemeGlobalsRegistered) return;
  ComponentThemeGlobalRegistry.register(
    () => c7.ChipThemeConfig.global,
  );
  _chipThemeGlobalsRegistered = true;
}

bool _circularProgressIndicatorThemeGlobalsRegistered = false;

/// Registers circular_progress_indicator theme globals once.
void registerCircularProgressIndicatorThemeGlobals() {
  if (_circularProgressIndicatorThemeGlobalsRegistered) return;
  ComponentThemeGlobalRegistry.register(
    () => c8.CircularProgressIndicatorThemeConfig.global,
  );
  _circularProgressIndicatorThemeGlobalsRegistered = true;
}

bool _codeSnippetThemeGlobalsRegistered = false;

/// Registers code_snippet theme globals once.
void registerCodeSnippetThemeGlobals() {
  if (_codeSnippetThemeGlobalsRegistered) return;
  ComponentThemeGlobalRegistry.register(
    () => c9.CodeSnippetThemeConfig.global,
  );
  _codeSnippetThemeGlobalsRegistered = true;
}

bool _dividerThemeGlobalsRegistered = false;

/// Registers divider theme globals once.
void registerDividerThemeGlobals() {
  if (_dividerThemeGlobalsRegistered) return;
  ComponentThemeGlobalRegistry.register(
    () => c10.DividerThemeConfig.global,
  );
  _dividerThemeGlobalsRegistered = true;
}

bool _dotIndicatorThemeGlobalsRegistered = false;

/// Registers dot_indicator theme globals once.
void registerDotIndicatorThemeGlobals() {
  if (_dotIndicatorThemeGlobalsRegistered) return;
  ComponentThemeGlobalRegistry.register(
    () => c11.DotIndicatorThemeConfig.global,
  );
  _dotIndicatorThemeGlobalsRegistered = true;
}

bool _emptyStateThemeGlobalsRegistered = false;

/// Registers empty_state theme globals once.
void registerEmptyStateThemeGlobals() {
  if (_emptyStateThemeGlobalsRegistered) return;
  ComponentThemeGlobalRegistry.register(
    () => c12.EmptyStateThemeConfig.global,
  );
  _emptyStateThemeGlobalsRegistered = true;
}

bool _featureCarouselThemeGlobalsRegistered = false;

/// Registers feature_carousel theme globals once.
void registerFeatureCarouselThemeGlobals() {
  if (_featureCarouselThemeGlobalsRegistered) return;
  ComponentThemeGlobalRegistry.register(
    () => c13.FeatureCarouselThemeConfig.global,
  );
  _featureCarouselThemeGlobalsRegistered = true;
}

bool _keyboardShortcutThemeGlobalsRegistered = false;

/// Registers keyboard_shortcut theme globals once.
void registerKeyboardShortcutThemeGlobals() {
  if (_keyboardShortcutThemeGlobalsRegistered) return;
  ComponentThemeGlobalRegistry.register(
    () => c14.KeyboardShortcutThemeConfig.global,
  );
  _keyboardShortcutThemeGlobalsRegistered = true;
}

bool _linearProgressIndicatorThemeGlobalsRegistered = false;

/// Registers linear_progress_indicator theme globals once.
void registerLinearProgressIndicatorThemeGlobals() {
  if (_linearProgressIndicatorThemeGlobalsRegistered) return;
  ComponentThemeGlobalRegistry.register(
    () => c15.LinearProgressIndicatorThemeConfig.global,
  );
  _linearProgressIndicatorThemeGlobalsRegistered = true;
}

bool _markdownThemeGlobalsRegistered = false;

/// Registers markdown theme globals once.
void registerMarkdownThemeGlobals() {
  if (_markdownThemeGlobalsRegistered) return;
  ComponentThemeGlobalRegistry.register(
    () => c16.MarkdownThemeConfig.global,
  );
  _markdownThemeGlobalsRegistered = true;
}

bool _numberTickerThemeGlobalsRegistered = false;

/// Registers number_ticker theme globals once.
void registerNumberTickerThemeGlobals() {
  if (_numberTickerThemeGlobalsRegistered) return;
  ComponentThemeGlobalRegistry.register(
    () => c17.NumberTickerThemeConfig.global,
  );
  _numberTickerThemeGlobalsRegistered = true;
}

bool _progressThemeGlobalsRegistered = false;

/// Registers progress theme globals once.
void registerProgressThemeGlobals() {
  if (_progressThemeGlobalsRegistered) return;
  ComponentThemeGlobalRegistry.register(
    () => c18.ProgressThemeConfig.global,
  );
  _progressThemeGlobalsRegistered = true;
}

bool _skeletonThemeGlobalsRegistered = false;

/// Registers skeleton theme globals once.
void registerSkeletonThemeGlobals() {
  if (_skeletonThemeGlobalsRegistered) return;
  ComponentThemeGlobalRegistry.register(
    () => c19.SkeletonThemeConfig.global,
  );
  _skeletonThemeGlobalsRegistered = true;
}

bool _spinnerThemeGlobalsRegistered = false;

/// Registers spinner theme globals once.
void registerSpinnerThemeGlobals() {
  if (_spinnerThemeGlobalsRegistered) return;
  ComponentThemeGlobalRegistry.register(
    () => c20.SpinnerThemeConfig.global,
  );
  _spinnerThemeGlobalsRegistered = true;
}

bool _textAnimateThemeGlobalsRegistered = false;

/// Registers text_animate theme globals once.
void registerTextAnimateThemeGlobals() {
  if (_textAnimateThemeGlobalsRegistered) return;
  ComponentThemeGlobalRegistry.register(
    () => c21.TextAnimateThemeConfig.global,
  );
  _textAnimateThemeGlobalsRegistered = true;
}

bool _trackerThemeGlobalsRegistered = false;

/// Registers tracker theme globals once.
void registerTrackerThemeGlobals() {
  if (_trackerThemeGlobalsRegistered) return;
  ComponentThemeGlobalRegistry.register(
    () => c22.TrackerThemeConfig.global,
  );
  _trackerThemeGlobalsRegistered = true;
}

bool _checkboxThemeGlobalsRegistered = false;

/// Registers checkbox theme globals once.
void registerCheckboxThemeGlobals() {
  if (_checkboxThemeGlobalsRegistered) return;
  ComponentThemeGlobalRegistry.register(
    () => c23.CheckboxThemeConfig.global,
  );
  _checkboxThemeGlobalsRegistered = true;
}

bool _chipInputThemeGlobalsRegistered = false;

/// Registers chip_input theme globals once.
void registerChipInputThemeGlobals() {
  if (_chipInputThemeGlobalsRegistered) return;
  ComponentThemeGlobalRegistry.register(
    () => c24.ChipInputThemeConfig.global,
  );
  _chipInputThemeGlobalsRegistered = true;
}

bool _colorInputThemeGlobalsRegistered = false;

/// Registers color_input theme globals once.
void registerColorInputThemeGlobals() {
  if (_colorInputThemeGlobalsRegistered) return;
  ComponentThemeGlobalRegistry.register(
    () => c25.ColorInputThemeConfig.global,
  );
  _colorInputThemeGlobalsRegistered = true;
}

bool _colorPickerThemeGlobalsRegistered = false;

/// Registers color_picker theme globals once.
void registerColorPickerThemeGlobals() {
  if (_colorPickerThemeGlobalsRegistered) return;
  ComponentThemeGlobalRegistry.register(
    () => c26.ColorPickerThemeConfig.global,
  );
  _colorPickerThemeGlobalsRegistered = true;
}

bool _datePickerThemeGlobalsRegistered = false;

/// Registers date_picker theme globals once.
void registerDatePickerThemeGlobals() {
  if (_datePickerThemeGlobalsRegistered) return;
  ComponentThemeGlobalRegistry.register(
    () => c27.DatePickerThemeConfig.global,
  );
  _datePickerThemeGlobalsRegistered = true;
}

bool _filePickerThemeGlobalsRegistered = false;

/// Registers file_picker theme globals once.
void registerFilePickerThemeGlobals() {
  if (_filePickerThemeGlobalsRegistered) return;
  ComponentThemeGlobalRegistry.register(
    () => c28.FilePickerThemeConfig.fileUploadDropzoneTheme,
  );
  _filePickerThemeGlobalsRegistered = true;
}

bool _formattedInputThemeGlobalsRegistered = false;

/// Registers formatted_input theme globals once.
void registerFormattedInputThemeGlobals() {
  if (_formattedInputThemeGlobalsRegistered) return;
  ComponentThemeGlobalRegistry.register(
    () => c29.FormattedInputThemeConfig.global,
  );
  _formattedInputThemeGlobalsRegistered = true;
}

bool _inputOtpThemeGlobalsRegistered = false;

/// Registers input_otp theme globals once.
void registerInputOtpThemeGlobals() {
  if (_inputOtpThemeGlobalsRegistered) return;
  ComponentThemeGlobalRegistry.register(
    () => c30.InputOtpThemeConfig.inputOTPTheme,
  );
  _inputOtpThemeGlobalsRegistered = true;
}

bool _multipleChoiceThemeGlobalsRegistered = false;

/// Registers multiple_choice theme globals once.
void registerMultipleChoiceThemeGlobals() {
  if (_multipleChoiceThemeGlobalsRegistered) return;
  ComponentThemeGlobalRegistry.register(
    () => c31.MultipleChoiceThemeConfig.global,
  );
  _multipleChoiceThemeGlobalsRegistered = true;
}

bool _phoneInputThemeGlobalsRegistered = false;

/// Registers phone_input theme globals once.
void registerPhoneInputThemeGlobals() {
  if (_phoneInputThemeGlobalsRegistered) return;
  ComponentThemeGlobalRegistry.register(
    () => c32.PhoneInputThemeConfig.global,
  );
  _phoneInputThemeGlobalsRegistered = true;
}

bool _radioGroupThemeGlobalsRegistered = false;

/// Registers radio_group theme globals once.
void registerRadioGroupThemeGlobals() {
  if (_radioGroupThemeGlobalsRegistered) return;
  ComponentThemeGlobalRegistry.register(
    () => c33.RadioGroupThemeConfig.radioCardTheme,
  );
  ComponentThemeGlobalRegistry.register(
    () => c33.RadioGroupThemeConfig.radioTheme,
  );
  _radioGroupThemeGlobalsRegistered = true;
}

bool _selectThemeGlobalsRegistered = false;

/// Registers select theme globals once.
void registerSelectThemeGlobals() {
  if (_selectThemeGlobalsRegistered) return;
  ComponentThemeGlobalRegistry.register(
    () => c34.SelectThemeConfig.global,
  );
  _selectThemeGlobalsRegistered = true;
}

bool _sliderThemeGlobalsRegistered = false;

/// Registers slider theme globals once.
void registerSliderThemeGlobals() {
  if (_sliderThemeGlobalsRegistered) return;
  ComponentThemeGlobalRegistry.register(
    () => c35.SliderThemeConfig.global,
  );
  _sliderThemeGlobalsRegistered = true;
}

bool _starRatingThemeGlobalsRegistered = false;

/// Registers star_rating theme globals once.
void registerStarRatingThemeGlobals() {
  if (_starRatingThemeGlobalsRegistered) return;
  ComponentThemeGlobalRegistry.register(
    () => c36.StarRatingThemeConfig.global,
  );
  _starRatingThemeGlobalsRegistered = true;
}

bool _switchThemeGlobalsRegistered = false;

/// Registers switch theme globals once.
void registerSwitchThemeGlobals() {
  if (_switchThemeGlobalsRegistered) return;
  ComponentThemeGlobalRegistry.register(
    () => c37.SwitchThemeConfig.global,
  );
  _switchThemeGlobalsRegistered = true;
}

bool _textFieldThemeGlobalsRegistered = false;

/// Registers text_field theme globals once.
void registerTextFieldThemeGlobals() {
  if (_textFieldThemeGlobalsRegistered) return;
  ComponentThemeGlobalRegistry.register(
    () => c38.TextFieldThemeConfig.global,
  );
  _textFieldThemeGlobalsRegistered = true;
}

bool _timePickerThemeGlobalsRegistered = false;

/// Registers time_picker theme globals once.
void registerTimePickerThemeGlobals() {
  if (_timePickerThemeGlobalsRegistered) return;
  ComponentThemeGlobalRegistry.register(
    () => c39.TimePickerThemeConfig.global,
  );
  _timePickerThemeGlobalsRegistered = true;
}

bool _accordionThemeGlobalsRegistered = false;

/// Registers accordion theme globals once.
void registerAccordionThemeGlobals() {
  if (_accordionThemeGlobalsRegistered) return;
  ComponentThemeGlobalRegistry.register(
    () => c40.AccordionThemeConfig.global,
  );
  _accordionThemeGlobalsRegistered = true;
}

bool _alertThemeGlobalsRegistered = false;

/// Registers alert theme globals once.
void registerAlertThemeGlobals() {
  if (_alertThemeGlobalsRegistered) return;
  ComponentThemeGlobalRegistry.register(
    () => c41.AlertThemeConfig.global,
  );
  _alertThemeGlobalsRegistered = true;
}

bool _cardThemeGlobalsRegistered = false;

/// Registers card theme globals once.
void registerCardThemeGlobals() {
  if (_cardThemeGlobalsRegistered) return;
  ComponentThemeGlobalRegistry.register(
    () => c42.CardThemeConfig.global,
  );
  _cardThemeGlobalsRegistered = true;
}

bool _collapsibleThemeGlobalsRegistered = false;

/// Registers collapsible theme globals once.
void registerCollapsibleThemeGlobals() {
  if (_collapsibleThemeGlobalsRegistered) return;
  ComponentThemeGlobalRegistry.register(
    () => c43.CollapsibleThemeConfig.global,
  );
  _collapsibleThemeGlobalsRegistered = true;
}

bool _filterBarThemeGlobalsRegistered = false;

/// Registers filter_bar theme globals once.
void registerFilterBarThemeGlobals() {
  if (_filterBarThemeGlobalsRegistered) return;
  ComponentThemeGlobalRegistry.register(
    () => c44.FilterBarThemeConfig.global,
  );
  _filterBarThemeGlobalsRegistered = true;
}

bool _hiddenThemeGlobalsRegistered = false;

/// Registers hidden theme globals once.
void registerHiddenThemeGlobals() {
  if (_hiddenThemeGlobalsRegistered) return;
  ComponentThemeGlobalRegistry.register(
    () => c45.HiddenThemeConfig.global,
  );
  _hiddenThemeGlobalsRegistered = true;
}

bool _outlinedContainerThemeGlobalsRegistered = false;

/// Registers outlined_container theme globals once.
void registerOutlinedContainerThemeGlobals() {
  if (_outlinedContainerThemeGlobalsRegistered) return;
  ComponentThemeGlobalRegistry.register(
    () => c46.OutlinedContainerThemeConfig.global,
  );
  _outlinedContainerThemeGlobalsRegistered = true;
}

bool _scrollableThemeGlobalsRegistered = false;

/// Registers scrollable theme globals once.
void registerScrollableThemeGlobals() {
  if (_scrollableThemeGlobalsRegistered) return;
  ComponentThemeGlobalRegistry.register(
    () => c47.ScrollableThemeConfig.scrollableClientTheme,
  );
  _scrollableThemeGlobalsRegistered = true;
}

bool _stageContainerThemeGlobalsRegistered = false;

/// Registers stage_container theme globals once.
void registerStageContainerThemeGlobals() {
  if (_stageContainerThemeGlobalsRegistered) return;
  ComponentThemeGlobalRegistry.register(
    () => c48.StageContainerThemeConfig.global,
  );
  _stageContainerThemeGlobalsRegistered = true;
}

bool _tableThemeGlobalsRegistered = false;

/// Registers table theme globals once.
void registerTableThemeGlobals() {
  if (_tableThemeGlobalsRegistered) return;
  ComponentThemeGlobalRegistry.register(
    () => c49.TableThemeConfig.global,
  );
  ComponentThemeGlobalRegistry.register(
    () => c49.TableThemeConfig.resizableTableTheme,
  );
  _tableThemeGlobalsRegistered = true;
}

bool _navigationBarThemeGlobalsRegistered = false;

/// Registers navigation_bar theme globals once.
void registerNavigationBarThemeGlobals() {
  if (_navigationBarThemeGlobalsRegistered) return;
  ComponentThemeGlobalRegistry.register(
    () => c50.NavigationBarThemeConfig.global,
  );
  _navigationBarThemeGlobalsRegistered = true;
}

bool _stepperThemeGlobalsRegistered = false;

/// Registers stepper theme globals once.
void registerStepperThemeGlobals() {
  if (_stepperThemeGlobalsRegistered) return;
  ComponentThemeGlobalRegistry.register(
    () => c51.StepperThemeConfig.global,
  );
  _stepperThemeGlobalsRegistered = true;
}

bool _tabsThemeGlobalsRegistered = false;

/// Registers tabs theme globals once.
void registerTabsThemeGlobals() {
  if (_tabsThemeGlobalsRegistered) return;
  ComponentThemeGlobalRegistry.register(
    () => c52.TabsThemeConfig.global,
  );
  ComponentThemeGlobalRegistry.register(
    () => c52.TabsThemeConfig.tabContainerTheme,
  );
  ComponentThemeGlobalRegistry.register(
    () => c52.TabsThemeConfig.tabListTheme,
  );
  ComponentThemeGlobalRegistry.register(
    () => c52.TabsThemeConfig.tabPaneTheme,
  );
  _tabsThemeGlobalsRegistered = true;
}

bool _contextMenuThemeGlobalsRegistered = false;

/// Registers context_menu theme globals once.
void registerContextMenuThemeGlobals() {
  if (_contextMenuThemeGlobalsRegistered) return;
  ComponentThemeGlobalRegistry.register(
    () => c53.ContextMenuThemeConfig.global,
  );
  _contextMenuThemeGlobalsRegistered = true;
}

bool _dialogThemeGlobalsRegistered = false;

/// Registers dialog theme globals once.
void registerDialogThemeGlobals() {
  if (_dialogThemeGlobalsRegistered) return;
  ComponentThemeGlobalRegistry.register(
    () => c54.DialogThemeConfig.modalBackdropTheme,
  );
  _dialogThemeGlobalsRegistered = true;
}

bool _drawerThemeGlobalsRegistered = false;

/// Registers drawer theme globals once.
void registerDrawerThemeGlobals() {
  if (_drawerThemeGlobalsRegistered) return;
  ComponentThemeGlobalRegistry.register(
    () => c55.DrawerThemeConfig.global,
  );
  _drawerThemeGlobalsRegistered = true;
}

bool _dropdownMenuThemeGlobalsRegistered = false;

/// Registers dropdown_menu theme globals once.
void registerDropdownMenuThemeGlobals() {
  if (_dropdownMenuThemeGlobalsRegistered) return;
  ComponentThemeGlobalRegistry.register(
    () => c56.DropdownMenuThemeConfig.global,
  );
  _dropdownMenuThemeGlobalsRegistered = true;
}

bool _gooeyToastThemeGlobalsRegistered = false;

/// Registers gooey_toast theme globals once.
void registerGooeyToastThemeGlobals() {
  if (_gooeyToastThemeGlobalsRegistered) return;
  ComponentThemeGlobalRegistry.register(
    () => c57.GooeyToastThemeConfig.global,
  );
  _gooeyToastThemeGlobalsRegistered = true;
}

bool _hoverCardThemeGlobalsRegistered = false;

/// Registers hover_card theme globals once.
void registerHoverCardThemeGlobals() {
  if (_hoverCardThemeGlobalsRegistered) return;
  ComponentThemeGlobalRegistry.register(
    () => c58.HoverCardThemeConfig.global,
  );
  _hoverCardThemeGlobalsRegistered = true;
}

bool _menuThemeGlobalsRegistered = false;

/// Registers menu theme globals once.
void registerMenuThemeGlobals() {
  if (_menuThemeGlobalsRegistered) return;
  ComponentThemeGlobalRegistry.register(
    () => c59.MenuThemeConfig.global,
  );
  ComponentThemeGlobalRegistry.register(
    () => c59.MenuThemeConfig.menuPopupTheme,
  );
  ComponentThemeGlobalRegistry.register(
    () => c59.MenuThemeConfig.menubarTheme,
  );
  _menuThemeGlobalsRegistered = true;
}

bool _menubarThemeGlobalsRegistered = false;

/// Registers menubar theme globals once.
void registerMenubarThemeGlobals() {
  if (_menubarThemeGlobalsRegistered) return;
  ComponentThemeGlobalRegistry.register(
    () => c60.MenubarThemeConfig.global,
  );
  _menubarThemeGlobalsRegistered = true;
}

bool _popupThemeGlobalsRegistered = false;

/// Registers popup theme globals once.
void registerPopupThemeGlobals() {
  if (_popupThemeGlobalsRegistered) return;
  ComponentThemeGlobalRegistry.register(
    () => c61.PopupThemeConfig.menuPopupTheme,
  );
  _popupThemeGlobalsRegistered = true;
}

bool _refreshTriggerThemeGlobalsRegistered = false;

/// Registers refresh_trigger theme globals once.
void registerRefreshTriggerThemeGlobals() {
  if (_refreshTriggerThemeGlobalsRegistered) return;
  ComponentThemeGlobalRegistry.register(
    () => c62.RefreshTriggerThemeConfig.global,
  );
  _refreshTriggerThemeGlobalsRegistered = true;
}

bool _swiperThemeGlobalsRegistered = false;

/// Registers swiper theme globals once.
void registerSwiperThemeGlobals() {
  if (_swiperThemeGlobalsRegistered) return;
  ComponentThemeGlobalRegistry.register(
    () => c63.SwiperThemeConfig.global,
  );
  _swiperThemeGlobalsRegistered = true;
}

bool _toastThemeGlobalsRegistered = false;

/// Registers toast theme globals once.
void registerToastThemeGlobals() {
  if (_toastThemeGlobalsRegistered) return;
  ComponentThemeGlobalRegistry.register(
    () => c64.ToastThemeConfig.global,
  );
  _toastThemeGlobalsRegistered = true;
}

bool _tooltipThemeGlobalsRegistered = false;

/// Registers tooltip theme globals once.
void registerTooltipThemeGlobals() {
  if (_tooltipThemeGlobalsRegistered) return;
  ComponentThemeGlobalRegistry.register(
    () => c65.TooltipThemeConfig.global,
  );
  _tooltipThemeGlobalsRegistered = true;
}

bool _errorSystemThemeGlobalsRegistered = false;

/// Registers error_system theme globals once.
void registerErrorSystemThemeGlobals() {
  if (_errorSystemThemeGlobalsRegistered) return;
  ComponentThemeGlobalRegistry.register(
    () => c66.ErrorSystemThemeConfig.global,
  );
  _errorSystemThemeGlobalsRegistered = true;
}

bool _focusOutlineThemeGlobalsRegistered = false;

/// Registers focus_outline theme globals once.
void registerFocusOutlineThemeGlobals() {
  if (_focusOutlineThemeGlobalsRegistered) return;
  ComponentThemeGlobalRegistry.register(
    () => c67.FocusOutlineThemeConfig.global,
  );
  _focusOutlineThemeGlobalsRegistered = true;
}

/// Registers all component token-config globals once.
void registerComponentThemeGlobalConfigs() {
  if (_componentThemeGlobalsRegistered) return;
  registerButtonThemeGlobals();
  registerHoverThemeGlobals();
  registerScrollbarThemeGlobals();
  registerAvatarThemeGlobals();
  registerBadgeThemeGlobals();
  registerCalendarThemeGlobals();
  registerCarouselThemeGlobals();
  registerChipThemeGlobals();
  registerCircularProgressIndicatorThemeGlobals();
  registerCodeSnippetThemeGlobals();
  registerDividerThemeGlobals();
  registerDotIndicatorThemeGlobals();
  registerEmptyStateThemeGlobals();
  registerFeatureCarouselThemeGlobals();
  registerKeyboardShortcutThemeGlobals();
  registerLinearProgressIndicatorThemeGlobals();
  registerMarkdownThemeGlobals();
  registerNumberTickerThemeGlobals();
  registerProgressThemeGlobals();
  registerSkeletonThemeGlobals();
  registerSpinnerThemeGlobals();
  registerTextAnimateThemeGlobals();
  registerTrackerThemeGlobals();
  registerCheckboxThemeGlobals();
  registerChipInputThemeGlobals();
  registerColorInputThemeGlobals();
  registerColorPickerThemeGlobals();
  registerDatePickerThemeGlobals();
  registerFilePickerThemeGlobals();
  registerFormattedInputThemeGlobals();
  registerInputOtpThemeGlobals();
  registerMultipleChoiceThemeGlobals();
  registerPhoneInputThemeGlobals();
  registerRadioGroupThemeGlobals();
  registerSelectThemeGlobals();
  registerSliderThemeGlobals();
  registerStarRatingThemeGlobals();
  registerSwitchThemeGlobals();
  registerTextFieldThemeGlobals();
  registerTimePickerThemeGlobals();
  registerAccordionThemeGlobals();
  registerAlertThemeGlobals();
  registerCardThemeGlobals();
  registerCollapsibleThemeGlobals();
  registerFilterBarThemeGlobals();
  registerHiddenThemeGlobals();
  registerOutlinedContainerThemeGlobals();
  registerScrollableThemeGlobals();
  registerStageContainerThemeGlobals();
  registerTableThemeGlobals();
  registerNavigationBarThemeGlobals();
  registerStepperThemeGlobals();
  registerTabsThemeGlobals();
  registerContextMenuThemeGlobals();
  registerDialogThemeGlobals();
  registerDrawerThemeGlobals();
  registerDropdownMenuThemeGlobals();
  registerGooeyToastThemeGlobals();
  registerHoverCardThemeGlobals();
  registerMenuThemeGlobals();
  registerMenubarThemeGlobals();
  registerPopupThemeGlobals();
  registerRefreshTriggerThemeGlobals();
  registerSwiperThemeGlobals();
  registerToastThemeGlobals();
  registerTooltipThemeGlobals();
  registerErrorSystemThemeGlobals();
  registerFocusOutlineThemeGlobals();
  _componentThemeGlobalsRegistered = true;
}
