import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../helpers/colors.dart';

class CustomHeader  {
  AppBar header(String title,{leading,List<Widget>? actions}){
    return AppBar(
      backgroundColor: appColor,
      automaticallyImplyLeading: false,
      title: Text(title,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
      centerTitle: true,
      leading: leading,
      actions: actions,
      // actions: [
      //   IconButton(
      //       splashColor: Colors.transparent,
      //       highlightColor: Colors.transparent,
      //       onPressed: actionIconTap, icon: Icon(icon,color: Colors.white,))
      // ],
    );
  }
}
