import 'dart:ui';

import 'package:flutter/material.dart';

import '../styles/colours.dart';

class BackDrop extends StatelessWidget {
  const BackDrop({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
      child: Container(
        color: black.withOpacity(0.1),
        height: height,
        width: width,
      ),
    );
  }
}
