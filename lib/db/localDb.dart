import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:m_product/model/user_model.dart';
import 'package:m_product/model/vente_model.dart';
import 'package:m_product/route/route_name.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../model/product.dart';

Database? _database;

class LocalDataBase {
  LocalDataBase(this.context);

  final BuildContext context;

  Future<Database> get database async {
    // this is the location of our database in device. ex - data/data/....
    final dbpath = await getDatabasesPath();
    // this is the name of our database.
    const dbname = 'local.db';
    // this joins the dbpath and dbname and creates a full path for database.
    // ex - data/data/todo.db
    final path = join(dbpath, dbname);

    // open the connection
    _database = await openDatabase(path, version: 1, onCreate: _createDB);
    // we will create the _createDB function separately

    return _database!;
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute(userTable);
    await db.execute(produitTable);
    await db.execute(venteTable);
  }

  static const produitTable = '''

    CREATE TABLE produit(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nomProduit TEXT NOT NULL,
    description TEXT,
    prixAchat REAL NOT NULL,
    prixVente REAL NOT NULL,
    quantite INTEGER NOT NULL,
    creationDate TEXT

);''';

  static const userTable = '''
    CREATE TABLE user(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    username TEXT NOT NULL,
    mdp TEXT NOT NULL,
    email TEXT NOT NULL
    ); ''';

  static const venteTable = ''' CREATE TABLE vente (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    IDProduit INTEGER NOT NULL,
    dateVente DATE NOT NULL,
    quantiteVendue INTEGER NOT NULL,
    montantVente REAL NOT NULL,
    FOREIGN KEY  (IDProduit) REFERENCES Produit (IDProduit)
);

    ''';

  // function for product

  Future<void> addProduct(Product produit) async {
    EasyLoading.show(
      status: AppLocalizations.of(context)!.loading,
      dismissOnTap: false,
    );
    try {
      final db = await database;
      await db.insert(
        'produit',
        produit.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      // (await db.query('sqlite_master', columns: ['type', 'name']))
      //     .forEach((row) {
      //   print(row.values);
      // });

      print('product ${produit.toString()} add succesfully');
      Future.delayed(Duration(seconds: 2), () {
        Future.delayed(Duration(seconds: 1), () {
          EasyLoading.showSuccess(AppLocalizations.of(context)!.pro_add);
        });
        NavigationServices(context).gotoHomeScreen();
      });
    } catch (e) {
      print("Error adding product: $e");
      EasyLoading.showError(
        duration: Duration(milliseconds: 1500),
        AppLocalizations.of(context)!.try_again,
      );
    }
  }

  Future<List<Product>> getProduct() async {
    final db = await database;
    // query the database and save the todo as list of maps
    List<Map<String, dynamic>> items = await db.query(
      'produit',
      orderBy: 'id DESC',
    ); // this will order the list by id in descending order.
    // so the latest todo will be displayed on top.

    // now convert the items from list of maps to list of todo
    return List.generate(
      items.length,
      (i) => Product(
        id: items[i]['id'],
        description: items[i]['description'],
        creationDate: DateTime.parse(items[i]['creationDate']),
        prixVente: items[i]['prixVente'],
        nomProduit: items[i]['nomProduit'],
        prixAchat: items[i]['prixAchat'],
        quantite: items[i]['quantite'],
        // this will convert the Integer to boolean. 1 = true, 0 = false.
      ),
    );
  }

  Future<void> deleteProduct(Product produit) async {
    final db = await database;
    // delete the todo from database based on its id.
    await db.delete(
      'produit',
      where: 'id == ?', // this condition will check for id in todo list
      whereArgs: [produit.id],
    );
  }

  Future<void> updateProduct(
      int id,
      String nomProduit,
      String description,
      double prixAchat,
      double prixVente,
      int quantite,
      String creationDate) async {
    try {
      final db = await database;
      EasyLoading.show(
        status: AppLocalizations.of(context)!.loading,
        dismissOnTap: false,
      );
      await db.update(
        'produit', // table name

        {
          'nomProduit': nomProduit,
          'description': description,
          'prixAchat': prixAchat,
          'prixVente': prixVente,
          'quantite': quantite,
          'creationDate': DateTime.now().toString()
        },

        where: 'id == ?', // which Row we have to update
        whereArgs: [id],
      );
      Future.delayed(Duration(seconds: 2), () {
        Future.delayed(Duration(seconds: 1), () {
          EasyLoading.showSuccess(
              AppLocalizations.of(context)!.pro_updated_success);
        });
        NavigationServices(context).gotoHomeScreen();
      });
    } catch (e) {
      print("Error adding product: $e");
      EasyLoading.showError(
        duration: Duration(milliseconds: 1500),
        AppLocalizations.of(context)!.try_again,
      );
    }
  }

  Future<bool> addSale(Vente vente, int id, int newQuantite) async {
    try {
      final db = await database;
      await db.insert(
        'vente',
        vente.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      await db.update(
        'produit', // table name

        {'quantite': newQuantite, 'creationDate': DateTime.now().toString()},

        where: 'id == ?', // which Row we have to update
        whereArgs: [id],
      );

      // (await db.query('sqlite_master', columns: ['type', 'name']))
      //     .forEach((row) {
      //   print(row.values);
      // });

      Future.delayed(Duration(seconds: 2), () {
        Future.delayed(Duration(seconds: 1), () {
          EasyLoading.showSuccess(AppLocalizations.of(context)!.add_sale);
        });
        NavigationServices(context).gotoHomeScreen();
      });

      return true;
    } catch (e) {
      print("Error selling product: $e");
      EasyLoading.showError(
        duration: Duration(milliseconds: 1500),
        AppLocalizations.of(context)!.try_again,
      );
      return false;
    }
  }

  Future<void> addUser(User user) async {
    EasyLoading.show(
      status: AppLocalizations.of(context)!.loading,
      dismissOnTap: false,
    );
    try {
      final db = await database;
      await db.insert(
        'user',
        user.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      // (await db.query('sqlite_master', columns: ['type', 'name']))
      //     .forEach((row) {
      //   print(row.values);
      // });

      print('product ${user.toString()} add succesfully');
      EasyLoading.dismiss();
    } catch (e) {
      print("Error adding user: $e");
      EasyLoading.showError(
        duration: Duration(milliseconds: 1500),
        AppLocalizations.of(context)!.try_again,
      );
    }
  }

  Future<bool> getUser(String email, String password) async {
    EasyLoading.show(
      status: AppLocalizations.of(context)!.loading,
      dismissOnTap: false,
    );
    final db = await database;
    // Query the database and save the users as a list of maps
    List<Map<String, dynamic>> items = await db.query(
      'user',
      orderBy: 'id ASC',
    );

    // Check if there is any user with the specified email and password
    bool userExists =
        items.any((item) => item['email'] == email && item['mdp'] == password);
    EasyLoading.dismiss();
    return userExists;
  }

  Future<List<Vente>> getAllvente() async {
    final db = await database;
    // query the database and save the todo as list of maps
    List<Map<String, dynamic>> items = await db.query(
      'vente',
      orderBy: 'id DESC',
    );
    print(items);
    return List.generate(
        items.length,
        (i) => Vente(
              IDProduit: items[i]['IDProduit'],
              dateVente: DateTime.parse(items[i]['dateVente']),
              montantVente: items[i]['montantVente'],
              quantiteVendue: items[i]['quantiteVendue'],
            ));
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