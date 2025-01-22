//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class ProjectInputProject {
  /// Returns a new [ProjectInputProject] instance.
  ProjectInputProject({
    this.archived,
    this.colour,
    required this.name,
  });

  /// Archived status
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  bool? archived;

  /// Colour associated represented by hex values casted into integer
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  int? colour;

  /// Project name
  String name;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProjectInputProject &&
          other.archived == archived &&
          other.colour == colour &&
          other.name == name;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (archived == null ? 0 : archived!.hashCode) +
      (colour == null ? 0 : colour!.hashCode) +
      (name.hashCode);

  @override
  String toString() =>
      'ProjectInputProject[archived=$archived, colour=$colour, name=$name]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.archived != null) {
      json[r'archived'] = this.archived;
    } else {
      json[r'archived'] = null;
    }
    if (this.colour != null) {
      json[r'colour'] = this.colour;
    } else {
      json[r'colour'] = null;
    }
    json[r'name'] = this.name;
    return json;
  }

  /// Returns a new [ProjectInputProject] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ProjectInputProject? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key),
              'Required key "ProjectInputProject[$key]" is missing from JSON.');
          assert(json[key] != null,
              'Required key "ProjectInputProject[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return ProjectInputProject(
        archived: mapValueOfType<bool>(json, r'archived'),
        colour: mapValueOfType<int>(json, r'colour'),
        name: mapValueOfType<String>(json, r'name')!,
      );
    }
    return null;
  }

  static List<ProjectInputProject> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <ProjectInputProject>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ProjectInputProject.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ProjectInputProject> mapFromJson(dynamic json) {
    final map = <String, ProjectInputProject>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ProjectInputProject.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ProjectInputProject-objects as value to a dart map
  static Map<String, List<ProjectInputProject>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<ProjectInputProject>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ProjectInputProject.listFromJson(
          entry.value,
          growable: growable,
        );
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'name',
  };
}
