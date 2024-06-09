import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../servicrs/user_service.dart';
import 'lost_dogs_profile.dart';
import 'normal_feed_profile.dart';
import 'adoption_feed_profile.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with TickerProviderStateMixin {
  int _selectedIndex = 0; // Inicialmente mostrando NormalFeedPage
  late AnimationController _controller;
  late Animation<double> _fadeInFadeOut;
  Map<String, dynamic>? _userProfile;

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
      _fetchUserProfile();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _fetchUserProfile() async {
    UserService userService = UserService();
    Map<String, dynamic>? profile = await userService.getUserProfile();
    if (profile != null) {
      setState(() {
        _userProfile = profile;
      });
    }
  }

  void _selectPage(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _widgetOptions = <Widget>[
      const NormalFeedProfile(), // Página NormalFeedProfile
      const LostDogsProfile(), // Página LostDogsProfile
      const AdoptionFeedProfile(), // Página AdoptionFeedProfile
    ];

    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Imagen de fondo y contenido del perfil
          Container(
            height:
                230, // Altura ajustada para la imagen de fondo y el contenido del perfil
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'images/fonde.png'), // Reemplaza con tu imagen de fondo
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
                      const CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage(
                            'assets/profile_image.jpg'), // Reemplaza con tu imagen de perfil
                      ),
                      const SizedBox(height: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: const Color(0xFF5BFFD3),
                                width: 2,
                              ),
                            ),
                            child: Text(
                              _userProfile?['username'] ??
                                  'Cargando...', // Nombre de usuario
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: const Color(0xFF5BFFD3),
                                width: 2,
                              ),
                            ),
                            child: Text(
                              'Publicados: ${_userProfile?['publicaciones'] ?? '0'}', // Contador de publicaciones
                              style: const TextStyle(
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
                    backgroundColor: Colors
                        .transparent, // Establece el color de fondo transparente
                    elevation: 0, // Sin sombra
                    automaticallyImplyLeading:
                        false, // No muestra la flecha de retorno
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
                  icon: Icon(Icons.publish,
                      color: _selectedIndex == 0
                          ? const Color(0xFF5BFFD3)
                          : Colors.grey),
                  onPressed: () {
                    _selectPage(
                        0); // Cambia al índice de la página NormalFeedProfile
                  },
                ),
                Container(
                  width: 1,
                  height: 24,
                  color: Colors.grey,
                ),
                IconButton(
                  icon: Icon(Icons.search,
                      color: _selectedIndex == 1
                          ? const Color(0xFF5BFFD3)
                          : Colors.grey),
                  onPressed: () {
                    _selectPage(
                        1); // Cambia al índice de la página LostDogsProfile
                  },
                ),
                Container(
                  width: 1,
                  height: 24,
                  color: Colors.grey,
                ),
                IconButton(
                  icon: Icon(Icons.pets,
                      color: _selectedIndex == 2
                          ? const Color(0xFF5BFFD3)
                          : Colors.grey),
                  onPressed: () {
                    _selectPage(
                        2); // Cambia al índice de la página AdoptionFeedProfile
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
