// home_content.dart
import 'package:flutter/material.dart';
import 'package:fit_finder/otherProfile.dart'; // Ensure this path is correct

const Color deepPurple = Color(0xFF6A0DAD);

class HomeContent extends StatefulWidget {
  @override
  _HomeContentState createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  // Placeholder data for profiles with multiple images for each profile
  final List<Map<String, dynamic>> profiles = [
    {
      'name': 'Nicolas',
      'imageUrls': [
        'https://www.thefashionisto.com/wp-content/uploads/2023/05/Mens-Trenchcoat.jpg',
        'https://images.unsplash.com/photo-1526170375885-4d8ecf77b99f'
      ],
      'description': 'Stylish trench coat with modern flair, perfect for urban adventures.',
      'matchPercentage': '90%',
    },
    {
      'name': 'Alice',
      'imageUrls': [
        'https://images.unsplash.com/photo-1526170375885-4d8ecf77b99f',
        'https://images.unsplash.com/photo-1503341455253-b2e723bb3dbb'
      ],
      'description': 'Elegant yet functional outdoor wear for explorers.',
      'matchPercentage': '85%',
    },
    {
      'name': 'Bob',
      'imageUrls': [
        'https://images.unsplash.com/photo-1503341455253-b2e723bb3dbb',
        'https://images.unsplash.com/photo-1512436991641-6745cdb1723f'
      ],
      'description': 'Urban street style, bold yet minimalistic.',
      'matchPercentage': '75%',
    },
    {
      'name': 'Charlie',
      'imageUrls': [
        'https://images.unsplash.com/photo-1512436991641-6745cdb1723f',
        'https://images.unsplash.com/photo-1520962915519-61eab2f158f7'
      ],
      'description': 'Casual wear with a touch of elegance.',
      'matchPercentage': '88%',
    },
  ];

  final PageController _pageController = PageController();
  Map<int, int> _currentPageIndex = {}; // Store the current page index for each profile
  List<Set<String>> _bookmarkedImages = []; // Store bookmarked image URLs per profile

  @override
  void initState() {
    super.initState();
    // Initialize current page indices and bookmarked images
    for (int i = 0; i < profiles.length; i++) {
      _currentPageIndex[i] = 0;
      _bookmarkedImages.add(<String>{});
    }
  }

  Future<String> _fetchPhotoDescription(String description) async {
    await Future.delayed(Duration(seconds: 1));
    return description;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Widget _buildPhotoIndicators(int length, int currentPage) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(length, (index) {
        return AnimatedContainer(
          duration: Duration(milliseconds: 300),
          margin: EdgeInsets.symmetric(horizontal: 4.0),
          width: currentPage == index ? 12.0 : 8.0,
          height: currentPage == index ? 12.0 : 8.0,
          decoration: BoxDecoration(
            color: currentPage == index ? deepPurple : Colors.grey[300],
            shape: BoxShape.circle,
          ),
        );
      }),
    );
  }

  Widget _buildHeaderWithAddFriendAndBookmark(
      String name, String matchPercentage, int profileIndex) {
    String currentImageUrl =
    profiles[profileIndex]['imageUrls'][_currentPageIndex[profileIndex]!];

    bool isBookmarked = _bookmarkedImages[profileIndex].contains(currentImageUrl);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          // Profile Name
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OtherProfilePage(
                    name: name,
                    username: '@${name.toLowerCase()}_style',
                    biography:
                    'Passionate about fashion and love baggy clothes. From Seattle hmu',
                    fashionDescription: profiles[profileIndex]['description'],
                    fashionTags: ['Casual', 'Streetwear', 'Vintage', 'Minimalist', 'Elegant'],
                    fashionImages: [
                      'https://images.unsplash.com/photo-1512436991641-6745cdb1723f',
                      'https://images.unsplash.com/photo-1503341455253-b2e723bb3dbb',
                      'https://images.unsplash.com/photo-1526170375885-4d8ecf77b99f',
                      'https://www.thefashionisto.com/wp-content/uploads/2023/05/Mens-Trenchcoat.jpg',
                    ],
                  ),
                ),
              );
            },
            child: Text(
              name,
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
                '$matchPercentage match',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: deepPurple,
                ),
              ),
            ),
          ),
          // Add Friend Button
          IconButton(
            icon: Icon(Icons.message),
            color: deepPurple,
            iconSize: 30,
            onPressed: () {
              print('Add Friend button pressed for $name');
              // Implement add friend functionality here
            },
            tooltip: 'Add Friend',
          ),
          // Bookmark Button
          IconButton(
            icon: Icon(
              isBookmarked ? Icons.bookmark : Icons.bookmark_border,
              color: isBookmarked ? deepPurple : Colors.grey,
            ),
            color: deepPurple,
            iconSize: 30,
            onPressed: () {
              setState(() {
                if (isBookmarked) {
                  _bookmarkedImages[profileIndex].remove(currentImageUrl);
                  print('Removed bookmark for $currentImageUrl');
                } else {
                  _bookmarkedImages[profileIndex].add(currentImageUrl);
                  print('Bookmarked $currentImageUrl');
                }
              });
            },
            tooltip: isBookmarked ? 'Remove Bookmark' : 'Bookmark',
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double imageHeight = MediaQuery.of(context).size.height * 0.55;

    return ListView.builder(
      itemCount: profiles.length, // Total number of profiles
      itemBuilder: (context, index) {
        final profile = profiles[index];
        final images = profile['imageUrls'] as List<String>;
        int currentPage = _currentPageIndex[index] ?? 0;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image and indicator
            Container(
              height: imageHeight,
              width: double.infinity,
              color: Colors.grey[200],
              child: Stack(
                children: [
                  PageView.builder(
                    key: PageStorageKey<int>(index),
                    controller: PageController(initialPage: currentPage),
                    itemCount: images.length, // Number of images per profile
                    onPageChanged: (int pageIndex) {
                      setState(() {
                        _currentPageIndex[index] = pageIndex;
                      });
                    },
                    itemBuilder: (context, pageIndex) {
                      return Image.network(
                        images[pageIndex],
                        fit: BoxFit.cover,
                        width: double.infinity,
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
                    child: _buildPhotoIndicators(images.length, currentPage),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.0),
            _buildHeaderWithAddFriendAndBookmark(
                profile['name']!,
                profile['matchPercentage']!,
                index), // Pass profile index
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: FutureBuilder<String>(
                future: _fetchPhotoDescription(profile['description']!),
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
            SizedBox(height: 20.0), // Spacing between profiles
          ],
        );
      },
    );
  }
}
