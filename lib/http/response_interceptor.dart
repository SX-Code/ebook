import 'package:dio/dio.dart';
import 'package:e_book_clone/utils/toast_utils.dart';

// 拦截器处理返回结果
class ResponseInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    String errorMessage = "请检查网络";
    if (err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.sendTimeout) {
      errorMessage = "连接超时，请检查网络连接";
    } else if (err.type == DioExceptionType.receiveTimeout) {
      errorMessage = "服务器响应超时，请稍后重试";
    } else if (err.response?.statusCode == 404) {
      errorMessage = "请求的资源不存在";
    } else if (err.type == DioExceptionType.unknown) {
      errorMessage = "未知错误，请重试";
    }
    // 显示错误消息
    ToastUtils.showErrorMsg(errorMessage);
    // 使用handler.next继续传递错误
    return handler.next(err);
  }
}
