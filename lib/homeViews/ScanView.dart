import 'package:ai_barcode/ai_barcode.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_permission_validator/easy_permission_validator.dart';
import 'package:ecashpay/PayPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:floating_pullup_card/floating_pullup_card.dart';
import 'package:flutter/material.dart';

ScannerController _scannerController;
String _qrCodeOfInput = "0 0 0 - 0 0 0";
String _qrResult;
//final GlobalKey _popUpKey = new GlobalKey();
CreatorController _creatorController;

class ScanView extends StatefulWidget {
  final PageController pageViewController;
  final FirebaseUser currentUser; // this user is a PAYER
  // this user is a PAYEE - We get their details from the
  final scanResults;
  final String userAction;

  ScanView(
      {Key key,
      this.pageViewController,
      this.currentUser,
      this.scanResults,
      this.userAction})
      : super(key: key);

  @override
  State createState() => ScanViewState();
}

class ScanViewState extends State<ScanView> {
  PageController pageViewController;
  FirebaseUser currentUser; // this user is a PAYER
  // this user is a PAYEE - We get their details from the
  String scanResults;
  Widget _showLoadingChild = CircularProgressIndicator();
  String userAction;

  @override
  void dispose() {
    _scannerController.stopCameraPreview();
    _scannerController.stopCamera();
    super.dispose();
  }

  showLoading() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Verifying Account"),
            content: SizedBox(
              child: _showLoadingChild,
              width: 50,
            ),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    _scannerController.startCamera();
                    _scannerController.startCameraPreview();
                    Navigator.pop(context);
                  },
                  child: Text('Try Again'))
            ],
          );
        });
  }

  checkUserAccountExist(String uid) async {
    print("UID $uid");
    await Firestore.instance
        .collection("merchants")
        .document(uid.trim())
        .get()
        .then((doc) {
      if (doc.exists) {
        setState(() {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => new PayPage(
                        pageViewController: pageViewController,
                        scanResults: _qrResult,
                        currentUser: currentUser,
                        userAction: userAction,
                      )));
        });
      } else {
        setState(() {
          _showLoadingChild = Text('Unknown Account');
        });
      }
      //return exists;
    });
  }

  @override
  void initState() {
    super.initState();
    currentUser = widget.currentUser;
    scanResults = widget.scanResults;
    pageViewController = widget.pageViewController;
    userAction = widget.userAction;

    // Ask for camera permission
    _cameraPermissionRequest();

    _creatorController = new CreatorController(creatorViewCreated: () {});

    // Controller for the BarcodeAi
    _scannerController = new ScannerController(scannerResult: (result) {
      setState(() {
        _qrResult = result;
      });
      print("QR: " + _qrResult);
      showLoading();
      checkUserAccountExist(_qrResult).then((exist) {}).catchError((e) {});
    });
  }

  _cameraPermissionRequest() async {
    final permissionValidator = EasyPermissionValidator(
      context: context,
      appName: 'eCashPay',
    );
    var result = await permissionValidator.camera();
    if (result) {
      _scannerController.startCamera();
      _scannerController.startCameraPreview();
    }
  }

  @override
  Widget build(BuildContext context) {
    return new FloatingPullUpCardLayout(
      collpsedStateOffset: (x, y) {
        return y * .9999;
      },
      autoPadding: false,
      cardColor: Colors.brown,
      cardElevation: 0,
      child: ListView(
        children: <Widget>[
          AppBar(
            leading: new IconButton(
              icon: new Icon(Icons.arrow_back, color: Colors.brown),
              onPressed: () {
                setState(() {
                  Navigator.pop(context); // Jumping to the PayPage/Scan
                });
              },
            ),
            // Here we take the value from the MyHomePage object that was created by
            // the App.build method, and use it to set our appbar title.
            title: Text("Scan an ID"),
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: Colors.brown),
            textTheme: TextTheme(
                headline6: TextStyle(
                    color: Colors.brown,
                    fontSize: 20,
                    fontWeight: FontWeight.bold)),
            elevation: 0,
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    return null;
                  },
                  child: Text(
                    'Enter Manually',
                    style: TextStyle(color: Colors.brown),
                  ))
            ],
          ),
          Container(
            decoration: BoxDecoration(color: Colors.black),
            child: Container(
              color: Colors.black26,
              width: 400,
              height: 650,
              child: PlatformAiBarcodeScannerWidget(
                platformScannerController: _scannerController,
              ),
            ),
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Text(
            "PayID：$_qrCodeOfInput",
            style: TextStyle(color: Colors.white70),
          ),
          Container(
            width: 300,
            height: 300,
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: Colors.blue,
                  width: 8,
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(4),
                ),
              ),
            ),
            margin: EdgeInsets.all(8),
            child: PlatformAiBarcodeCreatorWidget(
              creatorController: _creatorController,
              initialValue: "$_qrCodeOfInput",
            ),
          ),
        ],
      ),
    );
  }
}
