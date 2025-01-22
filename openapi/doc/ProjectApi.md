# openapi.api.ProjectApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to */api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**timecopsyncProjectsApiWebProjectControllerCreate**](ProjectApi.md#timecopsyncprojectsapiwebprojectcontrollercreate) | **POST** /projects | 
[**timecopsyncProjectsApiWebProjectControllerDelete**](ProjectApi.md#timecopsyncprojectsapiwebprojectcontrollerdelete) | **DELETE** /projects/{id} | 
[**timecopsyncProjectsApiWebProjectControllerIndex**](ProjectApi.md#timecopsyncprojectsapiwebprojectcontrollerindex) | **GET** /projects | 
[**timecopsyncProjectsApiWebProjectControllerShow**](ProjectApi.md#timecopsyncprojectsapiwebprojectcontrollershow) | **GET** /projects/{id} | 
[**timecopsyncProjectsApiWebProjectControllerUpdate**](ProjectApi.md#timecopsyncprojectsapiwebprojectcontrollerupdate) | **PATCH** /projects/{id} | 


# **timecopsyncProjectsApiWebProjectControllerCreate**
> ProjectResponse timecopsyncProjectsApiWebProjectControllerCreate(body)



Create a new project

### Example
```dart
import 'package:openapi/api.dart';

final api_instance = ProjectApi();
final body = ProjectInput(); // ProjectInput | Project to create

try {
    final result = api_instance.timecopsyncProjectsApiWebProjectControllerCreate(body);
    print(result);
} catch (e) {
    print('Exception when calling ProjectApi->timecopsyncProjectsApiWebProjectControllerCreate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **body** | [**ProjectInput**](ProjectInput.md)| Project to create | 

### Return type

[**ProjectResponse**](ProjectResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **timecopsyncProjectsApiWebProjectControllerDelete**
> timecopsyncProjectsApiWebProjectControllerDelete(id)



Delete a project

### Example
```dart
import 'package:openapi/api.dart';

final api_instance = ProjectApi();
final id = id_example; // String | Project ID

try {
    api_instance.timecopsyncProjectsApiWebProjectControllerDelete(id);
} catch (e) {
    print('Exception when calling ProjectApi->timecopsyncProjectsApiWebProjectControllerDelete: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| Project ID | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **timecopsyncProjectsApiWebProjectControllerIndex**
> Projects timecopsyncProjectsApiWebProjectControllerIndex(limit, showArchived)



List projects, fetches 100 unarchived projects by default

### Example
```dart
import 'package:openapi/api.dart';

final api_instance = ProjectApi();
final limit = 1000; // int | Number of results to show
final showArchived = 1; // int | if 1 shows archived projects, defaults to 0

try {
    final result = api_instance.timecopsyncProjectsApiWebProjectControllerIndex(limit, showArchived);
    print(result);
} catch (e) {
    print('Exception when calling ProjectApi->timecopsyncProjectsApiWebProjectControllerIndex: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **limit** | **int**| Number of results to show | [optional] 
 **showArchived** | **int**| if 1 shows archived projects, defaults to 0 | [optional] 

### Return type

[**Projects**](Projects.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **timecopsyncProjectsApiWebProjectControllerShow**
> ProjectResponse timecopsyncProjectsApiWebProjectControllerShow(id)



Get a single project

### Example
```dart
import 'package:openapi/api.dart';

final api_instance = ProjectApi();
final id = id_example; // String | Project ID

try {
    final result = api_instance.timecopsyncProjectsApiWebProjectControllerShow(id);
    print(result);
} catch (e) {
    print('Exception when calling ProjectApi->timecopsyncProjectsApiWebProjectControllerShow: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| Project ID | 

### Return type

[**ProjectResponse**](ProjectResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **timecopsyncProjectsApiWebProjectControllerUpdate**
> ProjectResponse timecopsyncProjectsApiWebProjectControllerUpdate(id, body)



Update a project

### Example
```dart
import 'package:openapi/api.dart';

final api_instance = ProjectApi();
final id = id_example; // String | Project ID
final body = ProjectInput(); // ProjectInput | Project to update

try {
    final result = api_instance.timecopsyncProjectsApiWebProjectControllerUpdate(id, body);
    print(result);
} catch (e) {
    print('Exception when calling ProjectApi->timecopsyncProjectsApiWebProjectControllerUpdate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| Project ID | 
 **body** | [**ProjectInput**](ProjectInput.md)| Project to update | 

### Return type

[**ProjectResponse**](ProjectResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

