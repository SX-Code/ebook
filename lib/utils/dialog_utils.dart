import 'package:flutter/material.dart';

class DialogUtils {
  static void showQuestionDialog(BuildContext context,
      {String? title, String? content, VoidCallback? confirm}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title ?? '询问弹窗'),
        content: SingleChildScrollView(
          child: Text(content ?? '确定？'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              confirm?.call();
            },
            child: const Text('确认'),
          ),
        ],
      ),
    );
  }
}
