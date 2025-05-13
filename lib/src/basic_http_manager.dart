import 'dart:collection';
import 'package:basic_http_manager/src/models/http_manager_config.dart';
import 'package:dio/dio.dart';

/// Http 请求管理
class BasicHttpManager {
  /// 初始化
  BasicHttpManager({required this.managerConfig}) {
    assert(!_isInitialized, 'BasicHttpManager has already been initialized');

    _isInitialized = true;
    if (null == _dio) {
      // _dio = Dio(BaseOptions(
      //     baseUrl: ApiUrlService.to.baseUrl,
      //     connectTimeout: REQUEST_TIMEOUT_DEFAULT,
      //     receiveTimeout: REQUEST_TIMEOUT_DEFAULT));
      _dio = Dio();
      _dio?.options.baseUrl = managerConfig.baseUrl;
      _dio?.options.connectTimeout = requestTimeout;
      _dio?.options.receiveTimeout = requestTimeout;
      _dio?.options.sendTimeout = requestTimeout;

      _dio?.interceptors.addAll(managerConfig.interceptors);
    }
  }

  bool _isInitialized = false;

  Dio? _dio;

  Dio get dio => _dio!;

  static const requestTimeout = Duration(seconds: 40);

  final HttpManagerConfig managerConfig;

  ///
  /// 通用的GET请求
  /// silent: 静默请求，请求失败时不弹出任何提示
  ///
  Future<Response<dynamic>?> get(
    String api, {
    Map<String, dynamic>? params,
    bool? silent,
    bool needToken = true,
  }) async {
    assert(_isInitialized, 'BasicHttpManager has not been initialized');

    _dio?.options.headers = managerConfig.httpHeaderGetter?.call();
    return await _dio?.get(api, queryParameters: params);
  }

  /// 通用的POST请求
  Future<Response<dynamic>?> post(
    String api, {
    dynamic params,
    bool? silent,
  }) async {
    assert(_isInitialized, 'BasicHttpManager has not been initialized');
    _dio?.options.headers = managerConfig.httpHeaderGetter?.call();
    return await _dio?.post(api, data: params);
  }

  /// 通用的PUT请求
  Future<Response<dynamic>?> put(
    String api, {
    SplayTreeMap<String, dynamic>? params,
    bool? silent,
  }) async {
    assert(_isInitialized, 'BasicHttpManager has not been initialized');

    _dio?.options.headers = managerConfig.httpHeaderGetter?.call();
    return await _dio?.put(api, data: params);
  }

  /// 通用的Delete请求
  Future<Response<dynamic>?> delete(
    String api, {
    SplayTreeMap<String, dynamic>? params,
    bool? silent,
  }) async {
    assert(_isInitialized, 'BasicHttpManager has not been initialized');
    _dio?.options.headers = managerConfig.httpHeaderGetter?.call();
    return _dio?.delete<dynamic>(api, data: params);
  }
}
