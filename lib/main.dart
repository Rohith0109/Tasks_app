import 'package:firebase/screens/home_screen.dart';
import 'package:firebase/screens/login_screen.dart';
import 'package:firebase/screens/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initFirebase();
  runApp(
    MyApp(),
  );
}

Future<void> initFirebase() async {
  await Firebase.initializeApp();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.red,
        brightness: Brightness.light
      ),
      darkTheme: ThemeData(
        primaryColor: Colors.red,
        brightness: Brightness.dark
      ),
      home: const SplashScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});


  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  var auth = FirebaseAuth.instance;
  bool _isSignedIn = false;

  @override
  void initState(){
    super.initState();
    checkLoginStatus();
  }

  checkLoginStatus() async {
    auth.authStateChanges().listen((User?user) {
      if (user!=null && mounted){
        setState(() {
          _isSignedIn = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<FirebaseApp>(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (_isSignedIn) {
              return const HomeScreen();
            } else {
              return const LoginScreen();
            }
          } else {
            return Center(child: const CircularProgressIndicator());
          }

        },
      ),// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
