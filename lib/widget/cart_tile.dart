import 'package:flutter/material.dart';
import 'package:m_product/model/product.dart';
import 'package:m_product/screens/details_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../utils/theme.dart';
import 'custom_number_input.dart';

class CartTile extends StatelessWidget {
  final Product product;

  const CartTile({
    super.key,
    required this.product,
  });

  void _showQuantityBottomSheet(BuildContext context) {
    int selectedQuantity = 1;

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return SizedBox(
              // Utilisez SizedBox pour définir la hauteur du contenu
              height: MediaQuery.of(context).size.height *
                  0.4, // Ajustez la hauteur comme vous le souhaitez
              child: Container(
                padding: EdgeInsets.all(10.0),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        AppLocalizations.of(context)!.product_quantity,
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(height: 16.0),
                      CustomNumberInput(
                        value: selectedQuantity,
                        onDecrease: () {
                          setState(() {
                            if (selectedQuantity >= 1) {
                              selectedQuantity--;
                            }
                          });
                        },
                        onIncrease: () {
                          print(product.quantity);
                          setState(() {
                            if (selectedQuantity < product.quantity) {
                              selectedQuantity++;
                            } else {}
                          });
                        },
                      ),
                      SizedBox(height: 16.0),
                      ElevatedButton(
                        onPressed: () {
                          // Fermez le BottomSheet et utilisez selectedQuantity ici
                          Navigator.of(context).pop(selectedQuantity);
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
              ),
            );
          },
        );
      },
    ).then((result) {
      // Après la fermeture du BottomSheet, vous pouvez utiliser la valeur saisie ici
      if (result != null) {
        print('Quantité saisie : $result');
        // Vous pouvez faire quelque chose avec la valeur, par exemple, l'envoyer à votre backend ou effectuer un traitement.
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => DetailsScreen(
            product: product,
          ),
        ));
      },
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Container(
                  height: 85,
                  width: 85,
                  decoration: BoxDecoration(
                    color: kcontentColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.all(10),
                  child: Image.asset(
                    product.image,
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      product.description,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade400,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "\$${product.sellingPrice}",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "${product.quantity} produits disponibles",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            top: 5,
            right: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () {
                    _showQuantityBottomSheet(context);
                  },
                  icon: const Icon(
                    Icons.shop,
                    color: kblue,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
