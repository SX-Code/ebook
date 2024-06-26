import 'package:flutter/material.dart';

class MyBookPage extends StatefulWidget {
  const MyBookPage({super.key});

  @override
  State<MyBookPage> createState() => _MyBookPageState();
}

class _MyBookPageState extends State<MyBookPage> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('My Book Page'),
    );
  }
}