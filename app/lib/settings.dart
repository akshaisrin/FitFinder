import 'package:flutter/material.dart';

const Color deepPurple = Color(0xFF6A0DAD);

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final TextEditingController _tagController = TextEditingController();
  List<String> _tags = []; // List to hold tags
  final int _maxTags = 8; // Maximum number of tags allowed

  // This will eventually be the user's images, placeholder for now
  List<String> _uploadedImages = [];

  // Function to add a tag
  void _addTag() {
    if (_tagController.text.isNotEmpty && _tags.length < _maxTags) {
      setState(() {
        _tags.add(_tagController.text);
        _tagController.clear();
      });
    }
  }

  // Function to remove a tag
  void _removeTag(String tag) {
    setState(() {
      _tags.remove(tag);
    });
  }

  // Placeholder for image upload functionality
  void _uploadImage() {
    setState(() {
      // Adding a placeholder image
      _uploadedImages.add('Placeholder image uploaded');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: deepPurple,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Navigate back when the back button is pressed
          },
        ),
        title: Text('Profile Settings',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tag Input Section
            Text(
              'Add or Remove Tags (Limit: $_maxTags tags)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _tagController,
                    decoration: InputDecoration(
                      hintText: 'Enter a tag',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _tags.length < _maxTags ? _addTag : null, // Disable if max tags reached
                  style: ElevatedButton.styleFrom(
                    backgroundColor: deepPurple,
                  ),
                  child: Text('Add'),
                ),
              ],
            ),
            SizedBox(height: 20),

            // Display added tags
            Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: _tags.map((tag) {
                return Chip(
                  label: Text(tag),
                  backgroundColor: deepPurple.withOpacity(0.2),
                  deleteIcon: Icon(Icons.close),
                  onDeleted: () => _removeTag(tag), // Remove tag when the delete icon is pressed
                );
              }).toList(),
            ),

            SizedBox(height: 30),

            // Upload Images Section
            Text(
              'Upload Images (Placeholder for now)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _uploadImage,
              style: ElevatedButton.styleFrom(
                backgroundColor: deepPurple,
              ),
              child: Text('Upload Image'),
            ),

            // Display uploaded images (placeholder)
            Expanded(
              child: ListView.builder(
                itemCount: _uploadedImages.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_uploadedImages[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tagController.dispose();
    super.dispose();
  }
}