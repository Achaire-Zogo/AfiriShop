import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:m_product/screens/product/recette/localData/recette.dart';
import 'package:m_product/screens/product/recette/onlineData/weekly.dart';
import 'package:m_product/screens/product/recette/onlineData/yearly.dart';

import '../monthly.dart';
import '../today.dart';

class OnlineIndexRecette extends StatefulWidget {
  const OnlineIndexRecette({
    Key? key,
  }) : super(key: key);
  @override
  State<OnlineIndexRecette> createState() => _OnlineIndexRecetteState();
}

class _OnlineIndexRecetteState extends State<OnlineIndexRecette> {
  _OnlineIndexRecetteState() {
    super.initState();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            // leading: IconButton(
            //   onPressed: () {
            //     back();
            //   },
            //   icon: Icon(
            //     Icons.arrow_back_ios,
            //     size: 20,
            //     color: Colors.black,
            //   ),
            // ),
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      colors: [
                        Colors.blueAccent,
                        Colors.greenAccent,
                      ],
                      begin: FractionalOffset(0.0, 0.0),
                      end: FractionalOffset(1.0, 0.0),
                      stops: [0.0, 1.0],
                      tileMode: TileMode.clamp)),
            ),
            title: Text(
              AppLocalizations.of(context)!.income_payement,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            centerTitle: true,
            bottom:
                TabBar(indicatorColor: Colors.white, indicatorWeight: 6, tabs: [
              Tab(
                text: AppLocalizations.of(context)!.daylys_payment,
                icon: const Icon(
                  Icons.payment,
                  color: Colors.white,
                ),
              ),
              Tab(
                text: AppLocalizations.of(context)!.weekly_payment,
                icon: const Icon(
                  Icons.payment_outlined,
                  color: Colors.white,
                ),
              ),
              Tab(
                text: AppLocalizations.of(context)!.monthly_payment,
                icon: const Icon(
                  Icons.payments,
                  color: Colors.white,
                ),
              ),
              Tab(
                text: AppLocalizations.of(context)!.income_payement,
                icon: const Icon(
                  Icons.payments_outlined,
                  color: Colors.white,
                ),
              ),
            ]),
          ),
          body: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    colors: [
                      Colors.blue,
                      Colors.purpleAccent,
                    ],
                    begin: FractionalOffset(0.0, 0.0),
                    end: FractionalOffset(1.0, 0.0),
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp)),
            child: const TabBarView(children: [
              OnlineGetProduct(),
              WeeklyGetProduct(),
              MonthlyProduct(),
              YearGetProduct(), // Text("Cycle")
            ]),
          ),
        ));
  }
}
