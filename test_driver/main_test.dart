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

      // then the projects page
      SerializableFinder menuButton = find.byValueKey("menuButton");
      await driver.waitFor(menuButton);
      await driver.tap(menuButton);
      SerializableFinder menuProjects = find.byValueKey("menuProjects");
      await driver.waitFor(menuProjects);
      await driver.tap(menuProjects);
      await driver.waitFor(find.byValueKey("addProject"));
      await screenshot(driver, config, 'projects');

      // then the export page
      await driver.tap(find.pageBack());
      SerializableFinder menuButton2 = find.byValueKey("menuButton");
      await driver.waitFor(menuButton2);
      await driver.tap(menuButton2);
      SerializableFinder menuExport = find.byValueKey("menuExport");
      await driver.waitFor(menuExport);
      await driver.tap(menuExport);
      await driver.waitFor(find.byValueKey("exportFAB"));
      await screenshot(driver, config, 'export');

      // then the about page
      await driver.tap(find.pageBack());
      SerializableFinder menuButton3 = find.byValueKey("menuButton");
      await driver.waitFor(menuButton3);
      await driver.tap(menuButton3);
      SerializableFinder menuAbout = find.byValueKey("menuAbout");
      await driver.waitFor(menuAbout);
      await driver.tap(menuAbout);
      await driver.waitFor(find.byValueKey("aboutPage"));
      await screenshot(driver, config, 'about');

    }, timeout: Timeout(Duration(seconds: 120)));
  });
}