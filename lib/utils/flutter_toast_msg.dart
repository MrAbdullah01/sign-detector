import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sign_detector/helpers/colors.dart';

class ToastMsg{
  void toastMsg(String msg){
    Fluttertoast.showToast(
        msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: appColor,
      textColor: Colors.white,
      fontSize: 12
    );
  }
}