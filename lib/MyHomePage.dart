import 'package:ecashpay/ProfilePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'homeViews/beneficiariesView.dart';
import 'homeViews/dashboardView.dart';
import 'homeViews/transactionsView.dart';
import 'homeViews/walletView.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title, @required this.currentUser})
      : super(key: key);
  final FirebaseUser currentUser;
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  FirebaseUser currentUser;
  int _viewIndex = 0; // this is the first view of the PageView
  PageController _pageViewController = new PageController(
      initialPage: 0, // this is the first view of the PageView
      viewportFraction: 1 // it should show a full page
      );

  // Allows the clicking of the 3rd BottomNavigationBarItem
  // The 3rd button is hidden under the FAB
  void bottomNavBarClick(int index) {
    setState(() {
      this._viewIndex = index;
      _pageViewController.jumpToPage(_viewIndex);
    });
  }

  @override
  void initState() {
    super.initState();
    currentUser = widget.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      backgroundColor: Colors.white,
      drawer: new Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              arrowColor: Colors.white,
              accountName: Text(currentUser.displayName ?? "No Name Yet"),
              accountEmail: Text(currentUser.phoneNumber ?? "No Number Yet"),
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(currentUser.photoUrl ??
                    "assets/images/camera_placeholder.png"),
              ),
              onDetailsPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ProfilePage(currentUser: currentUser)));
              },
            ),
            ListView(
              shrinkWrap: true,
              children: <Widget>[
                ListTile(
                  title: Text(
                    'Home',
                    style: TextStyle(color: Colors.brown),
                  ),
                  leading: Icon(
                    Icons.home,
                    color: Colors.brown,
                  ),
                ),
                ListTile(
                  onTap: () {},
                  title: Text(
                    'Update Card',
                    style: TextStyle(color: Colors.brown),
                  ),
                  leading: Icon(
                    Icons.credit_card,
                    color: Colors.brown,
                  ),
                ),
                ListTile(
                  title: Text(
                    'Create New Pin',
                    style: TextStyle(color: Colors.brown),
                  ),
                  leading: Icon(
                    Icons.security,
                    color: Colors.brown,
                  ),
                )
              ],
            ),
            AboutListTile(
              applicationName: "eCash Pay",
              applicationVersion: "0.1",
            )
          ],
        ),
      ),
      body: new PageView(
        scrollDirection: Axis.vertical,
        controller: _pageViewController,
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[
          DashboardView(
            pageViewController: _pageViewController,
            currentUser: currentUser,
          ),
          TransactionsView(
            pageViewController: _pageViewController,
            currentUser: currentUser,
          ),
          /* ScanView(
            pageViewController: _pageViewController,
            userAction: widget.,
          ), */
          BeneficiariesView(),
          WalletView()
        ],
      ),
      /*
      bottomNavigationBar: new Stack(
        overflow: Overflow.visible,
        children: <Widget>[
          new Positioned(
            child: new BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: _viewIndex,
              onTap: (int _index) {
                setState(() {
                  this._viewIndex = _index;
                  _pageViewController.jumpToPage(_index);
                });
              },
              items: <BottomNavigationBarItem>[
                new BottomNavigationBarItem(
                    icon: new Icon(Icons.home),
                    title: new Text(
                      "Home",
                      style: new TextStyle(fontSize: 12.0),
                    )),
                new BottomNavigationBarItem(
                    icon: new Icon(Icons.history),
                    title: new Text(
                      "Transactions",
                      style: new TextStyle(fontSize: 12.0),
                    )),
                new BottomNavigationBarItem(
                    icon: new Icon(Icons.center_focus_weak),
                    title: new Text("PAY")),
                new BottomNavigationBarItem(
                    icon: new Icon(Icons.people),
                    title: new Text(
                      "Friends",
                      style: new TextStyle(fontSize: 12.0),
                    )),
                new BottomNavigationBarItem(
                    icon: new Icon(Icons.account_balance_wallet),
                    title: new Text(
                      "Wallet",
                      style: new TextStyle(fontSize: 12.0),
                    )),
              ],
            ),
          ),
          new Positioned.directional(
            child: new FloatingActionButton(
              onPressed: () {
                bottomNavBarClick(2);
              },
              child: new Container(
                child: new Icon(
                  Icons.center_focus_weak,
                  size: 24.0,
                ),
                margin: const EdgeInsets.only(bottom: 10.0),
              ),
              mini: false,
              highlightElevation: 0.0,
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.only(
                      topRight: new Radius.circular(4.0),
                      topLeft: new Radius.circular(4.0))),
            ),
            textDirection: TextDirection.ltr,
            bottom: 0.0,
            width: 58.0,
            height: 58.0,
          ),
          new Positioned.directional(
            textDirection: TextDirection.ltr,
            child: new Text("PAY",
                style: new TextStyle(color: Colors.white, fontSize: 12.0)),
            bottom: 8.0,
          )
        ],
        alignment: Alignment.bottomCenter,
      ),
      */
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
