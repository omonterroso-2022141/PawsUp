import 'package:flutter/material.dart';
import 'post_widget.dart';

class FeedPage extends StatelessWidget {
  const FeedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/fonde.png'), // Ruta de la imagen
          fit: BoxFit.cover,
        ),
      ),
      child: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return PostWidget();
        },
      ),
    );
  }
}

