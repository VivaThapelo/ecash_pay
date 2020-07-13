import 'dart:convert';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:ecashpay/MyHomePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SecureView extends StatefulWidget {
  SecureView(
      {Key key,
      @required this.currentUser,
      @required this.pageViewController,
      @required this.RedirectUrl,
      @required this.PAY_REQUEST_ID,
      @required this.PAYGATE_ID,
      @required this.CHECKSUM})
      : super(key: key);
  String transRef;
  FirebaseUser currentUser;
  PageController pageViewController;
  final String RedirectUrl, PAY_REQUEST_ID, PAYGATE_ID, CHECKSUM;

  @override
  State<StatefulWidget> createState() => new SecureViewState();
}

class SecureViewState extends State<SecureView> {
  String RedirectUrl, PAY_REQUEST_ID, PAYGATE_ID, CHECKSUM;
  HttpsCallableResult callableResult;
  FirebaseUser currentUser;
  PageController pageViewController;
  WebViewController webViewController;
  String transRef;

  @override
  void initState() {
    super.initState();
    RedirectUrl = widget.RedirectUrl;
    PAY_REQUEST_ID = widget.PAY_REQUEST_ID;
    PAYGATE_ID = widget.PAYGATE_ID;
    CHECKSUM = widget.CHECKSUM;
    currentUser = widget.currentUser;
    pageViewController = widget.pageViewController;
    transRef = widget.transRef;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.brown),
        textTheme: TextTheme(
            headline6: TextStyle(
                color: Colors.brown,
                fontSize: 20,
                fontWeight: FontWeight.bold)),
        elevation: 0,
        title: Text('3D Secure'),
        actions: <Widget>[
          FlatButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MyHomePage(
                              currentUser: currentUser,
                            )));
              },
              child: Text(
                'Done',
                style:
                    TextStyle(color: Colors.brown, fontWeight: FontWeight.bold),
              ))
        ],
      ),
      body: Container(
        child: WebView(
          onWebViewCreated: (WebViewController c) {
            webViewController = c;
          },
          javascriptMode: JavascriptMode.unrestricted,
          initialUrl: new Uri.dataFromString(_loadHTML(),
                  mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
              .toString(),
        ),
        color: Colors.orange,
      ),
    );
  }

  String _loadHTML() {
    return r'''
    <html>
    <body onload="document.frmSubmit.submit();">
    <form action="''' +
        RedirectUrl +
        '''" name="frmSubmit" id="frmSubmit" method="post" >
    <input type="hidden" name="PAYGATE_ID" value="''' +
        PAYGATE_ID +
        '''" />
    <input type="hidden" name="PAY_REQUEST_ID" value="''' +
        PAY_REQUEST_ID +
        '''" />
    <input type="hidden" name="CHECKSUM" value="''' +
        CHECKSUM +
        '''" />
    </form>
</body>
</html>
    ''';
  }
}
