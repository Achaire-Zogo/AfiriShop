import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/IndexHome.dart';
import '../screens/auth/login.dart';


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late Timer _timer;
  String? email;

  _loadUserInfo() async {
    //EasyLoading.show(status: "Loading...");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String check = prefs.getString('email') ?? '';
    timer?.cancel();

    if (check != '') {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => GreatHome()),
          (route) => false);
      // Navigator.of(context).pushAndRemoveUntil(
      //     MaterialPageRoute(builder: (context) => LogInScreen()),
      //         (route) => false);
    } else {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LogInScreen()),
          (route) => false);
    }
  }

  Timer? timer;
  @override
  void initState() {
    // timer = Timer.periodic(
    //     const Duration(seconds: 10), (Timer t) => _loadUserInfo());
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
