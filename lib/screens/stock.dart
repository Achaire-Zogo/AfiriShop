import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:m_product/db/localDb.dart';
import 'package:m_product/screens/recette.dart';
import 'package:m_product/utils/theme.dart';
import 'package:m_product/widget/product_list.dart';

import '../model/product.dart';
import '../widget/cart_tile.dart';
import 'add_product.dart';
import 'home_screen.dart';

class Stock extends StatefulWidget {
  const Stock({super.key});

  @override
  State<Stock> createState() => _StockState();
}

class _StockState extends State<Stock> {
  List<dynamic> productList = [];
  List<Product> product = [];
  bool isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLoading = true;
    EasyLoading.dismiss();
    // WidgetsBinding.instance.addPostFrameCallback((_) async {
    // });
  }

  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        isLoading = false;
      });
    });
    return Scaffold(
      backgroundColor: kgrey.withOpacity(0.3),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        // title: Text(AppLocalizations.of(context)!.home_message),
        title: Text(AppLocalizations.of(context)!.all_pro),
        centerTitle: false,
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  isLoading = true;
                });
              },
              icon: Icon(Icons.refresh_outlined)),
          IconButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => addProduct()),);
              },
              icon: const Icon(Icons.add)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: [
                  Productlist(),
                ],
              ),
      ),
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
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => Recette(),
                ));
              },
            ),
            label: AppLocalizations.of(context)!.setting,
          ),
          BottomNavigationBarItem(
              icon: IconButton(
                icon: Icon(Icons.storage),
                onPressed: () {
                 
                },
              ),
              // label: AppLocalizations.of(context)!.product_add,
              label: 'stock'),
        ],
        currentIndex: 2,
        selectedItemColor: Colors.blue.shade400,
        onTap: (index) {},
      ),
    );
  }
}
