import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import 'package:m_product/model/user_model.dart';
import 'package:m_product/model/vente_model.dart';
import 'package:m_product/urls/all_url.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../api/encrypt.dart';
import '../model/RecetteModel.dart';
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

  Future<void> addProduct(Product produit, BuildContext context) async {
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
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const GreatHome(pos: 3,)),
          (route) => false);
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

  Future<bool> addSale(Vente vente, int productId, int newQuantite,
      double montantVente, BuildContext context) async {
    try {
      final db = await database;
        // Le produit n'a pas été vendu aujourd'hui, insérer une nouvelle vente
        await db.insert(
          'vente',
          Vente(
            IDProduit: productId,
            dateVente: DateFormat('yyyy-MM-dd').format(DateTime.now()),
            quantiteVendue: newQuantite,
            montantVente: montantVente,
          ).toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      //}

      // Mettre à jour la quantité en stock du produit
      final product = await db.query(
        'produit',
        columns: ['quantite'],
        where: 'id == ?',
        whereArgs: [productId],
      );

      if (product.isNotEmpty) {
        final currentQuantite = product.first['quantite'] as int;
        await db.update(
          'produit',
          {'quantite': currentQuantite - newQuantite},
          where: 'id == ?',
          whereArgs: [productId],
        );
      }

      EasyLoading.showSuccess(
        AppLocalizations.of(context)!.add_sale,
        duration: Duration(seconds: 3),
      );

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const GreatHome(pos: 3,)),
        (route) => false,
      );

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

Future<void> sendDataToAPI() async {
  EasyLoading.show(status: "Loading...");

  try {
    final produitUrl = Uri.parse(Urls.product); // URL pour les produits
    final venteUrl = Uri.parse(Urls.vente); // URL pour les ventes
    final jsonData = await getAllDataFromDatabase();

    // Envoi des données pour les produits
    final produitResponse = await http.post(
      produitUrl,
      headers: {
        'Accept': 'application/json',
      },
      body: jsonData['produit'],
    );

    print(produitResponse.body);

    // Envoi des données pour les ventes
    final venteResponse = await http.post(
      venteUrl,
      headers: {
        'Accept': 'application/json',
      },
      body: jsonData['vente'],
    );

    print(venteResponse.body);

    if (produitResponse.statusCode == 200 &&
        venteResponse.statusCode == 200) {
      final produitData = jsonDecode(produitResponse.body);
      final venteData = jsonDecode(venteResponse.body);

      if (produitData['message'] == 'product_success' &&
          venteData['message'] == 'vente_sucess') {
        // Succès de l'envoi, vider la table "vente" en local
        await clearLocalVenteData();
        EasyLoading.showSuccess('Succès');
      } else {
        EasyLoading.showError('Erreur lors de l\'enregistrement');
      }
    } else {
      EasyLoading.showError('Une erreur est survenue');
    }
  } on SocketException {
    EasyLoading.showError(
      duration: Duration(milliseconds: 1500),
      AppLocalizations.of(context)!.verified_internet,
    );
  } catch (e) {
    if (kDebugMode) {
      print(e);
    }
    EasyLoading.showError(
      duration: Duration(milliseconds: 1500),
      AppLocalizations.of(context)!.try_again,
    );
  }
}

Future<void> clearLocalVenteData() async {
  final db = await database; 
  await db.delete('vente');
}

  Future<Map<String, String>> getAllDataFromDatabase() async {
    final db = await database;

    // Récupérez toutes les données de la table "produit"
    final List<Map<String, dynamic>> produits = await db.query('produit');

    // Récupérez toutes les données de la table "vente"
    final List<Map<String, dynamic>> ventes = await db.query('vente');

    final produitJson = json.encode({'produit': produits});
    final venteJson = json.encode({'vente': ventes});

    return {'produit': produitJson, 'vente': venteJson};
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
        user.toJson(),
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
              dateVente: (items[i]['dateVente']),
              montantVente: items[i]['montantVente'],
              quantiteVendue: items[i]['quantiteVendue'],
            ));
  }

  Future<double> getTotalSalesBetweenDates(
      DateTime startDate, DateTime endDate) async {
    final db = await database;
    final startFormatted = DateFormat('yyyy-MM-dd').format(startDate);
    final endFormatted = DateFormat('yyyy-MM-dd').format(endDate);

    final result = await db.rawQuery(
      'SELECT SUM(montantVente) AS total FROM vente WHERE dateVente BETWEEN ? AND ?',
      [startFormatted, endFormatted],
    );
    final total = result.first['total'] as double? ?? 0.0;
    return total;
  }

  Future<double> getTotalSalesForToday() async {
    final db = await database;
    final formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    final result = await db.rawQuery(
      'SELECT SUM(montantVente) AS total FROM vente WHERE dateVente = ?',
      ['$formattedDate'],
    );

    final total = result.first['total'] as double? ?? 0.0;
    return total;
  }

  Future<List<Product>> getProductsSoldToday() async {
    final db = await database;
    final now = DateTime.now();
    final formattedDate = DateFormat('yyyy-MM-dd').format(now);

    final result = await db.rawQuery(
      'SELECT v.IDProduit, p.NomProduit, p.Description, p.prixAchat, p.prixVente, v.quantiteVendue, v.dateVente '
      'FROM vente AS v '
      'INNER JOIN produit AS p ON v.IDProduit = p.id '
      'WHERE v.dateVente LIKE ?'
      'GROUP BY v.IDProduit, p.NomProduit, p.Description, p.prixAchat, p.prixVente',
      ['$formattedDate%'], // Utilisez le format de date actuel
    );

    return result
        .map((row) => Product(
              id: row['IDProduit'] as int,
              nomProduit: row['nomProduit'] as String,
              description: row['description'] as String,
              creationDate: DateTime.parse(row['dateVente'] as String),
              prixVente: row['prixVente'] as double,
              prixAchat: row['prixAchat'] as double,
              quantite: row['quantiteVendue'] as int,
            ))
        .toList();
  }

  //ZAZ

  Future<List<RecetteModel>> detailIcome(int id) async {
    final db = await database;

    final result = await db.rawQuery(
      'SELECT v.IDProduit, p.NomProduit, p.Description, p.prixAchat, p.prixVente,v.dateVente, '
          'SUM(v.quantiteVendue) AS totalQuantiteVendue, '
          'SUM(v.montantVente) AS total '
          'FROM vente AS v '
          'INNER JOIN produit AS p ON v.IDProduit = p.id '
          'WHERE v.IDProduit LIKE ? '
          'GROUP BY v.dateVente ',
      ['$id%'], // Utilisez le format de date actuel
    );


    return result
        .map((row) => RecetteModel(
      id: row['IDProduit'] as int,
      nomProduit: row['nomProduit'] as String,
      total: row['total'] as double,
      quantity: row['totalQuantiteVendue'] as int,
      creationDate: DateTime.parse(row['dateVente'] as String),
    ))
        .toList();
  }



  Future<List<RecetteModel>> dailyIncome() async {
    final db = await database;
    final now = DateTime.now();
    final formattedDate = DateFormat('yyyy-MM-dd').format(now);

    final result = await db.rawQuery(
      'SELECT v.IDProduit, p.NomProduit, p.Description, p.prixAchat, p.prixVente,v.dateVente, '
          'SUM(v.quantiteVendue) AS totalQuantiteVendue, '
          'SUM(v.montantVente) AS total '
          'FROM vente AS v '
          'INNER JOIN produit AS p ON v.IDProduit = p.id '
          'WHERE v.dateVente LIKE ? '
          'GROUP BY v.IDProduit, p.NomProduit, p.Description',
      ['$formattedDate%'], // Utilisez le format de date actuel
    );


    return result
        .map((row) => RecetteModel(
      id: row['IDProduit'] as int,
      nomProduit: row['nomProduit'] as String,
      total: row['total'] as double,
      quantity: row['totalQuantiteVendue'] as int,
      creationDate: DateTime.parse(row['dateVente'] as String),
    ))
        .toList();
  }

  Future<List<RecetteModel>> weekIncomeData() async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT v.IDProduit, p.NomProduit, p.Description, p.prixAchat, p.prixVente,v.dateVente, '
          'SUM(v.quantiteVendue) AS totalQuantiteVendue, '
          'SUM(v.montantVente) AS total '
          'FROM vente AS v '
          'INNER JOIN produit AS p ON v.IDProduit = p.id '
          'WHERE strftime("%Y-%W", v.dateVente) = strftime("%Y-%W", "now")'
          'GROUP BY v.IDProduit, p.NomProduit, p.Description',
    );

    return result
        .map((row) => RecetteModel(
      id: row['IDProduit'] as int,
      nomProduit: row['nomProduit'] as String,
      total: row['total'] as double,
      quantity: row['totalQuantiteVendue'] as int,
      creationDate: DateTime.parse(row['dateVente'] as String),
    ))
        .toList();
  }
  Future<List<RecetteModel>> MonthIncomeData() async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT v.IDProduit, p.NomProduit, p.Description, p.prixAchat, p.prixVente,v.dateVente, '
          'SUM(v.quantiteVendue) AS totalQuantiteVendue, '
          'SUM(v.montantVente) AS total '
          'FROM vente AS v '
          'INNER JOIN produit AS p ON v.IDProduit = p.id '
          'WHERE strftime("%Y-%m", v.dateVente) = strftime("%Y-%m", "now")'
          'GROUP BY v.IDProduit, p.NomProduit, p.Description',
    );

    return result
        .map((row) => RecetteModel(
      id: row['IDProduit'] as int,
      nomProduit: row['nomProduit'] as String,
      total: row['total'] as double,
      quantity: row['totalQuantiteVendue'] as int,
      creationDate: DateTime.parse(row['dateVente'] as String),
    ))
        .toList();
  }
  Future<List<RecetteModel>> YearIncomeData() async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT v.IDProduit, p.NomProduit, p.Description, p.prixAchat, p.prixVente,v.dateVente, '
          'SUM(v.quantiteVendue) AS totalQuantiteVendue, '
          'SUM(v.montantVente) AS total '
          'FROM vente AS v '
          'INNER JOIN produit AS p ON v.IDProduit = p.id '
          'GROUP BY v.IDProduit, p.NomProduit, p.Description',
    );

    return result
        .map((row) => RecetteModel(
      id: row['IDProduit'] as int,
      nomProduit: row['nomProduit'] as String,
      total: row['total'] as double,
      quantity: row['totalQuantiteVendue'] as int,
      creationDate: DateTime.parse(row['dateVente'] as String),
    ))
        .toList();
  }

  Future<double> getweekincome()async{
    final db = await database;
    final result = await db.rawQuery(
      'SELECT SUM(montantVente) AS total '
      'FROM vente '
      'WHERE strftime("%Y-%W", dateVente) = strftime("%Y-%W", "now")',
    );

    final total = result.first['total'] as double? ?? 0.0;
    return total;
  }
  Future<double> getmonthincome()async{
    final db = await database;
    final result = await db.rawQuery(
        'SELECT SUM(montantVente) AS total '
            'FROM vente '
            'WHERE strftime("%Y-%m", dateVente) = strftime("%Y-%m", "now")'
    );
    final total = result.first['total'] as double? ?? 0.0;
    return total;
  }
  Future<double> getyearincome()async{
    final db = await database;
    final result = await db.rawQuery(
        'SELECT SUM(montantVente) AS total '
            'FROM vente '
    );
    final total = result.first['total'] as double? ?? 0.0;
    return total;
  }

  Future<bool> logout() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.remove('username');
    await pref.remove('email');
    await pref.remove('phone');
    return await pref.remove('id');
  }
  Future<String> getUserId() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return decrypt(pref.getString('user_id').toString());
  }

  Future<String> getRole() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return decrypt(pref.getString('role').toString());
  }
//get email
  Future<String> getEmail() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return decrypt(pref.getString('email').toString());
  }
//get username
  Future<String> getUserName() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    return decrypt(pref.getString('username').toString());
  }
}
