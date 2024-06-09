import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_page.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool _obscureText = true;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _response = '';

  Future<void> _login() async {
    final response = await http.post(
      Uri.parse('http://0.0.0.0/User/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'username': _usernameController.text,
        'password': _passwordController.text,
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _response = 'Login successful: ${data['message']}';
      });

      // Almacenar el token después de iniciar sesión
      final token = data['token'];
      print('Token recibido: $token');
      await _saveToken(token);

      // Verificar si el widget aún está montado antes de realizar acciones que dependan del contexto
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      }
    } else {
      setState(() {
        _response = 'Error: ${response.statusCode}';
      });
    }
  }

  Future<void> _saveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    print('Token guardado: $token');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextField(
            controller: _usernameController,
            style: const TextStyle(color: Colors.black, fontFamily: 'Hey'),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              hintText: 'Usuario/Correo Electrónico',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50.0),
                borderSide: const BorderSide(width: 2.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50.0),
                borderSide:
                    const BorderSide(width: 3.0, color: Color(0xFF5BFFD3)),
              ),
              prefixIcon: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.network(
                  'https://github.com/jrosselin-2022050/IMG_PAWSUP/blob/main/userl.png?raw=true',
                  width: 1,
                  height: 1,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20.0),
          TextFormField(
            controller: _passwordController,
            style: const TextStyle(color: Colors.black, fontFamily: 'Hey'),
            obscureText: _obscureText,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              hintText: 'Contraseña',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50.0),
                borderSide: const BorderSide(width: 2.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50.0),
                borderSide:
                    const BorderSide(width: 3.0, color: Color(0xFF5BFFD3)),
              ),
              prefixIcon: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.network(
                  'https://github.com/jrosselin-2022050/IMG_PAWSUP/blob/main/pass.png?raw=true',
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
                    NetworkImage(
                      _obscureText
                          ? 'https://github.com/jrosselin-2022050/IMG_PAWSUP/blob/main/off.png?raw=true'
                          : 'https://github.com/jrosselin-2022050/IMG_PAWSUP/blob/main/on.png?raw=true',
                    ),
                    color: const Color(0xFF5BFFD3),
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
          const SizedBox(height: 25.0),
          Container(
            constraints: const BoxConstraints(maxWidth: 250.0),
            width: double.infinity,
            child: MaterialButton(
              onPressed: _login,
              color: const Color(0xFF5BFFD3),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.0),
              ),
              child: const Text(
                'Iniciar sesión',
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.black,
                  fontFamily: 'Hey',
                ),
              ),
            ),
          ),
          const SizedBox(height: 20.0),
          Text(
            _response,
            style: const TextStyle(color: Colors.red, fontFamily: 'Hey'),
          ),
        ],
      ),
    );
  }
}
