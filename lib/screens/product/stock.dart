import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:m_product/db/localDb.dart';
import 'package:m_product/utils/theme.dart';
import '../../model/product.dart';
import '../../widget/cart_tile.dart';
import 'add_product.dart';

class Stock extends StatefulWidget {
  const Stock({super.key});

  @override
  State<Stock> createState() => _StockState();
}

class Debouncer {
  final int milliseconds;
  VoidCallback? action;
  Timer? _timer;

  Debouncer({required this.milliseconds});

  run(VoidCallback action) {
    if (null != _timer) {
      _timer!
          .cancel(); // when the user is continuosly typing, this cancels the timer
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}

class _StockState extends State<Stock> {
  List<Product> productList = [];
  List<Product> _filterproduct = [];
  late Future<List<Product>> product;

  final _debouncer = Debouncer(milliseconds: 2000);
  bool isLoading = true;
  @override
  void initState() {
    // TODO: implement initState
    getData();
    isLoading = false;
    super.initState();
    EasyLoading.dismiss();
    // WidgetsBinding.instance.addPostFrameCallback((_) async {
    // });
  }

  searchField() {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: TextField(
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(5.0),
          hintText: AppLocalizations.of(context)!.search_,
          prefixIcon: Icon(Icons.search),
        ),
        onChanged: (string) {
          _debouncer.run(() {
            setState(() {
              _filterproduct = productList
                  .where((u) => (u.nomProduit
                          .toLowerCase()
                          .contains(string.toLowerCase()) ||
                      u.prixAchat
                          .toString()
                          .toLowerCase()
                          .contains(string.toLowerCase()) ||
                      u.prixVente
                          .toString()
                          .toLowerCase()
                          .contains(string.toLowerCase())))
                  .toList();
            });
          });
        },
      ),
    );
  }

  getData() {
    final db = LocalDataBase(context);
    product = db.getProduct();
    //print('oooooooookkkkk');
    product.then((value) => {
          value.forEach((element) {
            //productList.add(Product.fromMap(element));
            setState(() {
              productList.add(element);
              _filterproduct.add(element);
              isLoading = false;
            });

            // print(productList);
          })
        });
  }

  Widget build(BuildContext context) {
    // Future.delayed(Duration(seconds: 2), () {
    //   setState(() {
    //     isLoading = false;
    //   });
    // });
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
                _filterproduct = [];
                setState(() {
                  isLoading = true;
                  getData();
                });
              },
              icon: const Icon(Icons.refresh_outlined)),
          IconButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => addProduct()),
                );
              },
              icon: const Icon(Icons.add)),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  searchField(),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _filterproduct.length,
                      itemBuilder: (context, i) {
                        final item = _filterproduct[i];
                        if (item.quantite > 0) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: CartTile(
                              id: item.id!,
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
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
