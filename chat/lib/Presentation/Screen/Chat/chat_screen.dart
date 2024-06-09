import 'package:chat/Presentation/Widgets/chat/her_mmessage_bubble.dart';
import 'package:chat/Presentation/Widgets/chat/my_message_bubble.dart';
import 'package:chat/Presentation/Widgets/shared/message_field_box.dart';
import 'package:chat/Presentation/providers/chat_providers.dart';
import 'package:chat/domain/entities/message.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.all(3.0),
          child: CircleAvatar(
            backgroundImage: NetworkImage(
                'https://github.com/jrosselin-2022050/IMG_PAWSUP/blob/main/Icon_Pets.jpg?raw=true'),
          ),
        ),
        title: const Text('PawsChat'),
        centerTitle: false,
      ),
      body: _ChatView(),
    );
  }
}

class _ChatView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final chatProvider = context.watch<ChatProviders>();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        child: Column(
          children: [
            Expanded(
                child: ListView.builder(
                    controller: chatProvider.chatScrollController,
                    itemCount: chatProvider.messageList.length,
                    itemBuilder: (context, index) {
                      final message = chatProvider.messageList[index];
                      return (message.fromWho == FromWho.hers)
                          ? HerMmessageBubble()
                          : MyMessageBubble(message: message);
                    })),

            //Caja de texto
            MessageFieldBox(
              onValue: chatProvider.sendMessagge,
            ),
          ],
        ),
      ),
    );
  }
}
