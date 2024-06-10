import 'package:flutter/material.dart';

class AdoptionFeedProfile extends StatelessWidget {
  const AdoptionFeedProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
                'https://github.com/jrosselin-2022050/IMG_PAWSUP/blob/main/fondebb.png?raw=true'), // Ruta a tu imagen de fondo
            fit: BoxFit.cover,
          ),
        ),
        child: const Center(
          child: Text(
            'Adoption Feed Profile',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors
                  .white, // Ajusta el color del texto para que sea visible
            ),
          ),
        ),
      ),
    );
  }
}
