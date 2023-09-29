import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:m_product/model/user_model.dart';
import 'package:m_product/model/vente_model.dart';
import 'package:m_product/route/route_name.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../model/product.dart';
import '../screens/IndexHome.dart';

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

  Future<void> addProduct(Product produit,BuildContext context) async {
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
      EasyLoading.showSuccess(AppLocalizations.of(context)!.pro_add);
      // Navigator.of(context).pushAndRemoveUntil(
      //       MaterialPageRoute(builder: (context) => GreatHome()),
      //           (route) => false);

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
    );

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

          EasyLoading.showSuccess(
              AppLocalizations.of(context)!.pro_updated_success);

        // Navigator.of(context).pushAndRemoveUntil(
        //     MaterialPageRoute(builder: (context) => GreatHome()),
        //         (route) => false);

    } catch (e) {
      print("Error Updating product: $e");
      EasyLoading.showError(
        duration: Duration(milliseconds: 1500),
        AppLocalizations.of(context)!.try_again,
      );
    }
  }

  Future<bool> addSale(Vente vente, int id, int newQuantite, BuildContext context) async {
    try {
      final db = await database;

      // Vérifie si le produit existe déjà dans la table vente
      final existingSale = await db.query(
        'vente',
        columns: ['quantiteVendue'],
        where: 'IDProduit == ?',
        whereArgs: [id],
      );

      if (existingSale.isNotEmpty) {
        // Le produit existe déjà dans la table vente, mettez à jour la quantité vendue
        final currentQuantiteVendue =
            existingSale.first['quantiteVendue'] as int;
        final newQuantiteVendue = currentQuantiteVendue + newQuantite;

        // Mettre à jour la quantité vendue dans la table vente
        await db.update(
          'vente',
          {'quantiteVendue': newQuantiteVendue},
          where: 'IDProduit == ?',
          whereArgs: [id],
        );
      } else {
        // Le produit n'existe pas dans la table vente, insérez une nouvelle vente
        await db.insert(
          'vente',
          vente.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }

      // Mettre à jour la quantité dans la table produit
      await db.update(
        'produit',
        {'quantite': newQuantite},
        where: 'id == ?',
        whereArgs: [id],
      );
        Future.delayed(Duration(seconds: 1), () {

        });
        EasyLoading.showSuccess(
            AppLocalizations.of(context)!.add_sale,duration: Duration(seconds: 3));
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => GreatHome()),
                (route) => false);

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

  Future<String> getAllDataFromDatabase() async {
    final Map<String, dynamic> data = {};
    final db = await database;

    // Récupérez toutes les données de la table "produit"
    final List<Map<String, dynamic>> produits = await db.query('produit');
    data['produit'] = produits;

    // Récupérez toutes les données de la table "vente"
    final List<Map<String, dynamic>> ventes = await db.query('vente');
    data['vente'] = ventes;

    final jsonData = json.encode(data); // Convertir la map en JSON

    return jsonData; // Renvoyer la chaîne JSON
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

  Future<double> getTotalSalesBetweenDates(
      DateTime startDate, DateTime endDate) async {
    final db = await database;
    final startFormatted = DateFormat('yyyy-MM-dd').format(startDate);
    final endFormatted = DateFormat('yyyy-MM-dd').format(endDate);
    var maintenant = DateTime.now();
    var hier = maintenant.subtract(const Duration(days: 1));
    var date_hier = DateFormat('yyyy-MM-dd').format(hier);
    print(date_hier);

    final result = await db.rawQuery(
      'SELECT SUM(montantVente) AS total FROM vente WHERE dateVente = ? ',
      [date_hier],
    );

    final total = result.first['total'] as double? ?? 0.0;
    return total;
  }

  Future<double> getTotalSalesForToday() async {
    final db = await database;
    final today = DateTime.now();
    final formattedDate = DateFormat('yyyy-MM-dd').format(today);

    final result = await db.rawQuery(
      'SELECT SUM(montantVente) AS total FROM vente WHERE dateVente = ?',
      ['$formattedDate%'],
    );

    final total = result.first['total'] as double? ?? 0.0;
    return total;
  }

  Future<List<Product>> getProductsSoldToday() async {
    final db = await database;
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);

    final startFormatted = DateFormat('yyyy-MM-dd HH:mm:ss').format(startOfDay);
    final endFormatted = DateFormat('yyyy-MM-dd HH:mm:ss').format(endOfDay);

    final result = await db.rawQuery(
      'SELECT v.IDProduit, p.NomProduit, p.Description, p.prixAchat, p.prixVente, v.quantiteVendue, v.dateVente '
      'FROM vente AS v '
      'INNER JOIN produit AS p ON v.IDProduit = p.id '
      'WHERE v.dateVente BETWEEN ? AND ?',
      [startFormatted, endFormatted],
    );

    return result
        .map((row) => Product(
              id: row['IDProduit'] as int,
              nomProduit: row['nomProduit'] as String,
              description: row['description'] as String,
              creationDate: DateTime.parse(row['dateVente'] as String),
              prixVente: row['prixVente'] as double,
              prixAchat: row['prixAchat'] as double,
              quantite: row['quantiteVendue'] as int, // Utiliser quantiteVendue
            ))
        .toList();
  }
}
