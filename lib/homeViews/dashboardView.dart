import 'package:ai_barcode/ai_barcode.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecashpay/homeViews/ScanView.dart';
import 'package:ecashpay/homeViews/transactionsView.dart';
import 'package:ecashpay/objects/BankCard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

enum userActions { Payment, Withdrawal, Send, Scan }

class DashboardView extends StatefulWidget {
  final FirebaseUser currentUser;
  final PageController pageViewController;

  DashboardView(
      {Key key, @required this.pageViewController, @required this.currentUser})
      : super(key: key);

  @override
  State createState() => DashboardViewState();
}

class DashboardViewState extends State<DashboardView> {
  FirebaseUser currentUser;
  PageController pageViewController;
  final GlobalKey<AnimatedListState> _animListKey =
      new GlobalKey<AnimatedListState>();

  //final GlobalKey _popUpKey = new GlobalKey(); // this is a global key for popup
  var timeFormat = new DateFormat("H:mm dd MMM yy");
  bool _cardLoad = false;
  CreatorController _creatorController;
  String userAction;
  double cardWidth = 30.0;
  double cardHeight = 30.0;
  MainAxisSize _mainAxisSize = MainAxisSize.min;

  TextEditingController _cardNumberController,
      _cardHolderController,
      _expiresController,
      _cvvController;

  BankCard bankCard; //initiator

