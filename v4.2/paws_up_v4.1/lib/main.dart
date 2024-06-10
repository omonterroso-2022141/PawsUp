import 'package:flutter/material.dart';
import 'package:paws_up_v1/Pages/Main%20Page/home_page.dart';
import 'Pages/Login.dart';
import 'Pages/Main Page/lost_dogs_feed_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PawsUp',
      theme: ThemeData(),
      debugShowCheckedModeBanner: false,
      home: const Login(),
    );
  }
}
