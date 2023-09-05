import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:m_product/db/localDb.dart';
import 'package:m_product/screens/stock.dart';

import 'home_screen.dart';

class Recette extends StatefulWidget {
  const Recette({super.key});

  @override
  State<Recette> createState() => _RecetteState();
}

class _RecetteState extends State<Recette> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Widget build(BuildContext context) {
    LocalDataBase(context).getAllvente();
    return Scaffold(
      appBar: AppBar(),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: IconButton(
              icon: Icon(Icons.home),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => HomeScreen(),
                ));
              },
            ),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: IconButton(
              icon: Icon(Icons.production_quantity_limits),
              onPressed: () {},
            ),
            label: AppLocalizations.of(context)!.setting,
          ),
          BottomNavigationBarItem(
              icon: IconButton(
                icon: Icon(Icons.storage),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => Stock(),
                  ));
                },
              ),
              // label: AppLocalizations.of(context)!.product_add,
              label: 'stock'),
        ],
        currentIndex: 1,
        selectedItemColor: Colors.blue.shade400,
        onTap: (index) {},
      ),
    );
  }
}
