import 'package:dio/dio.dart';

/// http manager 配置
class HttpManagerConfig {
  /// 初始化
  const HttpManagerConfig({
    required this.baseUrl,
    this.interceptors = const [],
    this.httpHeader = const {},
    this.onStatusCode,
    this.businessErrorCode,
    this.businessErrorMsg,
    this.checkBusinessError = false,
  });

  /// 基础url
  final String baseUrl;

  /// 拦截器
  final List<Interceptor> interceptors;

  /// http header
  final Map<String, dynamic> httpHeader;

  /// 当一次请求完毕，将状态码回调出去，提供外部判断
  final bool Function({required int code, String? errorMsg, bool? silent})?
      onStatusCode;

  /// 业务错误码
  final String? businessErrorCode;

  /// 业务错误信息
  final String? businessErrorMsg;

  /// 是否检查业务错误
  final bool checkBusinessError;

  ///copyWith
  HttpManagerConfig copyWith({
    String? baseUrl,
    List<Interceptor>? interceptors,
    Map<String, dynamic>? httpHeader,
    bool Function({required int code, String? errorMsg, bool? silent})?
        onStatusCode,
    String? businessErrorCode,
    String? businessErrorMsg,
    bool? checkBusinessError,
  }) {
    return HttpManagerConfig(
      baseUrl: baseUrl ?? this.baseUrl,
      interceptors: interceptors ?? this.interceptors,
      httpHeader: httpHeader ?? this.httpHeader,
      onStatusCode: onStatusCode ?? this.onStatusCode,
      businessErrorCode: businessErrorCode ?? this.businessErrorCode,
      businessErrorMsg: businessErrorMsg ?? this.businessErrorMsg,
      checkBusinessError: checkBusinessError ?? this.checkBusinessError,
    );
  }
}
