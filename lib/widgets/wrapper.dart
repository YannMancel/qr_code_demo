import 'package:flutter/material.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({
    Key? key,
    this.globalKeyForRepaintBoundary,
    required this.child,
  }) : super(key: key);

  final ValueChanged<GlobalKey<_WrapperState>>? globalKeyForRepaintBoundary;
  final Widget Function(BuildContext context) child;

  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  final _globalKey = GlobalKey<_WrapperState>();

  @override
  void initState() {
    super.initState();
    widget.globalKeyForRepaintBoundary?.call(_globalKey);
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: _globalKey,
      child: widget.child(context),
    );
  }
}
