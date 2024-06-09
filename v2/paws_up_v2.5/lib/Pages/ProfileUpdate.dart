import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: const Locale('es', 'ES'),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('es', 'ES'),
      ],
      home: ProfileUpdate(),
    );
  }
}

class ProfileUpdate extends StatefulWidget {
  @override
  _ProfileUpdateState createState() => _ProfileUpdateState();
}

class _ProfileUpdateState extends State<ProfileUpdate> {
  File? _profileImage;

  Future<void> _pickImage(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('images/fonde.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  top: MediaQuery.of(context).size.height * 0.06,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    alignment: Alignment.center,
                    child: Text(
                      'Actualizar perfil',
                      style: TextStyle(
                        color: const Color(0xFFFFFFFF),
                        fontSize: MediaQuery.of(context).size.width * 0.12,
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
                  top: MediaQuery.of(context).size.height * 0.15,
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          _pickImage(context);
                        },
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: _profileImage != null
                              ? FileImage(_profileImage!)
                              : null,
                          child: _profileImage == null
                              ? const Icon(Icons.camera_alt, size: 50)
                              : null,
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: MediaQuery.of(context).size.height * 0.10,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: ProfileUpdateForms(),
                  ),
                ),
                Positioned(
                  right: 20,
                  top: 20,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ProfileUpdateForms extends StatefulWidget {
  @override
  _ProfileUpdateFormsState createState() => _ProfileUpdateFormsState();
}

class _ProfileUpdateFormsState extends State<ProfileUpdateForms> {
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;
  DateTime _selectedDate = DateTime.now();

  void _toggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
    });
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
          const SizedBox(height: 20.0),
          _buildTextField(
            hintText: 'Usuario',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, introduce tu usuario';
              }
              return null;
            },
          ),
          const SizedBox(height: 20.0),
          _buildTextField(
            hintText: 'Nombre y Apellido',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, introduce tu nombre y apellido';
              }
              return null;
            },
          ),
          const SizedBox(height: 20.0),
          _buildTextField(
            hintText: 'Correo Electrónico',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, introduce tu correo electrónico';
              }
              return null;
            },
          ),
          const SizedBox(height: 20.0),
          _buildDatePicker(context),
          const SizedBox(height: 25.0),
          _buildPasswordField(
            hintText: 'Confirmar contraseña',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, introduce tu contraseña';
              }
              return null;
            },
          ),
          const SizedBox(height: 25.0),
          Container(
            constraints: const BoxConstraints(maxWidth: 250.0),
            width: double.infinity,
            child: MaterialButton(
              onPressed: () {
                if (_formKey.currentState?.validate() == true) {
                  // Aquí puedes manejar la lógica para guardar los cambios
                }
              },
              color: const Color(0xFF5BFFD3),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.0),
              ),
              child: const Text(
                'Guardar cambios',
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.black,
                  fontFamily: 'Hey',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
      {required String hintText, String? Function(String?)? validator}) {
    return TextFormField(
      style: const TextStyle(color: Colors.black, fontFamily: 'Hey'),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50.0),
          borderSide: const BorderSide(width: 2.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50.0),
          borderSide: const BorderSide(width: 3.0, color: Color(0xFF5BFFD3)),
        ),
      ),
      validator: validator,
    );
  }

  Widget _buildPasswordField(
      {required String hintText, String? Function(String?)? validator}) {
    return TextFormField(
      style: const TextStyle(color: Colors.black, fontFamily: 'Hey'),
      obscureText: _obscureText,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50.0),
          borderSide: const BorderSide(width: 2.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50.0),
          borderSide: const BorderSide(width: 3.0, color: Color(0xFF5BFFD3)),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility_off : Icons.visibility,
            color: const Color(0xFF5BFFD3),
          ),
          onPressed: _toggleObscureText,
        ),
      ),
      validator: validator,
    );
  }

  Widget _buildDatePicker(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          const Text(
            'Fecha de nacimiento:',
            style: TextStyle(
              fontFamily: 'Hey',
              fontSize: 10.5,
              color: Color(0xFF676767),
            ),
          ),
          const SizedBox(width: 8.0),
          Expanded(
            child: InkWell(
              onTap: () => _selectDate(context),
              child: InputDecorator(
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  labelText: 'Día',
                ),
                child: Text(
                  '${_selectedDate.day.toString().padLeft(2, '0')}',
                  style: const TextStyle(
                    fontFamily: 'Hey',
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8.0),
          Expanded(
            child: InkWell(
              onTap: () => _selectDate(context),
              child: InputDecorator(
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  labelText: 'Mes',
                ),
                child: Text(
                  '${_selectedDate.month.toString().padLeft(2, '0')}',
                  style: const TextStyle(
                    fontFamily: 'Hey',
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8.0),
          Expanded(
            child: InkWell(
              onTap: () => _selectDate(context),
              child: InputDecorator(
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  labelText: 'Año',
                ),
                child: Text(
                  '${_selectedDate.year.toString()}',
                  style: const TextStyle(
                    fontFamily: 'Hey',
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
