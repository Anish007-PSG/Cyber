import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';  // Import intl package for date formatting

class PostScreen extends StatefulWidget {
  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  late Future<List<Map<String, String>>> posts;

  @override
  void initState() {
    super.initState();
    posts = fetchPosts();
  }

  // Fetch posts from the backend
  Future<List<Map<String, String>>> fetchPosts() async {
    final response = await http.get(Uri.parse('http://localhost:5000/posts'));

    if (response.statusCode == 200) {
      List<dynamic> postData = json.decode(response.body);
      return postData.map((post) {
        // Cast the post fields to the expected types
        return {
          'user': post['createdBy']['username'] as String,
          'date': post['createdAt'] as String,
          'content': post['content'] as String,
        };
      }).toList();
    } else {
      throw Exception('Failed to load posts');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, String>>>(
      future: posts,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No posts available'));
        } else {
          final posts = snapshot.data!;
          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              // Parse the date string to a DateTime object
              DateTime dateTime = DateTime.parse(post['date']!);
              // Format the date for display
              String formattedDate = DateFormat('yyyy-MM-dd – HH:mm').format(dateTime);

              return Card(
                margin: EdgeInsets.all(10),
                elevation: 3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post['user']!,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      SizedBox(height: 5),
                      Text(
                        formattedDate,  // Display the formatted date
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 5),
                      Text(
                        post['content']!,
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}
