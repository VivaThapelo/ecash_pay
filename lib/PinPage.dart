import 'package:ecashpay/MyHomePage.dart';
import 'package:ecashpay/VerificationPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PinPage extends StatefulWidget {
  final FirebaseUser currentUser;

  PinPage({Key key, @required this.currentUser}) : super(key: key);

  @override
  State createState() => new PinPageState();
}

class PinPageState extends State<PinPage> {
  FirebaseUser currentUser;
  String _message = "";
  TextEditingController _firstController,
      _secondController,
      _thirdController,
      _forthController,
      _currentController;

  FocusNode _fstNode, _secNode, _thdNode, _fthNode;

  @override
  void initState() {
    super.initState();

    SystemChannels.textInput.invokeMethod('TextInput.hide');

    currentUser = widget.currentUser;

    _firstController = new TextEditingController(
      text: "",
    );
    _secondController = new TextEditingController(text: "");
    _thirdController = new TextEditingController(text: "");
    _forthController = new TextEditingController(text: "");
    _currentController = _firstController;

    _fstNode = FocusNode();
    _secNode = FocusNode();
    _thdNode = FocusNode();
    _fthNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Enter Secure Pin'),
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
          minimum: EdgeInsets.all(36),
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              Text(_message),
              Divider(
                height: 16,
                color: Colors.white,
              ),
              Flex(
                direction: Axis.horizontal,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                      flex: 4,
                      child: TextFormField(
                        maxLength: 1,
                        maxLengthEnforced: true,
                        obscureText: true,
                        style: TextStyle(fontSize: 24),
                        textAlign: TextAlign.center,
                        controller: _firstController,
                        decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(24)),
                                borderSide: BorderSide(
                                    color: Colors.brown,
                                    width: 1,
                                    style: BorderStyle.solid)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(24)),
                                borderSide: BorderSide(
                                    color: Colors.brown,
                                    width: 1,
                                    style: BorderStyle.solid)),
                            hintText: "",
                            labelText: "",
                            alignLabelWithHint: false),
                        focusNode: _fstNode,
                        autofocus: true,
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          setState(() {
                            _secNode.requestFocus();
                            _currentController = _secondController;
                          });
                        },
                      )),
                  Divider(
                    indent: 32,
                  ),
                  Expanded(
                    flex: 4,
                    child: TextFormField(
                      maxLength: 1,
                      maxLengthEnforced: true,
                      obscureText: true,
                      style: TextStyle(fontSize: 24),
                      textAlign: TextAlign.center,
                      controller: _secondController,
                      decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(24)),
                              borderSide: BorderSide(
                                  color: Colors.brown,
                                  width: 1,
                                  style: BorderStyle.solid)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(24)),
                              borderSide: BorderSide(
                                  color: Colors.brown,
                                  width: 1,
                                  style: BorderStyle.solid)),
                          hintText: "",
                          labelText: "",
                          alignLabelWithHint: false),
                      focusNode: _secNode,
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() {
                          _thdNode.requestFocus();
                          _currentController = _thirdController;
                        });
                      },
                    ),
                  ),
                  Divider(
                    indent: 32,
                  ),
                  Expanded(
                    flex: 4,
                    child: TextFormField(
                      maxLength: 1,
                      maxLengthEnforced: true,
                      obscureText: true,
                      style: TextStyle(fontSize: 24),
                      textAlign: TextAlign.center,
                      controller: _thirdController,
                      decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(24)),
                              borderSide: BorderSide(
                                  color: Colors.brown,
                                  width: 1,
                                  style: BorderStyle.solid)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(24)),
                              borderSide: BorderSide(
                                  color: Colors.brown,
                                  width: 1,
                                  style: BorderStyle.solid)),
                          hintText: "",
                          labelText: "",
                          alignLabelWithHint: false),
                      focusNode: _thdNode,
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() {
                          _fthNode.requestFocus();
                          _currentController = _forthController;
                        });
                      },
                    ),
                  ),
                  Divider(
                    indent: 32,
                  ),
                  Expanded(
                      flex: 4,
                      child: TextFormField(
                        maxLength: 1,
                        maxLengthEnforced: true,
                        obscureText: true,
                        style: TextStyle(fontSize: 24),
                        textAlign: TextAlign.center,
                        controller: _forthController,
                        decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(24)),
                                borderSide: BorderSide(
                                    color: Colors.brown,
                                    width: 1,
                                    style: BorderStyle.solid)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(24)),
                                borderSide: BorderSide(
                                    color: Colors.brown,
                                    width: 1,
                                    style: BorderStyle.solid)),
                            hintText: "",
                            labelText: "",
                            alignLabelWithHint: false),
                        focusNode: _fthNode,
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          setState(() async {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            String appPin = prefs.getString('appPin');
                            String inputPin = _firstController.text +
                                _secondController.text +
                                _thirdController.text +
                                _forthController.text;
                            if (appPin == inputPin && appPin != null) {
                              print('appPin: ' + appPin);
                              // go somewhere
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MyHomePage(
                                          currentUser: currentUser)));
                            } else {
                              clearAllAndRepeat("Pin Denied, Try Again");
                            }
                          });
                        },
                      )),
                ],
              ),
              /*
              Divider(
                color: Colors.white,
                height: 72,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 3,
                  crossAxisSpacing: 60,
                  mainAxisSpacing: 60,
                  children: <Widget>[
                    //
                    FlatButton(
                        onPressed: () {
                          setState(() {
                            _currentController.text += 1.toString();
                          });
                        },
                        child: Text(
                          '1',
                          style: TextStyle(fontSize: 24, color: Colors.brown),
                        )),
                    FlatButton(
                        onPressed: () {
                          setState(() {
                            _currentController.text += 2.toString();
                          });
                        },
                        child: Text(
                          '2',
                          style: TextStyle(fontSize: 24, color: Colors.brown),
                        )),
                    FlatButton(
                        onPressed: () {
                          setState(() {
                            _currentController.text += 3.toString();
                          });
                        },
                        child: Text(
                          '3',
                          style: TextStyle(fontSize: 24, color: Colors.brown),
                        )),
                    //
                    FlatButton(
                        onPressed: () {
                          setState(() {
                            _currentController.text += 4.toString();
                          });
                        },
                        child: Text(
                          '4',
                          style: TextStyle(fontSize: 24, color: Colors.brown),
                        )),
                    FlatButton(
                        onPressed: () {
                          setState(() {
                            _currentController.text += 5.toString();
                          });
                        },
                        child: Text(
                          '5',
                          style: TextStyle(fontSize: 24, color: Colors.brown),
                        )),
                    FlatButton(
                        onPressed: () {
                          setState(() {
                            _currentController.text += 6.toString();
                          });
                        },
                        child: Text(
                          '6',
                          style: TextStyle(fontSize: 24, color: Colors.brown),
                        )),
                    //
                    FlatButton(
                        onPressed: () {
                          setState(() {
                            // _currentController.text += 7.toString();
                          });
                        },
                        child: Text(
                          '7',
                          style: TextStyle(fontSize: 24, color: Colors.brown),
                        )),
                    FlatButton(
                        onPressed: () {
                          setState(() {
                            //    _currentController.text += 8.toString();
                          });
                        },
                        child: Text(
                          '8',
                          style: TextStyle(fontSize: 24, color: Colors.brown),
                        )),
                    FlatButton(
                        onPressed: () {
                          setState(() {
                            _currentController.text += 9.toString();
                          });
                        },
                        child: Text(
                          '9',
                          style: TextStyle(fontSize: 24, color: Colors.brown),
                        )),
                    //
                    FlatButton(
                        onPressed: () {
                          setState(() {
                            //_currentController.text += ".".toString();
                          });
                        },
                        child: Text('',
                            style:
                                TextStyle(fontSize: 24, color: Colors.brown))),
                    FlatButton(
                        onPressed: () {
                          setState(() {
                            _currentController.text += 0.toString();
                          });
                        },
                        child: Text('0',
                            style:
                                TextStyle(fontSize: 24, color: Colors.brown))),
                    IconButton(
                        icon: Icon(
                          Icons.backspace,
                          color: Colors.brown,
                          size: 24,
                        ),
                        onPressed: () {
                          setState(() {
                            clearAllAndRepeat("");
                          });
                        })
                  ],
                ),
              )
              */
            ],
          )),
    );
  }

  // clear all fields, show denied and start over
  clearAllAndRepeat(String message) {
    int tries = 0;
    if (tries < 3) {
      setState(() {
        _firstController.clear();
        _secondController.clear();
        _thirdController.clear();
        _forthController.clear();
        _message = message;
        _currentController = _firstController;
        _fstNode.requestFocus();
        tries++;
      });
    } else {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => VerificationPage()));
    }
  }
}
