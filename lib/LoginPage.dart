import 'package:country_code_picker/country_code_picker.dart';
import 'package:ecashpay/CreatePinPage.dart';
import 'package:ecashpay/ProfilePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key, @required this.currentUser}) : super(key: key);
  final FirebaseUser currentUser;

  @override
  State createState() => new LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  FirebaseAuth _auth;
  GlobalKey _scaffoldKey = GlobalKey<ScaffoldState>();
  FirebaseUser cUser;
  String countryCodeName = "ZA";
  String countryCodeDial = "+27";
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _smsController = TextEditingController();

  String _message = '';
  String _verificationId;
  String phoneNumber;
  FirebaseUser user;

  @override
  void initState() {
    super.initState();
    print("It goes to login");

    _auth = FirebaseAuth.instance;

    _auth.onAuthStateChanged.listen((userz) {
      if (userz != null) {
        cUser = userz;
        if (cUser != null && cUser.displayName == null && cUser.email == null) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ProfilePage(currentUser: cUser)));
        } else {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CreatePinPage(currentUser: cUser)));
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        textTheme: TextTheme(
            headline6: TextStyle(
                color: Colors.brown,
                fontSize: 20,
                fontWeight: FontWeight.bold)),
        elevation: 0,
        title: Text('Your Phone Number'),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              showPOPup();
            },
            icon: Icon(
              Icons.check,
              color: Colors.brown,
              size: 280649047642,
            ),
          )
        ],
      ),
      body: SafeArea(
          minimum: EdgeInsets.all(32.0),
          child: ListView(
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
              new CountryCodePicker(
                initialSelection: '+27',
                favorite: ['+27', 'ZA'],
                showCountryOnly: false,
                showOnlyCountryWhenClosed: true,
                alignLeft: false,
                onChanged: (code) {
                  setState(() {
                    countryCodeName = code.name;
                    countryCodeDial = code.dialCode;
                  });
                },
                onInit: (code) =>
                    print("on init ${code.name} ${code.dialCode}"),
              ),
              Divider(
                height: 32,
                color: Colors.white,
              ),
              TextFormField(
                controller: _phoneNumberController,
                autofocus: true,
                onFieldSubmitted: (value) {
                  setState(() {
                    if (value.length == 10) {
                      phoneNumber = countryCodeDial + value.substring(1, 10);
                    } else {
                      phoneNumber = countryCodeDial + value;
                    }
                  });
                  showPOPup();
                },
                style: TextStyle(fontSize: 18),
                validator: (value) {
                  if (value.isEmpty) {
                    return "Field is empty";
                  } else if ((value.length < 9) || value.length > 10) {
                    return "Phone number length is invalid";
                  }
                  return null;
                },
                autovalidate: true,
                decoration: InputDecoration(
                    prefixText: countryCodeDial,
                    hintText: "Phone Number",
                    alignLabelWithHint: true),
                keyboardType: TextInputType.phone,
              )
            ],
          )),
    );
  }

  // Example code of how to verify phone number
  void _verifyPhoneNumber() async {
    showSMSpop();
    setState(() {
      _message = '';
    });
    final PhoneVerificationCompleted verificationCompleted =
        (AuthCredential phoneAuthCredential) {
      _auth.signInWithCredential(phoneAuthCredential);
      setState(() {
        _message = 'Received phone auth credential: $phoneAuthCredential';
      });
    };

    final PhoneVerificationFailed verificationFailed =
        (AuthException authException) {
      setState(() {
        _message =
            'Phone number verification failed. Code: ${authException.code}. Message: ${authException.message}';
      });
    };

    final PhoneCodeSent codeSent =
        (String verificationId, [int forceResendingToken]) async {
      _verificationId = verificationId;

      /*
      Scaffold.of(_scaffoldKey.currentContext).showSnackBar(const SnackBar(
        content: Text('Please check your phone for the verification code.'),
      ));*/
    };

    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      _verificationId = verificationId;
    };

    await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 5),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  }

  // Example code of how to sign in with phone.
  void _signInWithPhoneNumber() async {
    AuthCredential credential = PhoneAuthProvider.getCredential(
      verificationId: _verificationId,
      smsCode: _smsController.text,
    );

    FirebaseUser user = (await _auth.signInWithCredential(credential)).user;
    FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);
    setState(() {
      _message = 'Successfully signed in, uid: ' + user.uid;
      if (user != null) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProfilePage(currentUser: user)));
      } else {
        _message = 'Sign in failed';
      }
    });
  }

  showPOPup() {
    showDialog(
        context: this.context,
        builder: (_) => AlertDialog(
              title: Text('Number Confirmation:'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(phoneNumber),
                  Divider(
                    height: 16,
                    color: Colors.white,
                  ),
                  Text("Is your phone number above correct?")
                ],
              ),
              actions: <Widget>[
                FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('NO, Edit')),
                FlatButton(
                    onPressed: () {
                      _verifyPhoneNumber();
                    },
                    child: Text(
                      'YES',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ))
              ],
              elevation: 24,
            ));
  }

  showSMSpop() {
    showDialog(
        context: this.context,
        builder: (context) => AlertDialog(
              title: Text("Authenticating..."),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(_message),
                  CircularProgressIndicator(),
                  Divider(
                    height: 8,
                    color: Colors.white,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    controller: _smsController,
                    decoration: InputDecoration(hintText: 'code here'),
                  )
                ],
              ),
              actions: <Widget>[
                FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Resend SMS')),
                FlatButton(
                    onPressed: () {
                      _signInWithPhoneNumber();
                    },
                    child: Text(
                      'SUBMIT',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ))
              ],
            ));
  }
}
