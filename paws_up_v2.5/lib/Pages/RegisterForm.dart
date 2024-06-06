import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker_fork/flutter_cupertino_date_picker_fork.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'Login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: Locale('es', 'ES'),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('es', 'ES'),
      ],
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
                  Container(
                    decoration: BoxDecoration(
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
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      alignment: Alignment.center,
                      child: Text(
                        'Crear cuenta',
                        style: TextStyle(
                          color: Color(0xFFFFFFFF),
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
                    bottom: MediaQuery.of(context).size.height * 0.10,
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: RegisterForms(),
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
                            MaterialPageRoute(builder: (context) => Login()),
                          );
                        },
                        child: Text(
                          '¿Ya tienes cuenta? Logeate',
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

class RegisterForms extends StatefulWidget {
  @override
  _RegisterFormsState createState() => _RegisterFormsState();
}

class _RegisterFormsState extends State<RegisterForms> {
  bool _obscureText = true;
  DateTime _selectedDate = DateTime.now();
  bool _acceptTerms = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _toggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  Future<void> _registerUser() async {
    if (_formKey.currentState!.validate() && _acceptTerms) {
      final response = await http.post(
        Uri.parse('https://back-paws-up-cloud.vercel.app/User/register'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'username': _usernameController.text,
          'nombre': _nameController.text,
          'email': _emailController.text,
          'password': _passwordController.text,
          'edad': _selectedDate.toIso8601String(),
        }),
      );

      if (response.statusCode == 200) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Login()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al registrar el usuario')),
        );
      }
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      locale: Locale('es', 'ES'), // Define la localización para mostrar el selector de fecha en español
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: MediaQuery
            .of(context)
        .size
        .height * 0.25),
    child: Form(
    key: _formKey,
    child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
    SizedBox(height: 20.0),
    TextFormField(
    controller: _usernameController,
    style: TextStyle(color: Colors.black, fontFamily: 'Hey'),
    decoration: InputDecoration(
    filled: true,
    fillColor: Colors.white,
    hintText: 'Usuario',
    border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(50.0),
    borderSide: BorderSide(width: 2.0),
    ),
    focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(50.0),
    borderSide: BorderSide(width: 3.0, color: Color(0xFF5BFFD3)),
    ),
    ),
    validator: (value) {
    if (value == null || value.isEmpty) {
    return 'Por favor, ingrese un usuario';
    }
    return null;
    },
    ),
    SizedBox(height: 20.0),
    TextFormField(
    controller: _nameController,
    style: TextStyle(color: Colors.black, fontFamily: 'Hey'),
    decoration: InputDecoration(
    filled: true,
    fillColor: Colors.white,
    hintText: 'Nombre y Apellido',
    border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(50.0),
    borderSide: BorderSide(width: 2.0),
    ),
    focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(50.0),
    borderSide: BorderSide(width: 3.0, color: Color(0xFF5BFFD3)),
    ),
    ),
    validator: (value) {
    if (value == null || value.isEmpty) {
    return 'Por favor, ingrese su nombre y apellido';
    }
    return null;
    },
    ),
    SizedBox(height: 20.0),
    TextFormField(
    controller: _emailController,
    style: TextStyle(color: Colors.black, fontFamily: 'Hey'),
    decoration: InputDecoration(
    filled: true,
    fillColor: Colors.white,
    hintText: 'Correo Electronico',
    border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(50.0),
    borderSide: BorderSide(width: 2.0),
    ),
    focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(50.0),
      borderSide: BorderSide(width: 3.0, color: Color(0xFF5BFFD3)),
    ),
    ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor, ingrese su correo electrónico';
        }
        return null;
      },
    ),
      SizedBox(height: 20.0),
      TextFormField(
        controller: _passwordController,
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
          suffixIcon: Container(
            width: 40.0,
            height: 40.0,
            child: GestureDetector(
              onTap: _toggleObscureText,
              child: Icon(
                _obscureText ? Icons.visibility : Icons.visibility_off,
                color: Colors.black,
              ),
            ),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Por favor, ingrese una contraseña';
          }
          return null;
        },
      ),
      SizedBox(height: 20.0),
      Container(
        width: 300.0,
        height: 50.0,
        child: ElevatedButton(
          onPressed: () => _selectDate(context),
          child: Text(
            'Fecha de Nacimiento: ${_selectedDate.day}/${_selectedDate
                .month}/${_selectedDate.year}',
            style: TextStyle(color: Colors.black, fontFamily: 'Hey'),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF5BFFD3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50.0),
            ),
          ),
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Checkbox(
            value: _acceptTerms,
            onChanged: (bool? value) {
              setState(() {
                _acceptTerms = value ?? false;
              });
            },
          ),
          Text(
            'Acepto los términos y condiciones',
            style: TextStyle(color: Colors.white, fontFamily: 'Hey'),
          ),
        ],
      ),
      SizedBox(height: 20.0),
      ElevatedButton(
        onPressed: _registerUser,
        child: Text(
          'Crear cuenta',
          style: TextStyle(color: Colors.black, fontFamily: 'Hey'),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF5BFFD3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.0),
          ),
        ),
      ),
    ],
    ),
    ),
    );
  }
}

