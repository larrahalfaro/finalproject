// In lib/user_profile.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  final String uid;
  final String name;
  final String email;
  final String role; // 'general' or 'technician'

  // Constructor with required named parameters
  UserProfile({
    required this.uid,
    required this.name,
    required this.email,
    required this.role,
  });

  /// Creates a UserProfile object from a Firestore document snapshot.
  factory UserProfile.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserProfile(
      uid: doc.id,
      name: data['name'] ?? '', // Provide default empty string if null
      email: data['email'] ?? '',
      role: data['role'] ?? 'general', // Default to 'general' if null
    );
  }

  /// Converts the UserProfile object to a Map for writing to Firestore.
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'email': email,
      'role': role,
    };
  }
}
