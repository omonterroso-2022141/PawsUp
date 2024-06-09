import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'lost_dogs_profile.dart';
import 'normal_feed_profile.dart';
import 'adoption_feed_profile.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with TickerProviderStateMixin {
  int _selectedIndex = 0; // Inicialmente mostrando NormalFeedPage
  late AnimationController _controller;
  late Animation<double> _fadeInFadeOut;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeInFadeOut = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _selectPage(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _widgetOptions = <Widget>[
      NormalFeedProfile(), // Página NormalFeedProfile
      LostDogsProfile(), // Página LostDogsProfile
      AdoptionFeedProfile(), // Página AdoptionFeedProfile
    ];

    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Imagen de fondo y contenido del perfil
          Container(
            height: 230, // Altura ajustada para la imagen de fondo y el contenido del perfil
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/fonde.png'), // Reemplaza con tu imagen de fondo
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: [
                // Contenido del perfil
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage('assets/profile_image.jpg'), // Reemplaza con tu imagen de perfil
                      ),
                      SizedBox(height: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Color(0xFF5BFFD3),
                                width: 2,
                              ),
                            ),
                            child: Text(
                              'JuaninBarrio03', // Reemplaza con tu nombre de usuario
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Color(0xFF5BFFD3),
                                width: 2,
                              ),
                            ),
                            child: Text(
                              'Publicados: 12', // Reemplaza con tu contador
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // AppBar
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: AppBar(
                    backgroundColor: Colors.transparent, // Establece el color de fondo transparente
                    elevation: 0, // Sin sombra
                    automaticallyImplyLeading: false, // No muestra la flecha de retorno
                  ),
                ),
              ],
            ),
          ),
          // Iconos justo arriba del contenido
          Container(
            color: Colors.black, // Fondo negro para los iconos
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: Icon(Icons.publish, color: _selectedIndex == 0 ? Color(0xFF5BFFD3) : Colors.grey),
                  onPressed: () {
                    _selectPage(0); // Cambia al índice de la página NormalFeedProfile
                  },
                ),
                Container(
                  width: 1,
                  height: 24,
                  color: Colors.grey,
                ),
                IconButton(
                  icon: Icon(Icons.search, color: _selectedIndex == 1 ? Color(0xFF5BFFD3) : Colors.grey),
                  onPressed: () {
                    _selectPage(1); // Cambia al índice de la página LostDogsProfile
                  },
                ),
                Container(
                  width: 1,
                  height: 24,
                  color: Colors.grey,
                ),
                IconButton(
                  icon: Icon(Icons.pets, color: _selectedIndex == 2 ? Color(0xFF5BFFD3) : Colors.grey),
                  onPressed: () {
                    _selectPage(2); // Cambia al índice de la página AdoptionFeedProfile
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: FadeTransition(
              opacity: _fadeInFadeOut,
              child: _widgetOptions.elementAt(_selectedIndex),
            ),
          ),
        ],
      ),
    );
  }
}
