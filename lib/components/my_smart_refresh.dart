import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class MySmartRefresh extends StatelessWidget {
  // 启用下拉
  final bool? enablePullDown;

  // 启用上拉
  final bool? enablePullUp;

  // 头布局
  final Widget? header;

  // 尾布局
  final Widget? footer;

  // 刷新事件
  final VoidCallback? onRefresh;

  // 加载事件
  final VoidCallback? onLoading;

  // 刷新组件控制器
  final RefreshController controller;

  final ScrollController? scrollController;

  // 被刷新的子组件
  final Widget child;

  const MySmartRefresh({
    super.key,
    this.enablePullDown,
    this.enablePullUp,
    this.header,
    this.footer,
    this.onLoading,
    this.onRefresh,
    required this.controller,
    required this.child,
    this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return _refreshView();
  }

  Widget _refreshView() {
    return SmartRefresher(
      scrollController: scrollController,
      controller: controller,
      enablePullDown: enablePullDown ?? true,
      enablePullUp: enablePullUp ?? true,
      header: header ?? const ClassicHeader(),
      footer: footer ?? const ClassicFooter(),
      onRefresh: onRefresh,
      onLoading: onLoading,
      child: child,
    );
  }
}
