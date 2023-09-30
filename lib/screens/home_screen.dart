import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:m_product/db/localDb.dart';
import 'package:m_product/route/route_name.dart';
import 'package:m_product/screens/product/add_product.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widget/activity_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentSlide = 0;
  bool isLoading = true;
  double totalSalesToday = 0.0;
  double totalSalesLastWeek = 0.0;
  double totalSalesLastMonth = 0.0;
  double totalSalesYerstaday = 0.0;

  @override
  void initState() {
    init();
    super.initState();
    EasyLoading.dismiss();
    setState(() {
      isLoading = false;
    });
  }

  Future<void> init() async {
    final currentDate = DateTime.now();
    final lastWeekStartDate = currentDate.subtract(const Duration(days: 7));
    final lastMonthStartDate = DateTime(
      currentDate.year,
      currentDate.month - 1,
      1,
    );

    final yesterdayDate = currentDate.subtract(const Duration(days: 1));

    final todaySales = await LocalDataBase(context).getTotalSalesForToday();
    totalSalesYerstaday =
        await LocalDataBase(context).getTotalSalesBetweenDates(
              yesterdayDate,
              currentDate,
            ) -
            todaySales; // Soustraire le montant des ventes d'aujourd'hui

    totalSalesToday = await LocalDataBase(context).getTotalSalesForToday();
    totalSalesLastWeek = await LocalDataBase(context).getTotalSalesBetweenDates(
      lastWeekStartDate,
      currentDate,
    );
    totalSalesLastMonth =
        await LocalDataBase(context).getTotalSalesBetweenDates(
      lastMonthStartDate,
      currentDate,
    );

    setState(() {
      totalSalesToday;
      totalSalesLastWeek;
      totalSalesLastMonth;
      totalSalesYerstaday;
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
                await LocalDataBase(context).sendDataToAPI();
              },
              icon: const Icon(Icons.online_prediction_outlined)),
          IconButton(
              onPressed: () {
                setState(() {
                  isLoading = true;
                });
              },
              icon: Icon(Icons.refresh_outlined)),
        ],
        leading: IconButton(
            onPressed: () async {
              final SharedPreferences prefs =
                  await SharedPreferences.getInstance();

              await prefs.remove('email');
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
                    Container(
                      height: 200,
                      child: CustomProductCard(
                        yesterdayPrice: totalSalesYerstaday,
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
                              title: AppLocalizations.of(context)!.add_message,
                            ),
                          ),
                          ActionsWidget(
                            iconData: Icons.payment,
                            title:
                                '${AppLocalizations.of(context)!.daylys_payment}\n\n$totalSalesToday Frcfa',
                          ),
                          ActionsWidget(
                            iconData: Icons.payment,
                            title:
                                '${AppLocalizations.of(context)!.weekly_payment}\n\n$totalSalesLastWeek Frcfa',
                          ),
                          ActionsWidget(
                            iconData: Icons.payment,
                            title:
                                '${AppLocalizations.of(context)!.monthly_payment}\n\n$totalSalesLastMonth Frcfa',
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
