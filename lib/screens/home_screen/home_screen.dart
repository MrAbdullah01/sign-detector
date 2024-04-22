import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
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
            SubmitButton(title: "Open Camera", press: ()async{
              var status = await Permission.camera.status;
              if (!status.isGranted) {
                status = await Permission.camera.request();
                if (!status.isGranted) {
                 openAppSettings();
                  return;
                }else if(status.isGranted){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CameraScreen()),
                  );
                }
              }
              // If permissions are granted, navigate to the CameraScreen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CameraScreen()),
              );
            })
          ],
        ),
      ),
    );
  }
}
