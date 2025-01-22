# openapi.api.TimerApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to */api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**timecopsyncProjectsApiWebTimerControllerCreate**](TimerApi.md#timecopsyncprojectsapiwebtimercontrollercreate) | **POST** /timers | 
[**timecopsyncProjectsApiWebTimerControllerDelete**](TimerApi.md#timecopsyncprojectsapiwebtimercontrollerdelete) | **DELETE** /timers/{id} | 
[**timecopsyncProjectsApiWebTimerControllerIndex**](TimerApi.md#timecopsyncprojectsapiwebtimercontrollerindex) | **GET** /timers | 
[**timecopsyncProjectsApiWebTimerControllerShow**](TimerApi.md#timecopsyncprojectsapiwebtimercontrollershow) | **GET** /timers/{id} | 
[**timecopsyncProjectsApiWebTimerControllerUpdate**](TimerApi.md#timecopsyncprojectsapiwebtimercontrollerupdate) | **PATCH** /timers/{id} | 


# **timecopsyncProjectsApiWebTimerControllerCreate**
> TimerResponse timecopsyncProjectsApiWebTimerControllerCreate(body)



Create a new timer

### Example
```dart
import 'package:openapi/api.dart';

final api_instance = TimerApi();
final body = TimerInput(); // TimerInput | Timer to create

try {
    final result = api_instance.timecopsyncProjectsApiWebTimerControllerCreate(body);
    print(result);
} catch (e) {
    print('Exception when calling TimerApi->timecopsyncProjectsApiWebTimerControllerCreate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **body** | [**TimerInput**](TimerInput.md)| Timer to create | 

### Return type

[**TimerResponse**](TimerResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **timecopsyncProjectsApiWebTimerControllerDelete**
> timecopsyncProjectsApiWebTimerControllerDelete(id)



Delete a timer

### Example
```dart
import 'package:openapi/api.dart';

final api_instance = TimerApi();
final id = id_example; // String | Timer ID

try {
    api_instance.timecopsyncProjectsApiWebTimerControllerDelete(id);
} catch (e) {
    print('Exception when calling TimerApi->timecopsyncProjectsApiWebTimerControllerDelete: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| Timer ID | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **timecopsyncProjectsApiWebTimerControllerIndex**
> Timers timecopsyncProjectsApiWebTimerControllerIndex()



List timers

### Example
```dart
import 'package:openapi/api.dart';

final api_instance = TimerApi();

try {
    final result = api_instance.timecopsyncProjectsApiWebTimerControllerIndex();
    print(result);
} catch (e) {
    print('Exception when calling TimerApi->timecopsyncProjectsApiWebTimerControllerIndex: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**Timers**](Timers.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **timecopsyncProjectsApiWebTimerControllerShow**
> TimerResponse timecopsyncProjectsApiWebTimerControllerShow(id)



Get a single timer

### Example
```dart
import 'package:openapi/api.dart';

final api_instance = TimerApi();
final id = id_example; // String | Timer ID

try {
    final result = api_instance.timecopsyncProjectsApiWebTimerControllerShow(id);
    print(result);
} catch (e) {
    print('Exception when calling TimerApi->timecopsyncProjectsApiWebTimerControllerShow: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| Timer ID | 

### Return type

[**TimerResponse**](TimerResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **timecopsyncProjectsApiWebTimerControllerUpdate**
> TimerResponse timecopsyncProjectsApiWebTimerControllerUpdate(id, body)



Update a timer

### Example
```dart
import 'package:openapi/api.dart';

final api_instance = TimerApi();
final id = id_example; // String | Timer ID
final body = TimerInput(); // TimerInput | Timer to update

try {
    final result = api_instance.timecopsyncProjectsApiWebTimerControllerUpdate(id, body);
    print(result);
} catch (e) {
    print('Exception when calling TimerApi->timecopsyncProjectsApiWebTimerControllerUpdate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| Timer ID | 
 **body** | [**TimerInput**](TimerInput.md)| Timer to update | 

### Return type

[**TimerResponse**](TimerResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

