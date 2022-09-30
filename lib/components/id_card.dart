import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:upasthit/Models/users_models.dart';
import 'package:upasthit/components/FadeAnimation.dart';

Widget IdCardWidget(VolModel model,context,bool isVol){
  return FadeAnimation(
    1,
      Container
      (
      padding:const EdgeInsets.only(top: 20,bottom: 30,left: 10,right: 10),
      width: 500,
      child: Card
        (
        /*color: Colors.red.shade700,*/
        color:Colors.blueAccent,

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),

        ),

        child: Column
          (
          children: <Widget>[

            Container(
              color: Colors.blue.shade900,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row
                (
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const <Widget>[

                  Padding(

                    padding: EdgeInsets.all(10),
                    child: Text(
                      "Teens of God",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25.0,

                      ),

                    ),
                  ),

                  Padding(
                    padding:  EdgeInsets.only(top: 10,right: 10),
                    child: InkWell
                      (
                      child: CircleAvatar(

                        // radius: MediaQuery.of(context).size.width*0.1,
                        backgroundColor: Colors.white,
                        backgroundImage: AssetImage("assets/images/volunteer-icon.png"),

                      ),
                    ),
                  ),

                ],
              ),

            ),


            Column(
              children:<Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 100,right: 100,top: 20,bottom: 20),
                  child: InkWell
                    (
                    child: CircleAvatar(

                      radius: MediaQuery.of(context).size.width*0.15,
                      backgroundColor: Colors.white,
                      backgroundImage: AssetImage("assets/images/volunteer-icon.png"),

                    ),
                  ),
                ),
                labelWidget(model.info['name']),
                labelWidget(model.info['em']),
                labelWidget(model.info['phno'].toString()),
                labelWidget(model.info['address']),




              ],
            ),
            if(isVol)
              const Padding(
                padding: EdgeInsets.only(top:15),
                child: Text("Scan for Attendance",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,

                  ),


                ),
              ),
            if(isVol)
              Container
                (
                padding: const EdgeInsets.only(top: 10),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SizedBox(
                      child: QrImage(
                        data: FirebaseAuth.instance.currentUser!.uid,
                        version: QrVersions.auto,
                        backgroundColor: Colors.white,
                        size: 300.0,
                      ),
                    );
                  },
                ),
              ),
            const SizedBox(height: 20,),

          ],




        ),







      ),
    ),
  );
}
Widget labelWidget(title){
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 20,
          ),
        ),

      ],

    ),
  );
}