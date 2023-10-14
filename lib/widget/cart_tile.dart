import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:m_product/model/product.dart';
import 'package:m_product/model/vente_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:m_product/screens/product/details_card.dart';
import '../db/localDb.dart';
import '../utils/theme.dart';
import 'custom_number_input.dart';

class CartTile extends StatefulWidget {
  final int id;
  final String nomProduit;
  final String description;
  // final String image;
  final double prixAchat;
  final double prixVente;
  final int quantite;
  final DateTime creationDate;

  const CartTile(
      {required this.id,
      required this.prixVente,
      required this.nomProduit,
      required this.description,
      required this.prixAchat,
      required this.quantite,
      required this.creationDate,
      Key? key})
      : super(key: key);

  @override
  State<CartTile> createState() => _CartTileState();
}

class _CartTileState extends State<CartTile> {
  int selectedQuantity = 1;

  void _showQuantityBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return SizedBox(
              // Utilisez SizedBox pour définir la hauteur du contenu
              height: MediaQuery.of(context).size.height *
                  0.7, // Ajustez la hauteur comme vous le souhaitez
              child: Container(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Nom du produit:",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black, // Couleur personnalisée
                              ),
                            ),
                            Text(
                              widget.nomProduit,
                              style: TextStyle(
                                fontSize: 22, // Taille de police plus grande
                                fontWeight: FontWeight.bold, // Texte en gras
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Quantité en stock du produit:",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black, // Couleur personnalisée
                              ),
                            ),
                            Text(
                              widget.quantite.toString(), // Convertir en chaîne
                              style: TextStyle(
                                fontSize: 22, // Taille de police plus grande
                                fontWeight: FontWeight.bold, // Texte en gras
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      AppLocalizations.of(context)!.product_quantite,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold, // Texte en gras
                      ),
                    ),
                    SizedBox(height: 16.0),
                    CustomNumberInput(
                      value: selectedQuantity,
                      onDecrease: () {
                        setState(() {
                          if (selectedQuantity > 1) {
                            selectedQuantity--;
                          }
                        });
                      },
                      onIncrease: () {
                        setState(() {
                          if (selectedQuantity < widget.quantite) {
                            selectedQuantity++;
                          } else {}
                        });
                      },
                    ),
                    SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: () async {
                        EasyLoading.show(
                          status: AppLocalizations.of(context)!.loading,
                          dismissOnTap: false,
                        );
                        LocalDataBase(context).addSale(
                          Vente(
                            IDProduit: widget.id,
                            montantVente: (selectedQuantity * widget.prixVente),
                            quantiteVendue: selectedQuantity,
                            dateVente: DateFormat('yyyy-MM-dd').format(DateTime.now()),
                          ),
                          widget.id, // ID du produit
                          selectedQuantity, // Quantité vendue
                          (selectedQuantity *
                              widget.prixVente), // Montant de la vente
                          context,
                        );
                      },
                      style: ButtonStyle(
                        elevation: MaterialStateProperty.all(
                            0), // Supprimer l'élévation
                        backgroundColor: MaterialStateProperty.all(
                            Colors.blue), // Couleur de fond personnalisée
                        minimumSize: MaterialStateProperty.all(
                            Size(double.infinity, 48)), // Largeur maximale
                      ),
                      child: Text(AppLocalizations.of(context)!.product_sale,
                          style: TextStyle(fontSize: 18)),
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    ).then((result) {
      // Après la fermeture du BottomSheet, vous pouvez utiliser la valeur saisie ici
      // if (result != null) {
      //   print('Quantité saisie : $result');
      //   // Vous pouvez faire quelque chose avec la valeur, par exemple, l'envoyer à votre backend ou effectuer un traitement.
      // }
    });
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      selectedQuantity;
    });
    return GestureDetector(
      onTap: () {
        _showQuantityBottomSheet(context);
      },
      onLongPress: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => DetailsScreen(
            product: Product(
                id: widget.id,
                nomProduit: widget.nomProduit,
                description: widget.description,
                prixAchat: widget.prixAchat,
                prixVente: widget.prixVente,
                quantite: widget.quantite,
                creationDate: widget.creationDate),
          ),
        ));
      },
      child: Stack(
        children: [
          Card(
            elevation: 0.5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5), // Les coins arrondis
            ),
            color: kgrey, // La couleur de la carte
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  // Container(
                  //   height: 85,
                  //   width: 85,
                  //   decoration: BoxDecoration(
                  //     color: kcontentColor,
                  //     borderRadius: BorderRadius.circular(15),
                  //   ),
                  //   padding: const EdgeInsets.all(10),
                  //   // child: Image.asset(
                  //   //   'assets/beauty.png',
                  //   // ),
                  // ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.nomProduit,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        widget.description,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: kblack,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "${widget.prixVente} FCFA",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "${widget.quantite} produits disponibles",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
