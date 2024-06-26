import 'package:flutter/material.dart';

class EbookStorePage extends StatefulWidget {
  const EbookStorePage({super.key});

  @override
  State<EbookStorePage> createState() => _EbookStorePageState();
}

class _EbookStorePageState extends State<EbookStorePage> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Ebook Store Page"),
    );
  }
}