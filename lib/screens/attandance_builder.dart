import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:upasthit/components/FadeAnimation.dart';
import 'package:upasthit/components/rounded_button.dart';
import 'package:upasthit/models/attendance_model.dart';

import '../constants.dart';
import '../providers/attendance_provider.dart';
import '../services/firebase_services.dart';

class AttendanceBuilder extends StatefulWidget {
  final String id;
  final bool isMember;
  const AttendanceBuilder({Key? key, required this.id, required this.isMember}) : super(key: key);

  @override
  State<AttendanceBuilder> createState() => _AttendanceBuilderState();
}

class _AttendanceBuilderState extends State<AttendanceBuilder> {
  var f = DateFormat('yyyy-MM-dd hh:mm a');
  final GlobalKey<FormState> key=GlobalKey<FormState>();
  bool isEdit=false;
  bool isLoading=false;
  @override
  Widget build(BuildContext context) {
    final List<AttendanceModel> attendanceModel=Provider.of<AttendanceProvider>(context).getAttendanceModel;
    return !isLoading?FadeAnimation(
      1.5,
      Form(
        key: key,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Divider(),
              const Text("Attendance Record",style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold
              ),),
              const Divider(),
              Card(
                elevation: 10,
                child:Column(
                  children: [
                    Table(
                        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                        columnWidths: const {
                          0: FractionColumnWidth(.75),
                        },
                        children: [
                          const TableRow(
                              decoration: BoxDecoration(
                                  color:Colors.blueAccent
                              ),
                              children :[
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('Date',style: TextStyle(
                                      color: Colors.white,

                                      fontSize: 20
                                  ),),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('Status',style: TextStyle(
                                      color: Colors.white,

                                      fontSize: 20
                                  )),
                                ),
                              ]),
                          for(var e in attendanceModel)
                            TableRow(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(f.format(e.date!.toDate()),style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 16
                                    ),),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        if(widget.isMember)
                                          Flexible(child: TextFormField(
                                            initialValue: e.status.toString().toUpperCase(),
                                            maxLengthEnforcement: MaxLengthEnforcement.enforced,
                                            onChanged: (value){
                                              if(value.isNotEmpty && (value=='p' || value=='a' || value=='l'))
                                              {
                                                e.status=value;
                                              }
                                            },
                                            validator: (value){
                                              if(value!.isEmpty)
                                              {
                                                return "Cant be empty";
                                              }
                                              else if((value!='p' && value!='a' && value!='l'))
                                              {
                                                return "Not valid label";
                                              }

                                              return null;
                                            },
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 16
                                            ),
                                            decoration: const InputDecoration(
                                              border: InputBorder.none,
                                              focusedBorder: InputBorder.none,
                                            ),
                                          ))
                                        else
                                          Flexible(child: Text(e.status.toString().toUpperCase(),style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 20
                                          ),)),

                                      ],
                                    ),
                                  )
                                ]

                            ),
                          if(widget.isMember)
                          TableRow(
                              decoration: const BoxDecoration(
                                  color:Colors.blueAccent
                              ),
                            children:[
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child:  Text("Add",style:  TextStyle(
                                    color: Colors.blueAccent,
                                    fontSize: 16
                                ),),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                  onTap: (){
                                    showDialog(context: context, builder: (builder){
                                      var status="";
                                      DateTime? dt;
                                      final GlobalKey<FormState> form=GlobalKey<FormState>();
                                      return StatefulBuilder(builder: (builder,setState){
                                        return AlertDialog(
                                          title: const Text("Add Attendance",style: TextStyle(
                                            fontSize: 20
                                          ),),
                                          content: Form(
                                            key: form,
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Row(
                                                  children: [
                                                    Flexible(child: TextFormField(
                                                      maxLengthEnforcement: MaxLengthEnforcement.enforced,
                                                      onChanged: (value){
                                                        if(value.isNotEmpty && (value.toLowerCase()=='p' || value.toLowerCase()=='a' || value.toLowerCase()=='l'))
                                                        {
                                                          status=value;
                                                        }
                                                      },
                                                      validator: (value){
                                                        if(value!.isEmpty)
                                                        {
                                                          return "Cant be empty";
                                                        }
                                                        else if((value.toLowerCase()=='p' && value.toLowerCase()!='a' && value.toLowerCase()!='l'))
                                                        {
                                                          return "Not valid label";
                                                        }

                                                        return null;
                                                      },
                                                      style: const TextStyle(
                                                          fontSize: 20
                                                      ),
                                                      decoration:  InputDecoration(
                                                        border: InputBorder.none,
                                                        hintText: "Add status L:Leave,A:Absent and P:Present",
                                                        label: const Text("Status"),
                                                        hintStyle: const TextStyle(
                                                          fontSize: 12
                                                      ),
                                                        labelStyle:const TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 20
                                                      ),
                                                        focusedBorder: OutlineInputBorder(
                                                          borderRadius: BorderRadius.circular(8),
                                                          borderSide: const BorderSide(color: Colors.black)
                                                        )
                                                      ),
                                                    )
                                                    ),

                                                  ],
                                                ),
                                                const SizedBox(height: 20,),
                                                Row(children: [
                                                  Flexible(child: GestureDetector(
                                                      onTap:(){

                                                        DatePicker.showDatePicker(context,
                                                            showTitleActions: true,
                                                            minTime: DateTime(2018, 3, 5),
                                                            maxTime: DateTime.now(), onChanged: (date) {

                                                            }, onConfirm: (date) {
                                                              setState((){
                                                                dt=date;
                                                              });
                                                            }, currentTime: DateTime.now(), locale: LocaleType.en);
                                                      },
                                                      child: Text(dt!=null?dt.toString():"Pick A Date",style: const TextStyle(
                                                          fontSize: 20
                                                      ),)))
                                                ],)
                                              ],
                                            ),
                                          ),
                                          actionsAlignment: MainAxisAlignment.spaceBetween,
                                          actions: [
                                            GestureDetector(
                                              onTap: (){
                                                Navigator.pop(context);
                                              },
                                              child: const Text("No",style: TextStyle(
                                                  fontSize: 20
                                              ),),
                                            ),
                                            GestureDetector(
                                              onTap: (){
                                                if(form.currentState!.validate()){

                                                  try{
                                                    Provider.of<AttendanceProvider>(context,listen: false).addAttendance(date: Timestamp.fromDate(dt!),status: status);
                                                    Navigator.pop(context);
                                                  }catch(e){
                                                    Fluttertoast.showToast(msg: "Something went wrong");
                                                  }
                                                }


                                              },
                                              child: const Text("Yes",style: TextStyle(
                                                  fontSize: 20
                                              ),),
                                            )
                                          ],
                                        );
                                      });
                                    });
                                  },
                                  child: const Icon(Icons.add_circle,size: 30,color: Colors.white,),
                                ),
                              ),
                            ]
                          )
                        ]
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10,),
              if(widget.isMember)
             RoundedButton(text: "Update",
                 color: Colors.blueAccent,
                 press: () async {
               if(key.currentState!.validate())
               {
                 try{
                   setState(() {
                     isLoading=true;
                   });
                   await FirebaseService.updateAttendance(attendanceModel: attendanceModel, volId:widget.id);

                 }catch(e){
                   log(e.toString());
                   Fluttertoast.showToast(msg: "Something went wrong");
                 }
                 setState(() {
                   isLoading=false;
                 });

               }
             })
            ],
          ),
        ),
      ),
    ):const CircularProgressIndicator(
      color: kNewPrimaryColor,
    );
  }
}

