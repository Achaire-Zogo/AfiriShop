import 'package:flutter/material.dart';

class Product {
  final int? id;
  final String nomProduit;
  final String description;
  // final String image;
  final double prixAchat;
  final double prixVente;
  final int quantite;
  DateTime creationDate;

  Product({
    this.id,
    required this.nomProduit,
    required this.description,
    // required this.image,
    // this.image = '"assets/wireless.png',
    required this.prixAchat,
    required this.prixVente,
    required this.quantite,
    required this.creationDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nomProduit': nomProduit,
      'description': description,
      'prixAchat': prixAchat,
      'prixVente': prixVente,
      'quantite': quantite,
      'creationDate': creationDate.toString(),
      // sqflite database doesn't support the datetime type so we will save it as Text.
    };
  }

  // this function is for debugging only
  @override
  String toString() {
    return 'Produit(id : $id, nomProduit : $nomProduit, creationDate : $creationDate)';
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      nomProduit: map['nomProduit'],
      description: map['description'],
      prixAchat: map['prixAchat'],
      prixVente: map['prixVente'],
      quantite: map['quantite'],
      creationDate: DateTime.parse(map['creationDate']),
    );
  }
}
