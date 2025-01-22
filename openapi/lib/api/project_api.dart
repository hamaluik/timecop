//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class ProjectApi {
  ProjectApi([ApiClient? apiClient])
      : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Create a new project
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [ProjectInput] body (required):
  ///   Project to create
  Future<Response> timecopsyncProjectsApiWebProjectControllerCreateWithHttpInfo(
    ProjectInput body,
  ) async {
    // ignore: prefer_const_declarations
    final path = r'/projects';

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

  /// Create a new project
  ///
  /// Parameters:
  ///
  /// * [ProjectInput] body (required):
  ///   Project to create
  Future<ProjectResponse?> timecopsyncProjectsApiWebProjectControllerCreate(
    ProjectInput body,
  ) async {
    final response =
        await timecopsyncProjectsApiWebProjectControllerCreateWithHttpInfo(
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
        'ProjectResponse',
      ) as ProjectResponse;
    }
    return null;
  }

  /// Delete a project
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///   Project ID
  Future<Response> timecopsyncProjectsApiWebProjectControllerDeleteWithHttpInfo(
    String id,
  ) async {
    // ignore: prefer_const_declarations
    final path = r'/projects/{id}'.replaceAll('{id}', id);

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

  /// Delete a project
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///   Project ID
  Future<void> timecopsyncProjectsApiWebProjectControllerDelete(
    String id,
  ) async {
    final response =
        await timecopsyncProjectsApiWebProjectControllerDeleteWithHttpInfo(
      id,
    );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// List projects, fetches 100 unarchived projects by default
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [int] limit:
  ///   Number of results to show
  ///
  /// * [int] showArchived:
  ///   if 1 shows archived projects, defaults to 0
  Future<Response> timecopsyncProjectsApiWebProjectControllerIndexWithHttpInfo({
    int? limit,
    int? showArchived,
  }) async {
    // ignore: prefer_const_declarations
    final path = r'/projects';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (limit != null) {
      queryParams.addAll(_queryParams('', 'limit', limit));
    }
    if (showArchived != null) {
      queryParams.addAll(_queryParams('', 'show_archived', showArchived));
    }

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

  /// List projects, fetches 100 unarchived projects by default
  ///
  /// Parameters:
  ///
  /// * [int] limit:
  ///   Number of results to show
  ///
  /// * [int] showArchived:
  ///   if 1 shows archived projects, defaults to 0
  Future<Projects?> timecopsyncProjectsApiWebProjectControllerIndex({
    int? limit,
    int? showArchived,
  }) async {
    final response =
        await timecopsyncProjectsApiWebProjectControllerIndexWithHttpInfo(
      limit: limit,
      showArchived: showArchived,
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
        'Projects',
      ) as Projects;
    }
    return null;
  }

  /// Get a single project
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///   Project ID
  Future<Response> timecopsyncProjectsApiWebProjectControllerShowWithHttpInfo(
    String id,
  ) async {
    // ignore: prefer_const_declarations
    final path = r'/projects/{id}'.replaceAll('{id}', id);

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

  /// Get a single project
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///   Project ID
  Future<ProjectResponse?> timecopsyncProjectsApiWebProjectControllerShow(
    String id,
  ) async {
    final response =
        await timecopsyncProjectsApiWebProjectControllerShowWithHttpInfo(
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
        'ProjectResponse',
      ) as ProjectResponse;
    }
    return null;
  }

  /// Update a project
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///   Project ID
  ///
  /// * [ProjectInput] body (required):
  ///   Project to update
  Future<Response> timecopsyncProjectsApiWebProjectControllerUpdateWithHttpInfo(
    String id,
    ProjectInput body,
  ) async {
    // ignore: prefer_const_declarations
    final path = r'/projects/{id}'.replaceAll('{id}', id);

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

  /// Update a project
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///   Project ID
  ///
  /// * [ProjectInput] body (required):
  ///   Project to update
  Future<ProjectResponse?> timecopsyncProjectsApiWebProjectControllerUpdate(
    String id,
    ProjectInput body,
  ) async {
    final response =
        await timecopsyncProjectsApiWebProjectControllerUpdateWithHttpInfo(
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
        'ProjectResponse',
      ) as ProjectResponse;
    }
    return null;
  }
}
