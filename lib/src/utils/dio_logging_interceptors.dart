import 'package:dio/dio.dart';
import 'package:pertama/src/injector/injector.dart';
import 'package:pertama/src/storage/sharedpreferences/shared_preferences_manager.dart';

class DioLoggingInterceptors extends InterceptorsWrapper {
  final Dio _dio;
  final SharedPreferencesManager _sharedPreferencesManager = locator<SharedPreferencesManager>();

  DioLoggingInterceptors(this._dio);

  @override
  Future onRequest(RequestOptions options) async {
//    print("--> ${options.method != null ? options.method.toUpperCase() : 'METHOD'} ${"" + (options.baseUrl ?? "") + (options.path ?? "")}");
//    print("Headers:");
//    options.headers.forEach((k, v) => print('$k: $v'));
//    if (options.queryParameters != null) {
//      print("queryParameters:");
//      options.queryParameters.forEach((k, v) => print('$k: $v'));
//    }
//    if (options.data != null) {
//      print("Body: ${options.data}");
//    }
//    print("--> END ${options.method != null ? options.method.toUpperCase() : 'METHOD'}");

//    if (options.headers.containsKey('requirestoken')) {
//      options.headers.remove('requirestoken');
//      print('accessToken: ${_sharedPreferencesManager.getString(SharedPreferencesManager.keyAccessToken)}');
//      String accessToken = _sharedPreferencesManager.getString(SharedPreferencesManager.keyAccessToken);
//      options.headers.addAll({'Authorization': 'Bearer $accessToken'});
//    }
    return options;
  }

  @override
  Future onResponse(Response response) {
    print(
        "<-- ${response.statusCode} ${(response.request != null ? (response.request.baseUrl + response.request.path) : 'URL')}");
    print("Headers:");
    response.headers?.forEach((k, v) => print('$k: $v'));
    print("Response: ${response.data}");
    print("<-- END HTTP");
    return super.onResponse(response);
  }

  @override
  Future onError(DioError dioError) async {
    print(
        "<-- ${dioError.message} ${(dioError.response?.request != null ? (dioError.response.request.baseUrl + dioError.response.request.path) : 'URL')}");
    print(
        "${dioError.response != null ? dioError.response.data : 'Unknown Error'}");
    print("<-- End error");
    super.onError(dioError);
  }
}
