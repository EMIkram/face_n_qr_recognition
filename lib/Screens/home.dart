import 'package:camera/camera.dart';
import 'package:face_n_qr_recognition/Screens/sign-in.dart';
import 'package:face_n_qr_recognition/Screens/sign-up.dart';
import 'package:face_n_qr_recognition/db/database.dart';
import 'package:face_n_qr_recognition/services/facenet.service.dart';
import 'package:face_n_qr_recognition/services/ml_vision_service.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Services injection
  FaceNetService _faceNetService = FaceNetService();
  MLVisionService _mlVisionService = MLVisionService();
  DataBaseService _dataBaseService = DataBaseService();

  CameraDescription cameraDescription;
  bool loading = false;

  @override
  void initState() {
    _startUp();
    super.initState();

  }

  /// 1 Obtain a list of the available cameras on the device.
  /// 2 loads the face net model
  _startUp() async {
    _setLoading(true);

    List<CameraDescription> cameras = await availableCameras();

    /// takes the front camera
    cameraDescription = cameras.firstWhere(
          (CameraDescription camera) => camera.lensDirection == CameraLensDirection.front,
    );
    print("camera desc");
    print(cameraDescription);

    // start the services
    await _faceNetService.loadModel();
    await _dataBaseService.loadDB();
    _mlVisionService.initialize();

    _setLoading(false);
  }

  // shows or hides the circular progress indicator
  _setLoading(bool value) {
    setState(() {
      loading = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Face recognition auth'),
        leading: Container(),
      ),
      body: !loading
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              child: Text('Sign In'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => SignIn(
                      cameraDescription: cameraDescription,
                    ),
                  ),
                );
              },
            ),
            RaisedButton(
              child: Text('Sign Up'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => SignUp(
                      cameraDescription: cameraDescription,
                    ),
                  ),
                );
              },
            ),
            RaisedButton(
              child: Text('Clean DB'),
              onPressed: () {
                _dataBaseService.cleanDB();
              },
            ),
          ],
        ),
      )
          : Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
