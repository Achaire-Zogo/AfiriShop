import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:m_product/screens/product/recette/localData/home/IndexRecette.dart';
import 'package:m_product/screens/product/recette/onlineData/home/IndexRecette.dart';
import 'package:m_product/screens/product/recette/onlineData/today.dart';
import 'package:m_product/screens/product/stock.dart';

import 'home_screen.dart';
import 'myDrawer/NavDrawer.dart';

class GreatHome extends StatefulWidget {
  const GreatHome({super.key,required this.pos});
  final int pos;
  @override
  _GreatHomeState createState() => _GreatHomeState(pos);
}

class _GreatHomeState extends State<GreatHome> {

  int currentTabIndex;
  _GreatHomeState(this.currentTabIndex,) {
    super.initState();
  }
  List<Widget> tabs = [];


  @override
  void initState() {
    super.initState();
    tabs = [
      const HomeScreen(),
      const IndexRecette(),
      const OnlineIndexRecette(),
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
          drawer: NavDrawer(),
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
                icon: Icon(Icons.get_app),
                label: 'online',
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
