import 'package:flutter/material.dart';
import 'package:swipe_cards/swipe_cards.dart';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'dart:convert';

const Color deepPurple = Color(0xFF6A0DAD);

class ExplorePage extends StatefulWidget {
  @override
  final String token;

  ExplorePage({required this.token});
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> with WidgetsBindingObserver {
  late MatchEngine _matchEngine;
  List<SwipeItem> _swipeItems = [];
  List<String> bookmarkedImages = []; // List to store bookmarked images
  bool _isLoading = true; // Track loading state
  final Random _random = Random(); // For generating random strings or values
  final String likeUrl = "https://trigtbh.dev:5000/api/swipe-right"; // Replace with your like URL
  final String dislikeUrl = "https://trigtbh.dev:5000/api/swipe-left"; // Replace with your dislike URL

  @override
  void initState() {
    super.initState();
    _fetchSwipeItems(); // Fetch and create swipe items when the widget initializes
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Fetch the swipe items after the widget is created
    _fetchSwipeItems();
  }

  @override
  void didPopNext() {
    // This gets called when returning to this page from another page
    _fetchSwipeItems(); // Refresh the page data when navigating back to it
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this); // Clean up observer
    super.dispose();
  }

  Future<void> _fetchSwipeItems() async {
    _swipeItems = [];
    List<SwipeItem> tempSwipeItems = [];
    try {
      for (int i = 0; i < 50; i++) {
        final response = await http.post(
          Uri.parse("https://trigtbh.dev:5000/api/next"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            "token": widget.token,
          }),
        );

        if (response.statusCode == 200) {
          String id = jsonDecode(response.body)["clothes_id"];
          String url = "https://trigtbh.dev:5000/api/get_image/" + id;

          // Create a SwipeItem for each fetched image URL
          tempSwipeItems.add(SwipeItem(
            content: url,
            likeAction: () async {
              await _sendLikeRequest(url);
            },
            nopeAction: () async {
              await _sendDislikeRequest(url);
            },
            superlikeAction: () async {
              _bookmarkImage(url);
            },
          ));
        } else {
          throw Exception("Failed to fetch image data");
        }
      }
    } catch (e) {
      print("Error fetching swipe items: $e");
    }

    // Once the items are loaded, update the state
    setState(() {
      _swipeItems = tempSwipeItems;
      _matchEngine = MatchEngine(swipeItems: _swipeItems);
      _isLoading = false; // Data has finished loading
    });
  }

  Future<void> _sendLikeRequest(String imageUrl) async {
    try {
      final response = await http.post(
        Uri.parse(likeUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          "clothes_id": imageUrl.split("/").last, // Get the image ID
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
          "clothes_id": imageUrl.split("/").last, // Get the image ID
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
        print('Image already bookmarked: $imageUrl');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(child: CircularProgressIndicator()) // Show a loading indicator while fetching data
          : _buildSwipeView(),
    );
  }

  Widget _buildSwipeView() {
    return Column(
      children: [
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
                        height: MediaQuery.of(context).size.height * 0.4, // Set height to 40% of the screen
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[200],
                            child: Center(
                              child: Icon(Icons.error, color: Colors.red),
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Fashion Item",
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
