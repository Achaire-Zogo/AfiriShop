import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../route/route_name.dart';
import '../urls/all_url.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late Timer _timer;
  String? email;
  bool islog = false;

  _loadUserInfo() async {
    //EasyLoading.show(status: "Loading...");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String check = prefs.getString('email').toString();
    timer?.cancel();

    islog = prefs.getBool('isLogged') ?? false;
    if (islog) {
      NavigationServices(context).gotoHomeScreen();
    } else {
      NavigationServices(context).gotoLoginScreen();
    }

    // if (check.isEmpty) {
    //   timer?.cancel();
    //   NavigationServices(context).gotoLoginScreen();
    // } else {
    //   try {
    //     email = decrypt(prefs.getString('email').toString());
    //     var url = Uri.parse(Urls.user);
    //     final response = await http.post(url, headers: {
    //       "Accept": "application/json"
    //     }, body: {
    //       "email": encrypt(email!),
    //       "action": encrypt("rentali_want_to_check_email_user_splashscreen")
    //     });
    //     // print(json.decode(response.body));
    //     var data = jsonDecode(response.body);
    //     if (kDebugMode) {
    //       print('dsd');
    //       print(data);
    //     }

    //     if (response.statusCode == 200) {
    //       timer?.cancel();
    //       var user_detail = data['data'];
    //       String email = user_detail['email'];
    //       String user_name = user_detail['user_name'];
    //       String tel = user_detail['phone_number'];
    //       SharedPreferences pref = await SharedPreferences.getInstance();
    //       await pref.setString('username', encrypt(user_name));
    //       await pref.setString('email', encrypt(email));
    //       await pref.setString('phone', encrypt(tel));
    //       NavigationServices(context).gotoBottomScreen(0);
    //     } else {
    //       timer?.cancel();
    //       if (data['status'] == 'error') {
    //         if (data['message'] == 'User request to delete account') {
    //           NavigationServices(context).gotoLoginScreen();
    //         }
    //         if (data['message'] == 'user is not active') {
    //           NavigationServices(context).gotoLoginScreen();
    //         }
    //         if (data['message'] == 'User not exist') {
    //           NavigationServices(context).gotoLoginScreen();
    //         } else {
    //           NavigationServices(context).gotoLoginScreen();
    //         }
    //       }
    //     }
    //   } on SocketException {
    //     if (kDebugMode) {
    //       print('bbbbbbbbb');
    //     }
    //     EasyLoading.showError(
    //       duration: Duration(milliseconds: 1500),
    //       AppLocalizations.of(context)!.verified_internet,
    //     );
    //   } catch (e) {
    //     if (kDebugMode) {
    //       print('Try cathc for splashcreen to the App ################');
    //     }
    //     if (kDebugMode) {
    //       print(e.toString());
    //     }
    //     // EasyLoading.showError(duration: Duration(milliseconds: 1500),
    //     //   AppLocalizations.of(context)!.try_again,
    //     // );
    //     timer?.cancel();
    //     NavigationServices(context).gotoLoginScreen();
    //   }
    // }
  }

  Timer? timer;
  @override
  void initState() {
    timer = Timer.periodic(
        const Duration(seconds: 10), (Timer t) => _loadUserInfo());
    _loadUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Container(
              height: double.infinity,
              width: double.infinity,
              child: Image.asset(
                'assets/illustration-3.png',
                fit: BoxFit.fill,
              ),
            ),
            const Align(
              alignment: Alignment.center,
              child: Center(child: CircularProgressIndicator()),
            ),
          ],
        ),
      ),
    );
  }
}
