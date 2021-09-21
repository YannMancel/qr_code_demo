import 'dart:io' show File;
import 'dart:typed_data' show Uint8List;
import 'dart:ui' as ui show Image, ImageByteFormat;

import 'package:flutter/rendering.dart' show RenderRepaintBoundary;
import 'package:flutter/widgets.dart';
import 'package:google_ml_vision/google_ml_vision.dart'
    show GoogleVision, GoogleVisionImage;
import 'package:google_ml_vision/google_ml_vision.dart';
import 'package:image_picker/image_picker.dart' show ImagePicker;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart' show getTemporaryDirectory;
import 'package:share_plus/share_plus.dart' show Share;

/*
 Dependencies:
  path_provider ........................ https://pub.dev/packages/path_provider
  share_plus .............................. https://pub.dev/packages/share_plus
  image_picker .......................... https://pub.dev/packages/image_picker
  google_ml_vision .................. https://pub.dev/packages/google_ml_vision
 */
mixin ImageMixin {
  Future<Uint8List?> convertWidgetToUint8List<T extends State<StatefulWidget>>({
    GlobalKey<T>? globalKey,
  }) async {
    try {
      if (globalKey == null) return null;

      final boundary = globalKey.currentContext?.findRenderObject()
          as RenderRepaintBoundary?;
      if (boundary == null) return null;

      final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) return null;

      return byteData.buffer.asUint8List();
    } catch (e) {
      return null;
    }
  }

  Future<File?> saveImageInTemporaryDirectory({
    required Uint8List data,
    required String fileName,
  }) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final file = await File('${tempDir.path}/$fileName.png').create();
      file.writeAsBytesSync(data);

      return file;
    } catch (e) {
      return null;
    }
  }

  Future<void> shareFile({required File file}) {
    return Share.shareFiles(
      [file.path],
      text: 'QR Code of user',
    );
  }

  Future<void> shareWidget<T extends State<StatefulWidget>>({
    GlobalKey<T>? globalKey,
  }) async {
    try {
      final data = await convertWidgetToUint8List(globalKey: globalKey);
      if (data == null) return;

      final file = await saveImageInTemporaryDirectory(
        data: data,
        fileName: 'qr_code',
      );
      if (file == null) return;

      await Share.shareFiles(
        <String>[file.path],
        subject: 'QR Code Share',
        text: 'QR Code of user',
      );
    } catch (e) {
      return;
    }
  }

  Future<String?> getPicturePathFromGallery() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      return image?.path;
    } catch (e) {
      return null;
    }
  }

  Future<List<String?>?> searchRawValueOfBarcodesFromGalleryPicture() async {
    final imagePath = await getPicturePathFromGallery();
    if (imagePath == null) return null;

    final imageFile = File(imagePath);
    final visionImage = GoogleVisionImage.fromFile(imageFile);

    final barcodeDetector = GoogleVision.instance.barcodeDetector();
    final barcodes = await barcodeDetector.detectInImage(visionImage);
    await barcodeDetector.close();

    return barcodes.map((e) => e.rawValue).toList(growable: false);
  }
}
