import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? token;

  @override
  void initState() {
    super.initState();
    _getAuthToken();
  }

  Future<void> _getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('auth_token');  // Retrieve the token from SharedPreferences
    });
  }

  Future<Map<String, dynamic>> fetchUserData() async {
    if (token == null) {
      throw Exception('Token is not available');
    }

    final response = await http.get(
      Uri.parse('http://localhost:5000/auth/user/posts'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load user data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return token == null
        ? Center(child: CircularProgressIndicator())
        : FutureBuilder<Map<String, dynamic>>(
            future: fetchUserData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              final userData = snapshot.data;
              final user = userData?['users'];
              final posts = userData?['posts'] ?? []; // Ensure posts is not null

              return Column(
                children: [
                  Container(
                    color: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: AssetImage('assets/sss.jpg'), // Replace with user avatar if available
                        ),
                        SizedBox(height: 10),
                        Text(
                          user?['username'] ?? 'Username not available',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.blue,
                          ),
                        ),
                        Text(
                          user?['email'] ?? 'Email not available',
                          style: TextStyle(color: Colors.blueGrey),
                        ),
                        SizedBox(height: 10,),
                        Divider(
  color: Colors.black,  // Line color
  thickness: 1,         // Line thickness
  height: 10,           // Space around the line
)
                      ],
                    ),
                  ),
                  Text(
                          "My posts",
                        
                          style: TextStyle(color: Colors.black,
                          fontWeight: FontWeight.bold,
                            fontSize: 20,),
                        ),
                  Expanded(
                    child: posts.isEmpty
                        ? Center(
                            child: Text(
                              'No posts yet!',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          )
                        : ListView.builder(
                            itemCount: posts.length,
                            itemBuilder: (context, index) {
                              final post = posts[index];
                              return ListTile(
                                title: Text(post['content']),
                                subtitle: Text('Created at: ${post['createdAt']}'),
                              );
                            },
                          ),
                  ),
                ],
              );
            },
          );
  }
}
