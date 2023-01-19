// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:upasthit/components/CustomProgressIndicator.dart';
import 'package:upasthit/constants.dart';
import 'package:upasthit/screens/admin/all_member_screen.dart';
import 'package:upasthit/screens/welcome_screen.dart';
import 'package:upasthit/services/admin_services.dart';

import '../../providers/admin_provider.dart';
import '../../services/logins_signup_services.dart';
import 'all_volunteer_screen.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({Key? key}) : super(key: key);

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initAsync();
  }

  void initAsync() async {
    try {
      await Provider.of<AdminProvider>(context, listen: false).fetchMembersData;
      await Provider.of<AdminProvider>(context, listen: false)
          .fetchVolunteerData();
    } catch (e) {
      log(e.toString());
    } finally {
      Provider.of<AdminProvider>(context, listen: false).setLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    bool isLoading = Provider.of<AdminProvider>(context).getLoadingStatus;
    var volunteerCards = Provider.of<AdminProvider>(context).getVolunteers;
    var memberCards = Provider.of<AdminProvider>(context).getMembers;
    List<MemberCard> nonApprovedMember =
        Provider.of<AdminProvider>(context).getNonApprovedMember;

    return Scaffold(
      body: !isLoading
          ? SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      height: nonApprovedMember.isNotEmpty ? 400 : 150,
                      decoration: BoxDecoration(
                        color: Colors.blue.shade700,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Admin Dashboard",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: isWeb(size) ? 40 : 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                IconButton(
                                    onPressed: () async {
                                      Provider.of<AdminProvider>(context,
                                              listen: false)
                                          .setLoading = true;
                                      await Authentication()
                                          .logOut()
                                          .then((value) {
                                        Navigator.popUntil(
                                            context, (route) => false);
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (builder) =>
                                                    const WelcomeScreen()));
                                      }).catchError((error) {
                                        Fluttertoast.showToast(
                                            msg: error.toString());
                                      });
                                      Provider.of<AdminProvider>(context,
                                              listen: false)
                                          .setLoading = false;
                                    },
                                    icon: Icon(
                                      Icons.logout,
                                      size: isWeb(size) ? 40 : 20,
                                      color: Colors.white,
                                    ))
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              nonApprovedMember.isEmpty
                                  ? "No pending requests for members registrations"
                                  : "${nonApprovedMember.length} members need approval",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          if (nonApprovedMember.isNotEmpty)
                            Center(
                              child: Container(
                                margin: const EdgeInsets.only(top: 20),
                                constraints: const BoxConstraints(
                                  maxHeight: 220,
                                  maxWidth: 400,
                                ),
                                alignment: Alignment.center,
                                child: SingleChildScrollView(
                                  controller:
                                      PageController(viewportFraction: 0.9),
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                      children: nonApprovedMember
                                          .map((e) => buildRequestsCard(
                                              title: e.info['name'],
                                              text: e.info['em'],
                                              mid: e.uid))
                                          .toList()),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: SizedBox(
                        height: 250,
                        width: isWeb(size) ? 500 : 1000,
                        child: PageView(
                          controller: PageController(
                              viewportFraction: 1, initialPage: 1),
                          scrollDirection: Axis.horizontal,
                          pageSnapping: false,
                          children: <Widget>[
                            buildItemCard(
                                title: "Volunteer Status",
                                total: "Total:${volunteerCards.length}",
                                color: Colors.blue,
                                icon: Icons.volunteer_activism,
                                onTap: () async {
                                  if (volunteerCards.isNotEmpty) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (builder) =>
                                                const AllVounteerScreen()));
                                  }
                                }),
                          ],
                        ),
                      ),
                    ),
                    Center(
                      child: SizedBox(
                        height: 250,
                        width: isWeb(size) ? 500 : 1000,
                        child: PageView(
                          controller: PageController(
                              viewportFraction: 1, initialPage: 1),
                          scrollDirection: Axis.horizontal,
                          pageSnapping: false,
                          children: <Widget>[
                            buildItemCard(
                                title: "Members Status",
                                total: "Total:${memberCards.length}",
                                color: Colors.blue,
                                icon: Icons.wallet_membership,
                                onTap: () async {
                                  if (memberCards.isNotEmpty) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (builder) =>
                                                const AllMemberScreen()));
                                  }
                                }),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : const Center(
              child: CustomProgressIndicator(
                msg: "Loading....",
              ),
            ),
    );
  }

  List<Map<String, dynamic>> nonApproveMember(memberData) {
    List<Map<String, dynamic>> members = [];
    if (memberData != null) {
      for (var i in memberData!.docs) {
        bool? isApprove;
        if (i.data().containsKey('isApproved')) {
          isApprove = i.get('isApproved');
        }
        if (isApprove == null) {
          var tmp = i.data();
          tmp['id'] = i.id;
          members.add(tmp);
        }
      }
    }
    return members;
  }

  Widget buildItemCard(
      {required String title,
      String? total,
      Color? color,
      IconData? icon,
      onTap}) {
    return Bounce(
      onPressed: onTap,
      duration: const Duration(milliseconds: 200),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                  text: TextSpan(
                children: [
                  WidgetSpan(
                      child: Icon(
                    icon,
                    color: color,
                    size: 40,
                  )),
                ],
              )),
              const SizedBox(height: 25),
              RichText(
                  text: TextSpan(
                      text: title,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 19,
                      ))),
              const SizedBox(height: 20),
              const Divider(
                thickness: 1,
              ),
              RichText(
                  text: TextSpan(
                      text: total,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ))),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildRequestsCard({
    required String title,
    String? subject,
    required String text,
    required String mid,
  }) {
    var size = MediaQuery.of(context).size;
    return Card(
      elevation: 2,
      surfaceTintColor: Colors.red,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        alignment: Alignment.center,
        child: Padding(
          padding: EdgeInsets.all(!isWeb(size) ? 24 : 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                    text: title.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                    )),
              ),
              RichText(
                text: TextSpan(
                    text: subject,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    )),
              ),
              RichText(
                text: TextSpan(
                    text: text,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    )),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Bounce(
                    onPressed: () async {
                      try {
                        Provider.of<AdminProvider>(context, listen: false)
                            .setLoading = true;
                        await AdminServices.rejectReq(id: mid);
                        await Provider.of<AdminProvider>(context, listen: false)
                            .fetchMembersData;
                      } catch (e) {
                        log(e.toString());
                        Fluttertoast.showToast(msg: "Something went wrong");
                      } finally {
                        Provider.of<AdminProvider>(context, listen: false)
                            .setLoading = false;
                      }
                    },
                    duration: const Duration(milliseconds: 200),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                          color: const Color(0XFFF4827A),
                          borderRadius: BorderRadius.circular(16)),
                      child: const Text(
                        "Decline",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Bounce(
                    onPressed: () async {
                      try {
                        Provider.of<AdminProvider>(context, listen: false)
                            .setLoading = true;
                        await AdminServices.acceptReq(id: mid);
                        await Provider.of<AdminProvider>(context, listen: false)
                            .fetchMembersData;
                      } catch (e) {
                        log(e.toString());
                        Fluttertoast.showToast(msg: "Something went wrong");
                      } finally {
                        Provider.of<AdminProvider>(context, listen: false)
                            .setLoading = false;
                      }
                    },
                    duration: const Duration(milliseconds: 200),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                          color: const Color(0XFF89B8FF),
                          borderRadius: BorderRadius.circular(16)),
                      child: const Text(
                        "Accept",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class VolunteerCard {
  final List attendance;
  final List donations;
  final Map<String, dynamic> info;
  final String uid;
  const VolunteerCard(
      {required this.attendance,
      required this.donations,
      required this.info,
      required this.uid});
}

class MemberCard {
  final Map<String, dynamic> info;
  final String uid;
  final bool? status;
  const MemberCard({
    required this.info,
    required this.uid,
    required this.status,
  });
}
