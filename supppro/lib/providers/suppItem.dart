import 'package:flutter/material.dart';

class SuppItem extends ChangeNotifier {
  String barCode;
  String brandName;
  String dSLDId;
  String dateEnteredIntoDSLD;
  String marketStatus;
  String netContents;
  String productName;
  String productType;
  String servingSize;
  String suggestedUse;
  String supplementForm;
  String url;

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

  @override
  Map<String, dynamic> toMap() {
    return {
      'barCode': barCode,
      'brandName': brandName,
      'dSLDId': dSLDId,
      'dateEnteredIntoDSLD': dateEnteredIntoDSLD,
      'marketStatus': marketStatus,
      'netContents': netContents,
      'productName': productName,
      'productType': productType,
      'servingSize': servingSize,
      'suggestedUse': suggestedUse,
      'supplementForm': supplementForm,
      'url': url,
    };
  }

  @override
  void fromMap(Map<String, dynamic> map) {
    barCode = map['barCode'];
    brandName = map['brandName'];
    dSLDId = map['dSLDId'];
    dateEnteredIntoDSLD = map['dateEnteredIntoDSLD'];
    marketStatus = map['marketStatus'];
    netContents = map['netContents'];
    productName = map['productName'];
    productType = map['productType'];
    servingSize = map['servingSize'];
    suggestedUse = map['suggestedUse'];
    supplementForm = map['supplementForm'];
    url = map['url'];
  }
}

class SuppItems extends ChangeNotifier {
  List<SuppItem> _suppItems = [];
  List<SuppItem> get suppItems {
    return [..._suppItems];
  }

  late SuppItem _currentSuppItem;
  SuppItem get currentSuppItem {
    return _currentSuppItem;
  }

  void addItem(SuppItem suppitem) {
    _suppItems.add(suppitem);
    // print(_suppItems.length);
  }

  void setCurrentItem(SuppItem si) {
    _currentSuppItem = si;
  }
}
