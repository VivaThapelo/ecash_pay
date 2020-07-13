import 'package:flutter/material.dart';

class VerificationPage extends StatefulWidget {
  VerificationPage({Key key, this.verificationCode}) : super(key: key);
  final String verificationCode;

  VerificationPageState createState() => new VerificationPageState();
}

class VerificationPageState extends State<VerificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verify Number'),
      ),
      body: SafeArea(
        minimum: EdgeInsets.all(32),
        child: Column(
          children: <Widget>[
            Text(
              "Please confirm your country code and enter your phone number.",
              style: TextStyle(
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
            Divider(
              height: 32,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
