import 'package:flutter/material.dart';

class PhoneSignInScreen extends StatefulWidget {
  const PhoneSignInScreen({Key? key}) : super(key: key);

  @override
  State<PhoneSignInScreen> createState() => _PhoneSignInScreenState();
}

class _PhoneSignInScreenState extends State<PhoneSignInScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Phone signup"),
        backgroundColor: Colors.red,
      ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [

            ],
          ),
        ),
      ),
    );
  }
}
