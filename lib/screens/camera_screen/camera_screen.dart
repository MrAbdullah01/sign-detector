import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key,this.url});
 final String? url;
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? controller;
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    initCamera();
  }

  Future<void> initCamera() async {
    final cameras = await availableCameras();
    controller = CameraController(cameras[0], ResolutionPreset.medium);
    controller!.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  Future<void> onCapture() async {
    var imagePath;
    try {
     var image = await controller!.takePicture();
     print(image.toString());
      // await controller!.takePicture().then((filePath) {
      //   if(mounted){
      //     setState(() {
      //       imagePath = filePath;
      //     });
      //   }
      // });
      // upload(File(imagePath));
       dataSend(image.toString());
    } catch (e) {
      print(e);
    }
  }

  dataSend(imagePath)async{
    try{
      Response response = await post(
        Uri.parse("https://0490-39-34-206-61.ngrok-free.app/upload"),
        body: {
          "reference_image" : imagePath.toString()
        }
      );
      print('Status code: ${response.statusCode}');
      print('Response body: ${response.body.toString()}');
      if(response.statusCode == 200){
        print("running");
       var data = jsonDecode(response.body.toString());
        print(data);
        print("Image Send");
      }else{
        print("failed");
      }
    }catch(e){
      print(e.toString());
    }
  }

  // upload(File imageFile) async {
  //   // open a byteStream
  //   var stream = new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
  //   // get file length
  //   var length = await imageFile.length();
  //
  //   // string to uri
  //   var uri = Uri.parse("https://0490-39-34-206-61.ngrok-free.app/upload");
  //
  //   // create multipart request
  //   var request = http.MultipartRequest("POST", uri);
  //
  //   // multipart that takes file
  //   var multipartFile = http.MultipartFile('reference_image', stream, length,
  //       filename: basename(imageFile.path));
  //
  //   // add file to multipart
  //   request.files.add(multipartFile);
  //
  //   // send
  //   var response = await request.send();
  //   print(response.statusCode);
  //
  //   // listen for response
  //   response.stream.transform(utf8.decoder).listen((value) {
  //     print(value);
  //   });
  // }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    if (controller == null || !controller!.value.isInitialized) {
      return Container();
    }
    return AspectRatio(
      aspectRatio: controller!.value.aspectRatio,
      child: CameraPreview(controller!,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Positioned(
              right: 20,
              child: Center(
                child: GestureDetector(
                  onTap: (){
                    onCapture();
                  },
                  child: Container(
                    height: 70,
                    width: 70,
                    color: Colors.blue,
                    child: Center(
                      child: Text("data",style: TextStyle(fontSize: 12),),
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    height: 50,
                    width: size.width * 0.8,
                    color: Colors.grey,
                    child:  Center(
                      child: Text(
                        widget.url != null ? widget.url! : "Your Text is Here",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                        color: Colors.blue
                    ),
                    child: const Center(
                      child: Text(
                        'Clear',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 12.0,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                        color: Colors.blue
                    ),
                    child: const Center(
                      child: Text(
                        'Restart',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 12.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
