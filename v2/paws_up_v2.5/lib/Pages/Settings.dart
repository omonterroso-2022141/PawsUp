import 'package:flutter/material.dart';
import 'ProfileUpdate.dart';
import 'home_page.dart';

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
        title: const Text(
          'Ajustes',
          style: TextStyle(
            fontSize: 40,
            color: Colors.white,
            fontFamily: "Meow",
          ),
        ),
        backgroundColor: const Color(0xFF5BFFD3),
        actions: [
          IconButton(
            icon: const Icon(Icons.home, color: Colors.white),
            onPressed: () {
              // Navegar a la otra página
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const HomePage()));
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
                const ListTile(
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
                  leading: const Icon(Icons.person, color: Color(0xFF5BFFD3)),
                  title: const Text(
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
                  leading: const Icon(Icons.lock, color: Color(0xFF5BFFD3)),
                  title: const Text(
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
                const Divider(
                  color: Color(0xFF5BFFD3),
                  thickness: 1,
                ),
                const ListTile(
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
                  leading:
                      const Icon(Icons.color_lens, color: Color(0xFF5BFFD3)),
                  title: const Text(
                    'Tema',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Text(
                    'Cambiar Tema de la App',
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 14,
                    ),
                  ),
                  tileColor: Colors.black,
                  onTap: () {
                    // Navegar a la página de cambio de tema
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.language, color: Color(0xFF5BFFD3)),
                  title: const Text(
                    'Idioma',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Text(
                    'Selecciona el idioma',
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 14,
                    ),
                  ),
                  tileColor: Colors.black,
                  onTap: () {
                    // Navegar a la página de selección de idioma
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.info, color: Color(0xFF5BFFD3)),
                  title: const Text(
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
                child: const ListTile(
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
