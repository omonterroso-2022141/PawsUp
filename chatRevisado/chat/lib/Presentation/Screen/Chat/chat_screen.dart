import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chat/domain/entities/message.dart';
import 'package:chat/Presentation/providers/chat_providers.dart';
import 'package:chat/Presentation/Widgets/chat/her_mmessage_bubble.dart';
import 'package:chat/Presentation/Widgets/chat/my_message_bubble.dart';
import 'package:chat/Presentation/Widgets/shared/message_field_box.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xFF000000), // Establece el color negro sólido
            border: Border(
              bottom: BorderSide(
                color: Color(0xFF5BFFD3), // Color del borde inferior
                width: 2.0, // Grosor del borde inferior
              ),
            ),
          ),
          child: AppBar(
            backgroundColor: Colors.transparent, // Hace que la AppBar sea transparente
            leading: Padding(
              padding: EdgeInsets.all(3.0),
              child: CircleAvatar(
                backgroundColor: Colors.black, // Cambia el color del círculo aquí
                backgroundImage: AssetImage('images/chat.png'),
              ),
            ),
            title: Text(
              'PawsChat',
              style: TextStyle(
                color: Colors.white, // Cambia el color del texto aquí
                fontFamily: 'Meow', // Establece el nombre de tu tipografía aquí
                fontWeight: FontWeight.bold, // Establece el peso de la fuente si es necesario
                fontSize: MediaQuery.of(context).size.width * 0.08, // Ajusta el tamaño de la fuente
              ),
            ),
            centerTitle: false,
          ),
        ),
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
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/fonde2.png'), // Ruta de tu imagen local
            fit: BoxFit.cover,
          ),
        ),
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
                        ? HerMmessageBubble(
                      bubbleColor: message.color,
                      textColor: Colors.black, // Cambia el color del texto aquí
                    )
                        : MyMessageBubble(
                      message: message,
                      bubbleColor: message.color,
                      textColor: Colors.black, // Cambia el color del texto aquí
                    );
                  },
                ),
              ),
              // Caja de texto
              MessageFieldBox(
                onValue: chatProvider.sendMessagge,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
