import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:m_product/api/encrypt.dart';
import 'package:m_product/route/route_name.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Database? _database;
List userdatList = [];
late List<dynamic> productList;

class LocalDataBase {
  LocalDataBase(this.context);

  final BuildContext context;

  Future get database async {
    if (_database != null) return null;
    _database = await _initialize("Local.db");
    return _database;
  }

  Future _initialize(String filePath) async {
    final dbpath = await getDatabasesPath();
    final path = join(dbpath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute(userTable);
    await db.execute(produitTable);
    await db.execute(venteTable);
  }

  static const produitTable = '''

    CREATE TABLE produit(
    IDProduit INTEGER PRIMARY KEY ,
    NomProduit TEXT NOT NULL,
    Description TEXT,
    prixAchat REAL NOT NULL,
    PrixUnitaire REAL NOT NULL,
    QuantiteEnStock INTEGER NOT NULL
);''';

  static const userTable = '''
    CREATE TABLE user(
    id INTEGER PRIMARY KEY  ,
    username TEXT NOT NULL,
    mdp TEXT NOT NULL,
    email TEXT NOT NULL
    ); ''';

  static const venteTable = ''' CREATE TABLE vente (
    IDVente INTEGER PRIMARY KEY ,
    IDProduit INTEGER NOT NULL,
    DateVente DATE NOT NULL,
    QuantiteVendue INTEGER NOT NULL,
    MontantVente REAL NOT NULL,
    FOREIGN KEY (IDProduit) REFERENCES Produit (IDProduit)
);

    ''';

  Future addUser(String username, String email, String password) async {
    username = encrypt(username);
    email = encrypt(email);
    password = encrypt(password);
    final db = await database;
    await db.insert(
        'user', {"username": username, "mdp": password, "email": email});
    print("${username} Added to database Succesfully");
    return "added";
  }

  Future<bool> getUser(String email, String password) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    EasyLoading.show(status: AppLocalizations.of(context)!.loading);

    try {
      final db = await database;
      final allData = await db!.query('user');
      userdatList = allData;
      for (final user in allData) {
        final decryptedUser = {
          'id': user['id'], // Supposons que 'id' n'est pas crypté
          'username': decrypt(user['username']),
          'email': decrypt(user['email']),
          'mdp': decrypt(user['mdp']),
        };
        if (decryptedUser['email'] == email &&
            decryptedUser['mdp'] == password) {
          // Obtain shared preferences.
          await prefs.setBool('isLogged', true);
          return true;
        }
      }

      return false;
    } on SocketException catch (e) {
      EasyLoading.showError(
        duration: Duration(milliseconds: 1500),
        AppLocalizations.of(context)!.verified_internet,
      );
      return false;
    } catch (e) {
      print('Une erreur s\'est produite : $e');
      EasyLoading.showError(
        duration: Duration(milliseconds: 1500),
        AppLocalizations.of(context)!.error_occur,
      );

      return false;
    }
  }

  Future addProduct(String productName, String descriptionProduct,
      double prixAchat, double prixVente, int quantite) async {
    try {
      final db = await database;
      await db.insert('produit', {
        "NomProduit": productName,
        "Description": descriptionProduct,
        "prixAchat": prixAchat,
        "PrixUnitaire": prixVente,
        "QuantiteEnStock": 0
      });

      print("${productName} Added to database Succesfully");
      return "added";
      // (await db.query('sqlite_master', columns: ['type', 'name']))
      //     .forEach((row) {
      //   print(row.values);
      // });
    } catch (e) {
      print("Error adding product: $e");
      EasyLoading.showError(
        duration: Duration(milliseconds: 1500),
        AppLocalizations.of(context)!.try_again,
      );
      return "error";
    }
  }

  Future<List<dynamic>> getAllProducts() async {
    try {
      // EasyLoading.show(status: AppLocalizations.of(context)!.loading);
      final db = await database;
      final allData = await db!.query('produit');

      // Convertir les données de la base de données en une liste de produits
      productList = allData.map((data) {
        return {
          'id': data['IDProduit'],
          'title': data['NomProduit'],
          'description': data['Description'],
          'image':
              'assets/wireless.png', // Vous devrez obtenir l'image de manière appropriée
          'purchasePrice': data['prixAchat'].toDouble(),
          'sellingPrice': data['PrixUnitaire'].toDouble(),
          'quantity': data[
              'QuantiteEnStock'], // Vous pouvez définir la quantité initiale comme 0
        };
      }).toList();
      // EasyLoading.dismiss();
      // print(productList);
      return productList;
    } catch (e) {
      print('Une erreur s\'est produite : $e');
      // EasyLoading.showError(
      //   duration: Duration(milliseconds: 1500),
      //   AppLocalizations.of(context)!.error_occur,
      // );
      return []; // En cas d'erreur, retourner une liste vide
    }
  }

  Future updateProduct(
      {id,
      productName,
      descriptionProduct,
      prixAchat,
      prixVente,
      quantite}) async {
    try {
      EasyLoading.show(status: AppLocalizations.of(context)!.loading);

      final db = await database;
      int dbupdateId = await db.rawUpdate(
          'UPDATE produit SET NomProduit= ? ,description = ?,prixVente= ? ,PrixUnitaire = ? , QuantiteEnStock = ? WHERE IDProduit = ?',
          [
            productName,
            descriptionProduct,
            prixVente,
            prixAchat,
            quantite,
            id
          ]);

      print("Product with ID $id updated successfully");
      return dbupdateId;
    } catch (e) {
      print("Error updating product: $e");
      // Gérer les erreurs ici, par exemple, afficher un message d'erreur à l'utilisateur.
    }
    EasyLoading.dismiss();
  }

 Future<void> deleteProductById(int productId) async {
  try {
    final db = await database;
    await db.delete(
      'produit',
      where: 'IDProduit = ?',
      whereArgs: [productId],
    );

    print("Product with ID $productId deleted successfully");
  } catch (e) {
    print("Error deleting product: $e");
    // Gérer les erreurs ici
  }
}

}



  // Future<void> deleteDatabaseFile() async {
  //   try {
  //     final databasesPath = await getDatabasesPath();
  //     print(databasesPath);
  //     final path = join(databasesPath,
  //         'sqlite_master'); // Remplacez 'your_database.db' par le nom de votre base de données

  //     await deleteDatabase(path);

  //     print('Database deleted successfully');
  //   } catch (e) {
  //     print('Error deleting database: $e');
  //   }
  // }