import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Add this import for making HTTP requests
import 'dart:convert'; // Add this import for JSON decoding

const Color deepPurple = Color(0xFF6A0DAD);

class ProfilePage extends StatefulWidget {
  @override

  String token;

  ProfilePage({required this.token});


  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String name = 'Nico';
  String username = '@nico_style';
  String biography = 'Passionate about fashion and love baggy clothes. From Seattle hmu';
  String fashionDescription = ''; // Initially empty
  List<String> fashionTags = [
    'Casual',
    'Streetwear',
    'Vintage',
    'Minimalist',
    'Elegant',
  ];

  final List<String> fashionImages = [
    'https://images.unsplash.com/photo-1512436991641-6745cdb1723f',
    'https://images.unsplash.com/photo-1503341455253-b2e723bb3dbb',
    'https://images.unsplash.com/photo-1526170375885-4d8ecf77b99f',
    'https://www.thefashionisto.com/wp-content/uploads/2023/05/Mens-Trenchcoat.jpg',
  ];

  String token = "";
  @override
  void initState() {
    super.initState();
    _fetchFashionDescription(); // Call the API when the widget is initialized
    token = widget.token;
  }

  Future<void> _fetchFashionDescription() async {
    try {
      final response = await http.post(
        Uri.parse("https://trigtbh.dev:5000/api/do_ai_styling"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          "token": widget.token,
        }),
      );
      if (response.statusCode == 200) {
        setState(() {
          fashionDescription = json.decode(response.body)['style']; // Adjust according to your API response structure
        });
      } else {
        throw Exception('Failed to load fashion description');
      }
    } catch (e) {
      print(e);
      setState(() {
        fashionDescription = 'Error fetching fashion description'; // Fallback error message
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                print('Profile picture tapped');
              },
              child: CircleAvatar(
                radius: 60,
                backgroundImage: NetworkImage(
                  'https://images.unsplash.com/photo-1502767089025-6572583495b4',
                ),
                backgroundColor: Colors.grey[200],
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: CircleAvatar(
                    radius: 18,
                    backgroundColor: deepPurple,
                    child: Icon(
                      Icons.edit,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              name,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: deepPurple,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              username,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Text(
                      '120',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: deepPurple,
                      ),
                    ),
                    SizedBox(height: 4.0),
                    Text(
                      'Followers',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 40.0),
                Column(
                  children: [
                    Text(
                      '150',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: deepPurple,
                      ),
                    ),
                    SizedBox(height: 4.0),
                    Text(
                      'Following',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 24.0),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                biography,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            SizedBox(height: 24.0),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: deepPurple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4.0,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  fashionDescription.isEmpty ? 'Loading...' : fashionDescription, // Display loading text initially
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            SizedBox(height: 24.0),
            Align(
              alignment: Alignment.centerLeft,
              child: Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                children: fashionTags.map((tag) {
                  return Chip(
                    label: Text(
                      tag,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    backgroundColor: deepPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 24.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: fashionImages.map((imageUrl) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    imageUrl,
                    width: (screenWidth - 48.0) / 4,
                    height: (screenWidth - 48.0) / 4,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[200],
                        child: Icon(
                          Icons.image_not_supported,
                          color: Colors.grey,
                        ),
                      );
                    },
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
