import 'package:flutter/material.dart';

class User {
  User({
    required this.id,
    required this.username,
    required this.email,
    this.emailVerifiedAt,
    this.codeVerif,
    required this.phone,
    required this.role,
    this.createdAt,
    this.updatedAt,
  });
  late final int id;
  late final String username;
  late final String email;
  late final Null emailVerifiedAt;
  late final Null codeVerif;
  late final String phone;
  late final String role;
  late final Null createdAt;
  late final Null updatedAt;

  User.fromJson(Map<dynamic, dynamic> json){
    id = json['id'];
    username = json['username'];
    email = json['email'];
    emailVerifiedAt = null;
    codeVerif = null;
    phone = json['phone'];
    role = json['role'];
    createdAt = null;
    updatedAt = null;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['username'] = username;
    _data['email'] = email;
    _data['email_verified_at'] = emailVerifiedAt;
    _data['code_verif'] = codeVerif;
    _data['phone'] = phone;
    _data['role'] = role;
    _data['created_at'] = createdAt;
    _data['updated_at'] = updatedAt;
    return _data;
  }
}
