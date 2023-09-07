import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:m_product/widget/recette_card.dart';

import '../db/localDb.dart';
import '../model/product.dart';

class GetProductToday extends StatefulWidget {
  const GetProductToday({super.key});

  @override
  State<GetProductToday> createState() => _GetProductTodayState();
}

class _GetProductTodayState extends State<GetProductToday> {
  @override
  Widget build(BuildContext context) {
   

    final db = LocalDataBase(context);
    return Expanded(
      child: FutureBuilder(
        future: db.getProductsSoldToday(),
        initialData: const [],
        builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
          var data =
              snapshot.data; // this is the data we have to show. (list of todo)
          var datalength = data!.length;

          return datalength == 0
              ? const Center(
                  child: Text('no data found'),
                )
              : ListView.builder(
                  itemCount: datalength,
                  itemBuilder: (context, i) {
                    final item = data[i];

                    // Vérifiez si la quantité est supérieure à zéro avant d'afficher l'élément
                    if (item.quantite > 0) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 4.0),
                        child: EntreeRecente(
                          date: data[i].creationDate.toString(),
                          descriptionProduit: data[i].description,
                          prix: data[i].prixVente,
                          quantite: data[i].quantite,
                          afficherTroisiemeColonne: true,
                          // ... autres informations sur le produit à afficher ici
                        ),
                      );
                    } else {
                      // Si la quantité est <= 0, retournez un conteneur vide ou null pour ne pas afficher l'élément
                      return SizedBox.shrink(); // Un conteneur vide
                      // Ou retournez simplement null
                      // return null;
                    }
                  },
                );
        },
      ),
    );
  }
}
