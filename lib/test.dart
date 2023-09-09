//  Future<void> addSale(Vente vente, int id, int newQuantite) async {
//     try {
//       final db = await database;

//       // Vérifiez si le produit existe déjà dans la table vente
//       final existingSale = await db.query(
//         'vente',
//         where: 'IDProduit = ?',
//         whereArgs: [vente.IDProduit],
//       );

//       if (existingSale.isNotEmpty) {
//         final existingQuantite = existingSale[0]['quantiteVendue'] as int;
//         final existingMontant = existingSale[0]['montantVente'] as double;

//         final newQuantiteVendue = existingQuantite + newQuantite;
//         final newMontantVente = vente.montantVente + existingMontant;

//         // Mettez à jour la quantité vendue et le montant de la vente
//         await db.update(
//           'vente',
//           {
//             'quantiteVendue': newQuantiteVendue,
//             'montantVente': newMontantVente,
//           },
//           where: 'IDProduit = ?',
//           whereArgs: [vente.IDProduit],
//         );
//       } else {
//         // Si le produit n'existe pas dans la table vente, insérez une nouvelle ligne
//         await db.insert(
//           'vente',
//           vente.toMap(),
//           conflictAlgorithm: ConflictAlgorithm.replace,
//         );
//       }

//       // Mettez à jour la quantité vendue dans la table produit
//       await db.update(
//         'produit',
//         {'quantite': newQuantite, 'creationDate': DateTime.now().toString()},
//         where: 'id = ?',
//         whereArgs: [id],
//       );

//       Future.delayed(Duration(seconds: 2), () {
//         Future.delayed(Duration(seconds: 1), () {
//           EasyLoading.showSuccess(AppLocalizations.of(context)!.add_sale);
//         });
//         NavigationServices(context).gotoHomeScreen();
//       });
//     } catch (e) {
//       print("Error selling product: $e");
//       EasyLoading.showError(
//         duration: Duration(milliseconds: 1500),
//         AppLocalizations.of(context)!.try_again,
//       );
//     }
//   }


// //   // Future<void> deleteDatabaseFile() async {
// //   //   try {
// //   //     final databasesPath = await getDatabasesPath();
// //   //     print(databasesPath);
// //   //     final path = join(databasesPath,
// //   //         'sqlite_master'); // Remplacez 'your_database.db' par le nom de votre base de données

// //   //     await deleteDatabase(path);

// //   //     print('Database deleted successfully');
// //   //   } catch (e) {
// //   //     print('Error deleting database: $e');
// //   //   }
// //   // }