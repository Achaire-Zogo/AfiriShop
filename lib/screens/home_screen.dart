import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'show_model.dart';
import '../model/cart_item.dart';
import '../widget/cart_tile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentSlide = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
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
        leading: IconButton(onPressed: () {}, icon: Icon(Icons.sort)),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemBuilder: (context, index) => CartTile(
          item: cartItems[index],
        ),
        separatorBuilder: (context, index) => const SizedBox(height: 20),
        itemCount: cartItems.length,
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
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => AddNewTaskModel(),
                ));
              },
            ),
            label: AppLocalizations.of(context)!.product_add,
          ),
          BottomNavigationBarItem(
            icon: IconButton(
              icon: Icon(Icons.person),
              onPressed: () {
                // Navigator.of(context).push(MaterialPageRoute(
                //   builder: (context) => Profile(),
                // ));
              },
            ),
            label: 'Profil',
          ),
        ],
        currentIndex: 0,
        selectedItemColor: Colors.blue.shade400,
        onTap: (index) {},
      ),
    );
  }
}