  @override
  initState() {
    super.initState();
    currentUser = widget.currentUser;
    bankCard = new BankCard();
    pageViewController = widget.pageViewController;
    _cardHolderController = new TextEditingController();
    _cardNumberController = new TextEditingController();
    _expiresController = new TextEditingController();
    _cvvController = new TextEditingController();
    _creatorController = new CreatorController(creatorViewCreated: () {});
    setState(() {
      getCardDetails();
    });
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        cardHeight = 210.0;
        cardWidth = double.maxFinite;
        _mainAxisSize = MainAxisSize.max;
      });
    });
    Future.delayed(Duration(milliseconds: 1000), () {
      setState(() {
        _animListKey.currentState.insertItem(0);
      });
    });
  }

  Widget _transactionsListItem(DocumentSnapshot transaction) {
    return new ListTile(
      leading: new CircleAvatar(
        backgroundImage: NetworkImage(transaction['txDestinationPhoto']),
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
  Widget build(BuildContext context) {
    return new ListView(
      children: <Widget>[
        AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text("eCash Pay"),
          titleSpacing: 0.0,
          //centerTitle: true,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.brown),
          textTheme: TextTheme(
              headline6: TextStyle(
                  color: Colors.brown,
                  fontSize: 20,
                  fontWeight: FontWeight.bold)),
          elevation: 0,
          /* actions: <Widget>[
            FlatButton(
              padding: EdgeInsets.symmetric(horizontal: 0.0),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => WalletView(
                              pageViewController: pageViewController,
                              currentUser: currentUser,
                            )));
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(
                    'R00.',
                    style: TextStyle(
                        color: Colors.brown, fontSize: 20, letterSpacing: 1.1),
                  ),
                  Text(
                    '00',
                    style: TextStyle(
                        color: Colors.brown, fontSize: 15, letterSpacing: 1.1),
                  ),
                ],
              ),
            ),
            new IconButton(
              padding: EdgeInsets.only(left: 0.0),
              icon: Icon(
                FontAwesomeIcons.qrcode,
                color: Colors.brown,
                size: 20,
              ),
              onPressed: () {
                setState(() {
                  showDialog(
                    context: context,
                    child: AlertDialog(
                      title: Text("PayID"),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          SizedBox(
                            height: 250,
                            width: 250,
                            child: PlatformAiBarcodeCreatorWidget(
                              creatorController: _creatorController,
                              initialValue: currentUser.uid,
                            ),
                          ),
                          Text(
                            currentUser.uid,
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                      actions: <Widget>[
                        FlatButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              'Dismiss',
                              style: TextStyle(
                                  color: Colors.brown,
                                  fontWeight: FontWeight.bold),
                            ))
                      ],
                    ),
                  );
                });
              },
            ),
          ],*/
        ),
        //BAnk Card Section
        AnimatedContainer(
          // height: cardHeight,
          // width: cardWidth,
          duration: Duration(milliseconds: 500),
          //curve: Curves.fastOutSlowIn,
          child: GestureDetector(
            child: new Container(
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                    gradient: SweepGradient(colors: [
                      Colors.purple,
                      Colors.teal,
                      Colors.yellow,
                      Colors.lightBlue,
                      Colors.teal,
                      Colors.yellow,
                      Colors.purple,
                    ]),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                margin: EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 8),
                child: Padding(
                  padding:
                  EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 10),
                  child: new Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text("BankCard",
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                              /*  Text(
                              "162****151",
                              style: TextStyle(
                                  color: Colors.white, letterSpacing: 2),
                            )*/
                            ],
                          ),
                          Image.asset(
                            "assets/images/card/master.png",
                            width: 70,
                            height: 50,
                          ),
                        ],
                      ),
                      Divider(
                        height: 24,
                        color: Colors.transparent,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            "Card Number",
                            style: TextStyle(
                                fontSize: 9,
                                color: Colors.white,
                                letterSpacing: 2),
                          ),
                          Text(
                            bankCard.getCardNumber(true) ??
                                "**** **** **** ****", // cardNumber
                            style: TextStyle(
                                fontSize: 24,
                                letterSpacing: 4,
                                color: Colors.white),
                          ),
                        ],
                      ),
                      Divider(
                        height: 24,
                        color: Colors.transparent,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          new Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Card Holder",
                                style: TextStyle(
                                    fontSize: 9,
                                    color: Colors.white,
                                    letterSpacing: 2),
                              ),
                              Text(bankCard.getCardHolder() ?? "**** *******",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      letterSpacing: 1))
                            ],
                          ),
                          new Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Expires",
                                style: TextStyle(
                                    fontSize: 9,
                                    color: Colors.white,
                                    letterSpacing: 2),
                              ),
                              Text(bankCard.getCardExpires() ?? "**/**",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      letterSpacing: 2))
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                )),
            onTap: () {
              setState(() {
                cardUpdateDialog();
              });
            },
          ),
        ),
        new Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Flexible(
              child: Container(
                width: 900,
                margin: EdgeInsets.only(left: 16, right: 4, top: 8, bottom: 0),
                child: OutlineButton(
                  onPressed: () {
                    setState(() {
                      userAction = userActions.Payment.toString();
                      // Jumping to the PayPage/Scan
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return ScanView(
                          currentUser: currentUser,
                          userAction: userAction,
                        );
                      }));
                    });
                  },
                  child: Text(
                    "Pay a Merchant",
                    style: TextStyle(color: Colors.brown),
                  ),
                  color: Colors.brown,
                  disabledTextColor: Colors.brown,
                  splashColor: Colors.brown,
                  borderSide: BorderSide(
                      color: Colors.brown, style: BorderStyle.solid, width: 1),
                  shape: StadiumBorder(),
                  highlightedBorderColor: Colors.blue,
                  disabledBorderColor: Colors.blue,
                ),
              ),
              flex: 4,
            ),
            Flexible(
              child: Container(
                width: 900,
                margin: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 0),
                child: OutlineButton(
                  onPressed: () {
                    setState(() {
                      userAction = userActions.Withdrawal.toString();
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return ScanView(
                          currentUser: currentUser,
                          userAction: userAction,
                        );
                      })); // Jumping to the PayPage/Scan
                    });
                  },
                  child: Text(
                    "Withdraw Money",
                    style: TextStyle(color: Colors.brown),
                  ),
                  color: Colors.brown,
                  disabledTextColor: Colors.brown,
                  splashColor: Colors.brown,
                  borderSide: BorderSide(
                      color: Colors.brown, style: BorderStyle.solid, width: 1),
                  shape: StadiumBorder(),
                  highlightedBorderColor: Colors.blue,
                  disabledBorderColor: Colors.blue,
                ),
              ),
              flex: 4,
            ),
          ],
        ),
        Container(
          margin: EdgeInsets.only(left: 16, right: 0, top: 8, bottom: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Text(
                "Recent Transactions",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.brown),
              ),
              IconButton(
                  padding: EdgeInsets.only(right: 0),
                  icon: Icon(
                    Icons.arrow_forward,
                    size: 20,
                    color: Colors.brown,
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                TransactionsView(
                                    pageViewController: pageViewController,
                                    currentUser: currentUser)));
                    /* pageViewController.animateToPage(1,
                        duration: Duration(milliseconds: 30),
                        curve: Curves.easeOutCubic);*/
                  })
            ],
          ),
        ),
        new StreamBuilder(
          stream: Firestore.instance
              .collection('transactions')
              .orderBy('txDatetime', descending: false)
              .limit(5)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) return const Text('Snapshot error!');
            if (!snapshot.hasData) return const Text('Loading...');
            return AnimatedList(
                key: _animListKey,
                shrinkWrap: true,
                initialItemCount: 0,
                itemBuilder: (context, index, animation) {
                  return _transactionsListItem(snapshot.data.documents[index]);
                });
          },
        )
      ],
    );
  }

  cardUpdateDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, StateSetter dialogState) {
            return AlertDialog(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Card Details'),
                  Visibility(
                    child: CircularProgressIndicator(),
                    visible: _cardLoad,
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Form(
                      child: ListView(
                        shrinkWrap: true,
                        children: <Widget>[
                          TextFormField(
                            maxLengthEnforced: true,
                            maxLength: 19,
                            keyboardType: TextInputType.number,
                            controller: _cardNumberController,
                            onChanged: (value) {
                              switch (value.length) {
                                case 4:
                                  {
                                    _cardNumberController.text += " ";
                                    _cardNumberController.selection =
                                        TextSelection.collapsed(offset: 5);
                                    break;
                                  }
                                case 9:
                                  {
                                    _cardNumberController.text += " ";
                                    _cardNumberController.selection =
                                        TextSelection.collapsed(offset: 10);
                                    break;
                                  }
                                case 14:
                                  {
                                    _cardNumberController.text += " ";
                                    _cardNumberController.selection =
                                        TextSelection.collapsed(offset: 15);
                                    break;
                                  }
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                hintText: '5324 9087 5432 1234',
                                labelText: 'Card Number'),
                          ),
                          TextFormField(
                            textCapitalization: TextCapitalization.words,
                            keyboardType: TextInputType.text,
                            controller: _cardHolderController,
                            decoration: InputDecoration(
                                hintText: 'John Doe', labelText: 'Card holder'),
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: TextFormField(
                                  autovalidate: true,
                                  validator: (value) {
                                    if (value.length >= 3 &&
                                        int.parse(value.split("/")[0]) > 12) {
                                      // months over 12
                                      return "Month greater than 12";
                                    } else if (value.length == 5 &&
                                        int.parse(value.split("/")[1]) <= 20) {
                                      // card expired
                                      return "Year less than 20";
                                    }
                                    return null;
                                  },
                                  onChanged: (value) {
                                    if (value.length == 2) {
                                      _expiresController.text = value + "/";
                                      _expiresController.selection =
                                          TextSelection.collapsed(offset: 3);
                                    }
                                    return null;
                                  },
                                  keyboardType: TextInputType.number,
                                  controller: _expiresController,
                                  decoration: InputDecoration(
                                      hintText: '12/20', labelText: 'Expires'),
                                  maxLength: 5,
                                  maxLengthEnforced: true,
                                ),
                              ),
                              Divider(
                                indent: 16,
                              ),
                              Expanded(
                                  child: TextFormField(
                                    maxLengthEnforced: true,
                                    maxLength: 3,
                                    keyboardType: TextInputType.number,
                                    controller: _cvvController,
                                    decoration: InputDecoration(
                                        hintText: '123', labelText: 'CVV'),
                                  )),
                            ],
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          )
                        ],
                      ))
                ],
              ),
              actions: <Widget>[
                FlatButton(
                    onPressed: () {
                      _cvvController.clear();
                      _expiresController.clear();
                      _cardHolderController.clear();
                      _cardNumberController.clear();
                      Navigator.pop(context);
                    },
                    child: Text('Cancel')),
                FlatButton(
                    onPressed: () {
                      dialogState(() {
                        _cardLoad = true;
                      });
                      bankCard = new BankCard(
                          cardNumber: _cardNumberController.text,
                          cardHolder: _cardHolderController.text,
                          cardExpires: _expiresController.text,
                          cardCVV: _cvvController.text);
                      bankCard.setBankCard();
                      setState(() {
                        //TODO: Logic for update card on Dashboard
                        getCardDetails();
                        Future.delayed(const Duration(seconds: 3), () {
                          Navigator.pop(context);
                        });
                      });
                      //
                      //Navigator.pop(context);
                    },
                    child: Text(
                      'Update',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ))
              ],
            );
          });
        });
  }

  getCardDetails() async {
    setState(() {
      bankCard.getBankCard();
    });
  }
}
