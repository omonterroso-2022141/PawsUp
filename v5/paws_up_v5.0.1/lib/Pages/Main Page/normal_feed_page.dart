import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Publicacion {
  final String id;
  final String autor;
  final String descripcion;
  final String horaPublicado;
  final List<String> imagenes;
  final List<String> likes;
  final List<String> dislikes;
  final List<String> comentarios;

  Publicacion({
    required this.id,
    required this.autor,
    required this.descripcion,
    required this.horaPublicado,
    required this.imagenes,
    required this.likes,
    required this.dislikes,
    required this.comentarios,
  });

  factory Publicacion.fromJson(Map<String, dynamic> json) {
    return Publicacion(
      id: json['id'] ?? '',
      autor: json['autor'] ?? '',
      descripcion: json['descripcion'] ?? '',
      horaPublicado: json['horaPublicado'] ?? '',
      imagenes: json['imagenes'] != null
          ? List<String>.from(json['imagenes'])
          : [],
      likes: json['like'] != null ? List<String>.from(json['like']) : [],
      dislikes:
          json['dislike'] != null ? List<String>.from(json['dislike']) : [],
      comentarios: json['comentarios'] != null
          ? List<String>.from(json['comentarios'])
          : [],
    );
  }
}

Future<String> fetchImagenUrl(String imagen) async {
  final response = await http.get(Uri.parse(
      'https://back-paws-up-cloud.vercel.app/imagen/getImagen/$imagen'));
  if (response.statusCode == 200) {
    return json.decode(response.body)['result'];
  } else {
    throw Exception('Failed to load imagen URL');
  }
}

Future<List<Publicacion>> fetchPublicaciones() async {
  final response = await http.get(Uri.parse(
      'https://back-paws-up-cloud.vercel.app/Publicacion/viewPublicacion'));
  debugPrint(response.body);

  if (response.statusCode == 200) {
    final List<dynamic> publicacionesJson =
        json.decode(response.body)['publicacionesReestructuradas'];
    List<Publicacion> publicaciones = [];
    for (var json in publicacionesJson) {
      Publicacion publicacion = Publicacion.fromJson(json);
      List<String> imagenUrls = [];
      for (var imagen in publicacion.imagenes) {
        imagenUrls.add(await fetchImagenUrl(imagen));
      }
      publicaciones.add(Publicacion(
        id: publicacion.id,
        autor: publicacion.autor,
        descripcion: publicacion.descripcion,
        horaPublicado: publicacion.horaPublicado,
        imagenes: imagenUrls,
        likes: publicacion.likes,
        dislikes: publicacion.dislikes,
        comentarios: publicacion.comentarios,
      ));
    }
    return publicaciones;
  } else {
    throw Exception('Failed to load publicaciones');
  }
}

class NormalFeedPage extends StatefulWidget {
  const NormalFeedPage({super.key});

  @override
  _NormalFeedPageState createState() => _NormalFeedPageState();
}

class _NormalFeedPageState extends State<NormalFeedPage> {
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
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return PostWidget(
                          publicacion: snapshot.data![index],
                          onLike: () => _toggleLike(snapshot.data![index]),
                          onComment: () => _navigateToComments(
                              context, snapshot.data![index]),
                        );
                      },
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  void _toggleLike(Publicacion publicacion) {
    setState(() {
      if (publicacion.likes.contains('currentUserId')) {
        publicacion.likes.remove('currentUserId');
      } else {
        publicacion.likes.add('currentUserId');
      }
    });
  }

  void _navigateToComments(BuildContext context, Publicacion publicacion) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CommentsPage(publicacionId: publicacion.id),
      ),
    );
  }
}

class PostWidget extends StatefulWidget {
  final Publicacion publicacion;
  final VoidCallback onLike;
  final VoidCallback onComment;

  const PostWidget({
    super.key,
    required this.publicacion,
    required this.onLike,
    required this.onComment,
  });

  @override
  _PostWidgetState createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
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
                const CircleAvatar(
                  backgroundImage:
                      NetworkImage('https://via.placeholder.com/150'),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.publicacion.autor,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF5BFFD3),
                        fontSize: 18,
                        fontFamily: "Hey",
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(widget.publicacion.horaPublicado,
                        style:
                            const TextStyle(fontSize: 12, color: Colors.white)),
                  ],
                ),
                const Spacer(),
                Theme(
                  data: Theme.of(context).copyWith(
                    iconTheme: const IconThemeData(color: Color(0xFF5BFFD3)),
                  ),
                  child: PopupMenuButton<String>(
                    onSelected: (String value) {},
                    itemBuilder: (BuildContext context) {
                      return {'Reportar', 'Ocultar'}.map((String choice) {
                        return PopupMenuItem<String>(
                          value: choice,
                          child: Text(choice),
                        );
                      }).toList();
                    },
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(15)),
              child: Column(
                children: widget.publicacion.imagenes.map((imagenUrl) {
                  return Image.network(
                    imagenUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 430,
                    errorBuilder: (context, error, stackTrace) {
                      return const Image(
                        image: AssetImage('images/placeholder.png'),
                        width: double.infinity,
                        height: 430,
                        fit: BoxFit.cover,
                      );
                    },
                  );
                }).toList(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              widget.publicacion.descripcion,
              style: const TextStyle(
                  fontSize: 16, color: Colors.white, fontFamily: "Hey"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const FaIcon(FontAwesomeIcons.bone,
                          color: Color(0xFF5BFFD3)),
                      onPressed: widget.onLike,
                    ),
                    Text('${widget.publicacion.likes.length}',
                        style:
                            const TextStyle(fontSize: 15, color: Colors.white)),
                    const SizedBox(width: 16),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.share, color: Color(0xFF5BFFD3)),
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),
          _buildCommentSection(),
        ],
      ),
    );
  }

  Widget _buildCommentSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widget.publicacion.comentarios.map((comment) {
          return Text(
            comment,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          );
        }).toList(),
      ),
    );
  }
}

class CommentsPage extends StatefulWidget {
  final String publicacionId;

  const CommentsPage({super.key, required this.publicacionId});

  @override
  _CommentsPageState createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Comentarios'),
      ),
      body: Center(
        child: Text('Comentarios para la publicación ${widget.publicacionId}'),
      ),
    );
  }
}
