import 'package:flutter/material.dart';

class SuppItem extends ChangeNotifier {
  final String barCode;
  final String brandName;
  final String dSLDId;
  final String dateEnteredIntoDSLD;
  final String marketStatus;
  final String netContents;
  final String productName;
  final String productType;
  final String servingSize;
  final String suggestedUse;
  final String supplementForm;
  final String url;

  SuppItem({
    required this.barCode,
    required this.brandName,
    required this.dSLDId,
    required this.dateEnteredIntoDSLD,
    required this.marketStatus,
    required this.netContents,
    required this.productName,
    required this.productType,
    required this.servingSize,
    required this.suggestedUse,
    required this.supplementForm,
    required this.url,
  });
}

class SuppItems extends ChangeNotifier {
  List<SuppItem> _suppItems = [];
  List<SuppItem> get suppItems {
    return [..._suppItems];
  }
}
