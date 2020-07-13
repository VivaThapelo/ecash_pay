import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecashpay/PayConfirmPage.dart';
import 'package:ecashpay/SecureView.dart';
import 'package:ecashpay/objects/BankCard.dart';
import 'package:ecashpay/objects/Transaction.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:xml2json/xml2json.dart';

class PayPage extends StatefulWidget {
  final FirebaseUser currentUser;
  final String userAction;
  final String scanResults;
  final PageController pageViewController;

  PayPage(
      {Key key,
      @required this.pageViewController,
      @required this.currentUser,
      @required this.scanResults,
      @required this.userAction})
      : super(key: key);

  @override
  PayPageState createState() => new PayPageState();
}

class PayPageState extends State<PayPage> {
  String shopID;
  FirebaseUser currentUser;
  String userAction;
  String merchantId;
  String merchantName;
  String merchantType;
  String merchantLogoURL;
  String amount;
  final String currency = "R";
  BankCard bankCard;
  TextEditingController _textEditingController;
  Tranxaction tranxaction;
  String transStatus = "Started";
  PageController pageViewController;

  @override
  void initState() {
    super.initState();
    bankCard = new BankCard();
    userAction = widget.userAction;
    currentUser = widget.currentUser;
    merchantId = widget.scanResults;
    _textEditingController = new TextEditingController();
    getMerchant().whenComplete(() => (Map<String, dynamic> snapshot) {
          if (snapshot.isNotEmpty) {
            print(snapshot['MerchantName']);
          }
        });

    setState(() {
      getCardDetails();
    });
  }

  doTransaction() {
    tranxaction = new Tranxaction(
        txSourceID: currentUser.uid,
        txSourceName: currentUser.displayName,
        txDestinationID: merchantId,
        txDestinationName: merchantName,
        txAmount: double.parse(amount),
        txFee: (userAction.split(".")[1] == "Payment") ? 1.0 : 5.0,
        // PAY fee is R1, WITHDRAW fee is R5
        txLocation: null,
        txCurrency: currency,
        txMethod: null,
        txType: userAction.split(".")[1],
        txStatus: transStatus,
        txDatetime: null);
    // Do main PayGate transaction
    doPayGatePayment();
    //on Confirmation, Store data and redirect to PayConfirmPage
  }

