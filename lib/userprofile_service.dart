// In lib/userprofile_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecotech/user_profile.dart'; // Import the model we just fixed

class UserProfileService {
  // Use _userCollection for consistency with your previous code
  final CollectionReference _userCollection =
  FirebaseFirestore.instance.collection('users');

  /// Fetches a user profile from Firestore and converts it to a UserProfile object.
  Future<UserProfile?> getUserProfile(String uid) async {
    try {
      final docSnapshot = await _userCollection.doc(uid).get();

      if (docSnapshot.exists) {
        // Use the .fromFirestore factory constructor from our model
        return UserProfile.fromFirestore(docSnapshot);
      } else {
        return null; // Document does not exist
      }
    } catch (e) {
      print("Error fetching user profile: $e");
      return null;
    }
  }

  /// Creates a new user document in Firestore from a UserProfile object.
  Future<void> createUserProfile({required UserProfile profile}) async {
    try {
      // Use the .toFirestore() method from our model
      await _userCollection.doc(profile.uid).set(profile.toFirestore());
    } catch (e) {
      print("Error creating user profile: $e");
      // Optionally, re-throw the error to be handled in the UI
      rethrow;
    }
  }
}
