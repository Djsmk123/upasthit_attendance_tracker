import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'package:printing/printing.dart';

import '../models/collection.dart';
class TranscationScreen extends StatefulWidget {
  final List donations;
  const TranscationScreen({Key? key, required this.donations}) : super(key: key);

  @override
  State<TranscationScreen> createState() => _TranscationScreenState();
}

class _TranscationScreenState extends State<TranscationScreen> {
  final pdf = pw.Document();
  bool isLoading=false;
  

  initAsync() async {
    final font = await rootBundle.load("assets/fonts/OpenSans.ttf");
    final ttf = pw.Font.ttf(font);

    pdf.addPage(pw.Page(build: (pw.Context context) {
      return pw.Column(
          children: [
            pw.Row(
              children: [
                pw.Text("Invoice - Donation Tracker",style: pw.TextStyle(
                  font: ttf,
                  //color: PdfColor.fromHex("#0000FF"),
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 20
                ))
              ]
            ),
        pw.Container(height: 20),
        pw.Table(children: [
          pw.TableRow(children: [
            pdfColumn("Index", ttf),
            pdfColumn("Customer name", ttf),
            pdfColumn("Date", ttf),
            pdfColumn("Amount", ttf),
            pdfColumn("Transaction Id", ttf),
            pdfColumn("To", ttf),
          ]),
          for (var i = 0; i < widget.donations.length; i++)
            pw.TableRow(children: [
              pdfColumn("${i + 1}\t", ttf),
              pdfColumn(widget.donations[i]['Customer Name'].toString(), ttf),
              pdfColumn(widget.donations[i]['Date'].toDate().toString(), ttf),
              pdfColumn("Rs:\t${widget.donations[i]['Amount']}", ttf),
              pdfColumn(widget.donations[i]['transactionId'].toString(), ttf),
              pdfColumn("${widget.donations[i]['To']}", ttf),
            ])
        ])
      ]);
    }));
  }

  pdfColumn(txt,ttf){
    return pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment
            .center,
        mainAxisAlignment: pw.MainAxisAlignment.center,
        children: [
          pw.Text(txt,
              style: pw.TextStyle(fontSize: 6,font: ttf)),
        ]
    );
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState(); //
    initAsync();// Page
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PdfPreview(
                build: (context)=>pdf.save(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
