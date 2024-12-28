import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'post_screen.dart';
import 'profile_screen.dart';
import 'post_creation_screen.dart'; // New screen for creating posts
import 'login_screen.dart'; // Import the LoginScreen for navigation

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    PostScreen(),
    ProfileScreen(),
  ];

  // Function to log out the user
  void _logout() {
    // Here, you can add your logout logic (e.g., clearing stored data)
    // For example, if you're storing a token, clear it from shared preferences or local storage.
    print('User logged out');

    // Navigate to the login screen after logout
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'CyberGuard',
          style: GoogleFonts.pacifico(
            textStyle: TextStyle(color: Colors.black, fontSize: 26),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.power_settings_new, color: Colors.black), // Power icon for logout
            onPressed: _logout, // Call the logout function when clicked
          ),
        ],
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the post creation screen when the FAB is pressed
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PostCreationScreen()),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
