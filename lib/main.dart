import 'package:ecashpay/CreatePinPage.dart';
import 'package:ecashpay/LoginPage.dart';
import 'package:ecashpay/PinPage.dart';
import 'package:ecashpay/ProfilePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(new MaterialApp(
    title: 'PayPass',
    theme: ThemeData(
      primarySwatch: Colors.brown,
    ),
    home: await whereToGo(),
  ));
}

Future<Widget> whereToGo() async {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser currentUser;
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return StreamBuilder<FirebaseUser>(
      initialData: currentUser,
      stream: _auth.onAuthStateChanged,
      builder: (context, snapshot) {
        print("Auth: " + "Works well");
        // if we have an account i.e. a user
        if (snapshot.hasData) {
          currentUser = snapshot.data;
          print("Snapshot data: " + currentUser.uid);
          // if the profile is not filled up
          if (currentUser.photoUrl == null || currentUser.displayName == null) {
            print("GoToProfilePage: " + "Works well");
            return ProfilePage(currentUser: currentUser);
          }
          // if APP PIN is not set
          switch (prefs.getString('appPin') == null) {
            case true:
              print("GoToCreatePinPage: " + "Works well");
              return CreatePinPage(currentUser: currentUser);
              break;
            case false:
              print("GoToPinPage: " + "Works well");
              return PinPage(currentUser: currentUser);
              break;
          }
        } else if (snapshot.hasError && !snapshot.hasData) {
          print("GoToLogon: " + "Works well");
          return LoginPage(currentUser: null);
        }
        // Splashscreen
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "eCashPay",
                  style: TextStyle(fontSize: 36, color: Colors.brown),
                ),
                Divider(
                  height: 16,
                  color: Colors.white,
                ),
                CircularProgressIndicator()
              ],
            ),
          ),
        );
      });
}
