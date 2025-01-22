//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class TimerApi {
  TimerApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Create a new timer
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [TimerInput] body (required):
  ///   Timer to create
  Future<Response> timecopsyncProjectsApiWebTimerControllerCreateWithHttpInfo(
    TimerInput body,
  ) async {
    // ignore: prefer_const_declarations
    final path = r'/timers';

    // ignore: prefer_final_locals
    Object? postBody = body;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];

    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Create a new timer
  ///
  /// Parameters:
  ///
  /// * [TimerInput] body (required):
  ///   Timer to create
  Future<TimerResponse?> timecopsyncProjectsApiWebTimerControllerCreate(
    TimerInput body,
  ) async {
    final response =
        await timecopsyncProjectsApiWebTimerControllerCreateWithHttpInfo(
      body,
    );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty &&
        response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(
        await _decodeBodyBytes(response),
        'TimerResponse',
      ) as TimerResponse;
    }
    return null;
  }

  /// Delete a timer
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///   Timer ID
  Future<Response> timecopsyncProjectsApiWebTimerControllerDeleteWithHttpInfo(
    String id,
  ) async {
    // ignore: prefer_const_declarations
    final path = r'/timers/{id}'.replaceAll('{id}', id);

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];

    return apiClient.invokeAPI(
      path,
      'DELETE',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Delete a timer
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///   Timer ID
  Future<void> timecopsyncProjectsApiWebTimerControllerDelete(
    String id,
  ) async {
    final response =
        await timecopsyncProjectsApiWebTimerControllerDeleteWithHttpInfo(
      id,
    );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// List timers
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response>
      timecopsyncProjectsApiWebTimerControllerIndexWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/timers';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];

    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// List timers
  Future<Timers?> timecopsyncProjectsApiWebTimerControllerIndex() async {
    final response =
        await timecopsyncProjectsApiWebTimerControllerIndexWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty &&
        response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(
        await _decodeBodyBytes(response),
        'Timers',
      ) as Timers;
    }
    return null;
  }

  /// Get a single timer
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///   Timer ID
  Future<Response> timecopsyncProjectsApiWebTimerControllerShowWithHttpInfo(
    String id,
  ) async {
    // ignore: prefer_const_declarations
    final path = r'/timers/{id}'.replaceAll('{id}', id);

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];

    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Get a single timer
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///   Timer ID
  Future<TimerResponse?> timecopsyncProjectsApiWebTimerControllerShow(
    String id,
  ) async {
    final response =
        await timecopsyncProjectsApiWebTimerControllerShowWithHttpInfo(
      id,
    );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty &&
        response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(
        await _decodeBodyBytes(response),
        'TimerResponse',
      ) as TimerResponse;
    }
    return null;
  }

  /// Update a timer
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///   Timer ID
  ///
  /// * [TimerInput] body (required):
  ///   Timer to update
  Future<Response> timecopsyncProjectsApiWebTimerControllerUpdateWithHttpInfo(
    String id,
    TimerInput body,
  ) async {
    // ignore: prefer_const_declarations
    final path = r'/timers/{id}'.replaceAll('{id}', id);

    // ignore: prefer_final_locals
    Object? postBody = body;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];

    return apiClient.invokeAPI(
      path,
      'PATCH',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Update a timer
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///   Timer ID
  ///
  /// * [TimerInput] body (required):
  ///   Timer to update
  Future<TimerResponse?> timecopsyncProjectsApiWebTimerControllerUpdate(
    String id,
    TimerInput body,
  ) async {
    final response =
        await timecopsyncProjectsApiWebTimerControllerUpdateWithHttpInfo(
      id,
      body,
    );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty &&
        response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(
        await _decodeBodyBytes(response),
        'TimerResponse',
      ) as TimerResponse;
    }
    return null;
  }
}
