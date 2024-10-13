import 'package:flutter/material.dart';

const Color deepPurple = Color(0xFF6A0DAD);

class OtherProfilePage extends StatefulWidget {
  final String name;
  final String username;
  final String biography;
  final String fashionDescription;
  final List<String> fashionTags;
  final List<String> fashionImages;

  OtherProfilePage({
    required this.name,
    required this.username,
    required this.biography,
    required this.fashionDescription,
    required this.fashionTags,
    required this.fashionImages,
  });

  @override
  _OtherProfilePageState createState() => _OtherProfilePageState();
}

class _OtherProfilePageState extends State<OtherProfilePage> {
  int followers = 120;
  int following = 150;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: deepPurple,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Go back to the previous page
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 60,
                backgroundImage: NetworkImage(
                  'https://images.unsplash.com/photo-1502767089025-6572583495b4',
                ),
                backgroundColor: Colors.grey[200],
              ),
              SizedBox(height: 16.0),
              Text(
                widget.name,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: deepPurple,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                widget.username,
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
                        '$followers',
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
                        '$following',
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
                  widget.biography,
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
                    widget.fashionDescription,
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
                  children: widget.fashionTags.map((tag) {
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
                children: widget.fashionImages.map((imageUrl) {
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
      ),
    );
  }
}