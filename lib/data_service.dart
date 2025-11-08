import 'package:flutter/material.dart';

// --- Global Enums ---

// Authentication/Login Status
enum AuthStatus { loggedOut, loggedIn }


enum UserRole { generalUser, technician }


enum RepairStatus {
  pending,
  scheduled,
  inProgress,
  awaitingParts,
  complete,
  cancelled
}


enum AppLanguage { english, spanish }





class UserProfileData {
  String name;
  String phone;
  String email;
  String address;
  String profileImageUrl;
  final String userId;

  UserProfileData({
    required this.userId,
    this.name = 'John Doe',
    this.phone = '555-123-4567',
    this.email = 'user@ecotech.com',
    this.address = '108 EcoTech Lane, Suite 4B, Cityville, TX 77001',
    this.profileImageUrl = 'https://placehold.co/120x120/cccccc/000?text=User',
  });
}


class RepairRequest {
  final String id;
  final String userId;
  final String gadget;
  String description;
  final DateTime submissionDate;
  RepairStatus status;
  final String? technicianId;
  final DateTime? completionDate;

  RepairRequest({
    required this.id,
    required this.userId,
    required this.gadget,
    required this.description,
    required this.submissionDate,
    this.status = RepairStatus.pending,
    this.technicianId,
    this.completionDate,
  });
}



class TechnicianTask {
  final String id;
  final String userId;
  final String user;
  final String gadget;
  final String address;
  RepairStatus status;

  TechnicianTask({
    required this.id,
    required this.userId,
    required this.user,
    required this.gadget,
    required this.address,
    required this.status,
  });
}
