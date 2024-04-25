import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class ApiTestingScreen extends StatefulWidget {
  const ApiTestingScreen({super.key});

  @override
  State<ApiTestingScreen> createState() => _ApiTestingScreenState();
}

class _ApiTestingScreenState extends State<ApiTestingScreen> {

  File? image ;
  final _picker = ImagePicker();
  bool showSpinner = false ;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Upload Image'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: (){
                getImage();
              },
              child: Container(
                child: image == null ? Center(child: Text('Pick Image'),)
                    :
                Container(
                  child: Center(
                    child: Image.file(
                      File(image!.path).absolute,
                      width: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 150,),
            GestureDetector(
              onTap: (){
                // uploadImage();
                sendApiRequest();
              },
              child: Container(
                height: 50,
                width: 200,
                color: Colors.green,
                child: Center(child: Text('Upload')),
              ),
            )
          ],
        ),
      ),
    );
  }


  Future getImage()async{
    XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery , imageQuality: 80);

  //  File file = File(image!.path);

    if(pickedFile!= null ){
      image = File(pickedFile.path);
      setState(() {

      });
    }else {
      print('no image selected');
    }
  }


  void sendApiRequest() async{

    var request =
    http.MultipartRequest('POST', Uri.parse('https://0490-39-34-206-61.ngrok-free.app/upload/'));
   // request.fields['reference_image'] = image.toString();
    request.files.add(http.MultipartFile.fromBytes('reference_image', File(image!.path).readAsBytesSync(),filename: image!.path));
    var res = await request.send();

    var responsed = await http.Response.fromStream(res);
    final responseData = json.decode(responsed.body);

    print("Response: ${res.statusCode}");

    if(res.statusCode == 200){
      print("SUCCESS");
      print(responseData);
    }else{
      print("Request Code: ${res.statusCode}");
    }


  }


}