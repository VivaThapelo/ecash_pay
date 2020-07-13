import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Tranxaction {
  Tranxaction(
      {@required this.txSourceID,
      @required this.txSourceName,
      @required this.txDestinationID,
      @required this.txDestinationName,
      @required this.txAmount,
      @required this.txFee,
      this.txLocation,
      @required this.txCurrency,
      @required this.txMethod,
      @required this.txType,
      @required this.txStatus,
      this.txDatetime});

  double txAmount;
  double txFee;
  String txCurrency;
  DateTime txDatetime;
  String txDestinationID;
  String txDestinationName;
  String txSourceID;
  String txSourceName;
  GeoPoint txLocation;
  String txMethod;
  String txStatus;
  String txType;

  makeTranxactions() async {
    Map<String, dynamic> transact = new Map<String, dynamic>();
    transact.addAll({
      "txAmount": this.txAmount,
      "txFee": this.txFee,
      "txCurrency": this.txCurrency,
      "txDatetime": this.txDatetime ?? DateTime.now(),
      "txDestinationID": this.txDestinationID,
      "txDestinationName": this.txDestinationName,
      "txSourceID": this.txSourceID,
      "txSourceName": this.txSourceName,
      "txLocation": this.txLocation ?? new GeoPoint(0.0, 0.0),
      "txMethod": this.txMethod ?? "Card",
      "txStatus": this.txStatus,
      "txType": this.txType
    });
    await Firestore.instance.collection('transactions').add(transact).then(
        (value) => (value) {
              return value;
            }, onError: (e) {
      return e.toString();
    });
  }
}
