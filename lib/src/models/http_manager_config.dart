import 'package:dio/dio.dart';

/// http manager 配置
class HttpManagerConfig {
  const HttpManagerConfig({
    required this.baseUrl,
    this.interceptors = const [],
    this.httpHeaderGetter,
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
  final Map<String, dynamic> Function()? httpHeaderGetter;

  /// 当一次请求完毕，将状态码回调出去，提供外部判断
  final bool Function({required int code, String? errorMsg, bool? silent})?
      onStatusCode;

  /// 业务错误码
  final String? businessErrorCode ;

  /// 业务错误信息
  final String? businessErrorMsg;

  /// 是否检查业务错误
  final bool checkBusinessError;
}
