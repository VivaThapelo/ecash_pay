import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  @override
  SplashPageState createState() => SplashPageState();
}

class SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        minimum: EdgeInsets.all(16),
        child: ListView(
          children: <Widget>[
            Icon(
              Icons.attach_money,
              size: 48,
              color: Colors.brown,
            ),
            SizedBox(
              child: CircularProgressIndicator(),
              width: 200,
              height: 200,
            )
          ],
        ));
  }
}
