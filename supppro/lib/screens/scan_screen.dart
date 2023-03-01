import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:provider/provider.dart';
import 'package:supppro/providers/suppItem.dart';
import 'package:supppro/productCard.dart';

import '../productPreview.dart';
import '../providers/app_state.dart';

class scanScreen extends StatefulWidget {
  const scanScreen({super.key});

  @override
  State<scanScreen> createState() => _scanScreenState();
}

class _scanScreenState extends State<scanScreen> {
  String _scanBarcode = '15794065166';
  late SuppItem _suppItem;
  var _isLoading = true;

  @override
  void didChangeDependencies() {
    setState(() {
      _isLoading = true;
    });
    super.didChangeDependencies();
    // Perform setup or resource allocation that depends on the dependencies of the widget
  }

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

  //scan barcode asynchronously
  // Future barcodeScanning() async {
  //   try {
  //     String barcode = (await BarcodeScanner.scan()) as String;
  //     setState(() => this.barcode = barcode);
  //   } on FormatException {
  //     setState(() => this.barcode = 'Nothing captured.');
  //   } catch (e) {
  //     setState(() => this.barcode = 'Unknown error: $e');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Scan Here")),
      body: Column(
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
                if (_scanBarcode != 'Unknown' && _scanBarcode != -1) {
                  Provider.of<ApplicationState>(context, listen: false)
                      .findDocument(_scanBarcode)
                      .then((snapshot) {
                    //print(snapshot?.data());
                    var _Suggested_Use = snapshot?.data()?["Suggested_Use"];
                    var _Brand_Name = snapshot?.data()?["Brand_Name"];
                    var _Bar_Code = snapshot?.data()?["Bar_Code"];
                    var _Product_Name = snapshot?.data()?["Product_Name"];
                    var _Supplement_Form = snapshot?.data()?["Supplement_Form"];
                    var _URL = snapshot?.data()?["URL"];
                    var _Net_Contents = snapshot?.data()?["Net_Contents"];
                    var _Serving_Size = snapshot?.data()?["Serving_Size"];
                    var _Market_Status = snapshot?.data()?["Market Status"];
                    var _Product_Type = snapshot?.data()?["Product_Type"];
                    var _DSLD_ID = snapshot?.data()?["DSLD_ID"];
                    _suppItem = SuppItem(
                        barCode: _Bar_Code,
                        brandName: _Brand_Name,
                        dSLDId: _DSLD_ID,
                        dateEnteredIntoDSLD: "",
                        marketStatus: _Market_Status,
                        netContents: _Net_Contents,
                        productName: _Product_Name,
                        productType: _Product_Type,
                        servingSize: _Serving_Size,
                        suggestedUse: _Suggested_Use,
                        supplementForm: _Supplement_Form,
                        url: _URL);
                    // print('_suppItem = SuppItem(');
                    // print('  barCode: $_Bar_Code,');
                    // print('  brandName: $_Brand_Name,');
                    // print('  dSLDId: $_DSLD_ID,');
                    // print('  marketStatus: $_Market_Status,');
                    // print('  netContents: $_Net_Contents,');
                    // print('  productName: $_Product_Name,');
                    // print('  productType: $_Product_Type,');
                    // print('  servingSize: $_Serving_Size,');
                    // print('  suggestedUse: $_Suggested_Use,');
                    // print('  supplementForm: $_Supplement_Form,');
                    // print('  url: $_URL');
                    setState(() {
                      _isLoading = false;
                    });
                  });
                }
              },
              icon: Icon(Icons.search)),
          Text('Scan result : $_scanBarcode\n', style: TextStyle(fontSize: 20)),
          _isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Consumer<SuppItems>(builder: (context, value, child) {
                  return Column(
                    children: [
                      Center(child: ProductPreview(_suppItem)),
                      ElevatedButton(
                          onPressed: () {
                            value.setCurrentItem(_suppItem);
                            context.push('/view-detail');
                          },
                          child: Text("View Detail"))
                    ],
                  );
                })
        ],
      ),
    );
  }
}
