import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../IndexHome.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => GreatHome()),
                (route) => false);
        return false;

      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.about_us),
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => GreatHome()),
                      (route) => false);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              size: 20,
              color: Colors.black,
            ),
          ),
        ),
        body: Container(
          padding: EdgeInsets.symmetric(vertical: 1.0, horizontal: 30.0),
          margin: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        "AFIRISHOP",
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Color(0xFF303030),
                        ),
                      ),
                    ),
                    Image.asset(
                      'lib/logo/1024.png',
                      height: 100,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        '1.0',
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Color(0xFF303030),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Center(
                child: Text('MIT'),
              ),
            ],
          ),
        ),
        // Center(
        //   child: Container(
        //     margin: EdgeInsets.symmetric(
        //         horizontal: MediaQuery.of(context).size.width / 20),
        //     child: Column(
        //       crossAxisAlignment: CrossAxisAlignment.center,
        //       children: [
        //         Text("Kufuli Pro"),
        //         SizedBox(height: 5),
        //         Image.asset(
        //           'lib/resources/1024.png',
        //           height: 50,
        //         ),
        //         SizedBox(height: 5),
        //         Text("1.26"),
        //         SizedBox(height: 5),
        //         Text("Copyright Aloa-Tech"),
        //       ],
        //     ),
        //   ),
        // )
        // body: FutureBuilder<Html>(
        //     future: HTMLParser().getHtmlPage(Urls.url_about_us, elementID),
        //     builder: (context, snapshot) {
        //       return Center(
        //         child: Container(
        //           margin: EdgeInsets.symmetric(
        //               horizontal: MediaQuery.of(context).size.width / 20),
        //           child: SingleChildScrollView(
        //               child: snapshot.connectionState == ConnectionState.waiting
        //                   ? CircularProgressIndicator()
        //                   : snapshot.data),
        //         ),
        //       );
        //     })
      ),
    );
  }
}
