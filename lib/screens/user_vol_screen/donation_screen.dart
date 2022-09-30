// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:upasthit/components/rounded_button.dart';
import 'package:upasthit/components/transcation_screen.dart';
import 'package:upasthit/services/firebase_services.dart';

import '../../Models/users_models.dart';
import '../../providers/attendance_provider.dart';

class DonationScreen extends StatefulWidget {
  const DonationScreen({Key? key}) : super(key: key);

  @override
  State<DonationScreen> createState() => _DonationScreenState();
}

class _DonationScreenState extends State<DonationScreen> {
  bool isLoading=false;
  double amount=100.0;
  late Razorpay _razorpay;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _razorpay=Razorpay();
     _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }
   openCheckout(double amount) async {
    var options = {
      'key': FirebaseService.razorPayKey,
      'amount': amount*100,
      'name': 'Teens of God',
      'description': 'Donating following amount RS: $amount to the NGO.',
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      'prefill': {'contact': '9667041944', 'email': 'djsmk123@gmail.com'},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: e');
    }
  }
  _handlePaymentSuccess(PaymentSuccessResponse response) async {
    String paymentId=response.paymentId.toString();
    print('Success Response: $paymentId');

    var uid=FirebaseAuth.instance.currentUser!.uid;
    final VolModel model=Provider.of<AttendanceProvider>(context,listen: false).getVolModel;
    await FirebaseService.addDonation(amount: amount, csName: model.info['name'], transactionId: paymentId, uid: uid);
    await Provider.of<AttendanceProvider>(context,listen: false).update(uid);
    Fluttertoast.showToast(
        msg: "Success",
        toastLength: Toast.LENGTH_SHORT);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print('Error Response: $response');
    Fluttertoast.showToast(
        msg: "ERROR: ${response.code} - ${response.message!}",
        toastLength: Toast.LENGTH_SHORT);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print('External SDK Response: $response');
     Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET: ${response.walletName!}",
        toastLength: Toast.LENGTH_SHORT);
  }
  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }
  @override
  Widget build(BuildContext context) {
    final List donations=Provider.of<AttendanceProvider>(context).getDonations;


    return Scaffold(
      appBar: AppBar(
        title: const Text("Donations Status"),
      ),
      body: isLoading?const Center(child: CircularProgressIndicator(),):Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
             children:  [
               const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                  child: Text("Add Donation",style: TextStyle(
                    color: Colors.black,
                    fontSize: 20
                  ),),
                ),
              ),
               const Center(
                 child: Padding(
                   padding: EdgeInsets.symmetric(horizontal: 20),
                   child: Text("Select amount from the following or enter custom",
                     textAlign: TextAlign.center,
                     style: TextStyle(
                       color: Colors.grey,
                       fontSize: 14
                   ),),
                 ),
               ),
               Padding(
                 padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 20),
                 child: Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     itemBuilder(amt: 10.0),
                     itemBuilder(amt: 50.0),
                     itemBuilder(amt: 100.0),
                     itemBuilder(amt: 1000.0)
                   ],
                 ),
               ),
               const Center(
                 child: Text("OR",style: TextStyle(
                   color: Colors.black,
                   fontSize: 30
                 ),),
               ),
               const Divider(
                 thickness: 2,
                 height: 20,
               ),
               Padding(
                 padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 20),
                 child: Row(
                   children: [
                     Flexible(
                       child: TextFormField(
                         keyboardType: TextInputType.number,
                         onChanged: (value){
                           if(value.isNotEmpty)
                             {
                               setState(() {
                                 amount=double.parse(value);
                               });
                             }
                         },
                         decoration: const InputDecoration(
                           hintText: "Enter Amount"
                         ),
                       ),
                     ),
                   ],
                 ),
               ),
               Padding(  padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 20),
               child: RoundedButton(
                 text: 'Donate',
                 color: Colors.blueAccent,
                 press: () async {
                   setState(() {
                     isLoading=true;
                   });
                   try{
                     await openCheckout(amount);
                     //Fluttertoast.showToast(msg: "Payment successfully donated");
                   }catch(e){
                     log(e.toString());
                     Fluttertoast.showToast(msg: "Something went wrong");
                   }finally{
                     setState(() {
                       isLoading=false;
                     });
                   }
                 },

               ),
               ),

               Padding(  padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 20),
                 child: RoundedButton(
                   text: 'Your donations',
                   color: Colors.blueAccent,
                   press: () async {
                   Navigator.push(context, MaterialPageRoute(builder: (builder)=>TranscationScreen(donations: donations)));
                   },

                 ),
               )

            ],
          ),
        ),
      ),
    );
  }
  Widget itemBuilder({required double amt}){
    bool isActive=amount==amt;
   return Flexible(
        child: Bounce(
          onPressed: (){
            if(!isActive)
              {
                setState(() {
                  amount=amt;
                });
              }
          },
          duration: const Duration(milliseconds: 200),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
            decoration: BoxDecoration(
                color: !isActive?Colors.white:Colors.blueAccent,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: isActive?Colors.blueAccent:Colors.black)
            ),
            child: Text("Rs ${amt.toStringAsFixed(0)}",style:TextStyle(
              color: isActive?Colors.white:Colors.black,
              fontSize: 12,
            ),),
          ),
        ));
  }
}
