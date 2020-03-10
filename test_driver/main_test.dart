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

    test('take screenshots', () async {
      //await driver.waitUntilFirstFrameRasterized();
      //await driver.waitUntilNoTransientCallbacks();

      // take a screenshot of the dashboard
      SerializableFinder startTimerButton = find.byValueKey("startTimerButton");
      //SerializableFinder timerEdit = find.byType("StoppedTimerRow");
      //SerializableFinder menuButton = find.byValueKey("menuButton");
      //SerializableFinder menuProjects = find.byValueKey("menuProjects");
      //SerializableFinder addProject = find.byValueKey("addProject");
      //SerializableFinder saveDetails = find.byValueKey("saveDetails");
      //SerializableFinder closeButton = find.byType("CloseButton");
      //SerializableFinder backButton = find.byType("BackButton");
      //SerializableFinder menuExport = find.byValueKey("menuExport");
      //SerializableFinder menuAbout = find.byValueKey("menuAbout");
      //SerializableFinder exportFAB = find.byValueKey("exportFAB");
      //SerializableFinder aboutPage = find.byValueKey("aboutPage");

      await driver.waitFor(startTimerButton);
      //await driver.waitUntilNoTransientCallbacks();
      await screenshot(driver, config, 'dashboard');

      // then the timer details page
      /*await driver.waitFor(timerEdit);
      await driver.tap(timerEdit);
      await driver.waitFor(saveDetails);
      await driver.waitUntilNoTransientCallbacks();
      await screenshot(driver, config, 'editor');

      // then the projects page
      await driver.waitFor(closeButton);
      await driver.tap(closeButton);
      await driver.waitFor(menuButton);
      await driver.tap(menuButton);
      await driver.waitFor(menuProjects);
      await driver.tap(menuProjects);
      await driver.waitFor(addProject);
      await driver.waitUntilNoTransientCallbacks();
      await screenshot(driver, config, 'projects');

      // then the export page
      await driver.waitFor(backButton);
      await driver.tap(backButton);
      await driver.waitFor(menuButton);
      await driver.tap(menuButton);
      await driver.waitFor(menuExport);
      await driver.tap(menuExport);
      await driver.waitFor(exportFAB);
      await driver.waitUntilNoTransientCallbacks();
      await screenshot(driver, config, 'export');

      // then the about page
      await driver.waitFor(backButton);
      await driver.tap(backButton);
      await driver.waitFor(menuButton);
      await driver.tap(menuButton);
      await driver.waitFor(menuAbout);
      await driver.tap(menuAbout);
      await driver.waitFor(aboutPage);
      await driver.waitUntilNoTransientCallbacks();
      await screenshot(driver, config, 'about');*/
    }, timeout: Timeout(Duration(seconds: 30)));
  });
}