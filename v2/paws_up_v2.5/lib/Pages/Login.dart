import 'package:flutter/material.dart';

import 'RegisterForm.dart';
import 'login_form.dart';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.black,
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: Stack(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(
                            'https://github.com/jrosselin-2022050/IMG_PAWSUP/blob/main/fonde.png?raw=true'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    left: MediaQuery.of(context).size.width * 0.03,
                    right: MediaQuery.of(context).size.width * 0.03,
                    top: MediaQuery.of(context).size.height * 0.02,
                    child: Container(
                      alignment: Alignment.topCenter,
                      child: Image.network(
                        'https://github.com/jrosselin-2022050/IMG_PAWSUP/blob/main/logos.png?raw=true',
                        width: MediaQuery.of(context).size.width * 0.5,
                        height: MediaQuery.of(context).size.width * 0.5,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    top: MediaQuery.of(context).size.height * 0.19,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      alignment: Alignment.center,
                      child: Text(
                        'PawsUp',
                        style: TextStyle(
                          color: const Color(0xFFFFFFFF),
                          fontSize: MediaQuery.of(context).size.width * 0.28,
                          fontFamily: 'Meow',
                          letterSpacing: 6.0,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: MediaQuery.of(context).size.height * 0.30,
                    child: Container(
                      padding: const EdgeInsets.all(20.0),
                      color: Colors.transparent,
                      child: const LoginForm(),
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
                                builder: (context) => const RegisterForm()),
                          );
                        },
                        child: const Text(
                          '¿No tienes una cuenta? Regístrate',
                          style:
                              TextStyle(color: Colors.white, fontFamily: 'Hey'),
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
