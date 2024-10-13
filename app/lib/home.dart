// home.dart
import 'package:fit_finder/messages.dart';
import 'package:flutter/material.dart';
import 'home_content.dart';
import 'profile.dart';
import 'package:fit_finder/explore.dart';
import 'settings.dart';

const Color deepPurple = Color(0xFF6A0DAD);

class HomePage extends StatefulWidget {

  String token;
  HomePage({required this.token});

  @override
  _HomePageState createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  String _token = "";

  List<Widget> _tabs = [];

  @override
  void initState() {
    super.initState();
    _token = widget.token;  // Initialize _token in initState
    _tabs = [
      HomeContent(),
      ExplorePage(token: _token),
      MessagesPage(token: _token),
      ProfilePage(token: _token),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              'FitFinder',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        backgroundColor: deepPurple,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.filter_list),
              color: Colors.white,
              iconSize: 30,
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              tooltip: 'Filter',
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: deepPurple,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.settings, color: deepPurple),
              title: Text('Profile Settings'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsPage()), // Navigate to SettingsPage
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.logout, color: deepPurple),
              title: Text('Logout'),
              onTap: () {
                Navigator.pop(context);
                // Perform logout action
                print('Logout tapped');
              },
            ),
          ],
        ),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _tabs,
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Home Page Button with Label
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.person_add),
                  iconSize: 38,
                  color: _selectedIndex == 0 ? deepPurple : Colors.grey,
                  onPressed: () => _onItemTapped(0),
                  tooltip: 'Connect',
                ),
                Text(
                  'Connect',
                  style: TextStyle(
                    color: _selectedIndex == 0 ? deepPurple : Colors.grey,
                    fontSize: 12.0,
                  ),
                ),
              ],
            ),
            // Explore Button with Label
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.search),
                  iconSize: 38,
                  color: _selectedIndex == 1 ? deepPurple : Colors.grey,
                  onPressed: () => _onItemTapped(1),
                  tooltip: 'Explore',
                ),
                Text(
                  'Explore',
                  style: TextStyle(
                    color: _selectedIndex == 1 ? deepPurple : Colors.grey,
                    fontSize: 12.0,
                  ),
                ),
              ],
            ),
            // Messages/Chat Button with Label
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.message),
                  iconSize: 38,
                  color: _selectedIndex == 2 ? deepPurple : Colors.grey,
                  onPressed: () => _onItemTapped(2),
                  tooltip: 'Messages',
                ),
                Text(
                  'Messages',
                  style: TextStyle(
                    color: _selectedIndex == 2 ? deepPurple : Colors.grey,
                    fontSize: 12.0,
                  ),
                ),
              ],
            ),
            // User Profile Button with Label
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.person),
                  iconSize: 38,
                  color: _selectedIndex == 3 ? deepPurple : Colors.grey,
                  onPressed: () => _onItemTapped(3),
                  tooltip: 'Profile',
                ),
                Text(
                  'Profile',
                  style: TextStyle(
                    color: _selectedIndex == 3 ? deepPurple : Colors.grey,
                    fontSize: 12.0,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class PlaceholderWidget extends StatelessWidget {
  final String title;

  PlaceholderWidget({required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        '$title Page',
        style: TextStyle(fontSize: 24, color: deepPurple),
      ),
    );
  }
}