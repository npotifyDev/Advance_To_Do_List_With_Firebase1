import 'dart:async';

import 'package:flutter/material.dart';
import 'package:notes_todo_firebase/Service/Auth_Service.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';

class PhoneAuthPage extends StatefulWidget {
  const PhoneAuthPage({super.key});

  @override
  State<PhoneAuthPage> createState() => _PhoneAuthPageState();
}

class _PhoneAuthPageState extends State<PhoneAuthPage> {

  int start = 30;
  bool wait = false;
  String buttonName = "Send";
  TextEditingController phoneController = TextEditingController();
  AuthClass authClass = AuthClass();
  String verificationIdFinal = "";
  String smsCode = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: Text("SignUp",
          style: TextStyle(
              color: Colors.white,
              fontSize: 25),
        ),
        centerTitle: true,
      ),
      body:Container(
        height:MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 150,),
              textField(),
                SizedBox(height: 20 ,),
              Container(
                width: MediaQuery.of(context).size.width-30,
                child: Row(children: [
                  Expanded(
                    child: Container(
                      height: 1,
                      color: Colors.grey,
                      margin: EdgeInsets.symmetric(horizontal: 12),
                    ),
                  ),
                  Text("Enter 6 Digit OTP",style: TextStyle(fontSize: 13,color: Colors.white),),
                  Expanded(
                    child: Container(
                      height: 1,
                      color: Colors.grey,
                      margin: EdgeInsets.symmetric(horizontal: 12),

                    ),
                  ),
                ],),
              ),
              SizedBox(height : 30,),
              otpField(),
              SizedBox(height: 40,),
              RichText(text: TextSpan(
                children:[
                  TextSpan(
                    text: "Send OPT again in ",
                    style: TextStyle(fontSize: 16,color: Colors.yellowAccent),
                  ),
                  TextSpan(
                    text: "00:$start",
                    style: TextStyle(fontSize: 16,color: Colors.pinkAccent),
                  ),
                  TextSpan(
                    text: " sec",
                    style: TextStyle(fontSize: 16,color: Colors.yellowAccent),
                  )
                ]
              )),
              SizedBox(height: 120,),

              InkWell(
                onTap: (){
                  authClass.signInwithPhoneNumber(verificationIdFinal , smsCode, context);
                },
                child: Container(
                  height: 60,
                  width: MediaQuery.of(context).size.width-60,
                  decoration: BoxDecoration(
                    color: Color(0xffff9601),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Center(
                    child: Text(
                      "Lets Go",
                      style: TextStyle(
                        fontSize: 17,
                        color: Color(0xfffbe2ae),
                        fontWeight: FontWeight.w700
                      ),
                    ),
                  ),
                ),
              )

            ],
          ),
        ),
      )
    );
  }

  void startTimer(){
    const onsec = Duration(seconds: 1);
    Timer timer = Timer.periodic(onsec, (timer){
      if(start==0){
        setState(() {
          timer.cancel();
          wait = false;
        });
      }else{
        setState(() {
          start--;

        });
      }
    });

  }

  Widget otpField(){
    return OTPTextField(
      length: 6,
      width: MediaQuery.of(context).size.width-34,
      fieldWidth: 58,
      otpFieldStyle: OtpFieldStyle(
        backgroundColor: Color(0xff2c2b2b),
        borderColor: Colors.white,
      ),
      style: TextStyle(
          fontSize: 17,
        color: Colors.white,
      ),
      textFieldAlignment: MainAxisAlignment.spaceAround,
      fieldStyle: FieldStyle.underline,
      onCompleted: (pin) {
        print("Completed: " + pin);
        setState(() {
          smsCode = pin;

        });
      },
    );
  }

  Widget textField(){
    return Container(
      width: MediaQuery.of(context).size.width - 40,
      height: 60 ,
      decoration: BoxDecoration(
        color: Color(0xff1d1d1d),
        borderRadius: BorderRadius.circular(15)
      ),
      child: TextFormField(
        controller: phoneController,
        keyboardType: TextInputType.number,
        decoration:InputDecoration(
          border: InputBorder.none,
          hintText:"Enter Your Mobile Number",
          hintStyle:TextStyle(
            color: Colors.white54,
            fontSize: 14),
          contentPadding: const EdgeInsets.symmetric(horizontal: 5,vertical: 19),
          prefixIcon: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 19),
            child: Text(
              " (+91) ", style: TextStyle(
                color: Colors.white,
                fontSize: 14),
            ),
          ),

            suffixIcon: InkWell(
              onTap: wait?null:() async {
                startTimer();
                setState(() {
                  start = 30;
                  wait = true;
                  buttonName = "Resend";
                });
                await authClass.verifyPhoneNumber("+91 ${phoneController.text}", context,setData);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 9,vertical: 19),
                child: Text(
                  buttonName, style: TextStyle(
                    color: wait? Colors.grey : Colors.white,
                    fontSize: 17,
                  fontWeight: FontWeight.bold
                ),
                ),
              ),
            )
        )
      ),
    );
  }

  void setData(verificationId){
    setState(() {
      verificationIdFinal = verificationId;
    });
    startTimer();
  }

}
