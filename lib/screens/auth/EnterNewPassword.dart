import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;

import '../../api/encrypt.dart';
import '../../urls/all_url.dart';
import 'login.dart';

class EnterNewPassword extends StatefulWidget {
  EnterNewPassword({required this.email});
  final String email;
  @override
  _EnterNewPasswordState createState() => _EnterNewPasswordState(email);
}

class _EnterNewPasswordState extends State<EnterNewPassword> {
  _EnterNewPasswordState(String email) {
    this.email = email;
  }
  String email = '';

  Timer? _timer;
  bool _isObscure = true;
  String confirmPassword = "";
  String password = "";

  String erro = ""; //pour afficher les messages d'erreur
  bool _loading = false;

  @override
  void initState() {
    super.initState();
  }

  //fonction de login avec la BD
  void setPassword(String email, String pass) async {
    //cette fonction permet de faire un post dans la BD
    try {
      var url = Uri.parse(Urls.user);
      final response = await http.post(url, body: {
        "email": encrypt(email),
        "password": encrypt(pass),
        "action": encrypt('afiri_want_to_change_user_password_now')
      });
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        setState(() {
          _loading = false;
        });
        if (kDebugMode) {
          print(data);
        }
        if (data["status"] == 'success') {
          EasyLoading.showSuccess(
              AppLocalizations.of(context)!.success_operation);

          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => LogInScreen()),
              (route) => false);
        } else {
          if (data['status'] == 'error') {
            setState(() {
              EasyLoading.showError(
                  AppLocalizations.of(context)!.invalid_email);
              _loading = false;
            });
          } else {
            setState(() {
              EasyLoading.showError(AppLocalizations.of(context)!.error_occur);
              _loading = false;
            });
          }
        }
      } else {
        setState(() {
          _loading = false;
        });
        EasyLoading.showInfo(AppLocalizations.of(context)!.error_occur);
      }
    } on SocketException catch (e) {
      setState(() {
        _loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(AppLocalizations.of(context)!.verified_internet)));
    } catch (e) {
      setState(() {
        _loading = false;
      });
      EasyLoading.showInfo(AppLocalizations.of(context)!.error_occur);
    }
  }

  Future<bool> back() async {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LogInScreen()));

    return false;
  }

  //creation d'une cle pour verifier que le formulaire est bien rempli
  final _key = GlobalKey<FormState>();
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
            AppLocalizations.of(context)!.reset_password,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
          ),
          //brightness: Brightness.light,
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
                  Text(
                    AppLocalizations.of(context)!.set_new_password,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 24),
                  ),
                  SizedBox(height: 70),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.password,
                      hintText: AppLocalizations.of(context)!.password,
                      prefixIcon: Icon(Icons.lock),
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _isObscure = !_isObscure;
                          });
                        },
                        icon: Icon(_isObscure
                            ? Icons.visibility_off
                            : Icons.visibility),
                      ),
                    ),
                    obscureText: _isObscure,
                    validator: (val) => val!.length < 6
                        ? AppLocalizations.of(context)!.six_letter
                        : null,
                    onChanged: (val) => password = val,
                  ),
                  SizedBox(height: 10.0),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.confirm_password,
                      hintText: AppLocalizations.of(context)!.confirm_password,
                      prefixIcon: Icon(Icons.lock),
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _isObscure = !_isObscure;
                          });
                        },
                        icon: Icon(_isObscure
                            ? Icons.visibility_off
                            : Icons.visibility),
                      ),
                    ),
                    obscureText: _isObscure,
                    validator: (val) => val!.length < 6
                        ? AppLocalizations.of(context)!.six_letter
                        : null,
                    onChanged: (val) => confirmPassword = val,
                  ),
                  const SizedBox(height: 30.0),
                  const SizedBox(height: 10.0),
                  _loading
                      ? const Center(child: CircularProgressIndicator())
                      : MaterialButton(
                          onPressed: () {
                            if (_key.currentState!.validate() &&
                                password == confirmPassword) {
                              setState(() {
                                _loading = true;
                              });
                              setPassword(email, password);
                              // Navigator.push(context, MaterialPageRoute(builder: (context)=> HomePageAll()));
                            }
                          },
                          textColor: Colors.white,
                          color: Colors.blue,
                          height: 50,
                          minWidth: 600,
                          child: SizedBox(
                            width: double.infinity,
                            child: Text(
                              AppLocalizations.of(context)!.send_request,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class BuildingButton extends StatelessWidget {
  final Image iconImage;
  final String textButton;
  const BuildingButton(
      {super.key, required this.iconImage, required this.textButton});
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
          const SizedBox(
            width: 5,
          ),
          Text(textButton),
        ],
      ),
    );
  }
}
