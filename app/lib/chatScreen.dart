import 'package:flutter/material.dart';

const Color deepPurple = Color(0xFF6A0DAD);

class ChatScreen extends StatefulWidget {
  final String name; // The name of the person you're chatting with
  final String channelID;
  final String token;

  ChatScreen({required this.name, required this.channelID, required this.token});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  List<String> messages = []; // Store chat messages

  void _sendMessage() {
    setState(() {
      if (_messageController.text.isNotEmpty) {
        String message = _messageController.text;



        messages.add(_messageController.text); // Add message to the list
        _messageController.clear(); // Clear the input field
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: deepPurple,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Go back to the messages page
          },
        ),
        centerTitle: true,
        title: Text(
          widget.name,
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                  child: Align(
                    alignment: Alignment.centerLeft, // Align messages on the left
                    child: Container(
                      padding: EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: deepPurple.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Text(
                        messages[index],
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // Message input field and send button
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Enter your message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: deepPurple),
                  onPressed: _sendMessage, // Send the message
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}