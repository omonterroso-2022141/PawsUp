import 'package:flutter/material.dart';
import 'RegisterForm.dart';


void main() {
  runApp(MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black,
        body: GestureDetector(
          onTap: () {
            // Al tocar en cualquier parte de la pantalla, se perderá el foco del campo de texto
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('images/fonde.png'),
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
                      child: Image.asset(
                        'images/logos.png',
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
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      alignment: Alignment.center,
                      child: Text(
                        'PawsUp',
                        style: TextStyle(
                          color: Color(0xFFFFFFFF),
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
                    bottom: MediaQuery.of(context).size.height * 0.35,
                    child: Container(
                      padding: EdgeInsets.all(20.0),
                      color: Colors.transparent,
                      child: LoginForm(),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: MediaQuery.of(context).size.height * 0.05,
                    child: Container(
                      padding: EdgeInsets.all(20.0),
                      color: Colors.transparent,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => RegisterForm()),
                          );
                        },
                        child: Text(
                          '¿No tienes una cuenta? Regístrate',
                          style: TextStyle(color: Colors.white, fontFamily: 'Hey'),
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


class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextField(
            style: TextStyle(color: Colors.black, fontFamily: 'Hey'),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              hintText: 'Usuario/Correo Electronico',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50.0),
                borderSide: BorderSide(width: 2.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50.0),
                borderSide: BorderSide(width: 3.0, color: Color(0xFF5BFFD3)),
              ),
              prefixIcon: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  'images/userl.png',
                  width: 1,
                  height: 1,
                ),
              ),
            ),
          ),
          SizedBox(height: 20.0),
          TextFormField(
            style: TextStyle(color: Colors.black, fontFamily: 'Hey'),
            obscureText: _obscureText,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              hintText: 'Contraseña',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50.0),
                borderSide: BorderSide(width: 2.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50.0),
                borderSide: BorderSide(width: 3.0, color: Color(0xFF5BFFD3)),
              ),
              prefixIcon: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  'images/pass.png',
                  width: 10,
                  height: 10,
                ),
              ),
              suffixIcon: Container(
                width: 40.0,
                height: 40.0,
                child: IconButton(
                  iconSize: 24.0,
                  icon: ImageIcon(
                    AssetImage(_obscureText ? 'images/off.png' : 'images/on.png'),
                    color: Color(0xFF5BFFD3),
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                ),
              ),
            ),
          ),
          SizedBox(height: 25.0),
          Container(
            constraints: BoxConstraints(maxWidth: 250.0),
            width: double.infinity,
            child: MaterialButton(
              onPressed: () {
                // Aquí puedes manejar la lógica para verificar el usuario y contraseña
              },
              color: Color(0xFF5BFFD3),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.0),
              ),
              child: Text(
                'Iniciar sesión',
                style: TextStyle(fontSize: 18.0, color: Colors.black, fontFamily: 'Hey'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
