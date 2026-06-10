import 'component_example_models.dart';
import 'components/accordion/accordion_examples.dart';
import 'components/alert/alert_examples.dart';
import 'components/alert_dialog/alert_dialog_examples.dart';
import 'components/animated_value_builder/animated_value_builder_examples.dart';
import 'components/app_bar/app_bar_examples.dart';
import 'components/autocomplete/autocomplete_examples.dart';
import 'components/avatar/avatar_examples.dart';
import 'components/avatar_group/avatar_group_examples.dart';
import 'components/badge/badge_examples.dart';
import 'components/border_loading/border_loading_examples.dart';
import 'components/breadcrumb/breadcrumb_examples.dart';
import 'components/button/button_examples.dart';
import 'components/calendar/calendar_examples.dart';
import 'components/card/card_examples.dart';
import 'components/card_image/card_image_examples.dart';
import 'components/carousel/carousel_examples.dart';
import 'components/chat/chat_examples.dart';
import 'components/checkbox/checkbox_examples.dart';
import 'components/chip/chip_examples.dart';
import 'components/chip_input/chip_input_examples.dart';
import 'components/circular_progress/circular_progress_examples.dart';
import 'components/code_snippet/code_snippet_examples.dart';
import 'components/collapsible/collapsible_examples.dart';
import 'components/color_picker/color_picker_examples.dart';
import 'components/command/command_examples.dart';
import 'components/context_menu/context_menu_examples.dart';
import 'components/date_picker/date_picker_examples.dart';
import 'components/dialog/dialog_examples.dart';
import 'components/divider/divider_examples.dart';
import 'components/dot_indicator/dot_indicator_examples.dart';
import 'components/drawer/drawer_examples.dart';
import 'components/dropdown_menu/dropdown_menu_examples.dart';
import 'components/empty_state/empty_state_examples.dart';
import 'components/error_system/error_system_examples.dart';
import 'components/expandable_sidebar/expandable_sidebar_examples.dart';
import 'components/feature_carousel/feature_carousel_examples.dart';
import 'components/file_diff_viewer/file_diff_viewer_examples.dart';
import 'components/filter_bar/filter_bar_examples.dart';
import 'components/file_picker/file_picker_examples.dart';
import 'components/form/form_examples.dart';
import 'components/formatted_input/formatted_input_examples.dart';
import 'components/gooey_toast/gooey_toast_examples.dart';
import 'components/hover_card/hover_card_examples.dart';
import 'components/input/input_examples.dart';
import 'components/input_otp/input_otp_examples.dart';
import 'components/item_picker/item_picker_examples.dart';
import 'components/keyboard_display/keyboard_display_examples.dart';
import 'components/linear_progress/linear_progress_examples.dart';
import 'components/menubar/menubar_examples.dart';
import 'components/multiselect/multiselect_examples.dart';
import 'components/navigation_bar/navigation_bar_examples.dart';
import 'components/navigation_menu/navigation_menu_examples.dart';
import 'components/navigation_sidebar/navigation_sidebar_examples.dart';
import 'components/number_input/number_input_examples.dart';
import 'components/number_ticker/number_ticker_examples.dart';
import 'components/overflow_marquee/overflow_marquee_examples.dart';
import 'components/pagination/pagination_examples.dart';
import 'components/phone_input/phone_input_examples.dart';
import 'components/popover/popover_examples.dart';
import 'components/progress/progress_examples.dart';
import 'components/radio_card/radio_card_examples.dart';
import 'components/radio_group/radio_group_examples.dart';
import 'components/repeated_animation_builder/repeated_animation_builder_examples.dart';
import 'components/refresh_trigger/refresh_trigger_examples.dart';
import 'components/resizable/resizable_examples.dart';
import 'components/select/select_examples.dart';
import 'components/sheet/sheet_examples.dart';
import 'components/skeleton/skeleton_examples.dart';
import 'components/slider/slider_examples.dart';
import 'components/sortable/sortable_examples.dart';
import 'components/star_rating/star_rating_examples.dart';
import 'components/stepper/stepper_examples.dart';
import 'components/steps/steps_examples.dart';
import 'components/swiper/swiper_examples.dart';
import 'components/switch/switch_examples.dart';
import 'components/switcher/switcher_examples.dart';
import 'components/tab_list/tab_list_examples.dart';
import 'components/table/table_examples.dart';
import 'components/tabs/tabs_examples.dart';
import 'components/text_animate/text_animate_examples.dart';
import 'components/text_area/text_area_examples.dart';
import 'components/time_picker/time_picker_examples.dart';
import 'components/timeline/timeline_examples.dart';
import 'components/toast/toast_examples.dart';
import 'components/toggle/toggle_examples.dart';
import 'components/tooltip/tooltip_examples.dart';
import 'components/tracker/tracker_examples.dart';
import 'components/tree/tree_examples.dart';
import 'components/window/window_examples.dart';

