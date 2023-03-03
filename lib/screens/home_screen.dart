import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/screens/login_screen.dart';
import 'package:firebase/widgets/tasks_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  var auth = FirebaseAuth.instance;
  final TextEditingController _addTask = TextEditingController();
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          _showTaskDialog();
        },
        backgroundColor: Colors.blue.shade400,
        child: const Icon(Icons.add,),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        elevation: 25,
        shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(onPressed: (){
              _underDevelopment();
            }, icon: const Icon(Icons.menu)),
            IconButton(onPressed: (){
              _signOutDialog();
            }, icon: const Icon(Icons.person)),
          ],
        ),
      ),
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.all(10),
          child: TaskList()
        )
      ),

      /*Container(
        margin: const EdgeInsets.only(top: 300),
        child: Center(
          child: Column(
            children: [
              const Text("Home screen"),
              ElevatedButton(onPressed: () async{
                auth.signOut();
                Navigator.push(context, MaterialPageRoute(builder: (ctx)=> LoginScreen()));
              }, child: Text("Logout"))
            ],
          ),
        ),
      ),*/
    );
  }

  Future<String?> getUserId() async {
    final String? uid = user?.uid;
    return uid;
  }

  Future<void> addTask(String taskName) async {
    final String? uid = await getUserId();
    if (uid != null) {
      final CollectionReference tasksRef = FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('tasks');
      tasksRef.add({
        'task': taskName,
        'timestamp': FieldValue.serverTimestamp(),
        'isCompleted': false,
      });
    }
  }

  void _showTaskDialog(){
    showDialog(context: context, builder: (ctx){
      return SimpleDialog(
        title: const Text("Add task"),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15)
        ),
        children: [
          Container(
            margin: const EdgeInsets.all(20),
            child: TextField(
              controller: _addTask,
              decoration: const InputDecoration(
                enabledBorder: OutlineInputBorder(

                ),
                focusedBorder: OutlineInputBorder(

                ),
                hintText: "Enter your task",
                labelText: "Task",


              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 20, right: 20),
            child: Row(
              children: [
                TextButton(onPressed: (){
                  _addTask.text = "";
                  Navigator.of(ctx).pop();
                }, child: const Text("Cancel"),),
                ElevatedButton(onPressed: (){
                  String task = _addTask.text;
                  if (task.isNotEmpty){
                    Navigator.of(ctx).pop();
                    addTask(task);
                  }
                }, child: const Text("Add"),),
              ],
            ),
          )
        ],
      );
    });
  }

  void _underDevelopment(){
    showDialog(context: context, builder: (ctx){
      return AlertDialog(
        title: const Text("Alert"),
        content: const Text("This functionality is under development"),
        actions: [
          TextButton(onPressed: (){
            Navigator.of(context).pop();
          }, child: const Text("Ok"))
        ],
      );
    });
  }

  void _signOutDialog(){
    showDialog(context: context, builder: (ctx){
      return AlertDialog(
        title: const Text("Alert"),
        content: const Text("Do you want to logout"),
        actions: [
          TextButton(onPressed: (){
            Navigator.of(context).pop();
          }, child: const Text("No")),
          ElevatedButton(onPressed: (){
            Navigator.of(context).pop();
            FirebaseAuth.instance.signOut();
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (ctx)=> const LoginScreen()));
          }, child: const Text("Yes")),
        ],
      );
    });
  }
}
