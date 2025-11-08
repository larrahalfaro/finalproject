import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ecotech/userprofile_service.dart';
import 'package:ecotech/user_profile.dart';

/// Defines the roles for the profile setup page
enum SetupRole { general, technician }

/// This screen is displayed if a user is authenticated with Firebase but lacks a Firestore profile.
class ProfileSetupPage extends StatefulWidget {
  final User user;

  const ProfileSetupPage({super.key, required this.user});

  @override
  State<ProfileSetupPage> createState() => _ProfileSetupPageState();
}

class _ProfileSetupPageState extends State<ProfileSetupPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  SetupRole? _selectedRole;
  bool _isLoading = false;
  final UserProfileService _profileService = UserProfileService();

  @override
  void initState() {
    super.initState();
    // Pre-fill email, though it won't be used in this UI, useful for debugging
    // You could also attempt to pre-fill the name if it was part of the Auth profile
    _nameController.text = widget.user.displayName ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _showSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  /// Finalizes the user profile by saving name and role to Firestore.
  // In lib/profile_setup_page.dart
// Replace the old method with this new, corrected one.

  /// Finalizes the user profile by saving name and role to Firestore.
  Future<void> _completeProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedRole == null) {
      _showSnackBar('Please select your role.');
      return;
    }

    setState(() { _isLoading = true; });

    try {
      // 1. Create the UserProfile object first.
      final newUserProfile = UserProfile(
        uid: widget.user.uid,
        name: _nameController.text.trim(),
        email: widget.user.email ?? 'no-email@ecotech.com',
        role: _selectedRole == SetupRole.technician ? 'technician' : 'general',
      );

      // 2. Pass the single object to the service. This now matches the service's requirements.
      await _profileService.createUserProfile(profile: newUserProfile);

      // Successfully created profile. The AuthWrapper will handle redirection.

    } catch (e) {
      _showSnackBar('Failed to complete profile: $e');
    } finally {
      if (mounted) {
        setState(() { _isLoading = false; });
      }
    }
  }


  /// Logs the user out if they can't or don't want to complete the profile now.
  void _logout() async {
    await FirebaseAuth.instance.signOut();
    // AuthWrapper handles redirection back to LoginPage
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.warning_amber, size: 80, color: Colors.amber.shade700),
                const SizedBox(height: 16),
                const Text(
                  'Complete Your Profile',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'We just need your name and role to finish setting up your account.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 40),

                // --- Name Input ---
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Your Full Name',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),

                // --- Role Selection ---
                Text(
                  'Select Your Role:',
                  style: TextStyle(fontSize: 18, color: primaryColor, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 15),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // General User Button
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            _selectedRole = SetupRole.general;
                          });
                        },
                        icon: const Icon(Icons.person_outline),
                        label: const Text('General User'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _selectedRole == SetupRole.general ? primaryColor : Colors.grey.shade200,
                          foregroundColor: _selectedRole == SetupRole.general ? Colors.white : Colors.black87,
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    // Technician Button
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            _selectedRole = SetupRole.technician;
                          });
                        },
                        icon: const Icon(Icons.construction),
                        label: const Text('Technician'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _selectedRole == SetupRole.technician ? primaryColor : Colors.grey.shade200,
                          foregroundColor: _selectedRole == SetupRole.technician ? Colors.white : Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),

                // --- Complete Profile Button ---
                SizedBox(
                  width: double.infinity,
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                    onPressed: _completeProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 5,
                    ),
                    child: const Text(
                      'Complete Profile',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // --- Logout Button ---
                TextButton(
                  onPressed: _logout,
                  child: const Text(
                    'Logout and Try Again',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
