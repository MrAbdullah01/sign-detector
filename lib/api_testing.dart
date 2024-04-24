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
                      height: 100,
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


  // Future getImage()async{
  //   final pickedFile = await _picker.pickImage(source: ImageSource.gallery , imageQuality: 80);
  //
  //   if(pickedFile!= null ){
  //     image = File(pickedFile.path);
  //     setState(() {
  //
  //     });
  //   }else {
  //     print('no image selected');
  //   }
  // }
  Future<File> getImage() async {
    final ImagePicker _picker = ImagePicker();
// Pick an image
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
//TO convert Xfile into file
    File file = File(image!.path);
//print(‘Image picked’);
    return file;
  }

  void sendApiRequest() async{
    final image = await getImage();

    var request =
    http.MultipartRequest('POST', Uri.parse('https://0490-39-34-206-61.ngrok-free.app/upload/'));
    request.fields['reference_image'] = image.toString();
    request.files.add(http.MultipartFile.fromBytes('reference_image', File(image.path).readAsBytesSync(),filename: image.path));
    var res = await request.send();

    print(res);
  }

  // Future<void> uploadImage ()async{
  //
  //   setState(() {
  //     showSpinner = true ;
  //   });
  //
  //   var stream  = new http.ByteStream(image!.openRead());
  //   stream.cast();
  //
  //   var length = await image!.length();
  //
  //   var uri = Uri.parse('https://0490-39-34-206-61.ngrok-free.app/upload');
  //
  //   var request = new http.MultipartRequest('POST', uri);
  //
  // //  request.fields['title'] = "Static title" ;
  //
  //   var multiport = new http.MultipartFile(
  //       'reference_image',
  //       stream,
  //       length);
  //
  //   request.files.add(multiport);
  //
  //   var response = await request.send() ;
  //
  //   print(response.stream.toString());
  //   print(response.statusCode);
  //   if(response.statusCode == 200){
  //     setState(() {
  //       showSpinner = false ;
  //     });
  //     print('image uploaded');
  //   }else {
  //     print('failed');
  //     setState(() {
  //       showSpinner = false ;
  //     });
  //
  //   }
  //
  // }

}
