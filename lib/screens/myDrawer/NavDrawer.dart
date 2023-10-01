import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:m_product/screens/auth/login.dart';

import '../../db/localDb.dart';
import 'AboutUs.dart';

class NavDrawer extends StatefulWidget {
  NavDrawer() : super();
  @override
  _NavDrawerState createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  // UserModel user;
  BuildContext? _context;
  _NavDrawerState() {
    super.initState();
  }
  String idu1 = '';
  String idu2 = '';
  String email1 = '';
  String email2 = '';
  String userName1 = '';
  String userName2 = '';

  Future<void> gett() async {
    idu2 = await LocalDataBase(context).getUserId();
    email2 = await LocalDataBase(context).getEmail();
    userName2 = await LocalDataBase(context).getUserName();
    setState(() {
      idu1 = idu2;
      email1 = email2;
      userName1 = userName2;
    });
  }



  @override
  void initState() {
    gett();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: new Text(userName1,
                style:
                    new TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0)),
            accountEmail: new Text(email1),
            currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage('lib/logo/1024.png')),
            // decoration: new BoxDecoration(color: Colors.green),
          ),
          // ListTile(
          //   onTap: () {
          //     Navigator.pushReplacement(
          //         context,
          //         MaterialPageRoute(
          //             builder: (BuildContext context) => ProfilePage()));
          //   },
          //   leading: Icon(Icons.person),
          //   title: Text(AppLocalizations.of(context)!.profile),
          // ),

          ListTile(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => AboutPage()));
            },
            leading: Icon(Icons.badge),
            title: Text(AppLocalizations.of(context)!.about_us),
          ),

          ListTile(
            onTap: () {
              final db = LocalDataBase(context);
              db.logout().then((value) => {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => LogInScreen()),
                        (route) => false)
                  });
            },
            leading: const Icon(Icons.exit_to_app),
            title: Text("Exit"),
          ),
          ListTile(
            onTap: () async {
              // const url = 'https://play.google.com/store/apps/details?id=fr.android.kufuli_pro';
              // if (await canLaunch(url)) {
              //   await launch(
              //     url,
              //     forceSafariVC: true,
              //     forceWebView: true,
              //     enableJavaScript: true,
              //   );
              // }
            },
            leading: const Icon(Icons.info_sharp),
            title: const Text(
              '1.0',
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
