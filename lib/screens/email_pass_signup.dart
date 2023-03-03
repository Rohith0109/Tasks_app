import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EmailPassSignupScreen extends StatefulWidget {
  const EmailPassSignupScreen({Key? key}) : super(key: key);

  @override
  State<EmailPassSignupScreen> createState() => _EmailPassSignupScreenState();
}

class _EmailPassSignupScreenState extends State<EmailPassSignupScreen> {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Email signup"),
        backgroundColor: Colors.red,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(30),
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.only(bottom: 5,),
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
                margin: const EdgeInsets.only(bottom: 5,),
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
                margin: const EdgeInsets.only(top: 10, right: 30, left: 30),
                child: InkWell(
                  onTap: (){
                    _signup();
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
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Text("Signup with email",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _signup(){
    final String emailTxt = _emailController.text.trim();
    final String passTxt = _passwordController.text;
    if (emailTxt.isNotEmpty && passTxt.isNotEmpty){
      _auth.createUserWithEmailAndPassword(
        email: emailTxt,
        password: passTxt
      )
      .then((user) => showDialog(context: context, builder: (ctx){
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text("Success"),
          content: const Text("You have signed up successfully"),
          actions: [
            TextButton(onPressed: (){
              Navigator.pop(context);
              Navigator.of(context).pop();
            }, child: const Text('Continue to app'))
          ],
        );
      }))
      .catchError((e){
        showDialog(context: context, builder: (ctx){
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            title: const Text("Error"),
            content: Text("${e.message}"),
            actions: [
              TextButton(onPressed: (){
                Navigator.of(ctx).pop();
              }, child: const Text("OK"))
            ],
          );
        });
      });
    } else{
      showDialog(context: context, builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: const Text("Error"),
          content: const Text("Please enter email and password"),
          actions: [
            TextButton(onPressed: (){
              _passwordController.text = "";
              _emailController.text = "";
              Navigator.of(ctx).pop();
            }, child: const Text("Ok"),),
          ],
        );
      });
    }
  }
}
