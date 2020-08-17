import 'package:ecashpay/MyHomePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreatePinPage extends StatefulWidget {
  CreatePinPage({Key key, @required this.currentUser}) : super(key: key);
  final FirebaseUser currentUser;

  @override
  State createState() => new CreatePinPageState();
}

class CreatePinPageState extends State<CreatePinPage> {
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
    print("CreatePinPage: " + "Works well");
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
        title: Text('Create a Pin'),
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
          minimum: EdgeInsets.all(32),
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              Text(_message),
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
                            // comparing current input to appPIn if it exists
                            if (appPin != null && appPin == inputPin) {
                              print('appPin: ' + appPin);
                              // go somewhere
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MyHomePage(
                                          currentUser: currentUser)));
                            } else {
                              prefs.setString('appPin',
                                  inputPin); // Storing the first PIN to use to current input
                              print('appPin: ' + inputPin);
                              clearAllAndRepeat("Please repeat to confirm");
                            }
                          });
                        },
                      )),
                ],
              )
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
        _fstNode.requestFocus();
        tries += 1;
      });
    } else {
      // Navigator.push(context, MaterialPageRoute(builder: (context) => VerificationPage()));
    }
  }
}
