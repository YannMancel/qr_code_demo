import 'dart:typed_data' show Uint8List;

import 'package:flutter/material.dart';

class Preview extends StatelessWidget {
  const Preview({
    Key? key,
    required this.imageInMemory,
  }) : super(key: key);

  final Uint8List imageInMemory;

  static const kMaxDimension = 50.0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        width: kMaxDimension,
        height: kMaxDimension,
        child: Image.memory(
          imageInMemory,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
