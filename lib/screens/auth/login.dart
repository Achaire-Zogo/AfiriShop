import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../api/encrypt.dart';
import '../../urls/all_url.dart';
import '../../utils/theme.dart';
import '../../widget/primary_button.dart';
import '../IndexHome.dart';
import 'forget_password_enter_email.dart';

class LogInScreen extends StatefulWidget {
  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  bool _isObscure = true;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController pswController = TextEditingController();
  String emailc = '', verif_code = '';

  Int8List? _bytes;



  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _showExitConfirmationDialog(context);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ksecondryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          title: Text(AppLocalizations.of(context)!.login_key),
          centerTitle: true,
          automaticallyImplyLeading: false,
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.info)),
          ],
        ),
        body: Padding(
          padding: kDefaultPadding,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 200,
                ),
                Text(
                  AppLocalizations.of(context)!.login_message,
                  style: titleText,
                ),
                SizedBox(
                  height: 5,
                ),
                Column(
                  children: [
                    buildInputForm('Email', false, emailController),
                    buildInputForm(AppLocalizations.of(context)!.input_pass,
                        true, pswController),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      //n'a pas de bordure
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ForgetPasswordEnterEmailPage()));
                        }, //navigation vers la page forget password
                        child: Text(
                          AppLocalizations.of(context)!.forgot_password,
                          style: const TextStyle(color: Colors.redAccent),
                        ))
                  ],
                ),
                SizedBox(height: 10.0),
                PrimaryButton(
                  buttonText: AppLocalizations.of(context)!.login_key,
                  ontap: () async {
                    if (validateLoginForm(emailController.text.trim(), pswController.text)) {

                      login(emailController.text.trim(),pswController.text);
                      // if (await LocalDataBase(context)
                      //     .getUser(emailController.text, pswController.text)) {
                      //   final SharedPreferences prefs =
                      //       await SharedPreferences.getInstance();
                      //
                      //   await prefs.setBool('isLogged', true);
                      //   NavigationServices(context).gotoHomeScreen();
                      // } else {
                      //   EasyLoading.showError(
                      //     AppLocalizations.of(context)!.try_again,
                      //     dismissOnTap: false,
                      //   );
                      // }
                      // await LocalDataBase(context).addUser(User(
                      //     username: 'rentali',
                      //     mdp: pswController.text,
                      //     email: emailController.text));
                    }

                    // Navigator.push(context,
                    //     MaterialPageRoute(builder: (context) => MyHomePage()));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showExitConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible:
          false, // L'utilisateur ne peut pas annuler en cliquant à l'extérieur
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            // Supprimer les bords
            borderRadius: BorderRadius.circular(0),
          ),
          title: Text(AppLocalizations.of(context)!.exit_title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(AppLocalizations.of(context)!.exit_text),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(AppLocalizations.of(context)!.exit_response_non),
              onPressed: () {
                Navigator.of(context).pop(); // Fermer la boîte de dialogue
              },
            ),
            TextButton(
              child: Text(AppLocalizations.of(context)!.exit_response_oui),
              onPressed: () {
                Navigator.of(context).pop(); // Fermer la boîte de dialogue
                SystemNavigator.pop();
              },
            ),
          ],
        );
      },
    );
  }

  login(String email, String password) async {
    EasyLoading.show(status: "Loading...");
    var url = Uri.parse(Urls.user);
    // try {

    try {
      final response = await http.post(url, headers: {
        "Accept": "application/json"
      }, body: {
        "email": encrypt(email),
        "password": encrypt(password),
        "action": encrypt("afiri_want_to_login_user_now")
      });
      // print(json.decode(response.body));
      var data = jsonDecode(response.body);
      if (kDebugMode) {
        print('dssd');
        print(data);
      }

      if (response.statusCode == 200) {
        if (data['status'] == 'error') {
          if (data['message'] == 'Incorrect password') {
            EasyLoading.showError(
              duration: Duration(milliseconds: 1500),
              AppLocalizations.of(context)!.incorrect_psw,
            );
          } else if (data['message'] == 'This email not exist') {
            EasyLoading.showError(
              duration: Duration(milliseconds: 1500),
              AppLocalizations.of(context)!.incorrect_email,
            );
          } else {
            EasyLoading.dismiss();
            if (kDebugMode) {
              print(data['message'] + "show error another error");
            }
          }
        } else {
          EasyLoading.dismiss();
          var user_detail = data['data'];
          String email = user_detail['email'];
          String user_name = user_detail['username'];
          String tel = user_detail['phone'];
          String id = user_detail['id'].toString();
          SharedPreferences pref = await SharedPreferences.getInstance();
          await pref.setString('username', encrypt(user_name));
          await pref.setString('email', encrypt(email));
          await pref.setString('phone', encrypt(tel));
          await pref.setString('user_id', encrypt(id));

          EasyLoading.showSuccess('Success');
           Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => GreatHome()),
                  (route) => false);
        }
      } else {
        EasyLoading.showError(
          duration: Duration(milliseconds: 1500),
          AppLocalizations.of(context)!.try_again,
        );
      }
    } on SocketException {
      if (kDebugMode) {
        print('bbbbbbbbb');
      }
      EasyLoading.showError(
        duration: Duration(milliseconds: 1500),
        AppLocalizations.of(context)!.verified_internet,
      );
    } catch (e) {
      if (kDebugMode) {
        print('Try cathc for login to the App ################');
      }
      if (kDebugMode) {
        print(e.toString());
      }
      EasyLoading.showError(
        duration: Duration(milliseconds: 1500),
        AppLocalizations.of(context)!.try_again,
      );
    }
  }

// Fonction de validation du formulaire de connexion (login)
  bool validateLoginForm(String email, String password) {
    // Vérification si aucun champ n'est vide
    if (email.isEmpty || password.isEmpty) {
      EasyLoading.showError(AppLocalizations.of(context)!.error_all_fields,
          duration: Duration(seconds: 3));

      return false;
    }

    // Vérification si l'email est au bon format
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      EasyLoading.showError(AppLocalizations.of(context)!.invalid_email,
          duration: Duration(seconds: 3));
      return false;
    }

    // Si toutes les validations sont réussies, retourne true pour indiquer que le formulaire est valide
    return true;
  }

// Utilisation de la fonction de validation dans un exemple de formulaire de connexion (login)

  Padding buildInputForm(
      String label, bool pass, TextEditingController textEditingController) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: TextFormField(
        controller: textEditingController,
        obscureText: pass ? _isObscure : false,
        decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(
              color: kTextFieldColor,
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: kPrimaryColor),
            ),
            suffixIcon: pass
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        _isObscure = !_isObscure;
                      });
                    },
                    icon: _isObscure
                        ? Icon(
                            Icons.visibility_off,
                            color: kTextFieldColor,
                          )
                        : Icon(
                            Icons.visibility,
                            color: kPrimaryColor,
                          ),
                  )
                : null),
      ),
    );
  }
}
