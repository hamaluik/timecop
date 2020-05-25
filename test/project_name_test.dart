import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timecop/models/project.dart';

void main() {
  group('project name tests', () {
    test('compare various project name values', () {
      var project = Project(id: 1, name: 'personal', colour: Colors.red);
      expect(project?.name != 'personal', equals(false));

      var project2 = Project(id: 2, name: 'test', colour: Colors.blue);
      expect(project2?.name != 'personal', equals(true));

      expect(() => Project(id: 3, name: null, colour: Colors.green),
          throwsAssertionError);

      Project project4;
      expect(project4?.name != 'personal', equals(true));

      expect(null != 'personal', equals(true));
    });
  });
}
