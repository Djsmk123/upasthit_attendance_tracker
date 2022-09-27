
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:upasthit/components/text_field_container.dart';

import '../constants.dart';
import '../providers/form_error.dart';
import 'FadeAnimation.dart';

class RoundedInputField extends StatefulWidget {
  final String hintText;
  final IconData icon;
  final ValueChanged<String> onChanged;
  final FormFieldValidator<String> validator;
  final TextInputType keyboardType1;
  final String errorKey;
  final bool isPassword;
  const RoundedInputField({
    Key? key,
    required this.hintText,
    this.icon = Icons.person,
    required this.onChanged,
    required this.validator,
    required this.keyboardType1,
    required this.errorKey,
    required this.isPassword,
  }) : super(key: key);

  @override
  State<RoundedInputField> createState() => _RoundedInputFieldState();
}

class _RoundedInputFieldState extends State<RoundedInputField> {
  bool isVisiblePass = true;
  var error = "";
  var periodicTimer = Timer.periodic(const Duration(seconds: 1), (timer) {});
  hideError() async {
    periodicTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (error != "") {
        Provider.of<FormErrorModel>(context, listen: false)
            .hideFormErrors(widget.errorKey);
      }
    });
  }

  @override
  initState() {
    super.initState();
    hideError();
  }

  @override
  void dispose() {
    super.dispose();
    periodicTimer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    error = Provider.of<FormErrorModel>(context).getFormError(widget.errorKey);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TextFieldContainer(
          child: TextFormField(
            onChanged: widget.onChanged,
            validator: widget.validator,
            keyboardType: widget.keyboardType1,
            cursorColor: kPrimaryColor,
            obscureText: !widget.isPassword ? false : isVisiblePass,
            decoration: InputDecoration(
              errorText: "",
              errorBorder: InputBorder.none,
              errorMaxLines: null,
              enabledBorder: InputBorder.none,
              border: InputBorder.none,
              errorStyle:
                  const TextStyle(color: Colors.transparent, fontSize: 0),
              icon: Icon(
                widget.icon,
                color: kPrimaryColor,
              ),
              suffixIcon: widget.isPassword
                  ? IconButton(
                      onPressed: () {
                        setState(() {
                          isVisiblePass = !isVisiblePass;
                        });
                      },
                      icon: isVisiblePass
                          ? const Icon(
                              Icons.visibility_off,
                              color: kPrimaryColor,
                            )
                          : const Icon(
                              Icons.visibility,
                              color: kPrimaryColor,
                            ))
                  : const Text(""),
              hintText: widget.hintText,
            ),
          ),
        ),
        if (error != "")
          Container(
            width: !isWeb(size) ? size.width * 0.8 : 500,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: FadeAnimation(
                0.5,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                        child: ListTile(
                            leading: const Icon(Icons.error_outline,
                                color: Colors.red),
                            horizontalTitleGap: 0,
                            contentPadding: const EdgeInsets.all(0),
                            title: Text(
                              error.toString(),
                              style: const TextStyle(
                                  color: Colors.red, fontSize: 12),
                            ))),
                  ],
                )),
          ),
      ],
    );
  }
}
