import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sign_detector/screens/home_screen/home_screen.dart';

import '../screens/start_screens/signin_screen.dart';

class SplashServices{
  void isLogin(context){
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    if(user != null){
      Timer(const Duration(seconds: 3), () =>Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>   HomeScreen())));
    }else{
      Timer(const Duration(seconds: 3), () =>Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>  SignInScreen())));
    }
  }
}