import 'package:flutter/material.dart';

class Vente {
  final int? id;
  final int IDProduit;
  final double montantVente;
  final int quantiteVendue;
  DateTime dateVente;

  Vente({
    this.id,
    required this.IDProduit,
    required this.montantVente,
    required this.quantiteVendue,
    required this.dateVente,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'IDProduit': IDProduit,
      'montantVente': montantVente,
      'quantiteVendue': quantiteVendue,
      'dateVente': dateVente.toString(),
      // sqflite database doesn't support the datetime type so we will save it as Text.
    };
  }

  factory Vente.fromMap(Map<String, dynamic> map) {
    return Vente(
      id: map['id'],
      IDProduit: map['IDProduit'],
      montantVente: map['montantVente'],
      quantiteVendue: map['quantiteVendue'],
      dateVente: DateTime.parse(map['dateVente']),
    );
  }
}
