import 'package:flutter/material.dart';
import 'post_widget.dart';

class FeedPage extends StatelessWidget {
  const FeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(
              'https://github.com/jrosselin-2022050/IMG_PAWSUP/blob/main/fonde.png?raw=true'), // Ruta de la imagen
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        color: Colors.black.withOpacity(0.5), // Fondo semi-transparente
        child: ListView.builder(
          itemCount: 10,
          itemBuilder: (context, index) {
            return const PostWidget();
          },
        ),
      ),
    );
  }
}
