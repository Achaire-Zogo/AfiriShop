import 'package:flutter/material.dart';

class RecetteModel {
  final int? id;
  final String nomProduit;
  final double total;
  final int quantity;
  DateTime creationDate;

  RecetteModel({
    this.id,
    required this.nomProduit,
    required this.total,
    required this.quantity,
    required this.creationDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nomProduit': nomProduit,
      'total': total,
      'quantity': quantity,
      'creationDate': creationDate.toString(),
      // sqflite database doesn't support the datetime type so we will save it as Text.
    };
  }

  // this function is for debugging only
  @override
  String toString() {
    return 'RecetteModel(id : $id, nomProduit : $nomProduit, creationDate : $creationDate)';
  }

  factory RecetteModel.fromMap(Map<String, dynamic> map) {
    return RecetteModel(
      id: map['id'],
      nomProduit: map['nomProduit'],
      total: map['total'],
      quantity: map['quantity'],
      creationDate: DateTime.parse(map['creationDate']),
    );
  }

  factory RecetteModel.fromJson(Map<String, dynamic> json) {
    return RecetteModel(
      id: json['id'],
      nomProduit: json['nomProduit'],
      total: json['total'],
      quantity: json['quantity'],
      creationDate: DateTime.parse(json['created_at']),
    );
  }
}
