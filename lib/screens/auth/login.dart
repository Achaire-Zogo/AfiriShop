import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:http/http.dart' as http;
import 'package:m_product/db/localDb.dart';
import 'package:m_product/route/route_name.dart';
import 'package:m_product/screens/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/theme.dart';
import '../../widget/primary_button.dart';

class LogInScreen extends StatefulWidget {
  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  bool _isObscure = true;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController pswController = TextEditingController();
  String emailc = '', verif_code = '';
  // _getBytes(imageUrl) async {
  //   final ByteData data =
  //       await NetworkAssetBundle(Uri.parse(imageUrl)).load(imageUrl);
  //   _bytes = data.buffer.asInt8List();
  // }

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
                  height: 60,
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
                SizedBox(
                  height: 20,
                ),
                PrimaryButton(
                  buttonText: AppLocalizations.of(context)!.login_key,
                  ontap: () async {
                    // await _getBytes('https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.ideematic.com%2Fdictionnaire-digital%2Fflutter-dart%2F&psig=AOvVaw37_HuTH19N3NhipXOU84E0&ust=1693684943334000&source=images&cd=vfe&opi=89978449&ved=0CBAQjRxqFwoTCPDO_56aioEDFQAAAAAdAAAAABAE');
                    if (validateLoginForm(
                        emailController.text.trim(), pswController.text)) {
                      // await LocalDataBase(context).addUser(
                      //     'rentali', emailController.text, pswController.text);
                      if (await LocalDataBase(context)
                          .getUser(emailController.text, pswController.text)) {
                        NavigationServices(context).gotoHomeScreen();
                      } else {
                        EasyLoading.showError(
                          duration: Duration(milliseconds: 1500),
                          AppLocalizations.of(context)!.try_again,
                        );
                      }
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

  storeLoginInfo() async {
    if (kDebugMode) {
      print("Shared pref called");
    }
    int isLogged = 0;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('isLogged', isLogged);
    if (kDebugMode) {
      print(prefs.getInt('isLogged'));
    }
  }

  // login(String email, String password) async {
  //   EasyLoading.show(status: "Loading...");
  //   var url = Uri.parse(Urls.user);
  //   // try {

  //   try {
  //     final response = await http.post(url, headers: {
  //       "Accept": "application/json"
  //     }, body: {
  //       "email": encrypt(email),
  //       "password": encrypt(password),
  //       "action": encrypt("rentali_want_to_login_user_now")
  //     });
  //     // print(json.decode(response.body));
  //     var data = jsonDecode(response.body);
  //     if (kDebugMode) {
  //       print('dssd');
  //       print(data);
  //     }

  //     if (response.statusCode == 200) {
  //       if (data['status'] == 'error') {
  //         if (data['message'] == 'Verify your email') {
  //           if (kDebugMode) {
  //             print(data['message'] + "status message email");
  //           }
  //           var user_get = data['data'];
  //           EasyLoading.showError(
  //             AppLocalizations.of(context)!.verifier_email,
  //           );
  //           NavigationServices(context)
  //               .gotoOptScreen(email, user_get['code_verif'].toString());
  //         } else if (data['message'] == 'Incorrect password') {
  //           if (kDebugMode) {
  //             print(data['message'] + "status message another");
  //           }
  //           EasyLoading.showError(
  //             AppLocalizations.of(context)!.incorrect_psw,
  //           );
  //         } else if (data['message'] == 'This email not exist') {
  //           EasyLoading.showError(
  //             AppLocalizations.of(context)!.incorrect_email,
  //           );
  //         } else if (data['message'] == 'mail not send') {
  //           EasyLoading.showError(
  //             AppLocalizations.of(context)!.verified_internet,
  //           );
  //         } else if (data['message'] == 'User request to delete account') {
  //           EasyLoading.showError(
  //             AppLocalizations.of(context)!.incorrect_psw,
  //           );
  //         } else {
  //           EasyLoading.dismiss();
  //           if (kDebugMode) {
  //             print(data['message'] + "show error another error");
  //           }
  //         }
  //       } else {
  //         EasyLoading.dismiss();
  //         var user_detail = data['data'];
  //         String email = user_detail['email'];
  //         String user_name = user_detail['user_name'];
  //         String tel = user_detail['phone_number'];
  //         SharedPreferences pref = await SharedPreferences.getInstance();
  //         await pref.setString('username', encrypt(user_name));
  //         await pref.setString('email', encrypt(email));
  //         await pref.setString('phone', encrypt(tel));

  //         storeLoginInfo();

  //         NavigationServices(context).gotoBottomScreen(0);
  //       }
  //     } else {
  //       EasyLoading.showError(
  //         AppLocalizations.of(context)!.try_again,
  //       );
  //     }
  //   } on SocketException {
  //     if (kDebugMode) {
  //       print('bbbbbbbbb');
  //     }
  //     EasyLoading.showError(
  //       AppLocalizations.of(context)!.verified_internet,
  //     );
  //   } catch (e) {
  //     if (kDebugMode) {
  //       print('Try cathc for login to the App ################');
  //     }
  //     if (kDebugMode) {
  //       print(e.toString());
  //     }
  //     EasyLoading.showError(
  //       AppLocalizations.of(context)!.try_again,
  //     );
  //   }
  // }
}
