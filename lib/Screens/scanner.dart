import 'dart:io';
import 'package:camera/camera.dart';
import 'package:face_n_qr_recognition/Screens/face_auth.dart';
import 'package:face_n_qr_recognition/Screens/sign-in.dart';
import 'package:face_n_qr_recognition/Utils/Utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:http/http.dart' as http;


class QRViewExample extends StatefulWidget {
  @override
  QRViewExampleState createState() => QRViewExampleState();
}

class QRViewExampleState extends State<QRViewExample> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode result;
  QRViewController controller;
  CameraDescription cameraDescription;
  List<CameraDescription> cameras;
  /// takes the front camera
  @override
  void initState() {
    availableCameras().then((cams) {
      cameras=cams;
      cameraDescription = cams.firstWhere(
            (CameraDescription camera) => camera.lensDirection == CameraLensDirection.front,
      );
    });


    // TODO: implement initState
    super.initState();
  }
  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller.pauseCamera();
    } else if (Platform.isIOS) {
      controller.resumeCamera();
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (){

          Utils.push(context, FaceAuth());
        },
        child: Icon(Icons.app_registration),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(

            padding: EdgeInsets.all(50),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width,
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.green,
                    width: 3
                  )
              ),
              child: GestureDetector(
                onTap: (){
                },
                child: QRView(
                  key: qrKey,
                  onQRViewCreated: _onQRViewCreated,
                ),
              ),
            ),
          ),
          (result != null)
              ? Expanded(
                child: Text(
                'Barcode Type: ${describeEnum(result.format)}   Data: ${result.code}'),
              )
              : Text('Scan a code'),

        ],
      ),
    );
  }
  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });

    Utils.push(context, SignIn(
      cameraDescription: cameraDescription,
      // authID: result.code,

    ));
    });
  }
  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}