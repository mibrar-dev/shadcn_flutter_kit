// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/widgets.dart';

import '../../../tabs.dart';

// ═══════════════════════════════════════════════════════════
// COMPONENT THEME TOKENS
// User customization layer (replace this file from website output)
// ═══════════════════════════════════════════════════════════

class TabsThemeTokens {
  const TabsThemeTokens({
    this.containerPadding = const EdgeInsets.all(4.0),
    this.tabPadding = const EdgeInsets.symmetric(
      horizontal: 16.0,
      vertical: 4.0,
    ),
    this.backgroundColor = const Color(0xFFF5F5F5),
    this.borderRadius = const BorderRadius.all(Radius.circular(8.0)),
    this.ignoreGlobalScaling = false,
    this.ignoreGlobalRadius = false,
  });

  final EdgeInsetsGeometry containerPadding;
  final EdgeInsetsGeometry tabPadding;
  final Color backgroundColor;
  final BorderRadiusGeometry borderRadius;
  final bool ignoreGlobalScaling;
  final bool ignoreGlobalRadius;
}

const tabsThemeTokens = TabsThemeTokens();

class TabContainerThemeTokens {
  const TabContainerThemeTokens({
    this.builder,
    this.childBuilder,
    this.ignoreGlobalScaling = false,
    this.ignoreGlobalRadius = false,
  });

  final TabBuilder? builder;
  final TabChildBuilder? childBuilder;
  final bool ignoreGlobalScaling;
  final bool ignoreGlobalRadius;
}

const tabContainerThemeTokens = TabContainerThemeTokens();

class TabListThemeTokens {
  const TabListThemeTokens({
    this.borderColor = const Color(0xFFE5E5E5),
    this.borderWidth = 1.0,
    this.indicatorColor = const Color(0xFF171717),
    this.indicatorHeight = 2.0,
    this.ignoreGlobalScaling = false,
    this.ignoreGlobalRadius = false,
  });

  final Color borderColor;
  final double borderWidth;
  final Color indicatorColor;
  final double indicatorHeight;
  final bool ignoreGlobalScaling;
  final bool ignoreGlobalRadius;
}

const tabListThemeTokens = TabListThemeTokens();

class TabPaneThemeTokens {
  const TabPaneThemeTokens({
    this.borderRadius = const BorderRadius.all(Radius.circular(8.0)),
    this.backgroundColor = const Color(0xFFFFFFFF),
    this.border = const BorderSide(color: Color(0xFFE5E5E5), width: 1.0),
    this.barHeight = 32.0,
    this.ignoreGlobalScaling = false,
    this.ignoreGlobalRadius = false,
  });

  final BorderRadiusGeometry borderRadius;
  final Color backgroundColor;
  final BorderSide border;
  final double barHeight;
  final bool ignoreGlobalScaling;
  final bool ignoreGlobalRadius;
}

const tabPaneThemeTokens = TabPaneThemeTokens();
