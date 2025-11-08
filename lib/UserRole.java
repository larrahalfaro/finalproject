import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ecotech/user_profile.dart';
import 'package:ecotech/userprofile_service.dart';
import 'general_dashboard.dart';
import 'technician_dashboard.dart';
import 'login_page.dart';

enum UserRole { general, technician }

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final UserProfileService _profileService = UserProfileService();

  UserRole? _selectedRole;
  bool _isLoading = false;

  void _showSnackBar(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  Future<void> _signup() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedRole == null) {
      _showSnackBar('Please select a role.');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final userCred = await _auth.createUserWithEmailAndPassword(
        email: _email.text.trim(),
        password: _password.text.trim(),
      );
      final user = userCred.user!;
      final profile = UserProfile(
        uid: user.uid,
        name: _name.text.trim(),
        email: user.email!,
        role: _selectedRole == UserRole.technician
            ? 'technician'
            : 'general',
      );
      await _profileService.createUserProfile(profile: profile);

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => profile.role == 'technician'
                ? const TechnicianDashboard()
                : const GeneralDashboard(),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      _showSnackBar(e.message ?? 'Sign up failed.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Icon(Icons.eco, size: 80, color: color),
                const SizedBox(height: 16),
                Text(
                  'EcoTech Repair Sign Up',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const SizedBox(height: 40),
                TextFormField(
                  controller: _name,
                  decoration: const InputDecoration(
                    labelText: 'Your Name',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Enter your name' : null,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _email,
                  decoration: const InputDecoration(
                    labelText: 'Email Address',
                    prefixIcon: Icon(Icons.email),
                  ),
                  validator: (v) =>
                      v == null || !v.contains('@') ? 'Enter valid email' : null,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _password,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock),
                  ),
                  obscureText: true,
                  validator: (v) =>
                      v == null || v.length < 6 ? 'At least 6 characters' : null,
                ),
                const SizedBox(height: 30),
                Text(
                  'Select Your Role:',
                  style: TextStyle(fontSize: 18, color: color),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => setState(() {
                          _selectedRole = UserRole.general;
                        }),
                        icon: const Icon(Icons.person_outline),
                        label: const Text('General User'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _selectedRole == UserRole.general
                              ? color
                              : Colors.grey.shade200,
                          foregroundColor: _selectedRole == UserRole.general
                              ? Colors.white
                              : Colors.black87,
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => setState(() {
                          _selectedRole = UserRole.technician;
                        }),
                        icon: const Icon(Icons.construction),
                        label: const Text('Technician'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _selectedRole == UserRole.technician
                              ? color
                              : Colors.grey.shade200,
                          foregroundColor: _selectedRole == UserRole.technician
                              ? Colors.white
                              : Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: _signup,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: color,
                            padding: const EdgeInsets.symmetric(vertical: 18),
                          ),
                          child: const Text(
                            'Sign Up',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginPage()),
                  ),
                  child: Text(
                    'Have an account? Log In',
                    style: TextStyle(color: color),
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
