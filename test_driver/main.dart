import 'dart:async';
import 'package:timecop/data_providers/data_provider.dart';
import 'package:timecop/data_providers/mock_data_provider.dart';
import 'package:timecop/data_providers/mock_settings_provider.dart';
import 'package:timecop/data_providers/settings_provider.dart';
import 'package:timecop/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_driver/driver_extension.dart';

Future<void> main() async {
  enableFlutterDriverExtension();
  WidgetsApp.debugAllowBannerOverride = false; // remove debug banner

  final SettingsProvider settings = MockSettingsProvider();
  final DataProvider data = MockDataProvider();
  return runMain(settings, data);
}
