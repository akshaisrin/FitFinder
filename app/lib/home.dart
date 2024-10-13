// home.dart
import 'package:flutter/material.dart';
import 'home_content.dart';
import 'profile.dart';
import 'package:fit_finder/messages.dart';


const Color deepPurple = Color(0xFF6A0DAD);

class HomePage extends StatefulWidget {
  final String token;
  const HomePage({Key? key, required this.token}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  late String _token;





  late List<Widget> _tabs;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

  }

  @override
  void initState() {
    super.initState();
    _token = widget.token;  // Initialize _token in initState
    _tabs = [
      HomeContent(),
      PlaceholderWidget(title: 'Marketplace'),
      MessagesPage(token: _token),
      ProfilePage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
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
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.filter_list),
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
            const DrawerHeader(
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
              leading: const Icon(Icons.settings, color: deepPurple),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                // Navigate to Settings page or perform other actions
                print('Settings tapped');
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: deepPurple),
              title: const Text('Logout'),
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
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Home Page Button with Label
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.home),
                  iconSize: 38,
                  color: _selectedIndex == 0 ? deepPurple : Colors.grey,
                  onPressed: () => _onItemTapped(0),
                  tooltip: 'Home',
                ),
                Text(
                  'Home',
                  style: TextStyle(
                    color: _selectedIndex == 0 ? deepPurple : Colors.grey,
                    fontSize: 12.0,
                  ),
                ),
              ],
            ),
            // Marketplace Button with Label
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.store),
                  iconSize: 38,
                  color: _selectedIndex == 1 ? deepPurple : Colors.grey,
                  onPressed: () => _onItemTapped(1),
                  tooltip: 'Marketplace',
                ),
                Text(
                  'Marketplace',
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
                  icon: const Icon(Icons.message),
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
                  icon: const Icon(Icons.person),
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

  const PlaceholderWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        '$title Page',
        style: const TextStyle(fontSize: 24, color: deepPurple),
      ),
    );
  }
}
