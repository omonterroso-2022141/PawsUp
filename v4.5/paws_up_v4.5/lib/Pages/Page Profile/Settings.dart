import 'package:flutter/material.dart';
import '../Main Page/home_page.dart';
import 'ProfileUpdate.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // No muestra la flecha de regreso
        flexibleSpace: Image.asset(
          'images/fonde.png',
          fit: BoxFit.cover,
        ),
        title: Text(
          'Ajustes',
          style: TextStyle(
            fontSize: 40,
            color: Colors.white,
            fontFamily: "Meow",
          ),
        ),
        backgroundColor: Color(0xFF5BFFD3),
        actions: [
          IconButton(
            icon: Icon(Icons.home, color: Colors.white),
            onPressed: () {
              // Navegar a la otra página
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => HomePage()));
            },
          ),
        ],
      ),
      backgroundColor: Colors.black, // Fondo negro
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  title: Text(
                    'Ajustes de Cuenta',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF5BFFD3),
                      fontSize: 18,
                    ),
                  ),
                  tileColor: Colors.black,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                ),
                ListTile(
                  leading: Icon(Icons.person, color: Color(0xFF5BFFD3)),
                  title: Text(
                    'Informacion Personal',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Text(
                    'Actualiza tu informacion personal/Perfil',
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 14,
                    ),
                  ),
                  tileColor: Colors.black,
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => ProfileUpdate()),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.lock, color: Color(0xFF5BFFD3)),
                  title: Text(
                    'Cambiar contraseña',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  tileColor: Colors.black,
                  onTap: () {
                    // Navegar a la página de cambio de contraseña
                  },
                ),
                Divider(
                  color: Color(0xFF5BFFD3),
                  thickness: 1,
                ),
                ListTile(
                  title: Text(
                    'Ajustes Generales',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF5BFFD3),
                      fontSize: 18,
                    ),
                  ),
                  tileColor: Colors.black,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                ),
                ListTile(
                  leading: Icon(Icons.info, color: Color(0xFF5BFFD3)),
                  title: Text(
                    'Informacion',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Text(
                    'Terminos, politica de privacidad, Condiciones de uso',
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 14,
                    ),
                  ),
                  tileColor: Colors.black,
                  onTap: () {
                    // Navegar a la página de acerca de
                  },
                ),
              ],
            ),
          ),
          Container(
            color: Colors.black,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  // Implementar la lógica de cierre de sesión
                },
                highlightColor: Colors.grey[400], // Color de fondo al presionar
                child: ListTile(
                  title: Center(
                    child: Text(
                      'Cerrar Sesion',
                      style: TextStyle(
                        color: Colors.white, // Texto blanco
                        fontSize: 16,
                      ),
                    ),
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
