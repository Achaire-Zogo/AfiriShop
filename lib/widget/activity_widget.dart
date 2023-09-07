import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../utils/theme.dart';

class CustomProductCard extends StatefulWidget {
  final IconData iconData;
  final String title;
  final double todayPrice;
  final double yesterdayPrice;
  final String obtainDate;

  CustomProductCard({
    required this.iconData,
    required this.title,
    required this.todayPrice,
    required this.yesterdayPrice,
    required this.obtainDate,
  });

  @override
  State<CustomProductCard> createState() => _CustomProductCardState();
}

class _CustomProductCardState extends State<CustomProductCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kwhite,
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      padding: EdgeInsets.all(10),
      // margin: EdgeInsets.only(left: 0),
      // width: 220,
      height: 250, // Augmenter la largeur du conteneur
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  // border: Border.all(
                  //   color: Colors.black, // Couleur de la bordure noire
                  //   width: 2.0, // Largeur de la bordure de 2 pixels
                  // ),
                  borderRadius: BorderRadius.circular(8.0), // Rayon des coins
                  color: kgrey.withOpacity(0.2), // Couleur intérieure blanche
                ),
                child: Icon(
                  widget.iconData,
                  color: kblack,
                  size: 30,
                ),
              ),
              SizedBox(
                  width:
                      10), // Réduisez l'espacement entre le conteneur de l'icône et le texte "title"
              Text(
                widget.title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${widget.todayPrice.toString()} FCFA',
                style: TextStyle(
                  fontSize:
                      24, // Augmentez la taille de la police pour "todayPrice"
                  fontWeight: FontWeight.bold,
                  color: Colors.yellow, // Couleur jaune pour "todayPrice"
                ),
              ),
              // Text(
              //   '${widget.todayPrice.toString()} FCFA',
              //   style: TextStyle(
              //     fontSize:
              //         24, // Augmentez la taille de la police pour "todayPrice"
              //     fontWeight: FontWeight.bold,
              //     color: Colors.yellow, // Couleur jaune pour "todayPrice"
              //   ),
              // ),
            ],
          ),
          SizedBox(height: 8),
          Divider(
            // height: 50,
            thickness: 1.5,
          ),
          Text(
            '${widget.yesterdayPrice.toString()} FCFA',
            style: TextStyle(
              fontSize:
                  18, // Taille de police plus petite pour "yesterdayPrice"
              color: Colors.blue, // Couleur noire pour "yesterdayPrice"
            ),
          ),
          SizedBox(height: 5),
          Text(
            widget.obtainDate.toString(),
            style: TextStyle(
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class ActionsWidget extends StatelessWidget {
  final IconData iconData;
  final String title;

  ActionsWidget({
    required this.iconData,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 5),
      child: Card(
        shadowColor: Colors.grey.withOpacity(0.5),
        elevation: 0.5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.2),
              ),
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: Colors.grey.withOpacity(0.2),
                ),
                child: Icon(
                  iconData,
                  color: Colors.black,
                  size: 25,
                ),
              ),
            ),
            SizedBox(width: 10), // Espace entre l'icône et le texte "title"
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
