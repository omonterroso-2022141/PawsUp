import 'package:chat/domain/entities/message.dart';
import 'package:flutter/material.dart';

class ChatProviders extends ChangeNotifier {
  final ScrollController chatScrollController = ScrollController();

  // Define el color hexadecimal para los mensajes
  static final Color defaultColor = Color(0xFF53C4A6);

  List<Message> messageList = [
    Message(text: 'Hola', fromWho: FromWho.me, color: defaultColor),
    Message(text: 'Estas bien?', fromWho: FromWho.me, color: defaultColor),
  ];

  get fromWho => null;

  Future<void> sendMessagge(String text) async {
    if (text.isEmpty) return;

    final newMessage = Message(text: text, fromWho: FromWho.me, color: defaultColor); // Usa el color predeterminado
    messageList.add(newMessage);

    notifyListeners();
    moveSrollToBottom();
  }

  Future<void> moveSrollToBottom() async {
    await Future.delayed(const Duration(milliseconds: 100));
    chatScrollController.animateTo(
        chatScrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut);
  }
}
