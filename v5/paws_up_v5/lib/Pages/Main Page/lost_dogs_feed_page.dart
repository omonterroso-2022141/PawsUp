import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Publicacion {
  final String id;
  final String autor;
  final String horaPublicado;
  final String nombre;
  final String edad;
  final String imagen;
  final String descripcion;
  final String sexo;

  Publicacion({
    required this.id,
    required this.autor,
    required this.horaPublicado,
    required this.nombre,
    required this.edad,
    required this.imagen,
    required this.descripcion,
    required this.sexo,
  });

  factory Publicacion.fromJson(Map<String, dynamic> json) {
    return Publicacion(
      id: json['_id']?.toString() ?? '',
      autor: json['tutor']?.toString() ?? '',
      horaPublicado: json['horaPublicado']?.toString() ?? '',
      nombre: json['nombre']?.toString() ?? '',
      edad: json['edad']?.toString() ?? '',
      imagen: json['imagen']?.toString() ?? '',
      descripcion: json['descripcion']?.toString() ?? '',
      sexo: json['sexo']?.toString() ?? '',
    );
  }
}

Future<List<Publicacion>> fetchPublicaciones() async {
  final response = await http.get(
      Uri.parse('https://back-paws-up-cloud.vercel.app/Mascota/viewMascota'));

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);

    if (data['mascotas'] is List) {
      final List<dynamic> mascotasJson = data['mascotas'];
      return mascotasJson.map((json) => Publicacion.fromJson(json)).toList();
    } else {
      throw Exception('La respuesta no contiene una lista de mascotas');
    }
  } else {
    throw Exception('Failed to load mascotas');
  }
}

class LostDogsFeedPage extends StatefulWidget {
  const LostDogsFeedPage({Key? key}) : super(key: key);

  @override
  _LostDogsFeedPageState createState() => _LostDogsFeedPageState();
}

class _LostDogsFeedPageState extends State<LostDogsFeedPage> {
  late Future<List<Publicacion>> futurePublicaciones;

  @override
  void initState() {
    super.initState();
    futurePublicaciones = fetchPublicaciones();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/fondebb.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: FutureBuilder<List<Publicacion>>(
          future: futurePublicaciones,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No hay publicaciones'));
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return PostWidget(
                    publicacion: snapshot.data![index],
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}

class PostWidget extends StatelessWidget {
  final Publicacion publicacion;

  const PostWidget({
    required this.publicacion,
  });

  String formatDate(String dateStr) {
    try {
      DateTime dateTime = DateTime.parse(dateStr);
      return "${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute}";
    } catch (e) {
      return dateStr; // return the original string if parsing fails
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black,
      margin: const EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(
                    publicacion.imagen.isNotEmpty
                        ? publicacion.imagen
                        : 'https://via.placeholder.com/150',
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      publicacion.autor,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 8,
                        fontFamily: "Hey",
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(15)),
              child: Image.network(
                publicacion.imagen.isNotEmpty
                    ? publicacion.imagen
                    : 'https://via.placeholder.com/400x300',
                fit: BoxFit.cover,
                width: double.infinity,
                height: 250,
                // Adjusted height to avoid potential issues
                loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              (loadingProgress.expectedTotalBytes ?? 1)
                          : null,
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Image.network('https://via.placeholder.com/400x300');
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Mascota: ',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF5BFFD3), // Color rojo
                          fontFamily: "Hey",
                        ),
                      ),
                      TextSpan(
                        text: publicacion.nombre,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white, // Color blanco
                          fontFamily: "Hey",
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  publicacion.descripcion,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontFamily: "Hey",
                  ),
                ),
                const SizedBox(height: 10),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Fecha: ',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF5BFFD3),
                          fontFamily: "Hey",
                        ),
                      ),
                      TextSpan(
                        text: formatDate(publicacion.horaPublicado),
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontFamily: "Hey",
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Edad: ',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF5BFFD3),
                          fontFamily: "Hey",
                        ),
                      ),
                      TextSpan(
                        text: publicacion.edad,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontFamily: "Hey",
                        ),
                      ),
                    ],
                  ),
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Sexo: ',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF5BFFD3),
                          fontFamily: "Hey",
                        ),
                      ),
                      TextSpan(
                        text: publicacion.sexo,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontFamily: "Hey",
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
