

import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';

import '../constants.dart';
import 'CustomProgressIndicator.dart';

class RoundedButton extends StatelessWidget {
  final String text;
  final Function press;
  final Color color, textColor;
  final bool isLoading;
  const RoundedButton(
      {Key? key,
      required this.text,
      required this.press,
      this.color = kNewPrimaryColor,
      this.textColor = Colors.white,
      this.isLoading = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Bounce(
      duration: const Duration(milliseconds: 200),
      onPressed: () {
        press();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
        alignment: Alignment.center,
        width: !isWeb(size) ? size.width * 0.8 : 500,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(29),
          color: color,
        ),
        child: !isLoading
            ? Text(
                text,
                style: TextStyle(
                    color: textColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w500),
              )
            : const CustomProgressIndicator(
                color: Colors.white,
              ),
      ),
    );
  }
}
