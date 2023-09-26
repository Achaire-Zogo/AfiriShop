import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;

import '../../api/encrypt.dart';
import '../../urls/all_url.dart';
import 'login.dart';
import 'otp/OtpScreen.dart';

class ForgetPasswordEnterEmailPage extends StatefulWidget {
  @override
  _ForgetPasswordEnterEmailPageState createState() =>
      _ForgetPasswordEnterEmailPageState();
}

class _ForgetPasswordEnterEmailPageState
    extends State<ForgetPasswordEnterEmailPage> {
  Timer? _timer;
  bool _isObscure = true;
  String email = "";
  //creation d'une cle pour verifier que le formulaire est bien rempli
  final _key = GlobalKey<FormState>();

  void verifiedEmail(String email) async {
    var url = Uri.parse(Urls.user);
    final response = await http.post(url, body: {
      "email_admin": encrypt(email),
      "action": encrypt('afiri_want_to_check_email_user_now')
    });

    if (response.statusCode == 200) {
      setState(() {
        _loading = false;
      });
      if (kDebugMode) {
        print(response.body);
      }
      var data = jsonDecode(response.body);

      if (data["status"] == 'success') {
        var data_all = data['data'];
        String email = data_all['email'];
        String code = data_all['code_verif'].toString();
        EasyLoading.showSuccess('success');
        setState(() {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => OtpScreen(
                email: email,
                code: code,
              )),
                  (route) => false);
        });
      } else {
        if (data["status"] == 'error') {
          setState(() {
            _loading = false;
          });
          EasyLoading.showError(AppLocalizations.of(context)!.invalid_email);
        }
        else {
          setState(() {
            _loading = false;
          });
          EasyLoading.showError(AppLocalizations.of(context)!.error_occur);
        }

        }
      }
    }


  @override
  void dispose() {
    super.dispose();
    EasyLoading.dismiss();
  }

  bool _loading = false;

  Future<bool> back() async {
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
        return back();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          title: Text(
           AppLocalizations.of(context)!.recovery_password,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
          ),
          brightness: Brightness.light,
          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              size: 20,
              color: Colors.black,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 1.0, horizontal: 30.0),
            child: Form(
              key: _key, //liaison de la cle avec le formulaire
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Image.asset(
                    'brand.png',
                    height: 50,
                  ),
                  // SizedBox(height: 5),
                  Text(
                    AppLocalizations.of(context)!.enter_valid_email,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                  SizedBox(height: 90),
                  Center(
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.email),
                      ),
                      keyboardType: TextInputType.emailAddress,

                      //recuperations des valeurs entre par l'utilisateur
                      validator: (val) => validateEmail(val!) != null
                          ? AppLocalizations.of(context)!.required
                          : null,
                      onChanged: (val) => email = val,
                    ),
                  ),
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: SizedBox(height: 10.0)),

                  _loading
                      ? Center(child: CircularProgressIndicator())
                      : MaterialButton(
                    onPressed: () {
                      if (_key.currentState!.validate()) {
                        setState(() {
                          _loading = true;
                        });
                        verifiedEmail(email);
                      }
                    },
                    textColor: Colors.white,
                    color: Colors.blue,
                    child: SizedBox(
                      width: double.infinity,
                      child: Text(
                        AppLocalizations.of(context)!.send_request,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    height: 50,
                    minWidth: 600,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String? validateEmail(String value) {
    String pattern =
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?)*$";
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value) || value == null)
      return 'Enter a valid email address';
    else
      return null;
  }
}

class BuildingButton extends StatelessWidget {
  final Image iconImage;
  final String textButton;
  BuildingButton({required this.iconImage, required this.textButton});
  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    return Container(
      height: mediaQuery.height * 0.06,
      width: mediaQuery.width * 0.36,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          iconImage,
          SizedBox(
            width: 5,
          ),
          Text(textButton),
        ],
      ),
    );
  }
}
