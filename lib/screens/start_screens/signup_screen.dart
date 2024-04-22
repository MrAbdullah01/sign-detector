import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sign_detector/screens/start_screens/signin_screen.dart';

import '../../helpers/colors.dart';
import '../../helpers/images.dart';
import '../../helpers/text_field.dart';
import '../../utils/flutter_toast_msg.dart';
import '../../widgets/header/header.dart';
import '../../widgets/submit_button/submit_button.dart';
import '../home_screen/home_screen.dart';

class SignUpScreen extends StatefulWidget {
  SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  var emailC = TextEditingController();

  var passwordC = TextEditingController();

  var nameC = TextEditingController();

  var formKey = GlobalKey<FormState>();

  FirebaseAuth auth = FirebaseAuth.instance;
  var firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomHeader().header("Sign Up",leading:IconButton(onPressed: (){
        Navigator.pop(context);
      }, icon: Icon(Icons.arrow_back_ios_new,color: Colors.white,))),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 350.0,
                child: Image.asset(ImagesPath.SIGNUP_IMAGE),
              ),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    InputField(inputController: nameC,hintText: "Enter your name",
                      validate: "Enter the Name",type: TextInputType.text,prefixIcon: Icon(Icons.person),),
                    SizedBox(height: 10,),
                    InputField(inputController: emailC,hintText: "Enter your email",
                      validate: "Enter the Email",type: TextInputType.emailAddress,prefixIcon: Icon(Icons.email_outlined),),
                    SizedBox(height: 10,),
                    InputField(inputController: passwordC,hintText: "Enter your password",
                      validate: "Enter the password",type: TextInputType.text,prefixIcon: Icon(Icons.lock_outline),),
                    SizedBox(height: 40,),
                  ],
                ),
              ),
              SubmitButton(title: "Sign Up", press: (){
                // saveDataToDatabase();
                // print("click");
                if(formKey.currentState!.validate()){
                  auth.createUserWithEmailAndPassword(
                      email: emailC.text.toString(),
                      password: passwordC.text.toString())
                      .then((value) {
                     saveDataToDatabase();
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
                  Text("Already have an account?"),
                  SizedBox(width: 5,),
                  InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>SignInScreen()));
                      },
                      child: Text("Signin",style: TextStyle(color: appColor),)),
                ],),
            ],
          ),
        ),
      ),
    );
  }

  void saveData(context) {
    // String? userUID = FirebaseAuth.instance.currentUser!.uid;

     FirebaseFirestore.instance.collection("users").doc("details").set({
      "email": emailC.text.toString(),
      "name": nameC.text.toString(),
    }).whenComplete(() {
      setState(() {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomeScreen()));
      });
    });
  }

  void saveDataToDatabase() async {
    // print("enter");
    // await firestore.collection("users").doc("userUID")
    // .set({
    //   "data" : "sata"
    // }).whenComplete(() {
    //   print("complete");
    // }).onError((error, stackTrace) {
    //   print("error");
    // });
    // String? userUID = FirebaseAuth.instance.currentUser!.uid;
    // await FirebaseFirestore.instance.collection("users").doc(userUID).set({
    //   "email": emailC.text.toString(),
    //   "name": nameC.text.toString(),
    //   "userUID": userUID,
    // }).whenComplete(() {
    //   setState(() {
    //     Navigator.push(
    //         context, MaterialPageRoute(builder: (context) => HomeScreen()));
    //   });
    // });
  }
}
