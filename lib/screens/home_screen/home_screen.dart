import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sign_detector/helpers/text_field.dart';
import 'package:sign_detector/screens/start_screens/signin_screen.dart';
import 'package:sign_detector/widgets/header/header.dart';
import 'package:sign_detector/widgets/submit_button/submit_button.dart';

import '../camera_screen/camera_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  CameraController? controller;
  FirebaseAuth auth = FirebaseAuth.instance;
  var urlC = TextEditingController(text: "https://0490-39-34-206-61.ngrok-free.app/upload");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomHeader().header("Home Screen",actions: [
        IconButton(onPressed: (){
          auth.signOut().then((value) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>SignInScreen()));
          });
        }, icon: Icon(Icons.logout,color: Colors.white,))
      ]),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InputField(inputController: urlC,),
            SizedBox(height: 20,),
            SubmitButton(title: "Open Camera", press: ()async{
              FocusScope.of(context).unfocus();
              var status = await Permission.camera.status;
              var statusM = await Permission.microphone.status;

              if (status.isPermanentlyDenied || statusM.isPermanentlyDenied) {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text('Permissions Request'),
                    content: Text('This app needs permanent camera and microphone permissions to function. Please enable them in the app settings.'),
                    actions: <Widget>[
                      TextButton(
                        child: Text('OPEN SETTINGS'),
                        onPressed: () {
                          openAppSettings();
                          Navigator.of(ctx).pop();
                        }
                      ),
                      TextButton(
                        child: Text('CANCEL'),
                        onPressed: () => Navigator.of(ctx).pop(),
                      )
                    ],
                  ),
                );
              } else {
                if (!status.isGranted) {
                  status = await Permission.camera.request();
                }
                if (!statusM.isGranted) {
                  statusM = await Permission.microphone.request();
                }
                if (status.isGranted && statusM.isGranted) {
                  String url = urlC.text.toString();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CameraScreen(url: url,)),
                  );
                }
              }
            })
          ],
        ),
      ),
    );
  }
}
