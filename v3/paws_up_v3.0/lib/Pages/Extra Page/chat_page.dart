import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late IO.Socket socket;
  List<Map<String, dynamic>> messages = [];
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    connectSocket();
  }

  void connectSocket() {
    // Conectarse al servidor socket.io
    socket = IO.io('https://back-paws-up-cloud.vercel.app/',
        IO.OptionBuilder().setTransports(['websocket']).build());

    // Escuchar eventos del servidor socket.io
    socket.onConnect((_) {
      print('Connected to server');
    });

    socket.onDisconnect((_) {
      print('Disconnected from server');
    });

    socket.on('receiveMessage', (data) {
      setState(() {
        messages.add({
          'message': data['message'],
          'sender': data['sender'],
          'timestamp': DateTime.now(),
        });
      });
    });
  }

  @override
  void dispose() {
    socket.disconnect();
    _messageController.dispose();
    super.dispose();
  }

  void sendMessage() {
    if (_messageController.text.isNotEmpty) {
      // Enviar mensaje al servidor socket.io
      socket.emit('sendMessage', {'message': _messageController.text});

      setState(() {
        messages.add({
          'message': _messageController.text,
          'sender': 'Me',
          'timestamp': DateTime.now(),
        });
        _messageController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Chat',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                return ListTile(
                  title: Text(
                    message['message'],
                    style: const TextStyle(color: Colors.black),
                  ),
                  subtitle: Text(
                    '${message['sender']} • ${message['timestamp'].hour}:${message['timestamp'].minute}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Escribe un mensaje...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.blue),
                  onPressed: sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
