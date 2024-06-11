import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
   await Firebase.initializeApp();   
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter CRUD con Firebase',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ItemList(),
      routes: {
        '/create': (context) => ItemForm(),
        '/update': (context) => ItemForm(itemId: ModalRoute.of(context)!.settings.arguments as String?),
      },
    );
  }
}

class ItemList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Items'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, '/create');
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('items').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          return ListView(
            children: snapshot.data!.docs.map((document) {
              return ListTile(
                title: Text(document['nombre']),
                subtitle: Text('${document['especialidad']}, ${document['horarios']} - Disponibilidad: ${document['disponibilidad']}'),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    deleteItem(document.id);
                  },
                ),
                onTap: () {
                  Navigator.pushNamed(context, '/update', arguments: document.id);
                },
              );
            }).toList(),
          );
        },
      ),
    );
  }

  void deleteItem(String id) {
    FirebaseFirestore.instance.collection('items').doc(id).delete();
  }
}

class ItemForm extends StatelessWidget {
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController horariosController = TextEditingController();
  final TextEditingController especialidadController = TextEditingController();
  final TextEditingController disponibilidadController = TextEditingController();
  final String? itemId;

  ItemForm({this.itemId});

  @override
  Widget build(BuildContext context) {
    if (itemId != null) {
      // Cargar datos para actualizar
      FirebaseFirestore.instance.collection('items').doc(itemId).get().then((document) {
        nombreController.text = document['nombre'];
        horariosController.text = document['horarios'];
        especialidadController.text = document['especialidad'];
        disponibilidadController.text = document['disponibilidad'];
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(itemId == null ? 'Crear Item' : 'Actualizar Item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nombreController,
              decoration: InputDecoration(labelText: 'Nombre'),
            ),
            TextField(
              controller: horariosController,
              decoration: InputDecoration(labelText: 'Horarios'),
            ),
            TextField(
              controller: especialidadController,
              decoration: InputDecoration(labelText: 'Especialidad'),
            ),
            TextField(
              controller: disponibilidadController,
              decoration: InputDecoration(labelText: 'Disponibilidad'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (itemId == null) {
                  createItem(
                    nombreController.text,
                    horariosController.text,
                    especialidadController.text,
                    disponibilidadController.text,
                  );
                } else {
                  updateItem(
                    itemId!,
                    nombreController.text,
                    horariosController.text,
                    especialidadController.text,
                    disponibilidadController.text,
                  );
                }
                Navigator.pop(context);
              },
              child: Text(itemId == null ? 'Crear' : 'Actualizar'),
            ),
          ],
        ),
      ),
    );
  }

  void createItem(String nombre, String horarios, String especialidad, String disponibilidad) {
    FirebaseFirestore.instance.collection('items').add({
      'nombre': nombre,
      'horarios': horarios,
      'especialidad': especialidad,
      'disponibilidad': disponibilidad,
    });
  }

  void updateItem(String id, String nombre, String horarios, String especialidad, String disponibilidad) {
    FirebaseFirestore.instance.collection('items').doc(id).update({
      'nombre': nombre,
      'horarios': horarios,
      'especialidad': especialidad,
      'disponibilidad': disponibilidad,
    });
  }
}
