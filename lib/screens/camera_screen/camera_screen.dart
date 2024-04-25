import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key,this.url});
 final String? url;
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {

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
    try {
     XFile image = await controller!.takePicture();
     print(image.toString());
      await controller!.takePicture();
      // upload(File(imagePath));
       dataSend(image);
    } catch (e) {
      print(e);
    }
  }

  dataSend(image)async{
    var request =
    http.MultipartRequest('POST', Uri.parse('https://0490-39-34-206-61.ngrok-free.app/upload/'));
    // request.fields['reference_image'] = image.toString();
    request.files.add(http.MultipartFile.fromBytes('reference_image', File(image!.path).readAsBytesSync(),filename: image!.path));
    var res = await request.send();

    final responsed = await http.Response.fromStream(res);
    responseData = json.decode(responsed.body);

    print("Response: ${res.statusCode}");

    if(res.statusCode == 200){
      print("SUCCESS");
      print(responseData["result"]);
    }else{
      print("Request Code: ${res.statusCode}");
    }
    setState(() {
      responseData;
    });
  }
  CameraController? controller;
  var responseData;
  var result = "";
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
                    setState(() {
                      result = result + responseData["result"];
                    });
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
                      child: Text(responseData != null ? result.toString() : "",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      setState(() {
                        result = "";
                      });
                      print("-------------------${result.toString()}-------------------");
                    },
                    child: Container(
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
