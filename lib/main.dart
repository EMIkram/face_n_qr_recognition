//
// import 'package:camera/camera.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
//
// void main() => runApp(MaterialApp(home: _MyHomePage()));
//
// class _MyHomePage extends StatefulWidget {
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<_MyHomePage> {
//   dynamic _scanResults;
//   CameraController _camera;
//   CameraImage _image;
//   bool _isDetecting = false;
//   CameraLensDirection _direction = CameraLensDirection.front;
//
//   @override
//   void initState() {
//     super.initState();
//     _initializeCamera();
//     // CameraPreview(_camera);
//   }
//
//   Future<CameraDescription> _getCamera(CameraLensDirection dir) async {
//     return await availableCameras().then(
//           (List<CameraDescription> cameras) => cameras.firstWhere(
//             (CameraDescription camera) => camera.lensDirection == dir,
//       ),
//     );
//   }
//
//   void _initializeCamera() async {
//     _camera = CameraController(
//
//       await _getCamera(_direction),
//       defaultTargetPlatform == TargetPlatform.iOS
//           ? ResolutionPreset.low
//           : ResolutionPreset.ultraHigh,
//     );
//     await _camera.initialize();
//     _camera.startImageStream((CameraImage image) {
//       setState(() {
//         _image=image;
//       });
//       print("------------------------------------------------------image-----------------------------------------------------/n$image");
//       if (_isDetecting) return;
//       _isDetecting = true;
//       try {
//         // await doOpenCVDectionHere(image)
//       } catch (e) {
//         // await handleExepction(e)
//       } finally {
//         _isDetecting = false;
//       }
//     });
//   }
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           Container(
//             height: 350,
//             width: 200,
//             child: CameraPreview(
//               _camera
//             ),
//
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Container(
//               height: 350,
//               width: 200,
//               child: Text(_image.planes.toString())
//
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//   recognizeImage()async{
//     try {
//       // await doOpenCVDectionHere(image)
//     } catch (e) {
//       // await handleExepction(e)
//     } finally {
//       _isDetecting = false;
//     }
//   }
// }

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'Screens/home.dart';
import 'Screens/scanner.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),

      // MyHomePage(title: 'SBS AMS test'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
TextEditingController _controller = TextEditingController();
String _qrString ;
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        centerTitle: true,
        actions: [
          IconButton(icon: Icon(Icons.qr_code), onPressed: (){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => QRViewExample()),
            );
          })
        ],
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 50,),
            _qrString==null? Container(
              padding: EdgeInsets.all(50),
              color: Colors.black12,
              height: 240,width: 240,):
            Container(
              height: 240,
              child: QrImage(
                data: _qrString,
                version: 3,
                size: 250,
                gapless: false,
                embeddedImage: AssetImage('assets/Sbs.png'),
                embeddedImageStyle: QrEmbeddedImageStyle(
                  size: Size(80, 80),
                ),
              ),
            ),
            SizedBox(height: 10,),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            onChanged: (text){
              setState(() {
                text==''?
                _qrString=null:
                    _qrString=text;
              });
            },
            controller: _controller,
            decoration: InputDecoration(
              labelText: "Generate QR",
                border: OutlineInputBorder(),
                hintText: 'Input and generate QR'
            ),
          ),
        ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => QRViewExample()),
              );
            }, child: Text("Scan QR")),

          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}




