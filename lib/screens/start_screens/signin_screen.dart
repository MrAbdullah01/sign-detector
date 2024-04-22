import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sign_detector/helpers/colors.dart';
import 'package:sign_detector/helpers/text_field.dart';
import 'package:sign_detector/screens/home_screen/home_screen.dart';
import 'package:sign_detector/screens/start_screens/signup_screen.dart';
import 'package:sign_detector/utils/flutter_toast_msg.dart';
import 'package:sign_detector/widgets/header/header.dart';
import 'package:sign_detector/widgets/submit_button/submit_button.dart';

import '../../helpers/images.dart';

class SignInScreen extends StatelessWidget {
  SignInScreen({super.key});

  var emailC = TextEditingController();
  var passwordC = TextEditingController();
  var _formKey = GlobalKey<FormState>();

  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return  Scaffold(
      appBar: CustomHeader().header("Sign In"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 350.0,
                child: Image.asset(ImagesPath.SIGNIN_IMAGE),
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    InputField(inputController: emailC,hintText: "Enter your email",
                      validate: "Enter the Email",type: TextInputType.emailAddress,prefixIcon: Icon(Icons.email_outlined),),
                    SizedBox(height: 10,),
                    InputField(inputController: passwordC,hintText: "Enter your password",
                      validate: "Enter the password",type: TextInputType.text,prefixIcon: Icon(Icons.lock_outline),),
                    SizedBox(height: 40,),
                  ],
                ),
              ),
              SubmitButton(title: "Sign In", press: (){
                FocusScope.of(context).unfocus();
                if(_formKey.currentState!.validate()){
                  auth.signInWithEmailAndPassword(email: emailC.text.toString(), password: passwordC.text.toString())
                  .then((value) {
                    ToastMsg().toastMsg(value.user!.email.toString());
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> HomeScreen()));
                  })
                      .onError((error, stackTrace) {
                    ToastMsg().toastMsg(error.toString());
                  });
                }
              }),
              SizedBox(height: 15,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                Text("Don't have an account?"),
                SizedBox(width: 5,),
                InkWell(
                  splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>SignUpScreen()));
                    },
                    child: Text("Signup",style: TextStyle(color: appColor),)),
              ],),
            ],
          ),
        ),
      ),
    );
  }
}
