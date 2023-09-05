import 'package:flutter/material.dart';
import 'package:m_product/db/localDb.dart';
import 'package:m_product/widget/cart_tile.dart';

class Productlist extends StatefulWidget {
  // create an object of database connect
  // to pass down to todocard, first our todolist have to receive the functions

  Productlist({Key? key}) : super(key: key);

  @override
  State<Productlist> createState() => _ProductlistState();
}

class _ProductlistState extends State<Productlist> {
  Widget build(BuildContext context) {
    final db = LocalDataBase(context);
    return Expanded(
      child: FutureBuilder(
        future: db.getProduct(),
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
                        child: CartTile(
                          id: item.id,
                          description: item.description,
                          creationDate: item.creationDate,
                          prixVente: item.prixVente,
                          nomProduit: item.nomProduit,
                          prixAchat: item.prixAchat,
                          quantite: item.quantite,
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
