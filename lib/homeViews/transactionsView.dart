import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionsView extends StatefulWidget {
  final FirebaseUser currentUser;
  final PageController pageViewController;

  TransactionsView(
      {@required this.pageViewController, @required this.currentUser});

  @override
  State createState() => TransactionsViewState();
}

class TransactionsViewState extends State<TransactionsView> {
  FirebaseUser currentUser;
  PageController pageViewController;

  var timeFormat = new DateFormat("H:mm dd MMM yy");

  Widget _transactionsListItem(DocumentSnapshot transaction) {
    return new ListTile(
      leading: new CircleAvatar(
        backgroundImage: new AssetImage("assets/images/smartwatch.jpg"),
      ),
      title: new Text(
        transaction['txDestinationName'].toString(),
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
      subtitle: new Text(
        transaction['txType'].toString() +
            " - " +
            timeFormat.format(transaction['txDatetime'].toDate()),
        style: TextStyle(fontSize: 11),
      ),
      trailing: new Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new Text(
                transaction['txAmount'].toString().split(".")[0],
                style:
                    new TextStyle(fontWeight: FontWeight.bold, fontSize: 22.0),
              ),
              Text(
                ".",
                style: TextStyle(fontSize: 11),
              ),
              Text(
                transaction['txAmount'].toString().split(".")[1],
                style: TextStyle(fontSize: 13),
              ),
            ],
          ),
          new Text(
            transaction['txFee'].toString() + " fee",
            style: new TextStyle(color: Colors.red, fontSize: 10.0),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    pageViewController = widget.pageViewController;
    currentUser = widget.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back, color: Colors.brown),
          onPressed: () {
            setState(() {
              Navigator.pop(context);
            });
          },
        ),
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("Transactions"),
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
      body: new StreamBuilder(
        stream: Firestore.instance
            .collection('transactions')
            .orderBy('txDatetime', descending: false)
            .limit(15)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return const Text('Snapshot error!');
          if (!snapshot.hasData)
            return const Center(
              child: Text('Loading...'),
            );
          return ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index) {
                return _transactionsListItem(snapshot.data.documents[index]);
              });
        },
      ),
    );
  }
}
