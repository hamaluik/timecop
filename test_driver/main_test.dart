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
      // take a screenshot of the dashboard
      SerializableFinder startTimerButton = find.byValueKey("startTimerButton");

      await driver.waitFor(startTimerButton);
      await screenshot(driver, config, '01 dashboard');

      // then the timer details page
      String mockupsText = await driver.requestData("mockups");
      SerializableFinder timerEdit = find.text(mockupsText);
      await driver.waitFor(timerEdit);
      await driver.tap(timerEdit);
      SerializableFinder saveDetails = find.byValueKey("saveDetails");
      await driver.waitFor(saveDetails);
      await driver.waitUntilNoTransientCallbacks();
      await screenshot(driver, config, '02 editor');

      // then the projects page
      SerializableFinder closeButton = find.byType("CloseButton");
      await driver.waitFor(closeButton);
      await driver.tap(closeButton);
      SerializableFinder menuButton = find.byValueKey("menuButton");
      await driver.waitFor(menuButton);
      await driver.tap(menuButton);
      SerializableFinder menuProjects = find.byValueKey("menuProjects");
      await driver.waitFor(menuProjects);
      await driver.tap(menuProjects);
      SerializableFinder addProject = find.byValueKey("addProject");
      await driver.waitFor(addProject);
      await driver.waitUntilNoTransientCallbacks();
      await screenshot(driver, config, '03 projects');

      // then the export page
      SerializableFinder backButton = find.byType("BackButton");
      await driver.waitFor(backButton);
      await driver.tap(backButton);
      await driver.waitFor(menuButton);
      await driver.tap(menuButton);
      SerializableFinder menuExport = find.byValueKey("menuExport");
      await driver.waitFor(menuExport);
      await driver.tap(menuExport);
      SerializableFinder exportFAB = find.byValueKey("exportFAB");
      await driver.waitFor(exportFAB);
      await driver.waitUntilNoTransientCallbacks();
      await screenshot(driver, config, '04 export');

      // then the about page
      await driver.waitFor(backButton);
      await driver.tap(backButton);
      await driver.waitFor(menuButton);
      await driver.tap(menuButton);
      SerializableFinder menuAbout = find.byValueKey("menuAbout");
      await driver.waitFor(menuAbout);
      await driver.tap(menuAbout);
      SerializableFinder aboutPage = find.byValueKey("aboutPage");
      await driver.waitFor(aboutPage);
      await driver.waitUntilNoTransientCallbacks();
      await screenshot(driver, config, '05 about');
    }, timeout: Timeout(Duration(seconds: 30)));
  });
}
