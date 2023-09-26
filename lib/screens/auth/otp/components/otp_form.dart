import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;

import '../../EnterNewPassword.dart';
import 'constants.dart';

class OtpForm extends StatefulWidget {
  OtpForm({required this.email,required this.code});
  final String email;
  final String code;
  @override
  _OtpFormState createState() => _OtpFormState(email,code);
}

class _OtpFormState extends State<OtpForm> {
  String? email = '';
  String? code = '';
  _OtpFormState(String email,String code) {
    this.email = email;
    this.code = code;
  }

  FocusNode? pin2FocusNode;
  FocusNode? pin3FocusNode;
  FocusNode? pin4FocusNode;

  final _key = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    pin2FocusNode = FocusNode();
    pin3FocusNode = FocusNode();
    pin4FocusNode = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    pin2FocusNode!.dispose();
    pin3FocusNode!.dispose();
    pin4FocusNode!.dispose();
    EasyLoading.dismiss();
  }

  void nextField(String value, FocusNode? focusNode) {
    if (value.length == 1) {
      focusNode!.requestFocus();
    }
  }

  int first = 0;
  int second = 0;
  int thirth = 0;
  int fourth = 0;

  void sendVerificationOtpCode(String coded) async {
    print(email);
    EasyLoading.show(status: AppLocalizations.of(context)!.loading);

    //cette fonction permet de faire un post dans la BD
    try {
      if(code == coded){
        EasyLoading.showSuccess(AppLocalizations.of(context)!.success_operation);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => EnterNewPassword(email: email!)));
      }
    } on SocketException catch (e) {
      print(e);
      EasyLoading.showError(AppLocalizations.of(context)!.verified_internet);
    } catch (e) {
      print(e);
      EasyLoading.showError(AppLocalizations.of(context)!.error_occur);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _key,
      child: Column(
        children: [
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 60,
                child: TextFormField(
                    autofocus: true,
                    obscureText: true,
                    style: TextStyle(fontSize: 24),
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    decoration: otpInputDecoration,
                    onChanged: (value) {
                      if (value.length == 1) {
                        nextField(value, pin2FocusNode);
                        first = int.parse(value);
                      }
                    }),
              ),
              SizedBox(
                width: 60,
                child: TextFormField(
                    focusNode: pin2FocusNode,
                    obscureText: true,
                    style: TextStyle(fontSize: 24),
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    decoration: otpInputDecoration,
                    onChanged: (value) {
                      if (value.length == 1) {
                        nextField(value, pin3FocusNode);
                        second = int.parse(value);
                      }
                    }),
              ),
              SizedBox(
                width: 60,
                child: TextFormField(
                    focusNode: pin3FocusNode,
                    obscureText: true,
                    style: TextStyle(fontSize: 24),
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    decoration: otpInputDecoration,
                    onChanged: (value) {
                      if (value.length == 1) {
                        nextField(value, pin4FocusNode);
                        thirth = int.parse(value);
                      }
                    }),
              ),
              SizedBox(
                width: 60,
                child: TextFormField(
                  focusNode: pin4FocusNode,
                  obscureText: true,
                  style: TextStyle(fontSize: 24),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: otpInputDecoration,
                  onChanged: (value) {
                    if (value.length == 1) {
                      pin4FocusNode!.unfocus();
                      fourth = int.parse(value);
                      // Then you need to check is the code is correct or not
                    }
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 40),
          MaterialButton(
            onPressed: () {
              if (_key.currentState!.validate()) {
                print(first);
                print(second);
                print(thirth);
                print(fourth);
                String f = first.toString();
                String s = second.toString();
                String t = thirth.toString();
                String fo = fourth.toString();

                String result = f + s + t + fo;
                int res = int.parse(result);
                print(res);
                print(email);
                sendVerificationOtpCode(result);
              }
            },
            textColor: Colors.white,
            color: Colors.blue,
            child: SizedBox(
              width: double.infinity,
              child: Text(
                "Send ->",
                textAlign: TextAlign.center,
              ),
            ),
            height: 50,
            minWidth: 600,
          ),
        ],
      ),
    );
  }
}
