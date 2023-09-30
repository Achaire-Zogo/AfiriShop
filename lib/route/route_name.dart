import 'package:flutter/material.dart';
import 'package:m_product/screens/auth/login.dart';
import 'package:m_product/screens/home_screen.dart';
import 'package:m_product/screens/product/stock.dart';

class NavigationServices {
  NavigationServices(this.context);

  final BuildContext context;

  Future<dynamic> _pushMaterialPageRoute(Widget widget,
      {bool fullscreenDialog = false}) async {
    return await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => widget, fullscreenDialog: fullscreenDialog),
    );
  }

  void back(Widget widget) async {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => widget), (route) => false);
  }

  Future<dynamic> gotoHomeScreen() async {
    return await _pushMaterialPageRoute(HomeScreen());
  }

  Future<dynamic> gotoLoginScreen() async {
    return await _pushMaterialPageRoute(LogInScreen());
  }

  Future<dynamic> gotoProductScreen() async {
    return await _pushMaterialPageRoute(Stock());
  }
}
