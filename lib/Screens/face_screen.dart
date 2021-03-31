import 'dart:io';

import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class FacePage extends StatefulWidget {
  @override
  _FacePageState createState() => _FacePageState();
}

class _FacePageState extends State<FacePage> {
  List<Face> _faces;
  File _imageFile;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
appBar: AppBar(
  title: Text("Face App"),
),

      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera_alt),
        tooltip: "Open Camera",
        onPressed: _getImageAndDetectFaces,
      ),
      body: _imageFile==null?Container():Column(

        children: [
          Flexible(
              flex: 2,
              child: Image.file(_imageFile)),
          Flexible(
            flex: 1,
            child: ListView(
              children:
              _faces.map<Widget>((face){
                print("face tracking id: ${face.trackingId}");
               return  ListTile(
                  title: Text(
                      "${face.boundingBox.top},"
                          "${face.boundingBox.left},"
                          "${face.boundingBox.bottom},"
                          "${face.boundingBox.right},"),
                );
              }
              ).toList(),

            ),
          )
        ],

      )
    );
  }
  _getImageAndDetectFaces() async{
    ImagePicker imagePicker = ImagePicker();
    final imageFile = await imagePicker.getImage(source: ImageSource.camera);
    // final imageFile = await ImagePicker.PickImage(source: ImageSource.camera);
    final image = FirebaseVisionImage.fromFile(File(imageFile.path));
    final faceDetector = FirebaseVision.instance.faceDetector();
    final faces =
    // await faceDetector.detectInImage(image);
    await faceDetector.processImage(image);
    if(mounted){
      setState(() {
        _faces = faces;
        _imageFile = File(imageFile.path);
      });
    }
  }
}
