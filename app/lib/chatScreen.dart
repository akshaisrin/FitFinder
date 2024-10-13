import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const Color deepPurple = Color(0xFF6A0DAD);

class Message {
  final String content;
  final bool isMyMessage;
  final double timestamp;

  Message({required this.content, required this.isMyMessage, required this.timestamp});
}

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
  List<Message> messages = []; // Single list to store all messages

  @override
  void initState() {
    super.initState(); // Call the super class's initState method
    _loadMessages(); // Load messages when the widget initializes
  }

  Future<void> _loadMessages() async {
    // Get user ID
    http.Response resp = await http.post(
      Uri.parse("https://trigtbh.dev:5000/api/whoami"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "token": widget.token, // Use widget.token to access the token
      }),
    );
    String userid = resp.body; // Decode to get the user ID

    // Get recent messages
    http.Response resp2 = await http.post(
      Uri.parse("https://trigtbh.dev:5000/api/get_recent_messages"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "token": widget.token, // Use widget.token to access the token
        "chat_id": widget.channelID,
      }),
    );

    // Assuming the response contains a list of messages
    Map<String, dynamic> messageList = jsonDecode(resp2.body);

    for (Map<String, dynamic> msg in messageList["message_info"]) {
      // Determine if the message is from the current user
      bool isMyMessage = msg['sender_id'] == userid; // Assuming the msg object contains a userId field
      messages.add(Message(content: msg['message_text'], isMyMessage: isMyMessage, timestamp: double.parse( msg["timestamp"]))); // Assuming the msg object contains content field
    }

    // Sort messages based on timestamp if your messages have a timestamp field
    messages.sort((a, b) => a.timestamp.compareTo(b.timestamp)); // Adjust according to your timestamp field

    setState(() {}); // Update the UI after loading messages
  }

  void _sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      String messageContent = _messageController.text;

      // Send message to the server
      http.Response response = await http.post(
        Uri.parse("https://trigtbh.dev:5000/api/send_message"), // Replace with your API endpoint
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          "token": widget.token,
          "chat_id": widget.channelID,
          "message_text": messageContent,
          "timestamp": DateTime.now().millisecondsSinceEpoch / 1000
        }),
      );

      // Add your message to the list
      messages.add(Message(content: messageContent, isMyMessage: true, timestamp: DateTime.now().millisecondsSinceEpoch / 1000));
      _messageController.clear(); // Clear the input field
      setState(() {}); // Update the UI to show the new message
    }
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
                final message = messages[index];

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                  child: Align(
                    alignment: message.isMyMessage ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      padding: EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: message.isMyMessage ? deepPurple.withOpacity(0.6) : deepPurple.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Text(
                        message.content,
                        style: TextStyle(fontSize: 16.0, color: Colors.black),
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
