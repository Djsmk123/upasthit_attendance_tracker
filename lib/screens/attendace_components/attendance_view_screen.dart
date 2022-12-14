import 'package:flutter/material.dart';

import '../../components/rounded_button.dart';
import 'attandance_builder.dart';

class AttendanceViewScreen extends StatefulWidget {
  final String id;
  final bool isMember;
  const AttendanceViewScreen({Key? key, required this.id, required this.isMember}) : super(key: key);

  @override
  State<AttendanceViewScreen> createState() => _AttendanceViewScreenState();
}

class _AttendanceViewScreenState extends State<AttendanceViewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Attendance Status"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: AttendanceBuilder(id: widget.id,isMember:widget.isMember),
            ),
            if(widget.isMember)
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: RoundedButton(
                  text: "Back",
                  color: Colors.grey,
                  press: (){
                   Navigator.pop(context);
                  },
                )
            )
          ],
        ),
      ),
    );
  }
}
