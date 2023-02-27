import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:provider/provider.dart';

import '../providers/app_state.dart';

class scanScreen extends StatefulWidget {
  const scanScreen({super.key});

  @override
  State<scanScreen> createState() => _scanScreenState();
}

class _scanScreenState extends State<scanScreen> {
  String _scanBarcode = '10030590491';

  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
    });
  }

  // Future<String> fetchProductName(String barcode) async {
  //   final response = await http.get(Uri.parse(
  //       'https://api.thesupplementdatabase.com/v1/products/barcode/$barcode'));

  //   if (response.statusCode == 200) {
  //     final data = json.decode(response.body);
  //     return data['product'][0]['product_name'];
  //   } else {
  //     throw Exception('Failed to fetch product');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Scan Here")),
      body: Consumer<ApplicationState>(
        builder: (context, appState, _) => Column(
          children: [
            Container(
              child: IconButton(
                  icon: Icon(Icons.camera),
                  onPressed: () {
                    scanBarcodeNormal();
                  }),
            ),
            IconButton(
                onPressed: () {
                  print("PRESSEED");
                  if (_scanBarcode != 'Unknown' && _scanBarcode != -1) {
                    print("NOT UNKNOWN");
                    Provider.of<ApplicationState>(context, listen: false)
                        .findDocument(_scanBarcode)
                        .then((snapshot) {
                      print(snapshot.toString());
                    });
                  }
                },
                icon: Icon(Icons.search)),
            Text('Scan result : $_scanBarcode\n',
                style: TextStyle(fontSize: 20))
          ],
        ),
      ),
    );
  }
}
