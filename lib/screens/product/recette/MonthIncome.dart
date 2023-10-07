import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:m_product/db/localDb.dart';
import 'package:m_product/screens/product/stock.dart';

import '../../../model/RecetteModel.dart';
import '../../../model/product.dart';
import '../../../widget/getproducts_sold_today.dart';
import '../../../widget/recette_card.dart';
import '../../home_screen.dart';

class MonthIncome extends StatefulWidget {
  const MonthIncome({super.key});

  @override
  State<MonthIncome> createState() => _MonthIncomeState();
}

class _MonthIncomeState extends State<MonthIncome> {
  double totalSalesBetweenDates = 0;
  var todaySales = 0.0;
  List<RecetteModel> recetteList = [];
  List<RecetteModel> _filter_recette = [];
  late Future<List<RecetteModel>> recett;

  get_value() async {

    final db = LocalDataBase(context);
    recett= db.MonthIncomeData();
    //print('oooooooookkkkk');
    recett.then((value) => {
      value.forEach((element) {
        // print(element);
        setState(() {
          recetteList.add(element);
          _filter_recette.add(element);
        });
      })
    });
    todaySales = await LocalDataBase(context).getmonthincome();
    setState(() {

    });
  }

  @override
  void initState() {
    // TODO: implement initState
    get_value();
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      DateTime startDate = DateTime.now();
      final endDate = DateTime.now()
          .subtract(Duration(days: 31)); // Date de fin de la période
      totalSalesBetweenDates = await LocalDataBase(context)
          .getTotalSalesBetweenDates(startDate, endDate);
    });
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

  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
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
            searchField(),
            RecetteCard(
              montantTotal: todaySales,
            ),
            Expanded(
                child: ListView.builder(
                  itemCount: _filter_recette.length,
                  itemBuilder: (context, i) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 4.0),
                      child: EntreeRecente(
                        date: DateFormat('yyyy-MM-dd')
                            .format(_filter_recette[i].creationDate),
                        descriptionProduit: _filter_recette[i].nomProduit,
                        prix: _filter_recette[i].total,
                        quantite: _filter_recette[i].quantity,
                        afficherTroisiemeColonne: true,
                      ),
                    );
                  },
                )
            ),
            // GetProductToday(),
          ],
        ),
      ),
    );
  }
}
