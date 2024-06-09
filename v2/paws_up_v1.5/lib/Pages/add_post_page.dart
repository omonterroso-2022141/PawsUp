import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddPostPage extends StatefulWidget {
  const AddPostPage({Key? key}) : super(key: key);

  @override
  _AddPostPageState createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  Future<void> addPost() async {
    final url =
        Uri.parse('https://back-paws-up-cloud.vercel.app/addPublicacion');

    try {
      final response = await http.post(
        url,
        body: json.encode({
          'titulo': titleController.text,
          'descripcion': descriptionController.text,
          // Aquí puedes incluir más campos de datos según sea necesario
        }),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // Manejar la respuesta del servidor
        print('Publicación agregada con éxito');
      } else {
        // Manejar el error
        print('Error al agregar la publicación: ${response.reasonPhrase}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar Publicación'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Título'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Descripción'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: addPost,
              child: Text('Publicar'),
            ),
          ],
        ),
      ),
    );
  }
}
