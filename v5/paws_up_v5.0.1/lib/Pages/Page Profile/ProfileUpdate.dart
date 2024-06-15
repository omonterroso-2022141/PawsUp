import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'Settings.dart';

class ProfileUpdate extends StatelessWidget {
  const ProfileUpdate({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: const Locale('es', 'ES'),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('es', 'ES'),
      ],
      home: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
              );
            },
          ),
          title: Text(
            'Actualizar Perfil',
            style: TextStyle(
              color: Colors.white,
              fontSize: MediaQuery.of(context).size.width * 0.08,
              fontFamily: 'Meow',
              letterSpacing: 6.0,
            ),
          ),
          centerTitle: true,
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
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
                    left: 0,
                    right: 0,
                    top: MediaQuery.of(context).size.height * 0.03,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      alignment: Alignment.center,
                      child: GestureDetector(
                        onTap: () async {
                          final picker = ImagePicker();
                          final pickedFile = await picker.pickImage(
                              source: ImageSource.gallery);
                          if (pickedFile != null) {}
                        },
                        child: CircleAvatar(
                          radius: MediaQuery.of(context).size.width * 0.15,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.add_a_photo,
                            size: MediaQuery.of(context).size.width * 0.1,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    top: MediaQuery.of(context).size.height *
                        0.22, // Ajuste la posición aquí
                    child: const Padding(
                      padding: EdgeInsets.all(20.0),
                      child: ProfileUpdateForms(),
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

class ProfileUpdateForms extends StatefulWidget {
  const ProfileUpdateForms({super.key});

  @override
  _ProfileUpdateFormsState createState() => _ProfileUpdateFormsState();
}

class _ProfileUpdateFormsState extends State<ProfileUpdateForms> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nombreController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;
  String? _feedbackMessage;

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null) {
      final response = await http.get(
        Uri.parse('https://back-paws-up-cloud.vercel.app/User/miPerfil'),
        headers: {'Authorization': token},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['user'];
        setState(() {
          _nombreController.text = data['nombre'];
          _usernameController.text = data['username'];
          _emailController.text = data['email'];
          _selectedDate = DateTime.parse(data['edad']);
        });
      } else {
        setState(() {
          _feedbackMessage = 'Error al cargar el perfil';
        });
      }
    } else {
      setState(() {
        _feedbackMessage = 'No se encontró el token de autenticación';
      });
    }
  }

  Future<void> _updateUserProfile() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _feedbackMessage = null;
      });

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token != null) {
        final response = await http.put(
          Uri.parse('https://back-paws-up-cloud.vercel.app/User/updateUser'),
          headers: {
            'Authorization': token,
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'nombre': _nombreController.text,
            'username': _usernameController.text,
            'email': _emailController.text,
            'edad': _selectedDate.toIso8601String(),
          }),
        );

        if (response.statusCode == 200) {
          setState(() {
            _isLoading = false;
            _feedbackMessage = 'Perfil actualizado exitosamente';
          });
        } else {
          setState(() {
            _isLoading = false;
            _feedbackMessage =
                'Error al actualizar el perfil: ${response.body}';
          });
        }
      } else {
        setState(() {
          _isLoading = false;
          _feedbackMessage = 'Error de autenticación: Token no encontrado';
        });
      }
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      locale: const Locale('es', 'ES'),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          if (_feedbackMessage != null) ...[
            Text(
              _feedbackMessage!,
              style: TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 10.0),
          ],
          TextFormField(
            controller: _usernameController,
            style: const TextStyle(color: Colors.black, fontFamily: 'Hey'),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              hintText: 'Usuario',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50.0),
                borderSide: const BorderSide(width: 2.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50.0),
                borderSide:
                    const BorderSide(width: 3.0, color: Color(0xFF5BFFD3)),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, ingrese un usuario';
              }
              return null;
            },
          ),
          const SizedBox(height: 20.0),
          TextFormField(
            controller: _nombreController,
            style: const TextStyle(color: Colors.black, fontFamily: 'Hey'),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              hintText: 'Nombre y Apellido',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50.0),
                borderSide: const BorderSide(width: 2.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50.0),
                borderSide:
                    const BorderSide(width: 3.0, color: Color(0xFF5BFFD3)),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, ingrese su nombre y apellido';
              }
              return null;
            },
          ),
          const SizedBox(height: 20.0),
          TextFormField(
            controller: _emailController,
            style: const TextStyle(color: Colors.black, fontFamily: 'Hey'),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              hintText: 'Correo Electrónico',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50.0),
                borderSide: const BorderSide(width: 2.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50.0),
                borderSide:
                    const BorderSide(width: 3.0, color: Color(0xFF5BFFD3)),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, ingrese su correo electrónico';
              }
              return null;
            },
          ),
          const SizedBox(height: 20.0),
          Container(
            width: 300.0,
            height: 50.0,
            child: ElevatedButton(
              onPressed: () => _selectDate(context),
              child: Text(
                'Fecha de Nacimiento: ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                style: const TextStyle(color: Colors.black, fontFamily: 'Hey'),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5BFFD3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.0),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: _isLoading ? null : _updateUserProfile,
            child: const Text(
              'Actualizar Perfil',
              style: TextStyle(color: Colors.black, fontFamily: 'Hey'),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF5BFFD3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
