import 'dart:io';

import 'package:camera/camera.dart';
import 'package:ecashpay/CreatePinPage.dart';
import 'package:ecashpay/PinPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key key, @required this.currentUser}) : super(key: key);
  final FirebaseUser currentUser;

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  FirebaseUser currentUser;
  CameraController _cameraController;
  Future<void> _initializeControllerFuture;
  var imagePath;
  String placeholderURL = "";
  TextEditingController _firstController;
  TextEditingController _lastController;
  FocusNode _firstNode, _lastNode;
  String proPic = "https://imgur.com/gallery/znlz0";

  StorageReference storageReference;

  @override
  void initState() {
    super.initState();
    currentUser = widget.currentUser;
    print("ProfilePage: " + "Works well");
    storageReference = FirebaseStorage.instance.ref();
    getPlaceholder();
    getProPic();
    _firstNode = FocusNode(canRequestFocus: true);
    _lastNode = FocusNode(canRequestFocus: true);

    _firstController = new TextEditingController(
        text: currentUser.displayName != null &&
                currentUser.displayName.length > 2
            ? currentUser.displayName.split(" ")[0]
            : "");
    _lastController = new TextEditingController(
        text: currentUser.displayName != null &&
                currentUser.displayName.length > 2
            ? currentUser.displayName.split(" ")[1]
            : "");

    _cameraController = CameraController(
      // Get a specific camera from the list of available cameras.
      CameraDescription(
        name: "1",
        lensDirection: CameraLensDirection.front,
      ),
      // Define the resolution to use.
      ResolutionPreset.medium,
      enableAudio: false,
    );
    _initializeControllerFuture = _cameraController.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        textTheme: TextTheme(
            headline6: TextStyle(
                color: Colors.brown,
                fontSize: 20,
                fontWeight: FontWeight.bold)),
        elevation: 0,
        title: Text(
          'Profile',
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            onPressed: () {
              setState(() async {
                UserUpdateInfo userUpdateInfo = new UserUpdateInfo();
                userUpdateInfo.displayName =
                    _firstController.text + " " + _lastController.text;
                // userUpdateInfo.photoUrl = "";
                await currentUser.updateProfile(userUpdateInfo);
                SharedPreferences prefs = await SharedPreferences.getInstance();
                if (prefs.getString('appPin') == null) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              CreatePinPage(currentUser: currentUser)));
                } else {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              PinPage(currentUser: currentUser)));
                }
              });
            },
            icon: Icon(
              Icons.check,
              color: Colors.brown,
              size: 28,
            ),
          )
        ],
      ),
      body: SafeArea(
          minimum: EdgeInsets.symmetric(horizontal: 64, vertical: 8),
          child: Center(
            child: ListView(
              children: <Widget>[
                Text(
                  'Take a selfie and enter your full names',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                Divider(
                  height: 24,
                  color: Colors.white,
                ),
                GestureDetector(
                  onTap: () {
                    showCameraPop(context);
                  },
                  child: CircleAvatar(
                    maxRadius: 120,
                    foregroundColor: Colors.yellow,
                    child: Text('Click to Change'),
                    backgroundColor: Colors.grey,
                    backgroundImage:
                    NetworkImage(proPic ?? placeholderURL, scale: .1),
                  ),
                ),
                Divider(
                  height: 24,
                  color: Colors.white,
                ),
                TextFormField(
                  focusNode: _firstNode,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "First Name field is empty";
                    } else if (value.length <= 2) {
                      return "First Name failed is too short";
                    }
                    return null;
                  },
                  controller: _firstController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(hintText: "First Name(s)"),
                  onFieldSubmitted: (value) {
                    Focus.of(context).requestFocus(_lastNode);
                  },
                ),
                Divider(
                  height: 24,
                  color: Colors.white,
                ),
                TextFormField(
                  focusNode: _lastNode,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Last Name field is empty";
                    } else if (value.length <= 2) {
                      return "Last Name failed is too short";
                    }
                    return null;
                  },
                  controller: _lastController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(hintText: "Last Name"),
                  onFieldSubmitted: (value) {
                    Focus.of(context).unfocus();
                  },
                )
              ],
            ),
          )),
    );
  }

  showCameraPop(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) => new Stack(
              children: <Widget>[
                FutureBuilder<void>(
                  future: _initializeControllerFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      // If the Future is complete, display the preview.
                      return Container(
                        color: Colors.black,
                        height: 500,
                        child: CameraPreview(_cameraController),
                      );
                    } else {
                      // Otherwise, display a loading indicator.
                      return Center(child: CircularProgressIndicator());
                    }
                  },
                ),
                Align(
                  heightFactor: 9,
                  alignment: Alignment.bottomCenter,
                  child: FloatingActionButton(
                    child: Icon(Icons.camera_alt),
                    // Provide an onPressed callback.
                    onPressed: () async {
                      // Take the Picture in a try / catch block. If anything goes wrong,
                      // catch the error.
                      try {
                        // Ensure that the camera is initialized.
                        await _initializeControllerFuture;
                        // Construct the path where the image should be saved using the path
                        // package.
                        String time = DateTime.now().toString();
                        final path = join(
                          // Store the picture in the temp directory.
                          // Find the temp directory using the `path_provider` plugin.
                          (await getTemporaryDirectory()).path,
                          time + '.png',
                        );
                        // Attempt to take a picture and log where it's been saved.
                        await _cameraController.takePicture(path);
                        print("Image Path: " + path);
                        setState(() {
                          uploadFile(path);
                        });
                      } catch (e) {
                        // If an error occurs, log the error to the console.
                        print(e);
                      }
                      Navigator.pop(context);
                    },
                  ),
                )
              ],
            ));
  }

  getCurrentUser() async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    FirebaseUser _user = await _auth.currentUser();
    setState(() {
      if (_user != null) {
        currentUser = _user;
      }
    });
  }

  getPlaceholder() async {
    print("getPlaceHolder:" + "runs");
    String response = await storageReference
        .child('profileImages')
        .child('thumb')
        .child('profile-placeholder_200x200.png')
        .getDownloadURL();
    setState(() {
      placeholderURL = response;
    });
  }

  getProPic() async {
    print("getProPic:" + "runs");
    String response = await storageReference
        .child('profileImages')
        .child('thumb')
        .child('${currentUser.uid}_200x200.png')
        .getDownloadURL();
    setState(() {
      proPic = response;
    });
  }

  Future uploadFile(_image) async {
    try {
      File imageFile = new File(_image);
      StorageUploadTask uploadTask = storageReference
          .child('profileImages/${currentUser.uid}.png')
          .putFile(imageFile);
      await uploadTask.onComplete;
      print('File Uploaded');
      await storageReference
          .child('profileImages/thumb/${currentUser.uid}_200x200.png')
          .getDownloadURL()
          .then((fileURL) {
        var imageFile = fileURL;
        print(imageFile.toString());
        UserUpdateInfo userUpdateInfo = new UserUpdateInfo();
        userUpdateInfo.photoUrl = imageFile;
        currentUser.updateProfile(userUpdateInfo);
        setState(() {
          imagePath = imageFile.toString();
        });
      }).catchError((e) {
        print("download error: " + e.toString());
      });
    } catch (e) {
      print("upload error: " + e.toString());
    }
  }
}
