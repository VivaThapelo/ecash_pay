import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BeneficiariesView extends StatefulWidget {
  final FirebaseUser currentUser;
  final PageController pageViewController;

  BeneficiariesView(
      {Key key, @required this.currentUser, @required this.pageViewController})
      : super(key: key);

  @override
  State createState() => BeneficiariesViewState();
}

class BeneficiariesViewState extends State<BeneficiariesView> {
  FirebaseUser currentUser;
  PageController pageViewController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentUser = widget.currentUser;
    pageViewController = widget.pageViewController;
  }

  @override
  Widget build(BuildContext context) {
    return new ListView(
      children: <Widget>[
        AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text("Friends"),
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
        new ListTile(
          onTap: () {
            showDialog(
                context: context,
                builder: (context) {
                  return SimpleDialog(
                    children: <Widget>[
                      new SimpleDialogOption(
                        child: new Text('Send Cash'),
                        onPressed: () {},
                      ),
                      new SimpleDialogOption(
                        child: new Text('Request Cash'),
                        onPressed: () {},
                      ),
                    ],
                  );
                });
          },
          leading: new CircleAvatar(
            backgroundImage: new AssetImage("assets/images/adduser.png"),
          ),
          title: new Text(
            "New Contact",
            style:
                new TextStyle(fontWeight: FontWeight.bold, color: Colors.brown),
          ),
          trailing: FaIcon(
            FontAwesomeIcons.qrcode,
            color: Colors.brown,
          ),
        ),
        new ListTile(
          leading: new CircleAvatar(
            backgroundImage: new AssetImage("assets/images/smartwatch.jpg"),
          ),
          title: new Text(
            "Thapelo Radebe",
            style: new TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: new Text(
            "0725460987",
          ),
        ),
      ],
    );
  }
}
