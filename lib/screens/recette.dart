import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:m_product/db/localDb.dart';
import 'package:m_product/screens/product/stock.dart';

import '../model/product.dart';
import '../widget/getproducts_sold_today.dart';
import '../widget/recette_card.dart';
import 'home_screen.dart';

class Recette extends StatefulWidget {
  const Recette({super.key});

  @override
  State<Recette> createState() => _RecetteState();
}

class _RecetteState extends State<Recette> {
  double totalSalesBetweenDates = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      DateTime startDate = DateTime.now();
      final endDate = DateTime.now()
          .subtract(Duration(days: 31)); // Date de fin de la période
      totalSalesBetweenDates = await LocalDataBase(context)
          .getTotalSalesBetweenDates(startDate, endDate);
    });
  }

  Widget build(BuildContext context) {
    LocalDataBase(context).getAllvente();

    return Scaffold(
      backgroundColor: Colors.grey.withOpacity(0.2),
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            RecetteCard(
              montantTotal: totalSalesBetweenDates,
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context)!.entree_recente,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  TextButton(
                      onPressed: () {},
                      child: Text(AppLocalizations.of(context)!.see_more))
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            GetProductToday(),
          ],
        ),
      ),
    );
  }
}
