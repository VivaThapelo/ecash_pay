import 'package:ecashpay/CreatePinPage.dart';
import 'package:ecashpay/FeesLimits.dart';
import 'package:ecashpay/ProfilePage.dart';
import 'package:ecashpay/homeViews/ScanView.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'homeViews/beneficiariesView.dart';
import 'homeViews/dashboardView.dart';
import 'homeViews/transactionsView.dart';
import 'homeViews/walletView.dart';

enum userActions { Payment, Withdrawal, Send, Scan }

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
  StorageReference storageReference;
  String proPic = "https://imgur.com/gallery/znlz0.jpg";
  String placeholderURL = "https://imgur.com/gallery/znlz0.jpg";
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

  showResetPop() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Reset Pin'),
              content:
                  Text("Are you sure? \n\n This action can't be reversed."),
              actions: [
                FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('No, Cancel')),
                FlatButton(
                    onPressed: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.setString('appPin', ''); // emptied out the APP pin
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  CreatePinPage(currentUser: currentUser)));
                    },
                    child: Text(
                      'Yes, Reset',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
              ],
            ));
  }

  _launchURL() async {
    const url = 'https://flutter.dev';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  void initState() {
    super.initState();
    print("MyHomePage: " + "Works well");
    currentUser = widget.currentUser;
    storageReference = FirebaseStorage.instance.ref();
    getPlaceholder();
    getProPic();
  }

  getPlaceholder() async {
    print("getPlaceHolder:" + "runs");
    String response = await storageReference
        .child('profileImages')
        .child('thumb')
        .child('profile-placeholder_200x200.png')
        .getDownloadURL();
    setState(() {
      placeholderURL = response;
    });
  }

  getProPic() async {
    print("getProPic:" + "runs");
    String response = await storageReference
        .child('profileImages')
        .child('thumb')
        .child('${currentUser.uid}_200x200.png')
        .getDownloadURL();
    setState(() {
      proPic = response;
    });
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
                backgroundImage: NetworkImage(proPic ?? placeholderURL),
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
                  onTap: () {
                    _pageViewController.animateToPage(0,
                        duration: Duration(milliseconds: 500),
                        curve: Curves.easeInCubic);
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Text(
                    'Fees & Limits',
                    style: TextStyle(color: Colors.brown),
                  ),
                  leading: Icon(
                    Icons.attach_money,
                    color: Colors.brown,
                  ),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => FeesLimits()));
                  },
                ),
                ListTile(
                  title: Text(
                    'Reset Pin',
                    style: TextStyle(color: Colors.brown),
                  ),
                  leading: Icon(
                    Icons.security,
                    color: Colors.brown,
                  ),
                  onTap: () => showResetPop(),
                )
              ],
            ),
            AboutListTile(
              applicationName: "eCash Pay",
              applicationVersion: "0.1",
            ),
            ListTile(
              title: Text(
                'Own a Shop?',
                style: TextStyle(color: Colors.brown),
              ),
              subtitle: Text(
                "Download the Merchant App",
                style: TextStyle(fontSize: 13),
              ),
              leading: Icon(
                Icons.store,
                size: 42,
                color: Colors.brown,
              ),
              onTap: () => _launchURL(),
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
          ScanView(
            pageViewController: _pageViewController,
            userAction: userActions.Scan.toString(),
            currentUser: currentUser,
          ),
          BeneficiariesView(
            currentUser: currentUser,
            pageViewController: _pageViewController,
          ),
          WalletView(
            currentUser: currentUser,
            pageViewController: _pageViewController,
          )
        ],
      ),

      /*  bottomNavigationBar: new Stack(
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
                    title: new Text("scan")),
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
            child: new Text("scan",
                style: new TextStyle(color: Colors.white, fontSize: 12.0)),
            bottom: 8.0,
          )
        ],
        alignment: Alignment.bottomCenter,
      ), */
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
