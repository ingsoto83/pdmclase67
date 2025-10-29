import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isPasswordVisible = false;
  final _formKey = GlobalKey<FormState>();
  String user = '';
  String pass = '';
  final FirebaseAuth _mAuth= FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
        backgroundColor: Colors.indigoAccent,
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          children: [
            Padding(
                padding: EdgeInsets.all(16),
                child: FlutterLogo(size: 120,),
            ),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                child: TextFormField(
                  validator: (value)=> value!.isEmpty ? "Debes proporcionar tu correo..." : !value.contains("@") ? "Correo Inválido..." : null,
                  onSaved: (value)=> user = value??'',
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email, color: Colors.indigoAccent,),
                    labelText: "Usuario",
                    labelStyle: TextStyle(color: Colors.indigoAccent),
                    isDense: true,
                    border: OutlineInputBorder(
                      //borderRadius: BorderRadius.all(Radius.elliptical(20, 20)),
                      gapPadding: 10
                    ),
                    focusedBorder: OutlineInputBorder(
                        //borderRadius: BorderRadius.all(Radius.elliptical(20, 20)),
                        borderSide: BorderSide(color: Colors.deepOrange),
                      gapPadding: 10
                    )
                  ),
                )
            ),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: TextFormField(
                  validator: (value)=> value!.isEmpty ? "Debes proporcionar tu contraseña..." : value.length<6 ? "Debe ser mínimo 6 caracteres..." : null,
                  onSaved: (value)=> pass = value??'',
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email, color: Colors.indigoAccent,),
                    suffix: GestureDetector(
                        onTap: (){
                          _isPasswordVisible = !_isPasswordVisible;
                          setState(() {
                          });
                        },
                        child: Icon(_isPasswordVisible ? Icons.visibility_off : Icons.visibility, color: Colors.indigoAccent,)
                    ),
                    labelText: "Contraseña",
                    labelStyle: TextStyle(color: Colors.indigoAccent),
                    isDense: true,
                    border: OutlineInputBorder(
                      //borderRadius: BorderRadius.all(Radius.elliptical(20, 20)),
                      gapPadding: 10
                    ),
                    focusedBorder: OutlineInputBorder(
                        //borderRadius: BorderRadius.all(Radius.elliptical(20, 20)),
                        borderSide: BorderSide(color: Colors.deepOrange),
                      gapPadding: 10
                    )
                  ),
                )
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Container(
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80)),
                    padding: EdgeInsets.all(0)
                  ),
                    onPressed: (){
                      FocusScope.of(context).unfocus();
                      login();
                    },
                    child: Ink(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [Colors.blue, Colors.black],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight
                        ),
                        borderRadius: BorderRadius.circular(30)
                      ),
                      child: Container(
                        constraints: BoxConstraints(minHeight: 50),
                        alignment: Alignment.center,
                        child: Text("Iniciar sesión", textAlign: TextAlign.center, style: TextStyle(color:Colors.white),),
                      ),
                    )
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void login() async{
    if(_formKey.currentState!.validate()){
      _formKey.currentState!.save();
      //Navigator.push(context, MaterialPageRoute(builder: (context)=> HomePage()));
      //Navigator.pop(context);
      try{
       await _mAuth.signInWithEmailAndPassword(email: user, password: pass);
      }on FirebaseAuthException catch(e){
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                backgroundColor: Colors.red,
                content: Row(
                  children: [
                    Icon(Icons.error, color: Colors.white,),
                    SizedBox(width: 10,),
                    Expanded(child: Text(e.toString(), style: TextStyle(fontSize: 16, color: Colors.white),))
                  ]
                )
            )
        );
      }
    }
  }
}
