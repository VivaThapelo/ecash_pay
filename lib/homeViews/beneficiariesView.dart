import 'package:flutter/material.dart';

class BeneficiariesView extends StatefulWidget {
  final String currentUserId;

  BeneficiariesView({this.currentUserId});

  @override
  State createState() =>
      BeneficiariesViewState(currentUserId: this.currentUserId);
}

class BeneficiariesViewState extends State<BeneficiariesView> {
  final String currentUserId;

  BeneficiariesViewState({this.currentUserId});

  @override
  Widget build(BuildContext context) {
    return new ListView(
      children: <Widget>[
        AppBar(
          actions: <Widget>[
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, "/wallet");
              },
              icon: Icon(Icons.add_circle_outline),
              color: Colors.blueAccent,
            )
          ],
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text("Friends"),
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.blueAccent),
          textTheme: TextTheme(
              headline6: TextStyle(
                  color: Colors.blueAccent,
                  fontSize: 20,
                  fontWeight: FontWeight.bold)),
          elevation: 0,
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
