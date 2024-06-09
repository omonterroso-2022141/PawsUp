import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddPostPage extends StatefulWidget {
  const AddPostPage({super.key});

  @override
  _AddPostPageState createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController breedController = TextEditingController();
  String selectedCategory = 'Adoptar o Adopción';
  String selectedSex = '';
  String userToken = '';
  @override
  void initState() {
    super.initState();

    getUserToken();
  }

  void getUserToken() async {
    await Future.delayed(Duration(seconds: 5));
    setState(() {
      userToken = '';
    });
  }

  void sendPublicationData() async {
    if (userToken.isEmpty) {
      print('Token no disponible.');
      return;
    }

    // URL del endpoint para agregar publicaciones
    var url = Uri.parse(
        'https://back-paws-up-cloud.vercel.app/Publicacion/addPublicacion');

    try {
      var headers = {'Authorization': 'Bearer $userToken', 'Accept': '*/*'};

      var request = http.MultipartRequest('POST', url)
        ..fields['autor'] = userToken
        ..fields['descripcion'] = descriptionController.text;

      request.headers.addAll(headers);

      var response = await request.send();

      if (response.statusCode == 200) {
        print('Publicación exitosa');

        var responseData = await response.stream.bytesToString();
        print(responseData);
      } else {
        print('Error al publicar: ${response.reasonPhrase}');
        var responseData = await response.stream.bytesToString();
        print(responseData);
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Publicación'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Título'),
            ),
            TextFormField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Descripción'),
            ),
            TextFormField(
              controller: breedController,
              decoration: const InputDecoration(labelText: 'Raza del Animal'),
            ),
            DropdownButtonFormField<String>(
              value: selectedCategory,
              items: ['Adoptar o Adopción', 'Vida Cotidiana', 'Otros']
                  .map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedCategory = newValue!;
                });
              },
              decoration: const InputDecoration(labelText: 'Categoría'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ChoiceChip(
                  label: const Text('Macho'),
                  selected: selectedSex == 'Macho',
                  onSelected: (bool selected) {
                    setState(() {
                      selectedSex = selected ? 'Macho' : '';
                    });
                  },
                ),
                ChoiceChip(
                  label: const Text('Hembra'),
                  selected: selectedSex == 'Hembra',
                  onSelected: (bool selected) {
                    setState(() {
                      selectedSex = selected ? 'Hembra' : '';
                    });
                  },
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                sendPublicationData();
              },
              child: const Text('Publicar'),
            ),
          ],
        ),
      ),
    );
  }
}
