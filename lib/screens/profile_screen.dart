import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/firebase_service.dart';
import '../services/auth_service.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  final AuthService _authService = AuthService();
  final displayNameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() async {
    final profile = await _firebaseService.getUserProfile();
    if (profile != null) {
      displayNameController.text = profile['displayName'] ?? '';
      phoneController.text = profile['phone'] ?? '';
      addressController.text = profile['address'] ?? '';
    } else {
      final user = FirebaseAuth.instance.currentUser;
      displayNameController.text = user?.displayName ?? user?.email ?? '';
    }
    setState(() {});
  }

  void _saveProfile() async {
    final success = await _firebaseService.updateUserProfile(
      displayName: displayNameController.text,
      phone: phoneController.text,
      address: addressController.text,
    );

    if (success) {
      setState(() => _isEditing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("✅ Profile updated successfully!"),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("❌ Failed to update profile"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _logout() async {
    await _authService.logout();
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Profile"),
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.close : Icons.edit),
            onPressed: () {
              setState(() => _isEditing = !_isEditing);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Profile Avatar
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.pink[100],
              child: Icon(
                Icons.person,
                size: 50,
                color: Colors.pink,
              ),
            ),
            const SizedBox(height: 16),
            // Email (non-editable)
            Text(
              user?.email ?? 'No email',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 32),
            // Form Fields
            if (_isEditing)
              Column(
                children: [
                  TextField(
                    controller: displayNameController,
                    decoration: InputDecoration(
                      labelText: "Display Name",
                      prefixIcon: const Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: phoneController,
                    decoration: InputDecoration(
                      labelText: "Phone Number",
                      prefixIcon: const Icon(Icons.phone),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: addressController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: "Address",
                      prefixIcon: const Icon(Icons.location_on),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _saveProfile,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: const Text("Save Changes"),
                        ),
                      ),
                    ],
                  ),
                ],
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProfileField(
                    icon: Icons.person,
                    label: "Display Name",
                    value: displayNameController.text.isEmpty
                        ? "Not set"
                        : displayNameController.text,
                  ),
                  const SizedBox(height: 16),
                  _buildProfileField(
                    icon: Icons.phone,
                    label: "Phone",
                    value: phoneController.text.isEmpty
                        ? "Not set"
                        : phoneController.text,
                  ),
                  const SizedBox(height: 16),
                  _buildProfileField(
                    icon: Icons.location_on,
                    label: "Address",
                    value: addressController.text.isEmpty
                        ? "Not set"
                        : addressController.text,
                  ),
                ],
              ),
            const SizedBox(height: 32),
            // Order History Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/orderHistory');
                },
                child: const Text("View Order History"),
              ),
            ),
            const SizedBox(height: 12),
            // Logout Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _logout,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[600],
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text(
                  "Logout",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileField({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.pink),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      fontWeight: FontWeight.w600)),
              Text(value, style: const TextStyle(fontSize: 14)),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    displayNameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.dispose();
  }
}
