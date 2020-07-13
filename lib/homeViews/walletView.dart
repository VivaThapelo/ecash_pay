import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class WalletView extends StatefulWidget {
  final FirebaseUser currentUser;

  WalletView({this.currentUser});

  State createState() => WalletViewState();
}

class WalletViewState extends State<WalletView> {
  FirebaseUser currentUser;

  @override
  void initState() {
    super.initState();
    currentUser = widget.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return new ListView(
      children: <Widget>[
        AppBar(
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.pushNamed(context, "/wallet");
              },
              child: Text(
                'C0:00',
                style: TextStyle(color: Colors.blueAccent, fontSize: 20.0),
              ),
            )
          ],
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text("Wallet"),
          backgroundColor: Colors.blueAccent,
          iconTheme: IconThemeData(color: Colors.white),
          textTheme: TextTheme(
              headline6: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold)),
          elevation: 0,
        ),
        new Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(0))),
            elevation: 0,
            margin: EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 8),
            color: Colors.blueAccent,
            child: Padding(
              padding: EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 0),
              child: new Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Divider(
                    height: 24,
                    color: Colors.transparent,
                  ),
                  Text(
                    "R0.00",
                    style: TextStyle(
                        fontSize: 28, letterSpacing: 4, color: Colors.white),
                  ),
                  Divider(
                    height: 24,
                    color: Colors.transparent,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Account Holder",
                            style: TextStyle(
                                fontSize: 9,
                                color: Colors.white,
                                letterSpacing: 2),
                          ),
                          Text("TP Radebe",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  letterSpacing: 2))
                        ],
                      ),
                      new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Connected Number",
                            style: TextStyle(
                                fontSize: 9,
                                color: Colors.white,
                                letterSpacing: 2),
                          ),
                          Text("064****324",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  letterSpacing: 2))
                        ],
                      )
                    ],
                  )
                ],
              ),
            )),
      ],
    );
  }
}
