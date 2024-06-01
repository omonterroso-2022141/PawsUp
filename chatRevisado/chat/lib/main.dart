import 'package:chat/Presentation/Screen/Chat/chat_screen.dart';
import 'package:chat/Presentation/providers/chat_providers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => ChatProviders())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
        ),
        title: 'Chat',
        home: const ChatScreen(),
      ),
    );
  }
}
