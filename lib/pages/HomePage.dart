import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notes_todo_firebase/Custom/TodoCard.dart';
import 'package:notes_todo_firebase/Service/Auth_Service.dart';
import 'package:notes_todo_firebase/pages/AddToDo.dart';
import 'package:notes_todo_firebase/pages/SignUpPage.dart';
import 'package:notes_todo_firebase/pages/profile..dart';
import 'package:notes_todo_firebase/pages/view_data.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  AuthClass authClass = AuthClass();
  final Stream<QuerySnapshot> _stream = FirebaseFirestore.instance.collection("Todo").snapshots();

  List<Select> selected = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: Text("Todays's Schedule",
          style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white),
        ),
        actions: [
          CircleAvatar(backgroundImage: AssetImage("assets/images/superman.jpg"),),
          SizedBox(width: 25,)
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(35),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 22),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Sunday 22",
                      style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.white)
                  ),
                  IconButton(onPressed: (){
                    var instance = FirebaseFirestore
                        .instance
                        .collection("Todo");
                    for(int i=0; i<selected.length;i++){
                      instance.doc().delete(); 
                    }

                  },
                      icon: Icon(
                        Icons.delete,
                        color: Colors.red,
                        size: 25,)),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black87,
        items: [
          BottomNavigationBarItem(
            icon:Icon(
              Icons.home,
            size: 32,
            color: Colors.white,),
            label: "Home",
              ),
          BottomNavigationBarItem(
            label: "Add",
            icon:InkWell(
              onTap: (){
                Navigator.push(context,
                MaterialPageRoute(builder: (context)=>AddToDo())
                );
              },
              child: Container(
                height: 52,
                width: 52,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      Colors.indigoAccent,
                      Colors.purple,
                    ]
                  )
                ),
                child: Icon(
                  Icons.add,
                  size: 32,
                  color: Colors.white,),
              ),
            ),
          ),
          BottomNavigationBarItem(
            label: "Setting",
            icon:InkWell(
              onTap: (){
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context)=>Profile())
                  );
              },
              child: Icon(
                Icons.settings,
                size: 32,
                color: Colors.white,),
            ),
          ),
        ],
      ),

    body: StreamBuilder(
      stream: _stream,
      builder: (context, snapshot){
        if(!snapshot.hasData){
          return Center(child: CircularProgressIndicator(),);
        }
        return ListView.builder(
            itemCount: snapshot.data?.docs.length,
            itemBuilder: (context,index){
              IconData iconData;
              Color iconColor;
              Map<String,dynamic> document =
                  snapshot.data?.docs[index].data() as Map<String, dynamic>;
              print(document["title"].toString());
              switch(document['Category']){
                case "Work":
                  iconData = Icons.run_circle_outlined;
                  iconColor = Colors.red;
                  break;
                case "WorkOut":
                  iconData = Icons.alarm;
                  iconColor = Colors.teal;
                  break;
                case "Food":
                  iconData = Icons.local_grocery_store;
                  iconColor = Colors.blue;
                  break;
                case "Design":
                  iconData = Icons.audiotrack;
                  iconColor = Colors.green;
                  break;
                case "Run":
                  iconData = Icons.fitness_center;
                  iconColor = Colors.amber ;
                  break;
                default:
                  iconData = Icons.run_circle_outlined;
                  iconColor = Colors.red;
              }
              selected.add(Select(id: snapshot.data!.docs[index].id, checkValue: false));
              return InkWell(
                onTap: (){
                  Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context)=>ViewData(
                    document: document,
                    id:snapshot.data!.docs[index].id,
                  )));
                },
                child: TodoCard(
                  title: document["title"] == null ? "Hey There" : document["title"],
                iconData: iconData,
                iconColor: iconColor,
                time: "10 AM",
                check: selected[index].checkValue,
                iconBgColor: Colors.white,
                index: index,
                  onChange: onChange,
                ),
              );
        });
      },
    )
    );
  }

  void onChange(int index){
    setState(() {
      selected[index].checkValue = !selected[index].checkValue;
    });
  }

  }

  class Select {
  String id;
  bool checkValue = false;
  Select({
    required this.id,
    required this.checkValue});
  }
























  // For future use
  // [IconButton(onPressed: ()async{
  // await authClass.logout();
  // Navigator.pushReplacement(context,
  // MaterialPageRoute(builder: (context)=> SignUpPage()));
  // }, icon: Icon(Icons.logout))],

