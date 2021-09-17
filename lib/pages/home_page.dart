import 'dart:typed_data' show Uint8List;

import 'package:flutter/material.dart';

import '../image_tools.dart';
import '../widgets/preview.dart';
import '../widgets/qr_code.dart';
import '../widgets/wrapper.dart';
import 'scan_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with ImageMixin {
  GlobalKey? _globalKey;
  Uint8List? _imageInMemory;

  static const kJson =
      '{"email": "yann.mancel@ngtvexperience.com","name": "yann"}';

  Future<void> _getPreview() async {
    final data = await convertWidgetToUint8List(globalKey: _globalKey);
    if (data == null) return;

    setState(() => _imageInMemory = data);
  }

  Future<void> _shareWidget() async {
    await shareWidget(globalKey: _globalKey);
    await _getPreview();
  }

  void _launchScanView({required BuildContext context}) {
    Navigator.push(context, ScanPage.route());
  }

  Future<void> _searchQRCode({required BuildContext context}) async {
    final rawValues = await searchRawValueOfBarcodesFromGalleryPicture();
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('QR Code'),
        content: Text('$rawValues'),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Wrapper(
              globalKeyForRepaintBoundary: (key) => _globalKey = key,
              child: (_) => QRCode(
                json: kJson,
                imageProvider: const AssetImage('assets/logo.png'),
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _shareWidget,
              child: Text('Share QR Code'),
            ),
            _imageInMemory == null
                ? const SizedBox.shrink()
                : Preview(imageInMemory: _imageInMemory!),
            ElevatedButton(
              onPressed: () => _launchScanView(context: context),
              child: Text('Launch scan view'),
            ),
            ElevatedButton(
              onPressed: () => _searchQRCode(context: context),
              child: Text('Search QR Code'),
            ),
          ],
        ),
      ),
    );
  }
}
