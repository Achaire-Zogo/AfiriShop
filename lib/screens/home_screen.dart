import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:m_product/db/localDb.dart';
import 'package:m_product/route/route_name.dart';
import 'package:m_product/screens/recette.dart';
import 'package:m_product/screens/stock.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widget/activity_widget.dart';
import 'add_product.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentSlide = 0;
  bool isLoading = true;
  double totalSalesToday = 0;
  double totalSalesBetweenDates = 0;


  @override
  void initState() {
    // TODO: implement initState
    get_detail();
    super.initState();
    EasyLoading.dismiss();
  }
  get_detail(){
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      DateTime startDate = DateTime.now();
      final endDate = DateTime.now(); // Date de fin de la période
      totalSalesBetweenDates = await LocalDataBase(context)
          .getTotalSalesBetweenDates(startDate, endDate);
      print(totalSalesBetweenDates);
      totalSalesToday = await LocalDataBase(context).getTotalSalesForToday();
      print(totalSalesToday);
    });
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        title: Text(AppLocalizations.of(context)!.home_message),
        centerTitle: false,
        actions: [
          IconButton(
              onPressed: () async {
                final jsonData =
                    await LocalDataBase(context).getAllDataFromDatabase();
                print(jsonData);
              },
              icon: const Icon(Icons.online_prediction_outlined)),
          IconButton(
              onPressed: () {
                setState(() {
                  isLoading = true;
                  get_detail();
                });
              },
              icon: Icon(Icons.refresh_outlined)),
        ],
        leading: IconButton(
            onPressed: () async {
              final SharedPreferences prefs =
                  await SharedPreferences.getInstance();

              await prefs.remove('isLogged');
              NavigationServices(context).gotoLoginScreen();
            },
            icon: Icon(Icons.logout_outlined)),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment
                      .start, // Ajustez l'alignement horizontal si nécessaire
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.continue_aisement,
                            textAlign: TextAlign.start,
                            semanticsLabel:
                                // AppLocalizations.of(context)!.more_option_hotel,
                                '',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.activity_sms,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          TextButton(
                              onPressed: () {},
                              child: Text(
                                  AppLocalizations.of(context)!.see_more))
                        ],
                      ),
                    ),
                    Container(
                      height: 200,
                      child: CustomProductCard(
                        yesterdayPrice: totalSalesBetweenDates,
                        iconData: Icons.monetization_on_outlined,
                        obtainDate: 'Obtenu Hier',
                        todayPrice: totalSalesToday,
                        title: 'Recette',
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Actions',
                          textAlign: TextAlign.start,
                          semanticsLabel: '',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ],
                    ),
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          // ActionsWidget(
                          //   iconData: Icons.attach_money,
                          //   title: AppLocalizations.of(context)!.add_sale,
                          // ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => addProduct(),
                              ));
                            },
                            child: ActionsWidget(
                              iconData: CupertinoIcons.add,
                              title:
                                  AppLocalizations.of(context)!.add_message,
                            ),
                          ),
                          ActionsWidget(
                            iconData: Icons.payment,
                            title: '${AppLocalizations.of(context)!.daylys_payment}\n\n17 000 Frcfa',
                          ),
                          ActionsWidget(
                            iconData: Icons.payment,
                            title: '${AppLocalizations.of(context)!.weekly_payment}\n\n23 000 Frcfa',
                          ),
                          ActionsWidget(
                            iconData: Icons.payment,
                            title: '${AppLocalizations.of(context)!.monthly_payment}\n\n35 000 Frcfa',
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
