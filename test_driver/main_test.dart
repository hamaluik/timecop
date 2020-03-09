import 'dart:io';

import 'package:flutter_driver/flutter_driver.dart';
import 'package:screenshots/screenshots.dart';
import 'package:test/test.dart';

void main() {
  group('end-to-end test', () {
    FlutterDriver driver;
    final config = Config();

    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    tearDownAll(() async {
      if(driver != null) await driver.close();
    });

    test('take comprehensive screenshots', () async {
      // take a screenshot of the dashboard
      SerializableFinder startTimerButton = find.byValueKey("startTimerButton");
      await driver.waitFor(startTimerButton);
      await screenshot(driver, config, 'dashboard');
      sleep(const Duration(seconds: 1));

      // then the projects page
      SerializableFinder menuButton = find.byValueKey("menuButton");
      await driver.waitFor(menuButton);
      await driver.tap(menuButton);
      sleep(const Duration(seconds: 1));
      SerializableFinder menuProjects = find.byValueKey("menuProjects");
      await driver.waitFor(menuProjects);
      await driver.tap(menuProjects);
      sleep(const Duration(seconds: 1));
      await driver.waitFor(find.byValueKey("addProject"));
      await screenshot(driver, config, 'projects');
      sleep(const Duration(seconds: 1));

      // then the export page
      final SerializableFinder back1 = find.pageBack();
      await driver.waitFor(back1);
      await driver.tap(back1);
      sleep(const Duration(seconds: 1));
      SerializableFinder menuButton2 = find.byValueKey("menuButton");
      await driver.waitFor(menuButton2);
      await driver.tap(menuButton2);
      sleep(const Duration(seconds: 1));
      SerializableFinder menuExport = find.byValueKey("menuExport");
      await driver.waitFor(menuExport);
      await driver.tap(menuExport);
      sleep(const Duration(seconds: 1));
      await driver.waitFor(find.byValueKey("exportFAB"));
      await screenshot(driver, config, 'export');
      sleep(const Duration(seconds: 1));

      // then the about page
      final SerializableFinder back2 = find.pageBack();
      await driver.waitFor(back2);
      await driver.tap(back2);
      sleep(const Duration(seconds: 1));
      SerializableFinder menuButton3 = find.byValueKey("menuButton");
      await driver.waitFor(menuButton3);
      await driver.tap(menuButton3);
      sleep(const Duration(seconds: 1));
      SerializableFinder menuAbout = find.byValueKey("menuAbout");
      await driver.waitFor(menuAbout);
      await driver.tap(menuAbout);
      sleep(const Duration(seconds: 1));
      await driver.waitFor(find.byValueKey("aboutPage"));
      await screenshot(driver, config, 'about');
      sleep(const Duration(seconds: 1));
    }, timeout: Timeout(Duration(seconds: 120)));
  });
}