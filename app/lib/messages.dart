import 'package:fit_finder/chatScreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const Color deepPurple = Color(0xFF6A0DAD);

class MessagesPage extends StatelessWidget {
  final String token;

  MessagesPage({required this.token});

  // Method to fetch messages and user info
  Future<List<Map<String, String>>> fetchMessages() async {
    List<String> messages = [];
    List<String> uids = [];
    List<String> chatIDs = [];

    // First request to get user chats
    final response = await http.post(
      Uri.parse("https://trigtbh.dev:5000/api/get_user_chats"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "token": token,
      }),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);

      // Get user IDs and chat IDs
      uids = List<String>.from(data["user_ids"]);
      chatIDs = List<String>.from(data["chat_ids"]);

      // Fetch usernames for each user ID
      for (String userid in uids) {
        final resp2 = await http.post(
          Uri.parse("https://trigtbh.dev:5000/api/get_user_info"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            "token": token,
            "user_id": userid,
          }),
        );

        if (resp2.statusCode == 200) {
          Map<String, dynamic> data2 = jsonDecode(resp2.body);
          messages.add(data2["username"]);
        } else {
          throw Exception('Failed to load user info');
        }
      }
    } else {
      throw Exception('Failed to load user chats');
    }

    // Combine messages and chatIDs into a list of maps for easy access
    return List.generate(
      messages.length,
          (index) => {
        'username': messages[index],
        'chatID': chatIDs[index],
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Messages'),
      ),
      body: FutureBuilder<List<Map<String, String>>>(
        future: fetchMessages(), // Fetch messages asynchronously
        builder: (BuildContext context, AsyncSnapshot<List<Map<String, String>>> snapshot) {
          // While waiting for the future to complete, show a loading spinner
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          // If there's an error, show an error message
          else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          // Once data is fetched, display the ListView.builder
          else if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data?.length ?? 0,
              itemBuilder: (context, index) {
                final message = snapshot.data![index];
                return ListTile(
                  title: Text(
                    message['username'] ?? '',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatScreen(
                          name: message['username']!,
                          channelID: message['chatID']!,
                          token: token,
                        ),
                      ),
                    );
                  },
                );
              },
            );
          } else {
            return Center(child: Text('No messages available'));
          }
        },
      ),
    );
  }
}
