

// ignore_for_file: file_names

import 'package:flutter/material.dart';

class CustomProgressIndicator extends StatelessWidget {
  final String msg;
  final Color color;
  const CustomProgressIndicator({Key? key, this.msg="", this.color=Colors.grey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Column(
         mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color:color,
          ),
          if(msg!="")
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child:Text(msg,style: TextStyle(
                color: color,
                fontSize: 14
            ),
            ),
          )
        ]

    );
  }
}
