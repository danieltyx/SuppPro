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

  Future<String> findSuppItem(String barcode) async {
    if (!_loggedIn) {
      throw Exception('Must be logged in');
    }
    SuppItem suppItem;
    final DocumentReference documentReference =
        FirebaseFirestore.instance.collection('supps').doc(barcode);
    print("### Test");
    final DocumentSnapshot documentSnapshot = await documentReference.get();
    print("DSLD ${documentSnapshot.data()}");
    final String stringValue = documentSnapshot.get('DSLD_ID');
    return stringValue;
  }

  Future<DocumentSnapshot<Map<String, dynamic>>?> findDocument(
      String docId) async {
    final collectionName = "supps";
    final DocumentSnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance
            .collection(collectionName)
            .doc(docId)
            .get();

    // If the document snapshot exists, return it
    if (snapshot.exists) {
      return snapshot;
    }

    // If the document snapshot does not exist, return null
    return null;
  }

  // Future<DocumentReference> addRecordtoUser(SuppItem suppItem) {
  //   if (!_loggedIn) {
  //     throw Exception('Must be logged in');
  //   }
  //   Map<String, dynamic> data = {
  //     'Bar_Code': suppItem.barCode,
  //     'Brand_Name': suppItem.brandName,
  //     'DSLD_ID': suppItem.dSLDId,
  //     'Net_Contents': suppItem.netContents,
  //     'Product_Name': suppItem.productName,
  //     'Product_Type': suppItem.productType,
  //     'Serving_Size': suppItem.servingSize,
  //     'Suggested_Use': suppItem.suggestedUse,
  //     'Supplement_Form': suppItem.supplementForm,
  //     'URL': suppItem.url,
  //   };
  //   FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(FirebaseAuth.instance.currentUser!.uid)
  //       .set(data);
  // }
}
