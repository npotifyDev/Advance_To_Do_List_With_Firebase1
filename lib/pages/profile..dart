import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  final ImagePicker _picker = ImagePicker();
  late XFile image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: SafeArea(
        child: Container(
          width:MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 60,
                backgroundImage: getImage(),
              ),
              SizedBox(height: 30,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(onPressed: () async {
                    image= (await _picker.pickImage(source: ImageSource.gallery))!;
                    setState(() {
                      image = image;
                    });
                  },
                      icon: Icon(
                        Icons.add_a_photo,
                        color: Colors.teal,
                        size: 30,)),
                  button(),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  ImageProvider getImage(){
    if(image!=null){
      return FileImage(File(image.path));
    }
    return AssetImage("assets/images/ironman.jpg");
  }

  Widget button(){
    return InkWell(
      onTap: (){

      },
      child: Container(
        height: 56,
        width: MediaQuery.of(context).size.width/2,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [
                Color(0xff8a32f1),
                Color(0xffad32f9),
              ],
            )
        ),
        child: Center(
          child: Text("Upload",style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
              color: Colors.white
          ),
          ),
        ),
      ),
    );
  }
}
