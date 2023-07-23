import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:notes_todo_firebase/Service/Auth_Service.dart';
import 'package:notes_todo_firebase/pages/HomePage.dart';
import 'package:notes_todo_firebase/pages/SignInPage.dart';

import 'PhoneAuthPage.dart';


class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  firebase_auth.FirebaseAuth firebaseAuth = firebase_auth.FirebaseAuth.instance;
  var _emailController = TextEditingController();
  var _passwordController = TextEditingController();
  bool circular = false;

  AuthClass authClass = AuthClass();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery
              .of(context)
              .size
              .height,
          width: MediaQuery
              .of(context)
              .size
              .width,
          color: Colors.black,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Sign Up", style: TextStyle(
                  fontSize: 35,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20,
              ),

              // buttonItem("assets/images/google.svg","Continue with Google",25,() async {
              //
              //   await authClass.googleSignIn(context);
              //
              // }),

              InkWell(
                onTap:() async{
                  await authClass.googleSignIn(context);},
                child: Container(
                  height:60,
                  width: MediaQuery.of(context).size.width-60,
                  child: Card(
                    color: Colors.black,
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                        side: BorderSide(
                          width: 1,
                          color: Colors.grey,
                        )
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          "assets/images/google.svg",
                          height: 25,
                          width:25,),
                        SizedBox(width: 15,),
                        Text(
                          "Continue with Google",
                          style: TextStyle(
                              color:Colors.white,
                              fontSize: 17),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15,),

              // buttonItem("assets/images/phone.svg","Continue with Mobile",30,(){}),

              InkWell(
                onTap:(){
                  Navigator.push(context,
                  MaterialPageRoute(builder: (context)=>PhoneAuthPage()));
                  },
                child: Container(
                  height:60,
                  width: MediaQuery.of(context).size.width-60,
                  child: Card(
                    color: Colors.black,
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                        side: BorderSide(
                          width: 1,
                          color: Colors.grey,
                        )
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          "assets/images/phone.svg",
                          height: 30,
                          width:30,),
                        SizedBox(width: 15,),
                        Text(
                          "Continue with Mobile",
                          style: TextStyle(
                              color:Colors.white,
                              fontSize: 17),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(height: 15,),

              Text("Or",style: TextStyle(fontSize: 18,color: Colors.white),),

              SizedBox(height: 15,),
              textItem("Email.....",_emailController,false),

              SizedBox(height: 15,),
              textItem("Password.....",_passwordController,true),

              SizedBox(height: 30,),
              colorButton(),

              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "If you already have an Account? ",
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.white),
                  ),
                  InkWell(
                    onTap: (){
                      Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context)=>SignInPage()));
                    },
                    child: Text(
                      "Login",
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              )


            ],
          ),
        ),
      ),
    );
  }

  Widget colorButton(){
    return InkWell(
      onTap: () async{
        setState(() {
          circular = true;
        });
        try{
          firebase_auth.UserCredential userCredential =  await firebaseAuth.createUserWithEmailAndPassword(
              email: _emailController.text,
              password: _passwordController.text);
          print(userCredential.user?.email);
          setState(() {
            circular = false;
          });
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context)=>HomePage()),);
        }
        catch(e){
          final snackBar = SnackBar(content: Text(e.toString()));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          setState(() {
            circular = false;
          });
        }
      },
      child: Container(
        height:60,
        width: MediaQuery.of(context).size.width-90,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(colors: [
            Color(0xfffd746c),
            Color(0xffff9068),
            Color(0xfffd746c)
          ]),
        ),
        child: Center(
            child: circular ? CircularProgressIndicator()
            : Text("Sign Up",
              style: TextStyle(
                  fontSize: 17,
                  color: Colors.white),)),
      ),
    );
  }

  // Widget buttonItem(String imagePath, String buttonName,double size,Function onTap){
  //   return InkWell(
  //     onTap:onTap,
  //     child: Container(
  //       height:60,
  //       width: MediaQuery.of(context).size.width-60,
  //       child: Card(
  //         color: Colors.black,
  //         elevation: 8,
  //         shape: RoundedRectangleBorder(
  //             borderRadius: BorderRadius.circular(15),
  //             side: BorderSide(
  //               width: 1,
  //               color: Colors.grey,
  //             )
  //         ),
  //         child: Row(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             SvgPicture.asset(
  //               imagePath,
  //               height: size,
  //               width:size,),
  //             SizedBox(width: 15,),
  //             Text(
  //               buttonName,
  //               style: TextStyle(
  //                   color:Colors.white,
  //                   fontSize: 17),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget textItem(String labelText,TextEditingController controller,bool obsecureText){
    return Container(
      height:55,
      width: MediaQuery.of(context).size.width-70,
      child: TextFormField(
        style: TextStyle(
          fontSize: 17,
          color: Colors.white
        ),
        controller: controller,
        obscureText: obsecureText,
        decoration: InputDecoration(
            labelText: labelText,
            labelStyle: TextStyle(
                fontSize: 17,
                color: Colors.white
            ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                width: 1.5,
                color: Colors.amber,
              )
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              width: 1,
              color: Colors.grey,
            )
          )
        ),
      ),
    );
  }

}

