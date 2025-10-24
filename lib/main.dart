import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pdmclase67/pages/home_page.dart';
import 'package:pdmclase67/pages/login_page.dart';

import 'config/firebase_options.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MaterialApp(
      title: "EjemploFirebase",
      home: AuthStream(),
    )
  );
}

class AuthStream extends StatefulWidget{

  const AuthStream({super.key});

  @override
  State<AuthStream> createState() => _AuthStreamState();
}

class _AuthStreamState extends State<AuthStream> {
  final FirebaseAuth _mAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context){
    return StreamBuilder(
      stream: _mAuth.authStateChanges(),
      builder: (context, snapshot){
        if(snapshot.connectionState == ConnectionState.waiting){
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        if(snapshot.hasData){
          return HomePage();
        }else{
          return LoginPage();
        }
      }
    );
  }
}
