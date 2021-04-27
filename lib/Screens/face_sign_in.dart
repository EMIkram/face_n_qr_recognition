import 'package:camera/camera.dart';
import 'package:face_n_qr_recognition/services/camera.service.dart';
import 'package:face_n_qr_recognition/services/facenet.service.dart';
import 'package:face_n_qr_recognition/services/ml_vision_service.dart';
import 'package:face_n_qr_recognition/widgets/FacePainter.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';

class FaceSignIn extends StatefulWidget {
  @override
  _FaceSignInState createState() => _FaceSignInState();
}

class _FaceSignInState extends State<FaceSignIn> {
  CameraService _cameraService = CameraService();
  MLVisionService _mlVisionService = MLVisionService();
  FaceNetService _faceNetService = FaceNetService();

  Future _initializeControllerFuture;

  bool cameraInitializated = false;
  bool _detectingFaces = false;
  bool pictureTaked = false;

  // switchs when the user press the camera
  bool _isLoading = true;

  String imagePath;
  Size imageSize;
  Face faceDetected;
  CameraDescription cameraDescription;
  List<CameraDescription> cameras;
  @override
  void initState() {
    availableCameras().then((cams) {
      cameras=cams;
      cameraDescription = cams.firstWhere(
            (CameraDescription camera) => camera.lensDirection == CameraLensDirection.front,);
      _start();
      setState(() {
        _isLoading=false;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _cameraService.dispose();
    super.dispose();
  }

  _start() async {
    print(cameraDescription);
    _initializeControllerFuture = _cameraService.startService(cameraDescription);
    await _initializeControllerFuture;
    setState(() {
      cameraInitializated = true;
    });

    _frameFaces();
  }
  _frameFaces() {
    imageSize = _cameraService.getImageSize();
    _cameraService.cameraController.startImageStream((image) async {
      if (_cameraService.cameraController != null) {
        // if its currently busy, avoids overprocessing
        if (_detectingFaces) return;

        _detectingFaces = true;

        try {
          List<Face> faces = await _mlVisionService.getFacesFromImage(image);

          if (faces != null) {
            if (faces.length > 0) {
              // preprocessing the image
              print(faceDetected);
              setState(() {
                faceDetected = faces[0];
              });

              if (_isLoading) {
                _isLoading = false;
                _faceNetService.setCurrentPrediction(image, faceDetected);///main line for recognizing the face
              }

            } else {
              setState(() {
                faceDetected = null;
              });
            }
          }

          _detectingFaces = false;
        } catch (e) {
          print(e);
          _detectingFaces = false;
        }
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(

      body:_isLoading?Container():Container(
        width: width,
        height: height,
        child: Stack(
          // fit: StackFit.expand,
          children: <Widget>[
            CameraPreview(_cameraService.cameraController),
            CustomPaint(
              painter: FacePainter(face: faceDetected, imageSize: imageSize),
            )
          ],
        ),
      ),
    );
  }
}
