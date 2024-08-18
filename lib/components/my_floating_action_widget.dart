import 'package:flutter/material.dart';

class MyFloatingActionController {
  Function(bool show)? toggleStatus;

  void show() {
    toggleStatus?.call(true);
  }

  void hide() {
    toggleStatus?.call(false);
  }
}

class MyFloatingActionWidget extends StatefulWidget {
  final MyFloatingActionController? actionController;
  final VoidCallback onPressed;

  const MyFloatingActionWidget(
      {super.key, this.actionController, required this.onPressed});

  @override
  State<MyFloatingActionWidget> createState() => _MyFloatingActionWidgetState();
}

class _MyFloatingActionWidgetState extends State<MyFloatingActionWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late Animation<double> _previousRotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller);
    _previousRotationAnimation = Tween(begin: 0.8, end: 1.0).animate(_controller);
    widget.actionController?.toggleStatus = (show) {
      if (show) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    };
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: RotationTransition(
        turns: _previousRotationAnimation,
        child: FloatingActionButton(
          onPressed: widget.onPressed,
          child: const Icon(Icons.arrow_upward),
        ),
      ),
    );
  }
}
