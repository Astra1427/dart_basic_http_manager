class HttpException implements Exception {
  final String? _message;

  String get message => _message ?? runtimeType.toString();

  final int? _code;

  int get code => _code ?? -1;

  HttpException([this._message, this._code]);

  @override
  String toString() {
    return "code:$code--message=$message";
  }
}

/// 客户端请求错误
class BadRequestException extends HttpException {
  BadRequestException({String? message, int? code}) : super(message, code);
}

/// 服务端响应错误
class BadServiceException extends HttpException {
  BadServiceException({String? message, int? code}) : super(message, code);
}

/// 未知错误
class UnknownException extends HttpException {
  UnknownException([String? message]) : super(message);
}

/// 取消请求
class CancelException extends HttpException {
  CancelException([String? message]) : super(message);
}

/// 网络错误
class NetworkException extends HttpException {
  NetworkException({String? message, int? code}) : super(message, code);
}

/// 401
class UnauthorisedException extends HttpException {
  UnauthorisedException({
    String? message,
    int? code,
  }) : super(message,code);
}

/// 失败的请求
class BadResponseException extends HttpException {
  dynamic data;

  BadResponseException([this.data]) : super();
}
