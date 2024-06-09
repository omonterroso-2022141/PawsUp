import 'package:flutter/material.dart';

class NormalFeedPage extends StatelessWidget {
  const NormalFeedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("images/fondebb.png"), // Ruta a tu imagen de fondo
          fit: BoxFit.cover,
        ),
      ),
      child: Center(
        child: Text('Normal Feed Page'),
      ),
    );
  }
}