const bool enableTextAnimateComponent = bool.fromEnvironment(
  'ENABLE_TEXT_ANIMATE_COMPONENT',
  defaultValue: true,
);

const Set<String> originalComponentIds = {
  'accordion',
  'alert',
  'alert_dialog',
  'animated_value_builder',
  'app',
  'app_bar',
  'audio_control',
  'autocomplete',
  'avatar',
  'avatar_group',
  'badge',
  'border_loading',
  'breadcrumb',
  'button',
  'calendar',
  'card',
  'card_image',
  'carousel',
  'chat',
  'checkbox',
  'chip',
  'chip_input',
  'circular_progress',
  'code_snippet',
  'collapsible',
  'color_picker',
  'command',
  'context_menu',
  'date_picker',
  'dialog',
  'divider',
  'dot_indicator',
  'drawer',
  'dropdown_menu',
  'empty_state',
  'error_system',
  'expandable_sidebar',
  'feature_carousel',
  'file_diff_viewer',
  'filter_bar',
  'file_picker',
  'form',
  'formatted_input',
  'go_router_app_example',
  'gooey_toast',
  'hover_card',
  'input',
  'input_otp',
  'item_picker',
  'keyboard_display',
  'linear_progress',
  'linear_gradient_picker',
  'menubar',
  'multiselect',
  'navigation_bar',
  'navigation_menu',
  'navigation_rail',
  'navigation_sidebar',
  'number_input',
  'number_ticker',
  'overflow_marquee',
  'pagination',
  'phone_input',
  'popover',
  'progress',
  'radio_card',
  'radio_group',
  'radial_gradient_picker',
  'repeated_animation_builder',
  'refresh_trigger',
  'resizable',
  'select',
  'sheet',
  'skeleton',
  'slider',
  'sortable',
  'star_rating',
  'stepper',
  'steps',
  'swiper',
  'switch',
  'switcher',
  'sweep_gradient_picker',
  'tab_pane',
  'tab_list',
  'table',
  'tabs',
  if (enableTextAnimateComponent) 'text_animate',
  'text_area',
  'time_picker',
  'timeline',
  'toast',
  'toggle',
  'tooltip',
  'tracker',
  'tree',
  'video_control',
  'window',
  'wrapper',
};

const List<ComponentExampleBatch> exampleBatches = [
  ComponentExampleBatch(
    title: 'Original Docs',
    componentIds: [
      'accordion',
      'alert',
      'alert_dialog',
      'animated_value_builder',
      'app_bar',
      'autocomplete',
      'avatar',
      'avatar_group',
      'badge',
      'border_loading',
      'breadcrumb',
      'button',
      'calendar',
      'card',
      'card_image',
      'carousel',
      'chat',
      'checkbox',
      'chip',
      'chip_input',
      'circular_progress',
      'code_snippet',
      'collapsible',
      'color_picker',
      'command',
      'context_menu',
      'date_picker',
      'dialog',
      'divider',
      'dot_indicator',
      'drawer',
      'dropdown_menu',
      'empty_state',
      'error_system',
      'expandable_sidebar',
      'feature_carousel',
      'file_diff_viewer',
      'filter_bar',
      'file_picker',
      'form',
      'formatted_input',
      'gooey_toast',
      'hover_card',
      'input',
      'input_otp',
      'item_picker',
      'keyboard_display',
      'linear_progress',
      'menubar',
      'multiselect',
      'navigation_bar',
      'navigation_menu',
      'navigation_sidebar',
      'number_input',
      'number_ticker',
      'overflow_marquee',
      'pagination',
      'phone_input',
      'popover',
      'progress',
      'radio_card',
      'radio_group',
      'repeated_animation_builder',
      'refresh_trigger',
      'resizable',
      'select',
      'sheet',
      'skeleton',
      'slider',
      'sortable',
      'star_rating',
      'stepper',
      'steps',
      'swiper',
      'switch',
      'switcher',
      'tab_list',
      'table',
      'tabs',
      if (enableTextAnimateComponent) 'text_animate',
      'text_area',
      'time_picker',
      'timeline',
      'toast',
      'toggle',
      'tooltip',
      'tracker',
      'tree',
      'window',
    ],
  ),
];