  doPayGatePayment() async {
    //TODO: Add this to Card Section of XML ${bankCard.getCardNumber(false).toString().splitMapJoin(" ") ?? 4000000000000002}
    try {
      await getCardDetails();
      print(bankCard.getCardExpires());

      String request = "https://secure.paygate.co.za/payhost/process.trans";

      String requestBody = '''
<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns1="http://www.paygate.co.za/PayHOST">
<SOAP-ENV:Body>
      <ns1:SinglePaymentRequest>
    <ns1:CardPaymentRequest>
        <ns1:Account>
            <ns1:PayGateId>10011072130</ns1:PayGateId>
            <ns1:Password>test</ns1:Password>
        </ns1:Account>
        <ns1:Customer>
            <ns1:Title>Mr</ns1:Title>
            <ns1:FirstName>${bankCard.getCardHolder().toString().split(" ")[0]}</ns1:FirstName>
            <ns1:LastName>${bankCard.getCardHolder().toString().split(" ")[1]}</ns1:LastName>
            <ns1:Telephone>0861234567</ns1:Telephone>
            <ns1:Mobile>0735552233</ns1:Mobile>
            <ns1:Email>joe@soap.com</ns1:Email>
        </ns1:Customer>
        <ns1:CardNumber>378282246310005</ns1:CardNumber> 
        <ns1:CardExpiryDate>${bankCard.getCardExpires().toString().split("/")[0] + "20" + bankCard.getCardExpires().toString().split("/")[1]}</ns1:CardExpiryDate>
        <ns1:CVV>${bankCard.getCardCvv()}</ns1:CVV>
        <ns1:BudgetPeriod>0</ns1:BudgetPeriod>
        <!-- 3D secure redirect object -->
        <ns1:Redirect>
            <ns1:NotifyUrl>https://ecashpay.web.app/notify.html</ns1:NotifyUrl>
            <ns1:ReturnUrl>https://us-central1-ecashpay.cloudfunctions.net/PayGateResponse?docref=MhT33DJkLPlPzeCqKHoP</ns1:ReturnUrl>
        </ns1:Redirect>
        <ns1:Order>
            <ns1:MerchantOrderId>$merchantId</ns1:MerchantOrderId>
            <ns1:Currency>ZAR</ns1:Currency>
            <ns1:Amount>$amount</ns1:Amount>
        </ns1:Order>
    </ns1:CardPaymentRequest>
</ns1:SinglePaymentRequest>
        </SOAP-ENV:Body>
</SOAP-ENV:Envelope>''';

      http.Response response = await http
          .post(request,
              headers: {
                "Content-Type": "application/xml",
                "cache-control": "no-cache"
              },
              body: utf8.encode(requestBody),
              encoding: Encoding.getByName("UTF-8"))
          // TODO: fix this
          // ignore: missing_return
          .then((onValue) {
        print("Response status: ${onValue.statusCode}");
        //print("Response body: ${onValue.body}");
        var XMLstring = onValue.body;
        Xml2Json xml2json = Xml2Json();
        xml2json.parse(XMLstring);
        var jsonS = xml2json.toBadgerfish();
        var js = json.decode(jsonS);
        var resp = js['SOAP-ENV:Envelope']['SOAP-ENV:Body']
            ['ns2:SinglePaymentResponse']['ns2:CardPaymentResponse'];
        print(resp);
        var StatusName = resp['ns2:Status']['ns2:StatusName']['\$'];
        // Checking if it requires a 3D Secure redirect
        switch (StatusName) {
          case "ThreeDSecureRedirectRequired":
            var UrlParams = resp['ns2:Redirect']['ns2:UrlParams'];
            var RedirectUrl = resp['ns2:Redirect']['ns2:RedirectUrl']['\$'];
            var PAY_REQUEST_ID = UrlParams[0]['ns2:value']['\$'];
            var PAYGATE_ID = UrlParams[1]['ns2:value']['\$'];
            var CHECKSUM = UrlParams[2]['ns2:value']['\$'];
            if (RedirectUrl != null &&
                PAY_REQUEST_ID != null &&
                PAYGATE_ID != null &&
                CHECKSUM != null) {
              // String transRef = tranxaction.makeTranxactions();
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => new SecureView(
                          pageViewController: pageViewController,
                          currentUser: currentUser,
                          RedirectUrl: RedirectUrl,
                          PAY_REQUEST_ID: PAY_REQUEST_ID,
                          PAYGATE_ID: PAYGATE_ID,
                          CHECKSUM: CHECKSUM)));
            } else {
              print("Error: UrlParams value is null");
            }
            break;
          /*
            * //If there is no more action required,
            *  transaction is completed
            * Either Approved or Declined
            * */
          case "Completed":
            /*
            * RESULT_CODE = 990017; TRANSACTION_STATUS = 1 - Approved Transactions
            * RESULT_CODE = 900003; TRANSACTION_STATUS = 2 - Insufficient Funds Transactions
            * RESULT_CODE = 900007; TRANSACTION_STATUS = 2 - Declined Transactions
            * RESULT_CODE = 990022; TRANSACTION_STATUS = 0 - Unprocessed Transactions
            * RESULT_CODE = 900004; TRANSACTION_STATUS = 2 - Invalid Card Number
            */

            print("TransStat: " +
                resp['ns2:Status']['ns2:TransactionStatusCode']['\$']);
            print("ResCode: " + resp['ns2:Status']['ns2:ResultCode']['\$']);
            var ResCode = resp['ns2:Status']['ns2:ResultCode']['\$'];
            switch (ResCode) {
              case "990017": // Approved
                tranxaction.makeTranxactions();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PayConfirmPage(
                              pageViewController: pageViewController,
                              currentUser: currentUser,
                              transStatus: "Approved",
                            )));
                break;
              case "900003": // Insufficient
                tranxaction.makeTranxactions();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PayConfirmPage(
                              pageViewController: pageViewController,
                              currentUser: currentUser,
                              transStatus: "Insufficient",
                            )));
                break;
              case "900007": // Declined
                tranxaction.makeTranxactions();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PayConfirmPage(
                              pageViewController: pageViewController,
                              currentUser: currentUser,
                              transStatus: "Declined",
                            )));
                break;
              case "990022": // Unprocessed
                tranxaction.makeTranxactions();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PayConfirmPage(
                              pageViewController: pageViewController,
                              currentUser: currentUser,
                              transStatus: "Unprocessed",
                            )));
                break;
              case "900004": // Invalid card
                tranxaction.makeTranxactions();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PayConfirmPage(
                              pageViewController: pageViewController,
                              currentUser: currentUser,
                              transStatus: "Invalid",
                            )));
                break;
            }
        }
      });
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white,
      appBar: new AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.brown),
        textTheme: TextTheme(
            headline6: TextStyle(
                color: Colors.brown,
                fontSize: 20,
                fontWeight: FontWeight.bold)),
        title: new Text(
          "Enter Amount",
        ),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.done),
              onPressed: () {
                setState(() {
                  amount = _textEditingController.text;
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('CONFIRM TRANSACTION'),
                          content: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text("Action: " +
                                  userAction
                                      .toUpperCase()
                                      .toString()
                                      .split(".")[1] +
                                  " ".toUpperCase()),
                              Divider(
                                height: 16,
                              ),
                              Text("Account: " + merchantName.toUpperCase()),
                              Divider(
                                height: 16,
                              ),
                              Text("Amount: " +
                                  currency.toUpperCase() +
                                  amount.toUpperCase()),
                            ],
                          ),
                          actions: <Widget>[
                            FlatButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('No, Cancel'),
                            ),
                            FlatButton(
                              onPressed: () {
                                doTransaction();
                              },
                              child: Text(
                                'Yes, Continue',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        );
                      });
                });
                /*  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => new PayConfirmPage())); */
              }),
        ],
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            FutureBuilder(
                future: Firestore.instance
                    .collection("merchants")
                    .document(merchantId)
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    merchantName = snapshot.data['MerchantName'];
                    merchantType = snapshot.data['MerchantType'];
                    return Card(
                        color: Colors.white70,
                        child: ListTile(
                          leading: Image.network(
                            "https://i.imgur.com/pqA5tnV.png",
                            width: 40,
                            height: 40,
                          ),
                          title: Text(snapshot.data['MerchantName']) ??
                              CircularProgressIndicator(),
                          subtitle: Text(snapshot.data['MerchantType']) ??
                              CircularProgressIndicator(),
                        ));
                  } else {
                    return CircularProgressIndicator();
                  }
                }),
            Divider(
              height: 18,
              color: Colors.transparent,
            ),
            TextFormField(
              keyboardType: TextInputType.numberWithOptions(),
              textAlignVertical: TextAlignVertical.center,
              style: TextStyle(fontSize: 48, color: Colors.brown),
              enabled: true,
              controller: _textEditingController,
              decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.attach_money,
                    color: Colors.grey,
                    size: 48,
                  ),
                  prefixStyle: TextStyle(color: Colors.blue, fontSize: 48),
                  hintText: "0",
                  hintStyle: TextStyle(fontSize: 48, color: Colors.grey),
                  border: InputBorder.none),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: GridView.count(
                shrinkWrap: true,
                crossAxisCount: 3,
                children: <Widget>[
                  //
                  FlatButton(
                      onPressed: () {
                        setState(() {
                          _textEditingController.text += 1.toString();
                        });
                      },
                      child: Text(
                        '1',
                        style: TextStyle(fontSize: 24),
                      )),
                  FlatButton(
                      onPressed: () {
                        setState(() {
                          _textEditingController.text += 2.toString();
                        });
                      },
                      child: Text(
                        '2',
                        style: TextStyle(fontSize: 24),
                      )),
                  FlatButton(
                      onPressed: () {
                        setState(() {
                          _textEditingController.text += 3.toString();
                        });
                      },
                      child: Text(
                        '3',
                        style: TextStyle(fontSize: 24),
                      )),
                  //
                  FlatButton(
                      onPressed: () {
                        setState(() {
                          _textEditingController.text += 4.toString();
                        });
                      },
                      child: Text(
                        '4',
                        style: TextStyle(fontSize: 24),
                      )),
                  FlatButton(
                      onPressed: () {
                        setState(() {
                          _textEditingController.text += 5.toString();
                        });
                      },
                      child: Text(
                        '5',
                        style: TextStyle(fontSize: 24),
                      )),
                  FlatButton(
                      onPressed: () {
                        setState(() {
                          _textEditingController.text += 6.toString();
                        });
                      },
                      child: Text(
                        '6',
                        style: TextStyle(fontSize: 24),
                      )),
                  //
                  FlatButton(
                      onPressed: () {
                        setState(() {
                          _textEditingController.text += 7.toString();
                        });
                      },
                      child: Text(
                        '7',
                        style: TextStyle(fontSize: 24),
                      )),
                  FlatButton(
                      onPressed: () {
                        setState(() {
                          _textEditingController.text += 8.toString();
                        });
                      },
                      child: Text(
                        '8',
                        style: TextStyle(fontSize: 24),
                      )),
                  FlatButton(
                      onPressed: () {
                        setState(() {
                          _textEditingController.text += 9.toString();
                        });
                      },
                      child: Text(
                        '9',
                        style: TextStyle(fontSize: 24),
                      )),

                  //
                  FlatButton(
                      onPressed: () {
                        setState(() {
                          _textEditingController.text += ".".toString();
                        });
                      },
                      child: Text('.', style: TextStyle(fontSize: 24))),
                  FlatButton(
                      onPressed: () {
                        setState(() {
                          _textEditingController.text += 0.toString();
                        });
                      },
                      child: Text('0', style: TextStyle(fontSize: 24))),
                  IconButton(
                      icon: Icon(
                        Icons.backspace,
                        color: Colors.black,
                        size: 24,
                      ),
                      onPressed: () {
                        setState(() {
                          if (_textEditingController.text.length > 0) {
                            _textEditingController.text =
                                _textEditingController.text.substring(
                                    0, _textEditingController.text.length - 1);
                          }
                        });
                      })
                ],
              ),
            )
          ],
        ),
        minimum: EdgeInsets.all(16),
      ),
    );
  }

  Future<Map<String, dynamic>> getMerchant() async {
    print("WHAT?" + merchantId);
    Map<String, dynamic> docs;
    try {
      await Firestore.instance
          .collection("merchants")
          .document(merchantId)
          .get()
          .then((value) => (DocumentSnapshot documentSnapshot) {
                docs = documentSnapshot.data;
              });
    } catch (e) {}
    return docs;
  }

  how3dSecure() {
    showDialog(
        context: context,
        builder: (context) {
          return null;
        });
  }

  getCardDetails() async {
    setState(() {
      print(bankCard.getBankCard());
    });
  }
}
