import 'package:chat/domain/entities/message.dart';
import 'package:flutter/material.dart';

class ChatProviders extends ChangeNotifier {
  final ScrollController chatScrollController = ScrollController();

  List<Message> messageList = [
    Message(text: 'Holax', fromWho: FromWho.me),
    Message(text: 'Estas bien?', fromWho: FromWho.me)
  ];

  get fromWho => null;

  Future<void> sendMessagge(String text) async {
    if (text.isEmpty) return;

    final newMessage = Message(text: text, fromWho: FromWho.me);
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
