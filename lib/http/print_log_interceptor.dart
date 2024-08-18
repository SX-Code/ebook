import 'package:dio/dio.dart';
import 'package:e_book_clone/utils/log_utils.dart';

// 请求拦截器
class PrintLogInterceptor extends InterceptorsWrapper {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    LogUtils.println("\nonRequest-------------->");
    options.headers.forEach((key, value) {
      LogUtils.println("headers: key=$key  value=${value.toString()}");
    });
    LogUtils.println("path: ${options.uri}");
    LogUtils.println("method: ${options.method}");
    LogUtils.println("data: ${options.data}");
    LogUtils.println("queryParameters: ${options.queryParameters.toString()}");
    LogUtils.println("<--------------onRequest\n");
    super.onRequest(options, handler);
  }

  // @override
  // void onResponse(Response response, ResponseInterceptorHandler handler) {
  //   LogUtils.println("\nonResponse-------------->");
  //   LogUtils.println("path: ${response.realUri}");
  //   LogUtils.println("headers: ${response.headers.toString()}");
  //   LogUtils.println("statusMessage: ${response.statusMessage}");
  //   LogUtils.println("statusCode: ${response.statusCode}");
  //   LogUtils.println("extra: ${response.extra.toString()}");
  //   LogUtils.println("data: ${response.data}");
  //   LogUtils.println("<--------------onResponse\n");

  //   super.onResponse(response, handler);
  // }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    LogUtils.println("\nonError-------------->");
    LogUtils.println("error: ${err.toString()}");
    LogUtils.println("<--------------onError\n");
    super.onError(err, handler);
  }
}
