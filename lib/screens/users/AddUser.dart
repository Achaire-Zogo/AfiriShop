import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:m_product/db/localDb.dart';
import 'package:m_product/screens/product/add_product.dart';
import 'package:m_product/screens/users/UserList.dart';
import 'package:m_product/utils/theme.dart';
import '../../../model/product.dart';
import '../../../widget/cart_tile.dart';
import '../../api/encrypt.dart';
import '../../model/user_model.dart';
import '../../urls/all_url.dart';
import '../../widget/primary_button.dart';

class AddUser extends StatefulWidget {
  const AddUser({super.key});

  @override
  State<AddUser> createState() => _AddUserState();
}

class Debouncer {
  final int milliseconds;
  VoidCallback? action;
  Timer? _timer;

  Debouncer({required this.milliseconds});

  run(VoidCallback action) {
    if (null != _timer) {
      _timer!
          .cancel(); // when the user is continuosly typing, this cancels the timer
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}

class _AddUserState extends State<AddUser> {
  List<User> userList = [];
  List<User> _filteruser = [];

  final _debouncer = Debouncer(milliseconds: 2000);
  bool isLoading = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    EasyLoading.dismiss();
    // WidgetsBinding.instance.addPostFrameCallback((_) async {
    // });
  }


  String name = '';
  String email = '';
  String phone = '';
  String role = 'gerant';
  String _selected = 'gerant';
  bool _isGerant = false;
  bool _isAdmin = false;
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  add_my_user(String username, String email, String phone,String status) async {
    EasyLoading.show(status: "Loading...");
    var url = Uri.parse(Urls.user);
    // try {

    try {
      final response = await http.post(url, headers: {
        "Accept": "application/json"
      }, body: {
        "username": encrypt(username),
        "email": encrypt(email),
        "phone": encrypt(phone),
        "role": encrypt(status),
        "action": encrypt("afiri_want_to_add_user_now")
      });
      // print(json.decode(response.body));
      var data = jsonDecode(response.body);
      if (kDebugMode) {
        print('dssd');
        print(data);
      }

      if (response.statusCode == 200) {
        if (data['status'] == 'error') {
          if (data['message'] == 'empty') {
            EasyLoading.showError(
              duration: Duration(milliseconds: 1500),
              AppLocalizations.of(context)!.please_not_empty,
            );
          } else if (data['message'] == 'email_exist') {
            EasyLoading.showError(
              duration: Duration(milliseconds: 1500),
              AppLocalizations.of(context)!.email_already_exist,
            );
          }else if(data['message'] == 'phone_exist'){
            EasyLoading.showError(
              duration: Duration(milliseconds: 1500),
              AppLocalizations.of(context)!.phone_already_exist,
            );
          } else {
            EasyLoading.dismiss();
            if (kDebugMode) {
              print(data['message'] + "show error another error");
            }
          }
        } else {
          EasyLoading.dismiss();
          EasyLoading.showSuccess('Success');
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const UserList()),
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
        print('Internet errrrrrrroooooorrrrr');
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




  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const UserList()),
                (route) => false);
        return false;
      },
      child: Scaffold(
        backgroundColor: kgrey.withOpacity(0.3),
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const UserList()),
                        (route) => false);
            },
            icon: const Icon(Icons.backspace_outlined),
          ),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
          // title: Text(AppLocalizations.of(context)!.home_message),
          title: Text(AppLocalizations.of(context)!.add_user),
          centerTitle: false,
        ),
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _key,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        autofocus: true,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          hintText: AppLocalizations.of(context)!.user_name,
                        ),
                        validator: (val) => val!.isEmpty
                            ? AppLocalizations.of(context)!.required
                            : null,
                        onChanged: (val) => name = val,
                      ),
                      const SizedBox(height: 2),
                      TextFormField(
                        autofocus: true,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          hintText: 'Email',
                        ),
                        validator: (val) => val!.isEmpty
                            ? AppLocalizations.of(context)!.required
                            : null,
                        onChanged: (val) => email = val,
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        readOnly: false,
                        autofocus: true,
                        decoration: InputDecoration(
                          labelText: 'Phone',
                        ),
                        keyboardType: TextInputType.number,
                        validator: (val) => val!.isEmpty
                            ? AppLocalizations.of(context)!.required
                            : null,
                        onChanged: (val) => phone = val,
                      ),
                      const SizedBox(height: 20),
                      DropdownButton<String>(
                        elevation: 10,
                        // Les options du select
                        items: [
                          DropdownMenuItem(
                            // La valeur de l'option
                            value: "admin",
                            // Le label de l'option
                            child: Text("Administrateur"),
                          ),
                          DropdownMenuItem(
                            value: "gerant",
                            child: Text("Gérant"),
                          ),
                        ],
                        // La valeur sélectionnée par défaut
                        value: _selected,
                        // L'événement listener de type onchange
                        onChanged: (String? value) {
                          // Effectue une action lorsque l'événement change est déclenché
                          setState(() {
                            _selected = value!;
                          });
                          role= value!;
                        },
                      ),
                      const SizedBox(height: 20),
                      PrimaryButton(
                        buttonText: AppLocalizations.of(context)!.validate,
                        ontap: () async {
                          if (_key.currentState!.validate()) {
                            add_my_user(name, email, phone, role);
                          }
                        },
                      ),
                    ],
                  ),

                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
