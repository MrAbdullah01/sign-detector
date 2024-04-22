import 'package:flutter/material.dart';
import 'package:sign_detector/firebase_services/splash_services.dart';
import 'package:sign_detector/helpers/helper_text.dart';

import '../../helpers/images.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  SplashServices splashServices = SplashServices();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    splashServices.isLogin(context);
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(15),
              height: 200,
             width: 200,
             decoration: BoxDecoration(
               color: Colors.white,
               borderRadius: BorderRadius.circular(20)
             ),
             child: Center(child: Image.asset(ImagesPath.SPLASH_IMAGE)),
            ),
            SizedBox(height: 25,),
            TextWidget(text: "Sign Detector", fontSize: 26, fontWeight: FontWeight.bold, isTextCenter: false, textColor: Colors.white)
          ],
        ),
      ),
    );
  }
}
