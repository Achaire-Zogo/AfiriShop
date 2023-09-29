import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:m_product/screens/recette.dart';
import 'package:m_product/screens/stock.dart';

import 'home_screen.dart';


class GreatHome extends StatefulWidget {
  @override
  _GreatHomeState createState() => _GreatHomeState();
}

class _GreatHomeState extends State<GreatHome> {
  List<Widget> tabs = [];

  int currentTabIndex = 0;


  @override
  void initState() {
    super.initState();
    tabs = [
      const HomeScreen(),
      const Recette(),
      const Stock(),
    ];
  }

  @override
  void dispose() {
    EasyLoading.dismiss();
    super.dispose();
  }

  onTapped(int index) {
    setState(() {
      currentTabIndex = index;
    });
  }

  Future<void> _showExitConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible:
      false, // L'utilisateur ne peut pas annuler en cliquant à l'extérieur
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            // Supprimer les bords
            borderRadius: BorderRadius.circular(0),
          ),
          title: Text(AppLocalizations.of(context)!.exit_title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(AppLocalizations.of(context)!.exit_text),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(AppLocalizations.of(context)!.exit_response_non),
              onPressed: () {
                Navigator.of(context).pop(); // Fermer la boîte de dialogue
              },
            ),
            TextButton(
              child: Text(AppLocalizations.of(context)!.exit_response_oui),
              onPressed: () {
                Navigator.of(context).pop(); // Fermer la boîte de dialogue
                SystemNavigator.pop();
              },
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) => WillPopScope(
    onWillPop: () async {
      _showExitConfirmationDialog(context);
      return false;
    },
    child: Scaffold(
      body: tabs[currentTabIndex],
      extendBody: true,
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTapped,
        currentIndex: currentTabIndex,
        backgroundColor: Colors.blueGrey,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.production_quantity_limits),
            label: AppLocalizations.of(context)!.setting,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.storage),
            label: 'Stock',
          ),
        ],
        selectedItemColor: Colors.blue.shade400,
      ),
    ),
  );
}
