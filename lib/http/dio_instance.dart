import 'package:dio/dio.dart';
import 'package:e_book_clone/http/cookie_interceptor.dart';
import 'package:e_book_clone/http/http_methods.dart';
import 'package:e_book_clone/http/response_interceptor.dart';
import 'package:e_book_clone/utils/constants.dart';
import 'package:e_book_clone/utils/header.dart';
import 'package:e_book_clone/utils/shared_prefs_utils.dart';

class DioInstance {
  static DioInstance? _instance;

  DioInstance._();

  String _cookie = "";

  static DioInstance instance() {
    return _instance ??= DioInstance._();
  }

  final Dio _dio = Dio();
  final _defaultTime = const Duration(seconds: 30);

  String get cookie => _cookie;
  
  set cookie(String value) {
    _cookie = value;
    SharedPrefsUtils.putString(Constants.keyCookie, value);
  }

  void initDio({
    String? httpMethod = HttpMethods.get,
    Duration? connectTimeout,
    Duration? receiveTimeout,
    Duration? sendTimeout,
    ResponseType? responseType = ResponseType.json,
    String? contentType,
  }) async {
    _dio.options = BaseOptions(
        method: httpMethod,
        connectTimeout: connectTimeout ?? _defaultTime,
        receiveTimeout: receiveTimeout ?? _defaultTime,
        sendTimeout: sendTimeout ?? _defaultTime,
        responseType: responseType,
        contentType: contentType);
    // _dio.interceptors.add(PrintLogInterceptor());
    _dio.interceptors.add(CookieInterceptor());
    _dio.interceptors.add(ResponseInterceptor());
    // 初始化 cookie
    _cookie = await SharedPrefsUtils.getString(Constants.keyCookie);
  }

  Future<Response> get({
    required String path,
    Map<String, dynamic>? param,
    Object? data,
    Options? options,
    CancelToken? cancelToken}) {
    return _dio.get(path,
        queryParameters: param,
        data: data,
        options: options ??
            Options(
                method: HttpMethods.get,
                receiveTimeout: _defaultTime,
                sendTimeout: _defaultTime),
        cancelToken: cancelToken);
  }

  Future<String> getString(
      {required String path,
      Object? data,
      Map<String, dynamic>? param,
      Options? options,
      CancelToken? cancelToken}) async {
    Response res = await _dio.get(
      path,
      queryParameters: param,
      data: data,
      cancelToken: cancelToken,
      options: options ??
          Options(
              method: HttpMethods.post,
              receiveTimeout: _defaultTime,
              sendTimeout: _defaultTime,
              headers: HeaderUtil.randomHeader()),
    );
    return res.data.toString();
  }

  Future<Response> post({
    required String path,
    Object? data,
    Map<String, dynamic>? param,
    Options? options,
    CancelToken? cancelToken
  }) {
    return _dio.post(path,
      queryParameters: param,
      data: data,
      cancelToken: cancelToken,
      options: options ??
          Options(
              method: HttpMethods.post,
              receiveTimeout: _defaultTime,
              sendTimeout: _defaultTime),
    );
  }
}
