import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:m_product/widget/recette_card.dart';

import '../db/localDb.dart';

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
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 4.0),
                      child: EntreeRecente(
                        date: DateFormat('yyyy-MM-dd')
                            .format(data[i].creationDate),
                        descriptionProduit: data[i].description,
                        prix: data[i].prixVente,
                        quantite: data[i].quantite,
                        afficherTroisiemeColonne: true,
                        // ... autres informations sur le produit à afficher ici
                      ),
                    );
                  },
                );
        },
      ),
    );
  }
}
