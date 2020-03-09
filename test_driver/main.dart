import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timecop/blocs/projects/bloc.dart';
import 'package:timecop/blocs/settings/bloc.dart';
import 'package:timecop/blocs/theme/bloc.dart';
import 'package:timecop/blocs/timers/bloc.dart';
import 'package:timecop/data_providers/data_provider.dart';
import 'package:timecop/data_providers/database_provider.dart';
import 'package:timecop/data_providers/settings_provider.dart';
import 'package:timecop/fontlicenses.dart';
import 'package:timecop/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_driver/driver_extension.dart';

Future<void> main() async {
  enableFlutterDriverExtension();
  WidgetsApp.debugAllowBannerOverride = false; // remove debug banner
  
  // import from timecop.main.dart
  WidgetsFlutterBinding.ensureInitialized();
  final SettingsProvider settings = await SettingsProvider.load();
  final DataProvider data = await DatabaseProvider.open();

  // setup intl date formats?
  //await initializeDateFormatting();
  LicenseRegistry.addLicense(getFontLicenses);

  assert(settings != null);

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<ThemeBloc>(
        create: (_) => ThemeBloc(),
      ),
      BlocProvider<SettingsBloc>(
        create: (_) => SettingsBloc(settings),
      ),
      BlocProvider<TimersBloc>(
        create: (_) => TimersBloc(data),
      ),
      BlocProvider<ProjectsBloc>(
        create: (_) => ProjectsBloc(data),
      ),
    ],
    child: BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) =>
          TimeCopApp(settings: settings),
    ),
  ));
}