import 'dart:async';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String barcode = "";

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: Text('Barcode Scanner - googleflutter.com'),
          ),
          body: Center(
            child: Column(
              children: <Widget>[
                Container(
                  child: ElevatedButton(
                      onPressed: barcodeScanning,
                      child: Text(
                        "Capture Image",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      )),
                  padding: const EdgeInsets.all(10.0),
                  margin: EdgeInsets.all(10),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                ),
                Text(
                  "Scanned Barcode Number",
                  style: TextStyle(fontSize: 20),
                ),
                Text(
                  barcode,
                  style: TextStyle(fontSize: 25, color: Colors.green),
                ),
              ],
            ),
          )),
    );
  }

  //scan barcode asynchronously
  Future barcodeScanning() async {
    try {
      String barcode = (await BarcodeScanner.scan()) as String;
      setState(() => this.barcode = barcode);
    } on FormatException {
      setState(() => this.barcode = 'Nothing captured.');
    } catch (e) {
      setState(() => this.barcode = 'Unknown error: $e');
    }
  }
}
