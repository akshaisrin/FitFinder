import 'package:flutter/material.dart';
import 'package:swipe_cards/swipe_cards.dart';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'dart:convert';

const Color deepPurple = Color(0xFF6A0DAD);

class ExplorePage extends StatefulWidget {
  @override

  String token;

  ExplorePage({required this.token});
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  late MatchEngine _matchEngine;
  List<SwipeItem> _swipeItems = [];
  List<String> bookmarkedImages = []; // List to store bookmarked images
  Random _random = Random(); // For generating random strings or values
  final String likeUrl = "https://trigtbh.dev:5000/api/swipe-right"; // Replace with your like URL
  final String dislikeUrl = "https://trigtbh.dev:5000/api/swipe-left"; // Replace with your dislike URL

  String token = "";
  @override
  void initState() {
    super.initState();
    _initializeSwipeItems(); // Initialize swipe items
    _matchEngine = MatchEngine(swipeItems: _swipeItems);
    token = widget.token;
  }

  // Initialize swipe items for the SwipeCards widget
  void _initializeSwipeItems() {
    _swipeItems.clear();
    for (int i = 0; i < 100; i++) {
      try {
        http.post(
          Uri.parse("https://trigtbh.dev:5000/api/next"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            "token": widget.token,
          }),
        ).then((resp) {
          String id = jsonDecode(resp.body)["clothes_id"];

          String url = "https://trigtbh.dev:5000/api/get_image/" + id;


          _swipeItems.add(SwipeItem(
            content: url,
            likeAction: () async {
              await _sendLikeRequest(url);
              // print("Liked: https://example.com/random_image_${_random.nextInt(1000)}.jpg");
            },
            nopeAction: () async {
              // print("Disliked: https://example.com/random_image_${_random.nextInt(1000)}.jpg");
              await _sendDislikeRequest(url);
            },
            superlikeAction: () async {
              // _bookmarkImage('https://example.com/random_image_${_random.nextInt(1000)}.jpg');
              // print("Bookmarked");
            },
          ));
        });
      } catch (e) {

      }



    }
  }

  Future<void> _sendLikeRequest(String imageUrl) async {
    try {
      final response = await http.post(
        Uri.parse(likeUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          "clothes_id": imageUrl.split("/")[imageUrl.split("/").length - 1], // Send the image URL or any other necessary data
          "token": widget.token,
        }),
      );

      if (response.statusCode == 200) {
        print("Successfully liked: $imageUrl");
      } else {
        print("Failed to like image: ${response.body}");
      }
    } catch (e) {
      print("Error sending like request: $e");
    }
  }

  Future<void> _sendDislikeRequest(String imageUrl) async {
    try {
      final response = await http.post(
        Uri.parse(dislikeUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          "clothes_id": imageUrl.split("/")[imageUrl.split("/").length - 1], // Send the image URL or any other necessary data
          "token": widget.token,
        }),
      );

      if (response.statusCode == 200) {
        print("Successfully disliked: $imageUrl");
      } else {
        print("Failed to dislike image: ${response.body}");
      }
    } catch (e) {
      print("Error sending dislike request: $e");
    }
  }


  // Function to bookmark the image and show a popup message
  void _bookmarkImage(String imageUrl) {
    setState(() {
      if (!bookmarkedImages.contains(imageUrl)) {
        bookmarkedImages.add(imageUrl);
        // Show a SnackBar to notify the user
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Image bookmarked!'),
            duration: Duration(seconds: 1),
          ),
        );
        print('Bookmarked: $imageUrl');
      } else {
        // Optionally handle duplicate bookmarks if needed
        print('Image already bookmarked: $imageUrl');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildSwipeView(),
    );
  }

  Widget _buildSwipeView() {
    return Column(
      children: [
        // Using SizedBox to control the height of the swipe area
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.7, // Set fixed height to 70% of the screen
          child: SwipeCards(
            matchEngine: _matchEngine,
            itemBuilder: (BuildContext context, int index) {
              final String imageUrl = _swipeItems[index].content;
              return Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height * 0.4, // Reduced height to 40% of the screen
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[200],
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Random Fashion Image",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: deepPurple,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
            onStackFinished: () {
              // No special handling required since we're generating images dynamically
              print('Stack finished');
            },
            upSwipeAllowed: true, // Allow upward swiping for bookmarking
            fillSpace: true, // Fill the available space
          ),
        ),
      ],
    );
  }
}