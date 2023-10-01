import 'package:flutter/material.dart';
import 'package:m_product/utils/theme.dart';

class RecetteCard extends StatelessWidget {
  final double montantTotal;
  const RecetteCard({
    super.key,
    required this.montantTotal,
  });
  String getMonthName(int month) {
    switch (month) {
      case 1:
        return 'janvier';
      case 2:
        return 'février';
      case 3:
        return 'mars';
      case 4:
        return 'avril';
      case 5:
        return 'mai';
      case 6:
        return 'juin';
      case 7:
        return 'juillet';
      case 8:
        return 'août';
      case 9:
        return 'septembre';
      case 10:
        return 'octobre';
      case 11:
        return 'novembre';
      case 12:
        return 'décembre';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final month = now.month;
    final year = now.year;
    final day = now.day;

    final monthName = getMonthName(month);

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white, // Couleur de la bordure
          width: 2.0, // Largeur de la bordure de 2 pixels
        ),
        borderRadius: BorderRadius.circular(8.0), // Rayon des coins
        color: Colors.white, // Couleur intérieure grise avec opacité
      ),
      padding: EdgeInsets.all(12.0),
      child: Column(
        children: [
          Container(
            height: 50,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey.withOpacity(0.2), // Couleur des bordures
                width: 2.0, // Largeur des bordures de 2 pixels
              ),
              borderRadius: BorderRadius.circular(8.0), // Rayon des coins
              color: Colors.grey
                  .withOpacity(0.2), // Couleur intérieure grise avec opacité
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0), // Ajoutez un padding ici
                  child: Text(
                    'Recette mensuelle',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black54, // Couleur du texte
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0), // Ajoutez un padding ici
                  child: Text(
                    '$day $monthName $year',
                    // Remplacez par le mois actuel
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black, // Couleur du texte
                    ),
                  ),
                ),
              ],
            ),
          ), // Espace entre les lignes

          // Deuxième ligne avec Recette totale et le montant
        ],
      ),
    );
  }
}

class EntreeRecente extends StatelessWidget {
  final String descriptionProduit;
  final double prix;
  final int quantite;
  final String date;
  final bool afficherTroisiemeColonne; // Paramètre optionnel

  const EntreeRecente({
    super.key,
    required this.descriptionProduit,
    required this.prix,
    required this.quantite,
    required this.date,
    this.afficherTroisiemeColonne =
        true, // Par défaut, affiche la troisième colonne
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey.withOpacity(0.2),
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.grey.withOpacity(0.2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              descriptionProduit, // Utilisez le paramètre descriptionProduit
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Divider(
              thickness: 2,
            ),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${prix * quantite} FCFA', // Utilisez le paramètre prix
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                VerticalDivider(
                  thickness: 2,
                  color: Colors.black, // Couleur noire
                ),
                Text(
                  '$quantite Unités', // Utilisez le paramètre quantite
                ),
                if (afficherTroisiemeColonne) ...[
                  VerticalDivider(
                    thickness: 2,
                  ),
                  Text(
                    date, // Utilisez le paramètre date
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
