import 'package:flutter/material.dart';

class MyIconTextButton extends StatelessWidget {
  const MyIconTextButton(
      {super.key,
      required this.onPressed,
      required this.label,
      this.labelSize,
      this.icon,
      this.iconColor});

  final VoidCallback onPressed;
  final String label;
  final IconData? icon;
  final Color? iconColor;
  final double? labelSize;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: const BoxDecoration(shape: BoxShape.circle),
        child: Column(
          children: [
            Icon(icon),
            Text(
              label,
              style: TextStyle(fontSize: labelSize),
            )
          ],
        ),
      ),
    );
  }
}
