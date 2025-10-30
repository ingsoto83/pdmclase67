import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  final FirebaseAuth _mAuth= FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> messagesStream =
    _db.collection("messages").snapshots(includeMetadataChanges: true);

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
      /*floatingActionButton: FloatingActionButton(
          onPressed: ()=>_sendMessage(),
          backgroundColor: Colors.orange,
          foregroundColor: Colors.white,
          child: Icon(Icons.add, color: Colors.white,),
      ),*/
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
                stream: messagesStream,
                builder: (context, snapshot) {
                  if(snapshot.hasError){
                    return Center(child: Text("Error al cargar los mensajes"));
                  }
                  if(snapshot.connectionState==ConnectionState.waiting){
                    return Center(child: CircularProgressIndicator());
                  }
                  final docs = snapshot.data!.docs;
                  if(docs.isEmpty){
                    return Center(child: Text("No hay mensajes"));
                  }
                  return ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (context, index){
                      return ListTile(
                        title: Text(docs[index]["senderEmail"]),
                        subtitle: Text(docs[index]["message"]),
                      );
                    }
                  );


                })

          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 15, top: 5, left: 16, right: 16),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      )
                    )
                  ),
                ),
                ElevatedButton(
                  onPressed: ()=>_sendMessage(),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(50, 60),
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(
                      )
                    )
                    ),
                  child: Icon(Icons.send, color: Colors.black,)
                )
              ]
            ),
          ),
        ],
      )
    );
  }

  void _sendMessage() async{
    CollectionReference messagesRef = _db.collection("messages");
    Map<String,dynamic> data = {};
    data["senderEmail"]= _mAuth.currentUser?.email;
    data["message"]="Hola desde app flutter";
    data["creationDate"]=  FieldValue.serverTimestamp();
    await messagesRef.add(data);
  }
}

