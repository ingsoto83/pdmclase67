import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  final FirebaseAuth _mAuth= FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Screen"),
        backgroundColor: Colors.indigoAccent,
        foregroundColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
                onPressed: ()=>_mAuth.signOut(),
                child: Icon(Icons.logout)),
          )
        ],
      ),
      body: Center(
        child: Text("Bienvenido ${_mAuth.currentUser?.email??"..."}"),
      ),
    );
  }
}
