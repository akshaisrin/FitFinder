// home_content.dart
// home_content.dart
import 'package:flutter/material.dart';

const Color deepPurple = Color(0xFF6A0DAD);

class HomeContent extends StatefulWidget {
  @override
  _HomeContentState createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  int _currentPage = 0;

  final List<String> imageUrls = [
    'https://www.thefashionisto.com/wp-content/uploads/2023/05/Mens-Trenchcoat.jpg',
    'https://images.unsplash.com/photo-1526170375885-4d8ecf77b99f',
    'https://images.unsplash.com/photo-1503341455253-b2e723bb3dbb',
    'https://images.unsplash.com/photo-1512436991641-6745cdb1723f',
  ];

  final PageController _pageController = PageController();

  Future<String> _fetchPhotoDescription() async {
    await Future.delayed(Duration(seconds: 2));
    return "Stylish trench coat with modern flair, perfect for urban adventures.";
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Widget _buildPhotoIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(imageUrls.length, (index) {
        return AnimatedContainer(
          duration: Duration(milliseconds: 300),
          margin: EdgeInsets.symmetric(horizontal: 4.0),
          width: _currentPage == index ? 12.0 : 8.0,
          height: _currentPage == index ? 12.0 : 8.0,
          decoration: BoxDecoration(
            color: _currentPage == index ? deepPurple : Colors.grey[300],
            shape: BoxShape.circle,
          ),
        );
      }),
    );
  }

  Widget _buildHeaderWithAddFriendAndMatch() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              print('Nicolas Susanto tapped');
            },
            child: Text(
              'Nicolas',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: deepPurple,
                decoration: TextDecoration.none,
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                '90% match',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: deepPurple,
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.person_add),
            color: deepPurple,
            iconSize: 30,
            onPressed: () {
              print('Add Friend button pressed');
            },
            tooltip: 'Add Friend',
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double imageHeight = MediaQuery.of(context).size.height * 0.6;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: imageHeight,
          width: double.infinity,
          color: Colors.grey[200],
          child: Stack(
            children: [
              PageView.builder(
                controller: _pageController,
                itemCount: imageUrls.length,
                onPageChanged: (int index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  return Image.network(
                    imageUrls[index],
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Center(
                        child: Text(
                          'Image not available',
                          style: TextStyle(color: Colors.red),
                        ),
                      );
                    },
                  );
                },
              ),
              Positioned(
                top: 16.0,
                left: 0,
                right: 0,
                child: _buildPhotoIndicators(),
              ),
            ],
          ),
        ),
        SizedBox(height: 16.0),
        _buildHeaderWithAddFriendAndMatch(),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: FutureBuilder<String>(
            future: _fetchPhotoDescription(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Row(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(width: 10),
                    Text('Loading description...'),
                  ],
                );
              } else if (snapshot.hasError) {
                return Text(
                  'Failed to load description',
                  style: TextStyle(color: Colors.red),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Text(
                  'No description available',
                  style: TextStyle(color: Colors.grey),
                );
              } else {
                String description = snapshot.data!;
                return Container(
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
                    description,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }
            },
          ),
        ),
      ],
    );
  }
}