import 'dart:async';

import 'package:timecop/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_driver/driver_extension.dart';

Future<void> main() async {
  enableFlutterDriverExtension();
  WidgetsApp.debugAllowBannerOverride = false; // remove debug banner
  runApp(TimeCopApp(testMode: true,));
}
