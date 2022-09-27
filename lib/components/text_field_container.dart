

import 'package:flutter/material.dart';

import '../constants.dart';

class TextFieldContainer extends StatelessWidget {
  final Widget child;
  final Color clr;
  const TextFieldContainer(
      {Key? key, required this.child, this.clr = kPrimaryLightColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
      width: !isWeb(size) ? size.width * 0.8 : 500,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: clr,
        borderRadius: BorderRadius.circular(29),
      ),
      child: child,
    );
  }
}
