// GENERATED CODE - DO NOT MODIFY BY HAND.
//
// Sources:
//   * flutter_shadcn_kit/lib/registry/blocks/<id>/<file>.dart
//
// Regenerate: dart run tool/gen_docs_data.dart
//
// One deferred import per block; the chunk is fetched when a Blocks
// page asks for the preview. A block widget IS its preview, so the
// class is the entry file's public widget class.

import 'package:flutter/widgets.dart';

import 'package:docs/ui/shadcn/blocks/login-01/login_01.dart'
    deferred as block_login_01;
import 'package:docs/ui/shadcn/blocks/login-02/login_02.dart'
    deferred as block_login_02;
import 'package:docs/ui/shadcn/blocks/login-03/login_03.dart'
    deferred as block_login_03;
import 'package:docs/ui/shadcn/blocks/otp-01/otp_01.dart'
    deferred as block_otp_01;
import 'package:docs/ui/shadcn/blocks/signup-01/signup_01.dart'
    deferred as block_signup_01;
import 'package:docs/ui/shadcn/blocks/signup-02/signup_02.dart'
    deferred as block_signup_02;
import 'package:docs/ui/shadcn/blocks/calendar-01/calendar_01.dart'
    deferred as block_calendar_01;
import 'package:docs/ui/shadcn/blocks/calendar-02/calendar_02.dart'
    deferred as block_calendar_02;
import 'package:docs/ui/shadcn/blocks/dashboard-01/dashboard_01.dart'
    deferred as block_dashboard_01;
import 'package:docs/ui/shadcn/blocks/dashboard-02/dashboard_02.dart'
    deferred as block_dashboard_02;
import 'package:docs/ui/shadcn/blocks/pricing-01/pricing_01.dart'
    deferred as block_pricing_01;
import 'package:docs/ui/shadcn/blocks/account-01/account_01.dart'
    deferred as block_account_01;
import 'package:docs/ui/shadcn/blocks/account-02/account_02.dart'
    deferred as block_account_02;
import 'package:docs/ui/shadcn/blocks/sidebar-01/sidebar_01.dart'
    deferred as block_sidebar_01;
import 'package:docs/ui/shadcn/blocks/sidebar-02/sidebar_02.dart'
    deferred as block_sidebar_02;
import 'package:docs/ui/shadcn/blocks/sidebar-03/sidebar_03.dart'
    deferred as block_sidebar_03;

/// Loads the preview widget for [blockId], fetching its deferred
/// chunk first. Throws [ArgumentError] for unknown ids.
Future<Widget> loadBlockPreview(String blockId) => switch (blockId) {
  'login-01' => block_login_01.loadLibrary().then(
    (_) => block_login_01.Login01(),
  ),
  'login-02' => block_login_02.loadLibrary().then(
    (_) => block_login_02.Login02(),
  ),
  'login-03' => block_login_03.loadLibrary().then(
    (_) => block_login_03.Login03(),
  ),
  'otp-01' => block_otp_01.loadLibrary().then((_) => block_otp_01.Otp01()),
  'signup-01' => block_signup_01.loadLibrary().then(
    (_) => block_signup_01.Signup01(),
  ),
  'signup-02' => block_signup_02.loadLibrary().then(
    (_) => block_signup_02.Signup02(),
  ),
  'calendar-01' => block_calendar_01.loadLibrary().then(
    (_) => block_calendar_01.Calendar01(),
  ),
  'calendar-02' => block_calendar_02.loadLibrary().then(
    (_) => block_calendar_02.Calendar02(),
  ),
  'dashboard-01' => block_dashboard_01.loadLibrary().then(
    (_) => block_dashboard_01.Dashboard01(),
  ),
  'dashboard-02' => block_dashboard_02.loadLibrary().then(
    (_) => block_dashboard_02.Dashboard02(),
  ),
  'pricing-01' => block_pricing_01.loadLibrary().then(
    (_) => block_pricing_01.Pricing01(),
  ),
  'account-01' => block_account_01.loadLibrary().then(
    (_) => block_account_01.Account01(),
  ),
  'account-02' => block_account_02.loadLibrary().then(
    (_) => block_account_02.Account02(),
  ),
  'sidebar-01' => block_sidebar_01.loadLibrary().then(
    (_) => block_sidebar_01.Sidebar01(),
  ),
  'sidebar-02' => block_sidebar_02.loadLibrary().then(
    (_) => block_sidebar_02.Sidebar02(),
  ),
  'sidebar-03' => block_sidebar_03.loadLibrary().then(
    (_) => block_sidebar_03.Sidebar03(),
  ),
  _ => throw ArgumentError.value(blockId, 'blockId', 'no registered preview'),
};
