// // profile.dart
// import 'package:flutter/material.dart';
//
// const Color deepPurple = Color(0xFF6A0DAD);
//
// class ProfilePage extends StatefulWidget {
//   @override
//   _ProfilePageState createState() => _ProfilePageState();
// }
//
// class _ProfilePageState extends State<ProfilePage> {
//   int _selectedIndex = 0;
//
//   final String name = 'Nico';
//   final String username = '@nico_style';
//   final String biography =
//       'Passionate fashion enthusiast from New York. I love blending classic and modern styles to create unique looks.';
//   final String fashionDescription =
//       'Stylish trench coat with modern flair, perfect for urban adventures.';
//   final List<String> fashionTags = [
//     'Casual',
//     'Streetwear',
//     'Vintage',
//     'Minimalist',
//     'Elegant',
//   ];
//
//   final List<String> fashionImages = [
//     'https://images.unsplash.com/photo-1512436991641-6745cdb1723f',
//     'https://images.unsplash.com/photo-1503341455253-b2e723bb3dbb',
//     'https://images.unsplash.com/photo-1526170375885-4d8ecf77b99f',
//     'https://www.thefashionisto.com/wp-content/uploads/2023/05/Mens-Trenchcoat.jpg',
//   ];
//
//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }
//
//   Future<String> _fetchPhotoDescription() async {
//     await Future.delayed(Duration(seconds: 2));
//     return "Stylish trench coat with modern flair, perfect for urban adventures.";
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;
//
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: deepPurple,
//         elevation: 0,
//         title: Row(
//           children: [
//             Text(
//               'FitFinder',
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.white,
//               ),
//             ),
//           ],
//         ),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.settings),
//             color: Colors.white,
//             iconSize: 30,
//             onPressed: () {
//               print('Settings button pressed');
//             },
//             tooltip: 'Settings',
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               GestureDetector(
//                 onTap: () {
//                   print('Profile picture tapped');
//                 },
//                 child: CircleAvatar(
//                   radius: 60,
//                   backgroundImage: NetworkImage(
//                     'https://images.unsplash.com/photo-1502767089025-6572583495b4',
//                   ),
//                   backgroundColor: Colors.grey[200],
//                   child: Align(
//                     alignment: Alignment.bottomRight,
//                     child: CircleAvatar(
//                       radius: 18,
//                       backgroundColor: deepPurple,
//                       child: Icon(
//                         Icons.edit,
//                         color: Colors.white,
//                         size: 20,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(height: 16.0),
//               Text(
//                 name,
//                 style: TextStyle(
//                   fontSize: 28,
//                   fontWeight: FontWeight.bold,
//                   color: deepPurple,
//                 ),
//               ),
//               SizedBox(height: 8.0),
//               Text(
//                 username,
//                 style: TextStyle(
//                   fontSize: 16,
//                   color: Colors.grey[600],
//                 ),
//               ),
//               SizedBox(height: 16.0),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Column(
//                     children: [
//                       Text(
//                         '120',
//                         style: TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                           color: deepPurple,
//                         ),
//                       ),
//                       SizedBox(height: 4.0),
//                       Text(
//                         'Followers',
//                         style: TextStyle(
//                           fontSize: 16,
//                           color: Colors.grey[600],
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(width: 40.0),
//                   Column(
//                     children: [
//                       Text(
//                         '150',
//                         style: TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                           color: deepPurple,
//                         ),
//                       ),
//                       SizedBox(height: 4.0),
//                       Text(
//                         'Following',
//                         style: TextStyle(
//                           fontSize: 16,
//                           color: Colors.grey[600],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//               SizedBox(height: 24.0),
//               Align(
//                 alignment: Alignment.centerLeft,
//                 child: Text(
//                   biography,
//                   style: TextStyle(
//                     fontSize: 16,
//                     color: Colors.black87,
//                   ),
//                   textAlign: TextAlign.left,
//                 ),
//               ),
//               SizedBox(height: 24.0),
//               Align(
//                 alignment: Alignment.centerLeft,
//                 child: Container(
//                   width: double.infinity,
//                   padding: EdgeInsets.all(16.0),
//                   decoration: BoxDecoration(
//                     color: deepPurple.withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(12.0),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black12,
//                         blurRadius: 4.0,
//                         offset: Offset(0, 2),
//                       ),
//                     ],
//                   ),
//                   child: Text(
//                     fashionDescription,
//                     style: TextStyle(
//                       fontSize: 18,
//                       color: Colors.black87,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(height: 24.0),
//               Align(
//                 alignment: Alignment.centerLeft,
//                 child: Wrap(
//                   spacing: 8.0,
//                   runSpacing: 4.0,
//                   children: fashionTags.map((tag) {
//                     return Chip(
//                       label: Text(
//                         tag,
//                         style: TextStyle(
//                           color: Colors.white,
//                         ),
//                       ),
//                       backgroundColor: deepPurple,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8.0),
//                       ),
//                     );
//                   }).toList(),
//                 ),
//               ),
//               SizedBox(height: 24.0),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: fashionImages.map((imageUrl) {
//                   return ClipRRect(
//                     borderRadius: BorderRadius.circular(8.0),
//                     child: Image.network(
//                       imageUrl,
//                       width: (screenWidth - 48.0) / 4,
//                       height: (screenWidth - 48.0) / 4,
//                       fit: BoxFit.cover,
//                       errorBuilder: (context, error, stackTrace) {
//                         return Container(
//                           color: Colors.grey[200],
//                           child: Icon(
//                             Icons.image_not_supported,
//                             color: Colors.grey,
//                           ),
//                         );
//                       },
//                     ),
//                   );
//                 }).toList(),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// profile.dart
import 'package:flutter/material.dart';

const Color deepPurple = Color(0xFF6A0DAD);

class ProfilePage extends StatelessWidget {
  String name = 'Nico';
  String username = '@nico_style';
  String biography =
      'Passionate about fashion and love baggy clothes. From Seattle hmu';
  String fashionDescription =
      'Stylish trench coat with modern flair, perfect for urban adventures.';
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
                  fashionDescription,
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
