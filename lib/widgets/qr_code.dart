import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart'
    show PrettyQr, QrErrorCorrectLevel;

/*
 Dependencies:
  pretty_qr_code ...................... https://pub.dev/packages/pretty_qr_code
 */
class QRCode extends StatelessWidget {
  const QRCode({
    Key? key,
    required this.json,
    this.imageProvider,
    this.size = 200.0,
    this.isRoundEdges = true,
  }) : super(key: key);

  final String json;
  final ImageProvider<Object>? imageProvider;
  final double size;
  final bool isRoundEdges;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(),
        borderRadius: const BorderRadius.all(Radius.circular(4.0)),
      ),
      padding: const EdgeInsets.all(4.0),
      child: PrettyQr(
        image: imageProvider,
        size: size,
        data: json,
        errorCorrectLevel: QrErrorCorrectLevel.M,
        roundEdges: isRoundEdges,
      ),
    );
  }
}
