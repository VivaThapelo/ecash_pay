import 'package:flutter/material.dart';

class FeesLimits extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScrollController listScrollController = new ScrollController();
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Fees and Limits'),
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
          child: ListView(
            controller: listScrollController,
            children: [
              Text(
                'Fees',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
              Divider(
                height: 8,
                color: Colors.white,
              ),
              new ListTile(
                contentPadding: EdgeInsets.all(0),
                title: Text(
                  'Merchant Payment',
                  style: TextStyle(fontSize: 18),
                ),
                trailing: Text(
                  'R2',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
              new ListTile(
                contentPadding: EdgeInsets.all(0),
                title: Text(
                  'Withdraw Cash',
                  style: TextStyle(fontSize: 18),
                ),
                trailing: Text(
                  'R5',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
              // Limits here
              Divider(
                height: 8,
                color: Colors.white,
              ),
              Text(
                'Limits',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
              Divider(
                height: 8,
                color: Colors.white,
              ),
              new ListTile(
                contentPadding: EdgeInsets.all(0),
                title: Text(
                  'Merchant Payment',
                  style: TextStyle(fontSize: 18),
                ),
                trailing: Text(
                  'R50',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
              new ListTile(
                contentPadding: EdgeInsets.all(0),
                title: Text(
                  'Withdraw Cash',
                  style: TextStyle(fontSize: 18),
                ),
                trailing: Text(
                  'R200',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              )
            ],
          )),
    );
  }
}
