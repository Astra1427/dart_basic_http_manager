import 'dart:collection';
import 'dart:io';

import 'package:basic_http_manager/src/models/http_exception.dart';
import 'package:basic_http_manager/src/models/http_manager_config.dart';
import 'package:basic_http_manager/src/models/http_response.dart';
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
  Future<ResponseData> get(
    String api, {
    Map<String, dynamic>? params,
    bool? silent,
    bool needToken = true,
  }) async {
    assert(_isInitialized, 'BasicHttpManager has not been initialized');

    Response<dynamic>? response;

    _dio?.options.headers = managerConfig.httpHeaderGetter?.call();
    try {
      response = await _dio?.get(api, queryParameters: params);
      return handleResponse(response!, silent);
      // } on DioError catch (e) {
    } on Exception catch (e) {
      return handleException(e, silent: silent);
    }
  }

  /// 通用的POST请求
  Future<ResponseData> post(
    String api, {
    dynamic params,
    bool? silent,
  }) async {
    assert(_isInitialized, 'BasicHttpManager has not been initialized');
    Response<dynamic>? response;
    _dio?.options.headers = managerConfig.httpHeaderGetter?.call();
    try {
      // Options options = Options();
      response = await _dio?.post(api, data: params);
      return handleResponse(response!, silent);
      // responseData = await _dio?.post(api, data: params) as ResponseData;
    } on Exception catch (e) {
      return handleException(e, silent: silent);
    }
  }

  /// 通用的PUT请求
  Future<ResponseData> put(
    String api, {
    SplayTreeMap<String, dynamic>? params,
    bool? silent,
  }) async {
    assert(_isInitialized, 'BasicHttpManager has not been initialized');

    Response<dynamic>? response;
    _dio?.options.headers = managerConfig.httpHeaderGetter?.call();
    try {
      response = await _dio?.put(api, data: params);
      return handleResponse(response!, silent);
    } on Exception catch (e) {
      return handleException(e, silent: silent);
    }
  }

  /// 通用的Delete请求
  Future<ResponseData> delete(
    String api, {
    SplayTreeMap<String, dynamic>? params,
    bool? silent,
  }) async {
    assert(_isInitialized, 'BasicHttpManager has not been initialized');
    Response<dynamic>? response;
    _dio?.options.headers = managerConfig.httpHeaderGetter?.call();
    try {
      response = await _dio?.delete(api, data: params);
      return handleResponse(response!, silent);
    } on Exception catch (e) {
      return handleException(e, silent: silent);
    }
  }

  /// 处理响应结果
  ResponseData handleResponse(Response<dynamic> response,
      [bool? silent = false]) {
    final option = response.requestOptions;
    try {
      // 一般只需要处理200的情况，300、400、500保留错误信息，外层为http协议定义的响应码
      if (response.statusCode == 200 || response.statusCode == 201) {
        // ///内层需要根据公司实际返回结构解析，一般会有code，data，msg字段
        // 根据接口返回code定义返回成功或者失败
        final dataCode = managerConfig.checkBusinessError
            ? (response.data?[managerConfig.businessErrorCode] as int?)
            : response.statusCode;
        final errorMsg = managerConfig.checkBusinessError
            ? response.data[managerConfig.businessErrorMsg]?.toString()
            : response.statusMessage;

        if (dataCode != null &&
            (managerConfig.onStatusCode?.call(code: dataCode) ?? true)) {
          return ResponseData.success(data: response.data, code: dataCode);
        }

        handleErrorCode(
          dataCode,
          '$dataCode - $errorMsg',
          silent,
        );
        return ResponseData.failure(
          data: response.data,
          code: dataCode,
          errorMsg: errorMsg,
        );

        // handleErrorCode(dataCode, response.data["message"], silent);
        // return ResponseData(response.data, false, dataCode,
        //     headers: response.headers);
      } else {
        return ResponseData.failure(
            data: response.data, erorCode: response.statusCode!);
      }
    } catch (e) {
      return ResponseData.failure(
          data: response.data, erorCode: response.statusCode!);
    }
  }

  void handleErrorCode(int? errorCode, String? message, bool? silent) {
    // 静默请求不处理其他错误码，但是要处理token失效问题
    managerConfig.onStatusCode?.call(
        code: errorCode ?? 0, errorMsg: message, silent: silent ?? false);
  }

  ResponseData handleException(Exception exception, {bool? silent}) {
    final parseException = _parseException(exception, silent: silent);

    if (exception is DioException &&
        exception.type == DioExceptionType.badResponse) {
      final response = exception.response;
      // if (response?.data[managerConfig.businessErrorCode] == 4079) {
      //   AppService.instance.checkChatRomUpdate();
      // }
      return ResponseData.failureFromExceptionAndData(
        exception: parseException,
        data: response?.data,
        // code: response?.data[managerConfig.businessErrorCode],
      );
    }
    return ResponseData.failureFromException(parseException);
  }

  HttpException _parseException(Exception exception, {bool? silent}) {
    if (exception is DioException) {
      switch (exception.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.receiveTimeout:
        case DioExceptionType.sendTimeout:
          if (silent != true) {
            // DialogHelper.showStyleErrorToast(message: 'request_timeout'.tr);
          }
          return NetworkException(message: exception.message);
        case DioExceptionType.cancel:
          return CancelException(exception.message);
        case DioExceptionType.badResponse:
          try {
            final errCode = managerConfig.checkBusinessError
                ? int.tryParse(
                    exception.response?.data[managerConfig.businessErrorCode]
                            ?.toString() ??
                        '',
                  )
                : exception.response?.statusCode;

            final errorMsg = managerConfig.checkBusinessError
                ? exception.response?.data[managerConfig.businessErrorMsg]
                    ?.toString()
                : exception.message;

            handleErrorCode(errCode, errorMsg, silent);

            switch (errCode) {
              case 400:
                return BadRequestException(message: errorMsg, code: errCode);
              case 401:
                return UnauthorisedException(message: errorMsg, code: errCode);
              case 403:
                return BadRequestException(message: errorMsg, code: errCode);
              case 404:
                return BadRequestException(message: errorMsg, code: errCode);
              case 406:
                // 服务器内部逻辑验证不通过
                return BadRequestException(message: errorMsg, code: errCode);
              case 405:
                return BadRequestException(message: errorMsg, code: errCode);
              case 500:
                return BadServiceException(message: errorMsg, code: errCode);
              case 502:
                return BadServiceException(message: errorMsg, code: errCode);
              case 503:
                return BadServiceException(message: errorMsg, code: errCode);
              case 505:
                return UnauthorisedException(message: errorMsg, code: errCode);
              default:
                return UnknownException(
                  exception.message,
                );
            }
          } on Exception catch (_) {
            if (silent != true) {
              // DialogHelper.showStyleErrorToast(message: 'unknown_error'.tr);
            }
            return UnknownException(exception.message);
          }
        case DioExceptionType.unknown:
          if (exception.error is SocketException) {
            if (silent != true) {
              // DialogHelper.showStyleErrorToast(
              //     message: LocaleKeys.network_unavailable.tr);
            }
            return NetworkException(message: exception.message);
          } else {
            if (silent != true) {
              // DialogHelper.showStyleErrorToast(
              //     message: LocaleKeys.network_unavailable.tr);
            }
            return UnknownException(exception.message);
          }
        case DioExceptionType.connectionError:
          if (silent != true) {
            // DialogHelper.showStyleErrorToast(
            //     message: LocaleKeys.network_unavailable.tr);
          }
          return NetworkException(message: exception.message);
        default:
          if (silent != true) {
            // DialogHelper.showStyleErrorToast(
            //     message: LocaleKeys.network_unavailable.tr);
          }
          return UnknownException(exception.message);
      }
    } else {
      if (silent != true) {
        // DialogHelper.showStyleErrorToast(message: 'unknown_error'.tr);
      }
      return UnknownException(exception.toString());
    }
  }
}
