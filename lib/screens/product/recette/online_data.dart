import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../../model/product.dart';
import '../../../urls/all_url.dart';
import '../../../widget/recette_card.dart';

class OnlineGetProduct extends StatefulWidget {
  const OnlineGetProduct({super.key});

  @override
  State<OnlineGetProduct> createState() => _OnlineGetProductState();
}

class _OnlineGetProductState extends State<OnlineGetProduct> {
  Future<List<ProductInfo>>? productInfoFuture;

  @override
  void initState() {
    super.initState();
    productInfoFuture = fetchProductInfoFromApi();
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
      appBar: AppBar(),
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

              return ListView.builder(
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
                      // ... autres informations sur le produit à afficher ici
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}

class ProductInfo {
  final String nomProduit;
  final DateTime dateVente;
  final int quantiteVendue;
  final String prix;

  ProductInfo({
    required this.nomProduit,
    required this.dateVente,
    required this.quantiteVendue,
    required this.prix,
  });
}
