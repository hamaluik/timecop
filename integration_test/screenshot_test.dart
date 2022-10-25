import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:timecop/blocs/locale/locale_bloc.dart';
import 'package:timecop/blocs/notifications/notifications_bloc.dart';
import 'package:timecop/blocs/projects/projects_bloc.dart';
import 'package:timecop/blocs/settings/bloc.dart';
import 'package:timecop/blocs/theme/theme_bloc.dart';
import 'package:timecop/blocs/timers/timers_bloc.dart';
import 'package:timecop/data_providers/data/data_provider.dart';
import 'package:timecop/data_providers/data/mock_data_provider.dart';
import 'package:timecop/data_providers/notifications/notifications_provider.dart';
import 'package:timecop/data_providers/settings/mock_settings_provider.dart';
import 'package:timecop/data_providers/settings/settings_provider.dart';
import 'package:timecop/screens/dashboard/components/StartTimerButton.dart';
import 'package:timecop/main.dart' as app;

Future<void> takeScreenshot(WidgetTester tester, IntegrationTestWidgetsFlutterBinding binding, String name) async {
  if (kIsWeb) {
    await binding.takeScreenshot(name);
  } else if (Platform.isAndroid) {
    await binding.convertFlutterSurfaceToImage();
    await tester.pumpAndSettle();
  }
  await binding.takeScreenshot(name);
}

void main() {

  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;

  group('end-to-end test', () {

    testWidgets(
        'tap on the floating action button, verify counter',
        (tester) async {
          WidgetsFlutterBinding.ensureInitialized();
          final SettingsProvider settings = MockSettingsProvider();
          final DataProvider data = MockDataProvider(const Locale("en"));
          NotificationsProvider notificationsProvider = await NotificationsProvider.load();
     // app.main();
      //await Future<void>.delayed(const Duration(seconds: 2));
        await tester.pumpWidget(MultiBlocProvider(
            providers: [
              BlocProvider<ThemeBloc>(
                create: (_) => ThemeBloc(settings),
              ),
              BlocProvider<LocaleBloc>(
                create: (_) => LocaleBloc(settings),
              ),
              BlocProvider<SettingsBloc>(
                create: (_) => SettingsBloc(settings, data),
              ),
              BlocProvider<TimersBloc>(
                create: (_) => TimersBloc(data, settings),
              ),
              BlocProvider<ProjectsBloc>(
                create: (_) => ProjectsBloc(data),
              ),
              BlocProvider<NotificationsBloc>(
                create: (_) => NotificationsBloc(notificationsProvider),
              ),
            ],
            child: app.TimeCopApp(settings: settings)
          )
        );
        await tester.pumpAndSettle();

      Finder startTimerButton = find.byType(StartTimerButton);

      // start by switching to the dark theme
      Finder menuButton = find.byKey(const ValueKey("menuButton"));
      await tester.tap(menuButton);

      await tester.pumpAndSettle();

      Finder menuSettings = find.byKey(const ValueKey("menuSettings"));
      await tester.tap(menuSettings);

      await tester.pumpAndSettle();

      Finder themeOption = find.byKey(const ValueKey("themeOption"));
      await tester.tap(themeOption);

      await tester.pumpAndSettle();

      Finder themeDark = find.byKey(const ValueKey("themeDark"));
      await tester.tap(themeDark);

      await tester.pumpAndSettle();

      await takeScreenshot(tester, binding, "06 settings");
    });
  });
}
