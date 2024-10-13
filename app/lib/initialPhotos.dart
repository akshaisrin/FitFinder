import 'package:flutter/material.dart';
import 'package:swipe_cards/swipe_cards.dart';

import 'package:swipe_cards/draggable_card.dart';
import 'home.dart'; // Import HomePage for navigation
import 'package:http/http.dart' as http;
import 'dart:convert';

const Color deepPurple = Color(0xFF6A0DAD);

class InitialPhotosPage extends StatefulWidget {
  final String token;

  const InitialPhotosPage({required this.token});

  @override
  _InitialPhotosPageState createState() => _InitialPhotosPageState();
}

class _InitialPhotosPageState extends State<InitialPhotosPage> {
  late MatchEngine _matchEngine;
  List<SwipeItem> _swipeItems = [];
  bool _completed = false;

  // List of 10 image URLs
  List<String> _imageUrls = [];

  // Define your URLs for like and dislike actions
  final String likeUrl = "https://trigtbh.dev:5000/api/swipe-right"; // Replace with your like URL
  final String dislikeUrl = "https://trigtbh.dev:5000/api/swipe-left"; // Replace with your dislike URL

  @override
  void initState() {
    super.initState(); // Call the super class's initState method
    _matchEngine = MatchEngine(swipeItems: _swipeItems);
    _fetchImages(); // Call the async method to fetch images
  }

  // Asynchronous method to fetch images
  Future<void> _fetchImages() async {
    for (int i = 0; i < 10; i++) {
      http.Response resp = await http.post(
        Uri.parse("https://trigtbh.dev:5000/api/next"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          "token": widget.token,
        }),
      );

      String id = jsonDecode(resp.body)["clothes_id"];
      _imageUrls.add("https://trigtbh.dev:5000/api/get_image/$id");
    }

    // Initialize swipe items after fetching images
    _initializeSwipeItems();

    // Update the MatchEngine with new items
    setState(() {
      _matchEngine = MatchEngine(swipeItems: _swipeItems);
    });
  }

  void _initializeSwipeItems() {
    _swipeItems = _imageUrls.map((url) {
      return SwipeItem(
        content: url,
        likeAction: () async {
          await _sendLikeRequest(url); // Send like request
        },
        nopeAction: () async {
          await _sendDislikeRequest(url); // Send dislike request
        },
        superlikeAction: () {
          print("Super Liked: $url");
        },
        onSlideUpdate: (SlideRegion? region) async {
          print("Region $region");
        },
      );
    }).toList();
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

  void _onSwipeComplete() {
    setState(() {
      _completed = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _completed
          ? null
          : AppBar(
        backgroundColor: deepPurple,
        elevation: 0,
        title: Text(
          'Initial Photos',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: _completed ? _buildResultView() : _buildSwipeView(),
    );
  }

  Widget _buildSwipeView() {
    return Column(
      children: [
        SizedBox(height: 20),
        Text(
          "Swipe right for like and swipe left for dislike",
          style: TextStyle(
            fontSize: 18,
            color: deepPurple,
            fontWeight: FontWeight.bold,
          ),
        ),
        Expanded(
          child: SwipeCards(
            matchEngine: _matchEngine,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    _imageUrls[index],
                    fit: BoxFit.cover,
                    width: double.infinity,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[200],
                        child: Center(
                          child: Text(
                            'Image not available',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
            onStackFinished: () {
              _onSwipeComplete();
            },
            upSwipeAllowed: false,
            fillSpace: true,
          ),
        ),
      ],
    );
  }

  Widget _buildResultView() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Your fashion style is:",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: deepPurple,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Classy, Old Money, and Gothic",
              style: TextStyle(
                fontSize: 22,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // Navigate to Home Page
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage(token: widget.token)),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: deepPurple,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                textStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                foregroundColor: Colors.white,
              ),
              child: Text("Go to Home Page"),
            ),
          ],
        ),
      ),
    );
  }
}
