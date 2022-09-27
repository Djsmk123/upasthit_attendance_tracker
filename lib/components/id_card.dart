import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:upasthit/Models/users_models.dart';

Widget IdCardWidget(VolModel model,context,bool isVol){
  return Container
    (
    padding:const EdgeInsets.only(top: 20,bottom: 30,left: 10,right: 10),
    width: 500,
    child: Card
      (
      color: Colors.blueAccent,

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),

      ),

      child: Column
        (
        children: <Widget>[

          Container(
            color: Colors.blue.shade900,
            child: Row
              (
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[

                const Padding(

                  padding: EdgeInsets.all(10),
                  child: Text(
                    "Teen of God",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25.0,

                    ),

                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 10,right: 10),
                  child: InkWell
                    (
                    child: CircleAvatar(

                      // radius: MediaQuery.of(context).size.width*0.1,
                      backgroundColor: Colors.blueAccent,
                      child: Image.asset("assets/images/volunteer-icon.png"),

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
                    backgroundColor: Colors.blueAccent,
                    child: Image.asset("assets/images/volunteer-icon.png"),

                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right:75,left: 75),
                child: Text(model.info['name'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 27,
                    fontWeight:FontWeight.bold,
                  ),

                ),
              ),
              Row(

                children: [

                  const Padding(
                    padding: EdgeInsets.only(left:75,top: 5),
                    child: Text("Email",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),

                    ),


                  ),


                  Padding(
                    padding: const EdgeInsets.only(left: 7,top: 2),
                    child: Text(model.info['em'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),

                    ),


                  ),

                ],

              ),

              Row(

                children: [

                  const Padding(
                    padding: EdgeInsets.only(left:75,top: 5),
                    child: Text("Phone No.",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),

                    ),


                  ),
                  const SizedBox(width: 10,),

                  Padding(
                    padding: const EdgeInsets.only(left: 7,top: 2),
                    child: Text(model.info['phno'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                  ),

                ],

              ),




              Row(

                children: [

                  const Padding(
                    padding: EdgeInsets.only(left:75,top: 5),
                    child: Text("Address",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),

                    ),

                  ),
                  const SizedBox(width: 10,),

                  Padding(
                    padding: const EdgeInsets.only(left: 7,top: 2),
                    child: Text(model.info['address'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                  ),

                ],

              ),

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
  );
}