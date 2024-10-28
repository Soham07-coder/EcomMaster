import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserInfoScreen extends StatelessWidget {
  const UserInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Info"),
        centerTitle: true,
      ),
      body: FutureBuilder<User?>(
        future: _getCurrentUser(), // Fetch current user
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || !snapshot.hasData) {
            return const Center(child: Text("Error fetching user information"));
          }

          User? user = snapshot.data;
          String username = user?.displayName ?? "No Username"; // Provide a default value
          String email = user?.email ?? "No Email"; // Provide a default value

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildUserInfoCard("Email", email),
                const SizedBox(height: 20),
                const Text(
                  "Additional Info",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<User?> _getCurrentUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    return user;
  }

  Widget _buildUserInfoCard(String title, String value) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(value),
      ),
    );
  }
}
