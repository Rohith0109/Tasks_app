import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/screens/email_pass_signup.dart';
import 'package:firebase/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  CollectionReference users = FirebaseFirestore.instance.collection("users");

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.all(30),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 50),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(100)),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x44D50303),
                      blurRadius: 15,
                      offset: Offset(20, 10),
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: const Image(
                  image: AssetImage("assets/login_round.png"),
                  width: 200,
                  height: 200,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 30),
                child: const Text("Login ",
                style: TextStyle(
                  fontSize: 35,
                  fontFamily: 'Acme',
                  fontWeight: FontWeight.bold
                ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.only(top: 15,),
                child: TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(

                    ),
                    labelText: "Email",
                    hintText: "Enter your email",
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.only(top: 5,),
                child: TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(

                    ),
                    labelText: "Password",
                    hintText: "Enter your password",
                  ),
                  obscureText: true,
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                child: InkWell(
                  onTap: (){
                    _signIn();
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [
                        Color(0xFFFF0000),
                        Color(0xFF8F0000),
                      ]),
                      borderRadius: BorderRadius.circular(8)
                    ),
                    child: const Center(
                      child: Text(
                        "Login with email",
                        style: TextStyle(
                          color: Colors.white
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              TextButton.icon(
                onPressed: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (ctx)=>const EmailPassSignupScreen()
                      )
                  );
                },
                icon: Icon(Icons.email, color: Theme.of(context).brightness==Brightness.dark? Colors.white: Colors.black,),
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                ),
                label: const Text('Signup with Email',),
              )
            ],
          ),
        ),
      ),
    );
  }
  void _signIn() async{
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    if (email.isNotEmpty && password.isNotEmpty){
      _auth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((user) async {
          users.doc(user.user?.uid).set({
            "email" : email,
          });
          Navigator.push(context, MaterialPageRoute(builder: (ctx) => HomeScreen()));

      })
        .catchError((e) {
          showDialog(context: context, builder: (ctx){
            return AlertDialog(
              title: const Text("Error"),
              content: Text("${e.message}"),
              actions: [
                TextButton(onPressed: (){
                  _passwordController.text = "";
                  Navigator.of(ctx).pop();
                }, child: const Text("Ok"))
              ],
            );
          });
        });
    } else {
      showDialog(context: context, builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15)
          ),
          title: const Text("Error"),
          content: const Text("Please enter email and password"),
          actions: [
            TextButton(onPressed: (){
              _emailController.text = "";
              _passwordController.text = "";
              Navigator.of(ctx).pop();
            }, child: const Text("Ok")),
            TextButton(onPressed: (){
              Navigator.of(ctx).pop();
            }, child: const Text("Cancel"))
          ],
        );
      });
    }
  }

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
  }
}
