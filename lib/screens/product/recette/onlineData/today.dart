import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../../../db/localDb.dart';
import '../../../../model/RecetteModel.dart';
import '../../../../urls/all_url.dart';
import '../../../../widget/custom_number_input.dart';
import '../../../../widget/recette_card.dart';
import '../../stock.dart';
import 'DetailOnlineData.dart';

class OnlineGetProduct extends StatefulWidget {
  const OnlineGetProduct({super.key});

  @override
  State<OnlineGetProduct> createState() => _OnlineGetProductState();
}

class _OnlineGetProductState extends State<OnlineGetProduct> {
  Future<List<ProductInfo>>? productInfoFuture;
  List<RecetteModel> recetteList = [];
  List<RecetteModel> _filter_recette = [];
  late Future<List<RecetteModel>> recett;

  @override
  void initState() {
    super.initState();
    productInfoFuture = fetchProductInfoFromApi();
  }

  final _debouncer = Debouncer(milliseconds: 2000);

  searchField() {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: TextField(
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(5.0),
          hintText: AppLocalizations.of(context)!.search_product,
          prefixIcon: Icon(Icons.search),
        ),
        onChanged: (string) {
          _debouncer.run(() {
            // Filter the original List and update the Filter list
            setState(() {
              _filter_recette = recetteList
                  .where((u) => (u.nomProduit
                      .toLowerCase()
                      .contains(string.toLowerCase())))
                  .toList();
            });
          });
        },
      ),
    );
  }

  Future<List<ProductInfo>> fetchProductInfoFromApi() async {
    EasyLoading.show(status: "Chargement...");

    try {
      final apiUrl = Uri.parse(Urls.recup);
      final response = await http.get(apiUrl);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        List<ProductInfo> productInfoList = [];

        data.forEach((item) {
          final String quantiteVendue = item['totalQuantiteVendue'].toString();
          print(item['IDProduit'].runtimeType);
          ProductInfo productInfo = ProductInfo(
            idProduit: item['IDProduit'],
            nomProduit: item['NomProduit'],
            quantiteVendue: int.parse(quantiteVendue),
            prix: item['total'].toString(),
            dateVente: DateFormat('yyyy-MM-dd').parse(item['dateVente']),
          );

          productInfoList.add(productInfo);
        });

        EasyLoading.dismiss();

        return productInfoList;
      } else {
        EasyLoading.showError('Erreur lors de la récupération des produits');
        throw Exception(
            'Erreur lors de la récupération des produits depuis l\'API');
      }
    } on SocketException {
      EasyLoading.showError('Erreur de connexion');
      throw Exception('Erreur de connexion à l\'API');
    } catch (e) {
      print('Erreur inattendue : $e');
      EasyLoading.showError('Erreur inattendue');
      throw Exception('Erreur inattendue : $e');
    }
  }

  double totalSales = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder<List<ProductInfo>>(
          future: productInfoFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Column(
                children: [
                  Center(child: CircularProgressIndicator()),
                ],
              );
            } else if (snapshot.hasError) {
              return Center(child: Text('Erreur: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('Aucun produit trouvé'));
            } else {
              final productInfoList = snapshot.data!;
              totalSales = 0.0; // Réinitialisez le total des ventes
              for (final productInfo in productInfoList) {
                totalSales += double.parse(productInfo.prix);
              }

              return Column(
                children: [
                  searchField(),
                  Expanded(
                    child: ListView.builder(
                      itemCount: productInfoList.length,
                      itemBuilder: (context, index) {
                        final productInfo = productInfoList[index];

                        return Padding(
                            padding: EdgeInsets.symmetric(vertical: 4.0),
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            DetailOnlineProduct(
                                                idProduct: 
                                                    productInfo.idProduit)),
                                    (route) => false);
                              },
                              child: EntreeRecente(
                                date: DateFormat('yyyy-MM-dd')
                                    .format(productInfo.dateVente),
                                descriptionProduit: productInfo.nomProduit,
                                prix: double.parse(productInfo
                                    .prix), // Mettez le prix correct ici
                                quantite: productInfo.quantiteVendue,
                                afficherTroisiemeColonne: true,
                              ),
                            ));
                      },
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
