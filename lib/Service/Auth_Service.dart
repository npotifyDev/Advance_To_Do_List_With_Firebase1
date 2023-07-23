import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../pages/HomePage.dart';

class AuthClass{

  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  FirebaseAuth _auth = FirebaseAuth.instance;
  final storage = new FlutterSecureStorage();

  Future<void> googleSignIn(BuildContext context) async {

    try{
      GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();

      if(googleSignInAccount != null){
        GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

        AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken,
        );

        try{
          UserCredential userCredential =
          await _auth.signInWithCredential(credential);
          storeTokenAndData(userCredential);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context)=>HomePage()),);
        }catch(e){
          final snackBar = SnackBar(content: Text(e.toString()));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      }
      else{
        final snackBar = SnackBar(content: Text("Not Able to sign In"));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }

    }
    catch(e){
      final snackBar = SnackBar(content: Text(e.toString()));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Future<void> storeTokenAndData(UserCredential userCredential) async {
    await storage.write(key: "token", value: userCredential.credential?.token.toString());
    await storage.write(key: "userCredential", value: userCredential.toString());
  }

  Future<String?> getToken() async{
    return await storage.read(key: "token");
  }

  Future<void> logout()async{
    try{
      await _googleSignIn.signOut();
      await _auth.signOut();
      await storage.delete(key: "token");
    }
    catch(e){
    }
  }

  Future<void> verifyPhoneNumber(String phoneNumber, BuildContext context,Function setData)async{

    PhoneVerificationCompleted verificationCompleted =
    (PhoneAuthCredential phoneAuthCredential) async {
      showSnackBar(context, "Verification Completed");
    };

    PhoneVerificationFailed verificationFailed = (FirebaseAuthException exception) {
      showSnackBar(context,exception.toString() );
    };

    PhoneCodeSent codeSent = (String verificationID,[int? forceResendingtoken]) {
      showSnackBar(context,"Verification Code sent on the phone number");
      setData(verificationID);
    } as PhoneCodeSent;

    PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
    (String verificationID) {
      showSnackBar(context, "Time Out");
    };

    try{
      await _auth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted:verificationCompleted ,
          verificationFailed: verificationFailed,
          codeSent: codeSent,
          codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
    }
    catch(e){
      showSnackBar(context, e.toString());
    }
  }

  Future<void> signInwithPhoneNumber(String verificationId, String smsCode,BuildContext context) async{
    try{
      AuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId,
          smsCode: smsCode);

      UserCredential userCredential =  await _auth.signInWithCredential(credential);

      storeTokenAndData(userCredential);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context)=>HomePage()),);
      showSnackBar(context, "Logged In");
    }catch(e){
      showSnackBar(context, e.toString());

    }
  }

  void showSnackBar (BuildContext context,String text){
    final snackBar = SnackBar(content:Text(text));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

}
