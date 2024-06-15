import 'package:flutter/material.dart';
import 'package:prueba2/services/firestore.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

final FirestoreService firestoreService =FirestoreService();
final TextEditingController textController =TextEditingController();

void OpenNotes(){
  showDialog(
    context: context,
     builder: (context)=> AlertDialog(
         title: Text('Notas'),
         content: TextField(
           controller: textController,
         ),         
         actions: [
          ElevatedButton(
            onPressed: (){
              firestoreService.addNote(textController.text);
              textController.clear();
              Navigator.pop(context);
            } ,
            child: Text("Agregar")
          )
         ],
     )
     );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inicio')),
        floatingActionButton: FloatingActionButton(
          onPressed: OpenNotes,
          child: const Icon(Icons.add),
        )      
    );
  }
}