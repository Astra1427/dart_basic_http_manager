import 'dart:io';

import 'package:basic_http_manager/src/models/http_exception.dart';

/// class ResponseData {
///   var data;
///   bool isSuccess;
///   int? dataCode; // 服务器返回code(参数：error)
///   var headers;
///
///   ResponseData(this.data, this.isSuccess, this.dataCode, {this.headers});
/// }
class ResponseData {

  /// 失败
  /// 带有 [exception] , [data] , [code]
  ResponseData.failureFromExceptionAndData({
    HttpException? exception,
    this.data,
    this.code,
  }) {
    error = exception ?? UnknownException();
    isSuccess = false;
  }

  /// 默认
  ResponseData.internal({this.isSuccess = false});

  /// 成功
  ResponseData.success({this.data, this.code}) {
    isSuccess = true;
  }

  /// 失败
  /// 带有错误信息
  ResponseData.failure(
      {this.data, this.code, int? erorCode, String? errorMsg}) {
    error = BadRequestException(message: errorMsg, code: erorCode);
    isSuccess = false;
  }

  /// 失败
  /// 带有 [data]
  ResponseData.failureFormResponse({dynamic data}) {
    error = BadResponseException(data);
    isSuccess = false;
  }

  /// 失败
  /// 带有 [exception]
  ResponseData.failureFromException([HttpException? exception]) {
    error = exception ?? UnknownException();
    isSuccess = false;
  }
  /// 数据
  dynamic data;
  /// 是否成功
  late bool isSuccess;
  /// 服务器返回code(参数：error)
  int? code;
  /// 错误信息
  HttpException? error;

  Map<String, dynamic>? get dataMap =>
      data is Map<String, dynamic> ? (data as Map<String, dynamic>) : null;
}
