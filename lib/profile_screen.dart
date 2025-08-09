import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5), // Light grey background
      body: ListView(
        // ListView makes the content scrollable
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          // SECTION 1: USER INFO
          const Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Color(0xFF2E8B57), // Soft Green
                  child: Icon(
                    Icons.person,
                    size: 50,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'User Name', // Placeholder for user's name
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'user.name@email.com', // Placeholder for user's email
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),
          const Divider(), // A subtle line to separate sections
          const SizedBox(height: 10),

          // SECTION 2: MENU LIST
          // ListTile is a perfect widget for creating menu items
          ListTile(
            leading: const Icon(Icons.edit_outlined),
            title: const Text('Edit Profile'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // TODO: Navigate to Edit Profile page
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings_outlined),
            title: const Text('Settings'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // TODO: Navigate to Settings page
            },
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: const Text('Privacy Policy'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // TODO: Show Privacy Policy
            },
          ),
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text('Help & Support'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // TODO: Navigate to Help page
            },
          ),

          const SizedBox(height: 30),
          const Divider(),
          const SizedBox(height: 10),

          // SECTION 3: LOGOUT BUTTON
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.withOpacity(0.1), // Light red
                foregroundColor: Colors.red, // Text color
                elevation: 0,
              ),
              onPressed: () {
                // TODO: Add logout functionality
              },
              child: const Text('Logout'),
            ),
          ),
        ],
      ),
    );
  }
}