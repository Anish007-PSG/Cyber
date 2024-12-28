import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart'; // Import shared_preferences

class PostCreationScreen extends StatefulWidget {
  @override
  _PostCreationScreenState createState() => _PostCreationScreenState();
}

class _PostCreationScreenState extends State<PostCreationScreen> {
  final TextEditingController _contentController = TextEditingController();

  Future<String?> getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');  // Retrieve the token from SharedPreferences
  }

  Future<void> createPost(String content) async {
    try {
      // Get the auth token from SharedPreferences
      String? token = await getAuthToken();

      if (token == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User not logged in')),
        );
        return;
      }

      // Send the post creation request to the backend
      final response = await http.post(
        Uri.parse('http://localhost:5000/posts'),  // Replace with your backend API URL
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',  // Add the token to the Authorization header
        },
        body: json.encode({
          'content': content,
        }),
      );

      if (response.statusCode == 201) {
        // If the post is created successfully, navigate back to the previous screen
        Navigator.pop(context);
      } else {
        throw Exception('Failed to create post');
      }
    } catch (e) {
      // Show error if something goes wrong
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Post'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Enter your post content:', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            TextField(
              controller: _contentController,
              decoration: InputDecoration(
                hintText: 'Write something...',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                String content = _contentController.text;

                if (content.isNotEmpty) {
                  // Call backend to create the post
                  createPost(content);
                } else {
                  // Show error message if no content is entered
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please enter some content')),
                  );
                }
              },
              child: Text('Post'),
            ),
          ],
        ),
      ),
    );
  }
}
