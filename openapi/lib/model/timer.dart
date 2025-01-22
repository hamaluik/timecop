//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class Timer {
  /// Returns a new [Timer] instance.
  Timer({
    this.description,
    this.endTime,
    this.id,
    this.notes,
    this.projectId,
    required this.startTime,
  });

  /// Description of the timer
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? description;

  /// End time of the timer in UTC format, a timer cannot end before it started. If not provided, timer is still running
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? endTime;

  /// Timer ID
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? id;

  /// Notes about the timer, in markdown format
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? notes;

  /// Project ID this timer belongs to
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? projectId;

  /// Start time of the timer in UTC format
  String startTime;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Timer &&
          other.description == description &&
          other.endTime == endTime &&
          other.id == id &&
          other.notes == notes &&
          other.projectId == projectId &&
          other.startTime == startTime;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (description == null ? 0 : description!.hashCode) +
      (endTime == null ? 0 : endTime!.hashCode) +
      (id == null ? 0 : id!.hashCode) +
      (notes == null ? 0 : notes!.hashCode) +
      (projectId == null ? 0 : projectId!.hashCode) +
      (startTime.hashCode);

  @override
  String toString() =>
      'Timer[description=$description, endTime=$endTime, id=$id, notes=$notes, projectId=$projectId, startTime=$startTime]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.description != null) {
      json[r'description'] = this.description;
    } else {
      json[r'description'] = null;
    }
    if (this.endTime != null) {
      json[r'end_time'] = this.endTime;
    } else {
      json[r'end_time'] = null;
    }
    if (this.id != null) {
      json[r'id'] = this.id;
    } else {
      json[r'id'] = null;
    }
    if (this.notes != null) {
      json[r'notes'] = this.notes;
    } else {
      json[r'notes'] = null;
    }
    if (this.projectId != null) {
      json[r'project_id'] = this.projectId;
    } else {
      json[r'project_id'] = null;
    }
    json[r'start_time'] = this.startTime;
    return json;
  }

  /// Returns a new [Timer] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static Timer? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key),
              'Required key "Timer[$key]" is missing from JSON.');
          assert(json[key] != null,
              'Required key "Timer[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return Timer(
        description: mapValueOfType<String>(json, r'description'),
        endTime: mapValueOfType<String>(json, r'end_time'),
        id: mapValueOfType<String>(json, r'id'),
        notes: mapValueOfType<String>(json, r'notes'),
        projectId: mapValueOfType<String>(json, r'project_id'),
        startTime: mapValueOfType<String>(json, r'start_time')!,
      );
    }
    return null;
  }

  static List<Timer> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <Timer>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = Timer.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, Timer> mapFromJson(dynamic json) {
    final map = <String, Timer>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = Timer.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of Timer-objects as value to a dart map
  static Map<String, List<Timer>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<Timer>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = Timer.listFromJson(
          entry.value,
          growable: growable,
        );
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'start_time',
  };
}
