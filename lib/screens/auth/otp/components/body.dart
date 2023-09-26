import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;

import '../../../../api/encrypt.dart';
import '../../../../urls/all_url.dart';
import '../../login.dart';
import '../OtpScreen.dart';
import 'constants.dart';
import 'otp_form.dart';

class MyBody extends StatelessWidget {
  MyBody({required this.email, required this.code});

  final String email;
  final String code;
  Future<bool> back(BuildContext context) async {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => LogInScreen()));

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return back(context);
      },
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 15),
                Text(
                  AppLocalizations.of(context)!.otp_verification,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
                Text(
                  AppLocalizations.of(context)!.we_send_otp_to,
                  textAlign: TextAlign.center,
                ),
                Text(
                  email,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 14),
                ),
                buildTimer(),
                SizedBox(height: 80),
                OtpForm(
                  email: email,
                  code: code,
                ),
                SizedBox(height: 30),
                GestureDetector(
                  onTap: () async {
                    EasyLoading.show();
                    try {
                      var url = Uri.parse(Urls.user);
                      final response = await http.post(url, body: {
                        "email_admin": encrypt(email),
                        "action": encrypt('afiri_want_to_check_email_user_now')
                      });

                      if (response.statusCode == 200) {
                        if (kDebugMode) {
                          print(response.body);
                        }
                        var data = jsonDecode(response.body);

                        if (data["status"] == 'success') {
                          var data_all = data['data'];
                          String email = data_all['email'];
                          String code = data_all['code_verif'].toString();
                          EasyLoading.showSuccess('success');

                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(builder: (context) => OtpScreen(
                                email: email,
                                code: code,
                              )),
                                  (route) => false);

                        } else {
                          if (data["status"] == 'error') {
                            EasyLoading.showError(
                                AppLocalizations.of(context)!.invalid_email);
                          } else {
                            EasyLoading.showError(
                                AppLocalizations.of(context)!.error_occur);
                          }
                        }
                      }
                    } on SocketException catch (e) {
                      print(e);
                      EasyLoading.showError(
                          AppLocalizations.of(context)!.verified_internet);
                    } catch (e) {
                      print(e);
                      EasyLoading.showError(
                          AppLocalizations.of(context)!.error_occur);
                    }
                  },
                  child: Text(
                    AppLocalizations.of(context)!.resend_code,
                    style: TextStyle(decoration: TextDecoration.underline),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row buildTimer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("This code will expired in "),
        TweenAnimationBuilder(
          tween: Tween(begin: 30.0, end: 0.0),
          duration: Duration(seconds: 30),
          builder: (_, dynamic value, child) => Text(
            "00:${value.toInt()}",
            style: TextStyle(color: kPrimaryColor),
          ),
        ),
      ],
    );
  }
}