final Map<String, List<ComponentExample>> componentExamples = {
  'accordion': accordionExamples,
  'alert': alertExamples,
  'alert_dialog': alertDialogExamples,
  'animated_value_builder': animatedValueBuilderExamples,
  'app_bar': appBarExamples,
  'autocomplete': autocompleteExamples,
  'avatar': avatarExamples,
  'avatar_group': avatarGroupExamples,
  'badge': badgeExamples,
  'border_loading': borderLoadingExamples,
  'breadcrumb': breadcrumbExamples,
  'button': buttonExamples,
  'calendar': calendarExamples,
  'card': cardExamples,
  'card_image': cardImageExamples,
  'carousel': carouselExamples,
  'chat': chatExamples,
  'checkbox': checkboxExamples,
  'chip': chipExamples,
  'chip_input': chipInputExamples,
  'circular_progress': circularProgressExamples,
  'code_snippet': codeSnippetExamples,
  'collapsible': collapsibleExamples,
  'color_picker': colorPickerExamples,
  'command': commandExamples,
  'context_menu': contextMenuExamples,
  'date_picker': datePickerExamples,
  'dialog': dialogExamples,
  'divider': dividerExamples,
  'dot_indicator': dotIndicatorExamples,
  'drawer': drawerExamples,
  'dropdown_menu': dropdownMenuExamples,
  'empty_state': emptyStateExamples,
  'error_system': errorSystemExamples,
  'expandable_sidebar': expandableSidebarExamples,
  'feature_carousel': featureCarouselExamples,
  'file_diff_viewer': fileDiffViewerExamples,
  'filter_bar': filterBarExamples,
  'file_picker': filePickerExamples,
  'form': formExamples,
  'formatted_input': formattedInputExamples,
  'gooey_toast': gooeyToastExamples,
  'hover_card': hoverCardExamples,
  'input': inputExamples,
  'input_otp': inputOtpExamples,
  'item_picker': itemPickerExamples,
  'keyboard_display': keyboardDisplayExamples,
  'linear_progress': linearProgressExamples,
  'menubar': menubarExamples,
  'multiselect': multiselectExamples,
  'navigation_bar': navigationBarExamples,
  'navigation_menu': navigationMenuExamples,
  'navigation_sidebar': navigationSidebarExamples,
  'number_input': numberInputExamples,
  'number_ticker': numberTickerExamples,
  'overflow_marquee': overflowMarqueeExamples,
  'pagination': paginationExamples,
  'phone_input': phoneInputExamples,
  'popover': popoverExamples,
  'progress': progressExamples,
  'radio_card': radioCardExamples,
  'radio_group': radioGroupExamples,
  'repeated_animation_builder': repeatedAnimationBuilderExamples,
  'refresh_trigger': refreshTriggerExamples,
  'resizable': resizableExamples,
  'select': selectExamples,
  'sheet': sheetExamples,
  'skeleton': skeletonExamples,
  'slider': sliderExamples,
  'sortable': sortableExamples,
  'star_rating': starRatingExamples,
  'stepper': stepperExamples,
  'steps': stepsExamples,
  'swiper': swiperExamples,
  'switch': switchExamples,
  'switcher': switcherExamples,
  'tab_list': tabListExamples,
  'table': tableExamples,
  'tabs': tabsExamples,
  if (enableTextAnimateComponent) 'text_animate': textAnimateExamples,
  'text_area': textAreaExamples,
  'time_picker': timePickerExamples,
  'timeline': timelineExamples,
  'toast': toastExamples,
  'toggle': toggleExamples,
  'tooltip': tooltipExamples,
  'tracker': trackerExamples,
  'tree': treeExamples,
  'window': windowExamples,
};

List<ComponentExample> examplesForComponent(String componentId) {
  return componentExamples[componentId] ?? const [];
}
