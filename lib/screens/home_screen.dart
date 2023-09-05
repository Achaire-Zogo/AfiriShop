import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:m_product/db/localDb.dart';
import 'package:m_product/route/route_name.dart';
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    EasyLoading.dismiss();
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
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Icon(Icons.refresh)),
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
      body: Padding(
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
                        child: Text(AppLocalizations.of(context)!.see_more))
                  ],
                ),
              ),
              Container(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: yourDataList
                      .length, // Le nombre d'éléments que vous souhaitez afficher
                  itemBuilder: (BuildContext context, int index) {
                    final item = yourDataList[
                        index]; // Obtenez l'élément à l'index actuel
                    return CustomProductCard(
                      iconData: item.iconData,
                      title: item.title,
                      sellingbenefit: item.sellingbenefit,
                      benefit: item.benefit,
                      obtainDate: item.obtainDate,
                    );
                  },
                ),
              ),
              SizedBox(
                height: 5,
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
                    ActionsWidget(
                      iconData: Icons.attach_money,
                      title: AppLocalizations.of(context)!.add_sale,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => addProduct(),
                        ));
                      },
                      child: ActionsWidget(
                        iconData: CupertinoIcons.cube_box,
                        title: AppLocalizations.of(context)!.add_message,
                      ),
                    ),
                    ActionsWidget(
                      iconData: Icons.payment,
                      title: AppLocalizations.of(context)!.add_expense,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFD5E8FA),
        foregroundColor: Colors.blue.shade800,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        onPressed: () {},
        tooltip: AppLocalizations.of(context)!.product_add,
        child: const Icon(Icons.online_prediction_outlined),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: IconButton(
              icon: Icon(Icons.home),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => HomeScreen(),
                ));
              },
            ),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: IconButton(
              icon: Icon(Icons.production_quantity_limits),
              onPressed: () {},
            ),
            label: AppLocalizations.of(context)!.setting,
          ),
          BottomNavigationBarItem(
              icon: IconButton(
                icon: Icon(Icons.storage),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => Stock(),
                  ));
                },
              ),
              // label: AppLocalizations.of(context)!.product_add,
              label: 'stock'),
        ],
        currentIndex: 0,
        selectedItemColor: Colors.blue.shade400,
        onTap: (index) {},
      ),
    );
  }
}
