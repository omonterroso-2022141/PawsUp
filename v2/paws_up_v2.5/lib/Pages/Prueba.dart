import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'lost_dogs_feed_page.dart';
import 'map_google.dart';
import 'normal_feed_page.dart';
import 'profile_page.dart';

class Prueba {
  int _selectedIndex = 0;
  bool _showLostDogsOnly = false;
  late AnimationController _controller;
  late Animation<double> _fadeInFadeOut;

  Prueba(BuildContext context) {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: context as TickerProvider,
    );
    _fadeInFadeOut = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
    SchedulerBinding.instance!.addPostFrameCallback((_) {
      _controller.forward();
    });
  }

  void _toggleLostDogsOnly(bool value) {
    _showLostDogsOnly = value;
  }

  void onItemTapped(int index) {
    _controller.reverse().then((_) {
      _selectedIndex = index;
      _controller.forward();
    });
  }

  Widget build(BuildContext context) {
    List<Widget> _widgetOptions = <Widget>[
      _showLostDogsOnly ? const LostDogsFeedPage() : const NormalFeedPage(),
      const MapGoogle(),
      const ProfilePage(),
    ];

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text(
          'PawsUp',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Meow',
            fontSize: 45,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.filter_alt, color: Color(0xFF5BFFD3)),
            onPressed: () => _toggleLostDogsOnly(!_showLostDogsOnly),
          ),
          IconButton(
            icon: const Icon(Icons.local_grocery_store_rounded,
                color: Color(0xFF5BFFD3)),
            onPressed: () {},
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeInFadeOut,
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.black,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_location_sharp),
            label: 'PawsMap',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.auto_awesome_mosaic_rounded),
            label: 'Categorias',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color(0xFF5BFFD3),
        unselectedItemColor: Colors.white,
        onTap: onItemTapped,
      ),
    );
  }
}
