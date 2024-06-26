import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:line_icons/line_icons.dart';

class ToastUtils {
  static final navigatorKey = GlobalKey<NavigatorState>();
  static BuildContext get context => navigatorKey.currentContext!;

  static const Color successColor = Color(0xFF75FB4C);
  static const Color errorColor = Color(0xFFEA3323);

  static const IconData successIcon = LineIcons.checkCircle;
  static const IconData errorIcon = LineIcons.ban;
  static const IconData infoIcon = LineIcons.infoCircle;

  /// 显示成功吐司
  /// [msg] 消息
  /// [icon] 图标
  static showSuccessMsg(String msg, {IconData? icon}) {
    DelightToastBar(
      autoDismiss: true,
      position: DelightSnackbarPosition.top,
      builder: (context) => ToastCard(
        title: Text(
          msg,
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14.sp),
        ),
        leading: Icon(
          icon ?? successIcon,
          color: successColor,
          size: 20.r,
        ),
      ),
    );
  }

    /// 显示错误吐司
  /// [msg] 消息
  /// [icon] 图标
  static showErrorMsg(String msg, {IconData? icon}) {
    DelightToastBar(
      autoDismiss: true,
      position: DelightSnackbarPosition.top,
      builder: (context) => ToastCard(
        title: Text(
          msg,
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14.sp),
        ),
        leading: Icon(
          icon ?? errorIcon,
          color: errorColor,
          size: 20.r,
        ),
      ),
    );
  }

    /// 显示提示吐司
  /// [msg] 消息
  /// [icon] 图标
  static showInfoMsg(String msg, {IconData? icon}) {
    DelightToastBar(
      autoDismiss: true,
      position: DelightSnackbarPosition.top,
      builder: (context) => ToastCard(
        title: Text(
          msg,
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14.sp),
        ),
        leading: Icon(
          icon ?? infoIcon,
          size: 20.r,
        ),
      ),
    );
  }
}
