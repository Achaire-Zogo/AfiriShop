import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:m_product/db/localDb.dart';

import '../utils/card_costum.dart';
import '../utils/list_title_costum.dart';
import '../utils/theme.dart';
import 'myDrawer/NavDrawer.dart';

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
  double totalSalesYear = 0.0;

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
    totalSalesYerstaday = await LocalDataBase(context).getTotalSalesBetweenDates(yesterdayDate, currentDate,) - todaySales; // Soustraire le montant des ventes d'aujourd'hui

    totalSalesToday = await LocalDataBase(context).getTotalSalesForToday();
    totalSalesLastWeek = await LocalDataBase(context).getweekincome();
    totalSalesLastMonth = await LocalDataBase(context).getmonthincome();
    totalSalesYear = await LocalDataBase(context).getyearincome();

    setState(() {
      totalSalesToday;
      totalSalesLastWeek;
      totalSalesLastMonth;
      totalSalesYerstaday;
      totalSalesYear;
      isLoading = false;
    });
  }

  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
                  init();
                });
              },
              icon: Icon(Icons.refresh_outlined)),
        ],
      ),
      drawer: NavDrawer(),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment
                      .center, // Ajustez l'alignement horizontal si nécessaire
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: size.width / 2 - 20,
                            child: Column(
                              children: [
                                CustomPaint(
                                  //foregroundPainter: CircleProgress(),
                                  child: SizedBox(
                                    width: 157,
                                    height: 90,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          totalSalesToday.toString()+' FCFA',
                                          style: textBold3,
                                        ),
                                        Text(
                                          "REACH Today",
                                          style: textSemiBold,
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            const Icon(
                                              Icons.arrow_upward_outlined,
                                              color: green,
                                              size: 14,
                                            ),
                                            Text(
                                              "8.1%",
                                              style: textSemiBold,
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Text(
                                  "Yesterday ACHIEVMENT",
                                  style: textBold2,
                                ),
                                Text(
                                  totalSalesYerstaday.toString()+ ' FCFA',
                                  style: textBold,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 100,
                            height: 180,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage("lib/logo/1024.png"))),
                          )
                        ],
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          RichText(
                            text: TextSpan(
                                text: "Key metrics",
                                style: GoogleFonts.montserrat().copyWith(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 18,
                                    color: purple1),
                                children: const <TextSpan>[
                                  TextSpan(
                                      text: " this week",
                                      style: TextStyle(fontWeight: FontWeight.bold))
                                ]),
                          ),
                          const SizedBox( height: 20,),
                          CardCustom(
                            width: size.width/ 2 - 23,
                            height: 88.9,
                            mLeft: 0,
                            mRight: 3,
                            child: ListTileCustom(
                              bgColor: purpleLight,
                              pathIcon: "line.svg",
                              title: "Daily",
                              subTitle: "$totalSalesToday Frcfa",
                            ),
                          ),
                          CardCustom(
                            width: size.width/ 2 - 23,
                            height: 88.9,
                            mLeft: 3,
                            mRight: 0,
                            child: ListTileCustom(
                              bgColor: greenLight,
                              pathIcon: "thumb_up.svg",
                              title: "Weekly",
                              subTitle: "$totalSalesLastWeek Frcfa",
                            ),
                          ),
                          CardCustom(
                            width: size.width/ 2 - 23,
                            height: 88.9,
                            mLeft: 0,
                            mRight: 3,
                            child: ListTileCustom(
                              bgColor: yellowLight,
                              pathIcon: "starts.svg",
                              title: "Monthly",
                              subTitle: "$totalSalesLastMonth Frcfa",
                            ),
                          ),
                          CardCustom(
                            width: size.width/ 2 - 23,
                            height: 88.9,
                            mLeft: 3,
                            mRight: 0,
                            child: ListTileCustom(
                              bgColor: blueLight,
                              pathIcon: "eyes.svg",
                              title: "Annual",
                              subTitle: "$totalSalesYear FCFA",
                            ),
                          ),
                        ],
                      ),
                    ),




                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     Text(
                    //       'Actions',
                    //       textAlign: TextAlign.start,
                    //       semanticsLabel: '',
                    //       style: Theme.of(context).textTheme.titleLarge,
                    //     ),
                    //   ],
                    // ),
                    // SingleChildScrollView(
                    //   child: Column(
                    //     children: [
                    //       // ActionsWidget(
                    //       //   iconData: Icons.attach_money,
                    //       //   title: AppLocalizations.of(context)!.add_sale,
                    //       // ),
                    //       GestureDetector(
                    //         onTap: () {
                    //           Navigator.of(context).push(MaterialPageRoute(
                    //             builder: (context) => addProduct(),
                    //           ));
                    //         },
                    //         child: ActionsWidget(
                    //           iconData: CupertinoIcons.add,
                    //           title: AppLocalizations.of(context)!.add_message,
                    //         ),
                    //       ),
                    //       ActionsWidget(
                    //         iconData: Icons.payment,
                    //         title:
                    //             '${AppLocalizations.of(context)!.daylys_payment}\n\n$totalSalesToday Frcfa',
                    //       ),
                    //       ActionsWidget(
                    //         iconData: Icons.payment,
                    //         title:
                    //             '${AppLocalizations.of(context)!.weekly_payment}\n\n$totalSalesLastWeek Frcfa',
                    //       ),
                    //       ActionsWidget(
                    //         iconData: Icons.payment,
                    //         title:
                    //             '${AppLocalizations.of(context)!.monthly_payment}\n\n$totalSalesLastMonth Frcfa',
                    //       ),
                    //     ],
                    //   ),
                    // )
                  ],
                ),
              ),
            ),
    );
  }
}
