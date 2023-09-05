import 'package:flutter/material.dart';

class User {
  final int? id;
  final String username;
  final String mdp;
  final String email;

  User({
    this.id,
    required this.username,
    required this.mdp,
    required this.email,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'mdp': mdp,
      'email': email,
    };
  }

  // this function is for debugging only
  @override
  String toString() {
    return 'User(id : $id, nomProduit : $email)';
  }
}
