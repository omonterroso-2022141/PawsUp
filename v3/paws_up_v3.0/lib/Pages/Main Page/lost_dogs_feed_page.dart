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
      id: json['_id'] ?? '',
      autor: json['autor'] ?? '',
      descripcion: json['descripcion'] ?? '',
      horaPublicado: json['horaPublicado'] ?? '',
      imagenes:
          json['imagenes'] != null ? List<String>.from(json['imagenes']) : [],
      likes: json['like'] != null ? List<String>.from(json['like']) : [],
      dislikes:
          json['dislike'] != null ? List<String>.from(json['dislike']) : [],
      comentarios: json['comentarios'] != null
          ? List<String>.from(json['comentarios'])
          : [],
    );
  }
}

Future<List<Publicacion>> fetchPublicaciones() async {
  final response = await http.get(Uri.parse(
      'https://back-paws-up-cloud.vercel.app/Publicacion/viewPublicacion'));
  debugPrint(response.body);

  if (response.statusCode == 200) {
    final List<dynamic> publicacionesJson =
        json.decode(response.body)['publicacionesReestructuradas'];
    return publicacionesJson.map((json) => Publicacion.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load publicaciones');
  }
}

class LostDogsFeedPage extends StatefulWidget {
  const LostDogsFeedPage({super.key});

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
                        color: Colors.white,
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
              child: Image.network(
                widget.publicacion.imagenes.isNotEmpty
                    ? widget.publicacion.imagenes[0]
                    : 'https://via.placeholder.com/400x300',
                fit: BoxFit.cover,
                width: double.infinity,
                height: 430,
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
                    IconButton(
                      icon: const Icon(Icons.comment_outlined,
                          color: Color(0xFF5BFFD3)),
                      onPressed: widget.onComment,
                    ),
                    Text('${widget.publicacion.comentarios.length}',
                        style:
                            const TextStyle(fontSize: 15, color: Colors.white)),
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
            style: const TextStyle(color: Colors.white),
          );
        }).toList(),
      ),
    );
  }
}

class CommentsPage extends StatefulWidget {
  final String publicacionId;

  CommentsPage({required this.publicacionId});

  @override
  _CommentsPageState createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late TextEditingController _commentController;
  List<dynamic> _comments = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
    _controller.forward();
    _commentController = TextEditingController();
    fetchComments();
  }

  Future<void> fetchComments() async {
    try {
      final response = await http.get(Uri.parse(
          'https://back-paws-up-cloud.vercel.app/Comentario/viewComentarioOfPublicacion/${widget.publicacionId}'));
      if (response.statusCode == 200) {
        setState(() {
          _comments = json.decode(response.body)['comentarios'];
        });
      } else {
        throw Exception('Failed to load comments');
      }
    } catch (error) {
      print(error);
    }
  }

  Future<void> addComment(String commentText) async {
    try {
      final response = await http.post(
        Uri.parse(
            'https://back-paws-up-cloud.vercel.app/Comentario/addComentario/${widget.publicacionId}'),
        body: {'descripcion': commentText},
      );
      if (response.statusCode == 200) {
        fetchComments(); // Refresh comments after adding a new one
      } else {
        throw Exception('Failed to add comment');
      }
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Comentarios',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FadeTransition(
        opacity: _animation,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _comments.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CircleAvatar(
                          backgroundImage: const NetworkImage(
                              'https://via.placeholder.com/150'),
                          radius: 20.0,
                        ),
                        const SizedBox(width: 10.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Usuario ${_comments[index]['autor']}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 5.0),
                              Text(
                                _comments[index]['descripcion'],
                                style: const TextStyle(color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const Divider(height: 1.0, color: Colors.grey),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  const CircleAvatar(
                    backgroundImage:
                        NetworkImage('https://via.placeholder.com/150'),
                    radius: 20.0,
                  ),
                  const SizedBox(width: 10.0),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: TextField(
                          controller: _commentController,
                          decoration: InputDecoration(
                            hintText: 'Añadir un comentario...',
                            border: InputBorder.none,
                            hintStyle: TextStyle(color: Colors.grey.shade600),
                          ),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send, color: Colors.blue),
                    onPressed: () {
                      String commentText = _commentController.text.trim();
                      if (commentText.isNotEmpty) {
                        addComment(commentText);
                        _commentController.clear();
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
