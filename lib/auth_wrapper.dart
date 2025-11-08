import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ecotech/user_profile.dart';
import 'package:ecotech/userprofile_service.dart';
import 'package:ecotech/login_page.dart' as login_page;
import 'package:ecotech/profile_setup_page.dart';
import 'package:ecotech/general_dashboard.dart';
import 'package:ecotech/technician_dashboard.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, authSnapshot) {
        if (authSnapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        if (authSnapshot.hasData && authSnapshot.data != null) {
          final user = authSnapshot.data!;
          return FutureBuilder<UserProfile?>(
            future: UserProfileService().getUserProfile(user.uid),
            builder: (context, profileSnapshot) {
              if (profileSnapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(body: Center(child: CircularProgressIndicator()));
              }

              if (profileSnapshot.hasData && profileSnapshot.data != null) {
                final profile = profileSnapshot.data!;
                if (profile.role == 'technician') {
                  return const TechnicianDashboard();
                } else {
                  return const GeneralDashboard();
                }
              } else {
                return ProfileSetupPage(user: user);
              }
            },
          );
        }

        // Use the alias here
        return login_page.LoginPage();
      },
    );
  }
}
