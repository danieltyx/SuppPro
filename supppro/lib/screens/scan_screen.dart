import 'dart:ffi';

import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:go_router/go_router.dart';
import 'package:supppro/barcode/barcode_list_scanner_controller.dart';
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
  String CheckBarCode(String scanedBarcode) {
    String newBarcode = scanedBarcode.substring(1, 13);
    int newBarcodeInt = int.parse(newBarcode);
    newBarcode = newBarcodeInt.toString();
    return newBarcode;
  }

  String _scanBarcode = '15794065166';
  late SuppItem _suppItem;
  var _isLoading = true;
  var _isNotFound = false;
  @override
  void didChangeDependencies() {
    setState(() {
      _isLoading = true;
    });
    super.didChangeDependencies();
    // Perform setup or resource allocation that depends on the dependencies of the widget
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Scan Here")),
      body: Column(
        children: [
          Container(
              child: IconButton(
                  icon: Icon(Icons.camera),
                  onPressed: () async {
                    var result = await Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) =>
                                BarcodeListScannerWithController()));
                    if (result == null) {
                      result = "-1";
                    } else {
                      result = CheckBarCode(result);
                    }

                    print(result);
                    setState(() {
                      _scanBarcode = result as String;
                    });

                    if (_scanBarcode != 'Unknown' && _scanBarcode != -1) {
                      try {
                        Provider.of<ApplicationState>(context, listen: false)
                            .findDocument(_scanBarcode)
                            .then((snapshot) {
                          //print(snapshot?.data());
                          if (snapshot != null) {
                            var _Suggested_Use =
                                snapshot?.data()?["Suggested_Use"];
                            var _Brand_Name = snapshot?.data()?["Brand_Name"];
                            var _Bar_Code = snapshot?.data()?["Bar_Code"];
                            var _Product_Name =
                                snapshot?.data()?["Product_Name"];
                            var _Supplement_Form =
                                snapshot?.data()?["Supplement_Form"];
                            var _URL = snapshot?.data()?["URL"];
                            var _Net_Contents =
                                snapshot?.data()?["Net_Contents"];
                            var _Serving_Size =
                                snapshot?.data()?["Serving_Size"];
                            var _Market_Status =
                                snapshot?.data()?["Market Status"];
                            var _Product_Type =
                                snapshot?.data()?["Product_Type"];
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
                          } else {
                            setState(() {
                              _isNotFound = true;
                              _isLoading = true;
                            });
                          }
                        });
                      } catch (e) {
                        print(e.toString());
                      }
                    }
                  })),
          _isLoading
              ? _isNotFound
                  ? Text("Sorry, we do not have this item in our database yet.")
                  : const Center(
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
                }),
        ],
      ),
    );
  }
}
