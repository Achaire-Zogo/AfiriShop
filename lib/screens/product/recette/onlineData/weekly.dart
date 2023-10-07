import 'dart:convert';
import 'dart:io';
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

class WeeklyGetProduct extends StatefulWidget {
  const WeeklyGetProduct({super.key});

  @override
  State<WeeklyGetProduct> createState() => _WeeklyGetProductState();
}

class _WeeklyGetProductState extends State<WeeklyGetProduct> {
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
      final apiUrl = Uri.parse(Urls.getweek);
      final response = await http.get(apiUrl);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        List<ProductInfo> productInfoList = [];

        data.forEach((item) {
          final int quantiteVendue = item['quantiteVendue'];

          ProductInfo productInfo = ProductInfo(
            nomProduit: item['produit']['nomProduit'],
            quantiteVendue: quantiteVendue,
            prix: item['montantVente'],
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder<List<ProductInfo>>(
          future: productInfoFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Erreur: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('Aucun produit trouvé'));
            } else {
              final productInfoList = snapshot.data!;

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
                          child: EntreeRecente(
                            date: DateFormat('yyyy-MM-dd')
                                .format(productInfo.dateVente),
                            descriptionProduit: productInfo.nomProduit,
                            prix: (double.parse(productInfo.prix) /
                                productInfo
                                    .quantiteVendue), // Mettez le prix correct ici
                            quantite: productInfo.quantiteVendue,
                            afficherTroisiemeColonne: true,
                          ),
                        );
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
