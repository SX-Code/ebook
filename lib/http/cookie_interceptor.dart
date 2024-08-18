import 'dart:io';

import 'package:dio/dio.dart';
import 'package:e_book_clone/http/dio_instance.dart';

class CookieInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (options.headers[HttpHeaders.cookieHeader] == null && DioInstance.instance().cookie.isNotEmpty) {
      options.headers[HttpHeaders.cookieHeader] = DioInstance.instance().cookie;
    }
    handler.next(options);
  }
}
