import 'package:flutter/widgets.dart';
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:supppro/providers/suppItem.dart';

import '../firebase_options.dart';

class ApplicationState extends ChangeNotifier {
  ApplicationState() {
    init();
  }

  bool _loggedIn = false;
  bool get loggedIn => _loggedIn;

  Future<void> init() async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform, name: "myApp");

    FirebaseUIAuth.configureProviders([
      EmailAuthProvider(),
    ]);

    FirebaseAuth.instance.userChanges().listen((user) {
      if (user != null) {
        _loggedIn = true;
      } else {
        _loggedIn = false;
      }
      notifyListeners();
    });
  }

  Future<DocumentSnapshot<Map<String, dynamic>>?> findDocument(
      String docId) async {
    final collectionName = "supps";
    final DocumentSnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance
            .collection(collectionName)
            .doc(docId)
            .get();

    if (snapshot.exists) {
      return snapshot;
    }

    // If the document snapshot does not exist, return null
    return null;
  }

  Future<void> createPersonalBox() async {
    if (!_loggedIn) {
      throw Exception('Must be logged in');
    }
    Map<String, dynamic> data = {
      'Supps': [],
    };
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set(data)
        .onError((e, _) => print("Error writing document: $e"));
  }

  Future<void> addRecordtoUser(SuppItem suppItem) async {
    if (!_loggedIn) {
      throw Exception('Must be logged in');
    }
    Map<String, dynamic> data = {
      'Bar_Code': suppItem.barCode,
      'Brand_Name': suppItem.brandName,
      'DSLD_ID': suppItem.dSLDId,
      'Net_Contents': suppItem.netContents,
      'Product_Name': suppItem.productName,
      'Product_Type': suppItem.productType,
      'Serving_Size': suppItem.servingSize,
      'Suggested_Use': suppItem.suggestedUse,
      'Supplement_Form': suppItem.supplementForm,
      'URL': suppItem.url,
      'Market_Status': suppItem.marketStatus,
    };

    var userDocRef = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid);
    var doc = await userDocRef.get();
    if (!doc.exists) {
      createPersonalBox();
    }
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
      'Supps': FieldValue.arrayUnion([data])
    }).onError((e, _) => print("Error writing document: $e"));
  }

  Future<List<SuppItem>> fetchSupplementData() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    if (!snapshot.exists) {
      return [];
    }
    final Map<String, dynamic> userData =
        snapshot.data() as Map<String, dynamic>;
    // print(userData.values.expand((l) => l).runtimeType);
    // print((userData.values.expand((l) => l)));
    var dataList = userData.values.expand((l) => l);
    List<SuppItem> suppItemList = dataList.map((data) {
      // print(data);
      return SuppItem(
        barCode: data['Bar_Code'],
        brandName: data['Brand_Name'],
        dSLDId: data['DSLD_ID'],
        dateEnteredIntoDSLD: DateTime.now().toString(),
        marketStatus: data['Market_Status'],
        netContents: data['Net_Contents'],
        productName: data['Product_Name'],
        productType: data['Product_Type'],
        servingSize: data['Serving_Size'],
        suggestedUse: data['Suggested_Use'],
        supplementForm: data['Supplement_Form'],
        url: data['URL'],
      );
    }).toList();
    return suppItemList;
  }
}
