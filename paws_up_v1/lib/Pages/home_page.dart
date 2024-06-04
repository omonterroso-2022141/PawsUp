import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'lost_dogs_feed_page.dart';

import 'map_google.dart';
import 'normal_feed_page.dart';
import 'notifications_page.dart';
import 'profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  bool _showLostDogsOnly = false;
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
    SchedulerBinding.instance!.addPostFrameCallback((_) {
      _controller.forward();
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _controller.reverse().then((_) {
        setState(() {
          _selectedIndex = index;
        });
        _controller.forward();
      });
    });
  }

  void _toggleLostDogsOnly(bool value) {
    setState(() {
      _showLostDogsOnly = value;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _widgetOptions = <Widget>[
      _showLostDogsOnly ? const LostDogsFeedPage() : const NormalFeedPage(),
      const MapGoogle(),
      const AddPostPage(),
      const NotificationsPage(),
      const ProfilePage(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'PawsUp',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Comic Sans MS',
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.teal,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.filter_alt),
            onPressed: () => _toggleLostDogsOnly(!_showLostDogsOnly),
          ),
          IconButton(
            icon: const Icon(Icons.local_grocery_store_rounded,
                color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeInFadeOut,
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
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
            icon: Icon(Icons.add_box_outlined),
            label: 'Publicar',
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
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.black,
        onTap: _onItemTapped,
      ),
    );
  }
}

class AddPostPage extends StatelessWidget {
  const AddPostPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Add Post Page'),
    );
  }
}
