import 'package:flutter/material.dart';
import 'RegisterForm.dart';

class Information extends StatelessWidget {
  const Information({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.black,
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: Stack(
                children: [
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: MediaQuery.of(context).size.height * 0.30,
                    child: Container(
                      padding: const EdgeInsets.all(20.0),
                      color: Colors.transparent,
                      child: const Text(
                        'Información importante para los usuarios.',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Hey',
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: MediaQuery.of(context).size.height * 0.05,
                    child: Container(
                      padding: const EdgeInsets.all(20.0),
                      color: Colors.transparent,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RegisterForm()),
                          );
                        },
                        child: const Text(
                          'Si necesita ayuda, haga clic aquí para registrarse.',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Hey',
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
