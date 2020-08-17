import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class WalletView extends StatefulWidget {
  WalletView({@required this.currentUser, @required this.pageViewController});

  final FirebaseUser currentUser;
  final PageController pageViewController;

  State createState() => WalletViewState();
}

class WalletViewState extends State<WalletView> {
  FirebaseUser currentUser;
  PageController pageViewController;

  @override
  void initState() {
    super.initState();
    currentUser = widget.currentUser;
    pageViewController = widget.pageViewController;
  }

  @override
  Widget build(BuildContext context) {
    return new ListView(
      children: <Widget>[
        AppBar(
          actions: <Widget>[
            OutlineButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, "/wallet");
              },
              icon: Icon(
                Icons.add,
                color: Colors.brown,
              ),
              label: Text(
                'TOP UP',
                style: TextStyle(
                  color: Colors.brown,
                ),
              ),
            )
          ],
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text("Wallet"),
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.brown),
          textTheme: TextTheme(
              headline6: TextStyle(
                  color: Colors.brown,
                  fontSize: 20,
                  fontWeight: FontWeight.bold)),
          elevation: 0,
          automaticallyImplyLeading: false,
        ),
        new Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(0))),
            elevation: 1,
            margin: EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 8),
            color: Colors.white,
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
                        fontSize: 48, letterSpacing: 4, color: Colors.brown),
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
                                color: Colors.brown,
                                letterSpacing: 2),
                          ),
                          Text(currentUser.displayName ?? "No Name",
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.brown,
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
                                color: Colors.brown,
                                letterSpacing: 2),
                          ),
                          Text(currentUser.phoneNumber ?? "No number",
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.brown,
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
