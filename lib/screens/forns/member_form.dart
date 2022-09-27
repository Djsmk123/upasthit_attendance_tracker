import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:provider/provider.dart';
import 'package:upasthit/screens/memeber_screen/member_screen.dart';

import '../../Models/users_models.dart';
import '../../components/CustomProgressIndicator.dart';
import '../../components/custom_text_input.dart';
import '../../providers/form_error.dart';
import '../../services/logins_signup_services.dart';


class MemberForm extends StatefulWidget {
  const MemberForm({Key? key}) : super(key: key);

  @override
  _MemberFormState createState() => _MemberFormState();
}

class _MemberFormState extends State<MemberForm> {
  final _formKey = GlobalKey<FormState>();
  final hm = MemberModel();
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    if (mounted) {
      Provider.of<FormErrorModel>(context, listen: false).resetErrors();
    }
    hm.info['em']=FirebaseAuth.instance.currentUser!.email!;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SizedBox(
        height: size.height,
        width: double.infinity,
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              child: Image.asset(
                "assets/images/main_top.png",
                //width:size.width
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Flexible(
                            child: ListTile(
                          title: const Text(
                            "Join",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          trailing: !isLoading
                              ? GestureDetector(
                                  onTap: () async {
                                    if (_formKey.currentState!.validate()) {
                                      setState(() {
                                        isLoading = true;
                                      });
                                      await Authentication()
                                          .addData(index: 1, data: {
                                        'info': hm.info,
                                      }).catchError((onError) {
                                        setState(() {
                                          isLoading = false;
                                        });
                                        Fluttertoast.showToast(
                                            msg: "Something went wrong");
                                      }).then((value) {
                                        Navigator.popUntil(
                                            context, (route) => false);
                                       Navigator.push(context, MaterialPageRoute(builder: (builder)=>const MemberScreen()));
                                      });
                                      setState(() {
                                        isLoading = false;
                                      });
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                        left: 20,
                                        right: 20,
                                        top: 10,
                                        bottom: 10),
                                    decoration: BoxDecoration(
                                        color: const Color(0XFFDCCFFF),
                                        borderRadius: BorderRadius.circular(8)),
                                    child: const Text(
                                      "Submit",
                                    ),
                                  ),
                                )
                              : const CustomProgressIndicator(),
                          subtitle: const Text(
                            "To get started, either send us some information about your self or contact us at ___________",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                            ),
                          ),
                        ))
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: SafeArea(
                    child: Scrollbar(
                      thickness: 5,
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Form(
                            key: _formKey,
                            autovalidateMode: AutovalidateMode.disabled,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Card(
                                  elevation: 10,
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Info",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                        CustomTextInputContainer(
                                          label: 'Name',
                                          errorKey: 'fnm',
                                          valid: (String? value) {
                                            var message = "";
                                            if (value!.isEmpty) {
                                              message = "Name can't be empty";
                                              Provider.of<FormErrorModel>(
                                                  context,
                                                  listen: false)
                                                  .setFormError('fnm', message);
                                              return message;
                                            }
                                            Provider.of<FormErrorModel>(context,
                                                listen: false)
                                                .setFormError('fnm', message);
                                            return null;
                                          },
                                          keyboardTyp: TextInputType.name,
                                          valueChanged: (String value) {
                                            hm.info['name'] = value;
                                          },
                                        ),
                                        CustomTextInputContainer(
                                          label: 'Title',
                                          valid: (String? value) {
                                            return null;
                                          },
                                          keyboardTyp: TextInputType.name,
                                          valueChanged: (String value) {
                                            hm.info['title'] = value;
                                          },
                                        ),
                                        CustomTextInputContainer(
                                          label: 'Phone(+91)',
                                          errorKey: 'phn1',
                                          valid: (String? value) {
                                            String? message;
                                            if (value!.isEmpty) {
                                              message =
                                                  "Phone number can't be empty";
                                            } else if (value.length < 10) {
                                              message =
                                                  "Enter valid mobile number";
                                            }
                                            Provider.of<FormErrorModel>(context,
                                                    listen: false)
                                                .setFormError(
                                                    'phn1', message ?? "");
                                            return message;
                                          },
                                          keyboardTyp: TextInputType.phone,
                                          valueChanged: (String value) {
                                            hm.info['phno'] = value;
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Card(
                                  elevation: 10,
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Additional Info",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        const Text(
                                          "Comments",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w300,
                                            fontSize: 14,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        const Text(
                                          "To provide any additional information that may be useful. Or to ask any questions.",
                                          style: TextStyle(
                                            color: Color(0XFF888888),
                                            fontWeight: FontWeight.w400,
                                            fontSize: 12,
                                          ),
                                        ),
                                        CustomTextInputContainer(
                                          label: '',
                                          valid: (String? value) {
                                            return null;
                                          },
                                          keyboardTyp: TextInputType.name,
                                          maxLines: 15,
                                          valueChanged: (String value) {
                                            hm.info['comments'] = value;
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
