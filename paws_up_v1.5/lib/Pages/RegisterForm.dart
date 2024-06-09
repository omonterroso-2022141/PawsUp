  import 'package:flutter/material.dart';
  import 'package:flutter_localizations/flutter_localizations.dart';
  import 'Login.dart';

  class RegisterForm extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
      return MaterialApp(
        locale: Locale('es', 'ES'), // Establecer el idioma español (España)
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('es', 'ES'), // Español
        ],
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
                              MaterialPageRoute(builder: (context) => Login()), // Utiliza la clase Login existente
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

    void _toggleObscureText() {
      setState(() {
        _obscureText = !_obscureText;
      });
    }

    Future<void> _selectDate(BuildContext context) async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _selectedDate ?? DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime.now(),
        locale: Locale('es', 'ES'), // Establecer el idioma español (España)
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
        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 20.0),
            TextField(
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
            ),
            SizedBox(height: 20.0),
            TextField(
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
            ),
            SizedBox(height: 20.0),
            TextField(
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
                suffixIcon: Container(
                  width: 40.0,
                  height: 40.0,
                  child: IconButton(
                    iconSize: 24.0,
                    icon: ImageIcon(
                      AssetImage(_obscureText ? 'images/off.png' : 'images/on.png'),
                      color: Color(0xFF5BFFD3),
                    ),
                    onPressed: _toggleObscureText,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.0),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              padding: EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Text('Fecha de nacimiento:',
                      style: TextStyle(
                          fontFamily: 'Hey',
                          fontSize: 10.5,
                          color: Color(0xFF676767))),
                  SizedBox(width: 8.0),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        _selectDate(context);
                      },
                      child: InputDecorator(
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          labelText: 'Día',
                        ),
                        child: Text(
                          '${_selectedDate.day.toString().padLeft(2, '0')}',
                          style: TextStyle(
                              fontFamily: 'Hey',
                              fontSize: 16,
                              color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8.0),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        _selectDate(context);
                      },
                      child: InputDecorator(
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          labelText: 'Mes',
                        ),
                        child: Text(
                          '${_selectedDate.month.toString().padLeft(2, '0')}',
                          style: TextStyle(
                              fontFamily: 'Hey',
                              fontSize: 16,
                              color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8.0),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        _selectDate(context);
                      },
                      child: InputDecorator(
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          labelText: 'Año',
                        ),
                        child: Text(
                          '${_selectedDate.year}',
                          style: TextStyle(
                              fontFamily: 'Hey',
                              fontSize: 16,
                              color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.0),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.0), // Define el radio de los bordes
              ),
              padding: EdgeInsets.all(10.0), // Agrega un espacio interno alrededor del SwitchListTile
              child: SwitchListTile(
                title: Text(
                  'Aceptar Términos y Condiciones',
                  style: TextStyle(color: Colors.black, fontFamily: 'Hey'), // Cambia el color del texto
                ),
                value: _acceptTerms,
                activeColor: Color(0xFF5BFFD3),
                onChanged: (bool value) {
                  setState(() {
                    _acceptTerms = value;
                  });
                },
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF5BFFD3),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0), // Aquí se ajusta el radio de acuerdo al botón "Crear cuenta"
                ),
                padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 8.0), // Ajusta el padding horizontal y vertical
              ),
              onPressed: _acceptTerms
                  ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Login()), // Aquí se navega a la página de Login
                );
              }
                  : null,
              child: Text(
                'Crear cuenta',
                style: TextStyle(fontFamily: 'Hey', fontSize: 16, color: Colors.black), // Cambia el color del texto
              ),
            ),
          ],
        ),
      );
    }
  }
