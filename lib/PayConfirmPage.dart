import 'package:ecashpay/MyHomePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PayConfirmPage extends StatefulWidget {
  final PageController pageViewController;
  final FirebaseUser currentUser;
  final String transStatus;

  PayConfirmPage(
      {Key key,
      @required this.pageViewController,
      @required this.currentUser,
      @required this.transStatus})
      : super(key: key);

  @override
  PayConfirmPageState createState() => new PayConfirmPageState();
}

class PayConfirmPageState extends State<PayConfirmPage> {
  FirebaseUser currentUser;
  PageController pageViewController;
  String _label;
  String _reason;
  IconData _icon;
  Color _color;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    String transStatus = widget.transStatus;
    currentUser = widget.currentUser;
    pageViewController = widget.pageViewController;

    switch (transStatus) {
      case "Approved":
        setState(() {
          _label = "Success";
          _reason = "Transaction Approved";
          _icon = Icons.done;
          _color = Colors.green;
        });
        break;
      case "Insufficient":
        setState(() {
          _label = "Failed";
          _reason = "Insufficient Funds";
          _icon = Icons.money_off;
          _color = Colors.red;
        });
        break;
      case "Declined":
        setState(() {
          _label = "Failed";
          _reason = "Transaction Declined";
          _icon = Icons.clear;
          _color = Colors.red;
        });
        break;
      case "Unprocessed":
        setState(() {
          _label = "Incomplete";
          _reason = "Unprocessed Transactions";
          _icon = Icons.visibility_off;
          _color = Colors.blueGrey;
        });
        break;
      case "Invalid":
        setState(() {
          _label = "Failed";
          _reason = "Invalid Card Number";
          _icon = Icons.credit_card;
          _color = Colors.red;
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Confirmation"),
        //centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.brown),
        textTheme: TextTheme(
            headline6: TextStyle(
                color: Colors.brown,
                fontSize: 20,
                fontWeight: FontWeight.bold)),
        elevation: 0,
      ),
      body: SafeArea(
        minimum: EdgeInsets.all(16.0),
        child: Container(
          padding: EdgeInsets.all(0),
          margin: EdgeInsets.all(0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(
                  _icon,
                  size: 148,
                  color: _color,
                ),
                Text(
                  _label,
                  style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                ),
                Text(
                  _reason,
                  style: TextStyle(fontSize: 18),
                ),
                Divider(
                  height: 48,
                  color: Colors.white,
                ),
                SizedBox(
                  width: double.infinity,
                  child: FlatButton(
                      padding: EdgeInsets.symmetric(vertical: 4.0),
                      color: Colors.brown,
                      child: Text(
                        "GO BACK",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MyHomePage(
                                      currentUser: currentUser,
                                    )));
                      }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
