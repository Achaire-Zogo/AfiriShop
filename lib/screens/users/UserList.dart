import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:m_product/db/localDb.dart';
import 'package:m_product/screens/IndexHome.dart';
import 'package:m_product/screens/product/add_product.dart';
import 'package:m_product/utils/theme.dart';
import '../../../model/product.dart';
import '../../../widget/cart_tile.dart';
import '../../api/encrypt.dart';
import '../../model/user_model.dart';
import '../../urls/all_url.dart';
import 'AddUser.dart';

class UserList extends StatefulWidget {
  const UserList({super.key});

  @override
  State<UserList> createState() => _UserListState();
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

class _UserListState extends State<UserList> {
  List<User> userList = [];
  List<User> _filteruser = [];

  final _debouncer = Debouncer(milliseconds: 2000);
  bool isLoading = true;
  @override
  void initState() {
    // TODO: implement initState
    getData();
    super.initState();
    EasyLoading.dismiss();
    // WidgetsBinding.instance.addPostFrameCallback((_) async {
    // });
  }

  searchField() {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: TextField(
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(5.0),
          hintText: AppLocalizations.of(context)!.search_,
          prefixIcon: Icon(Icons.search),
        ),
        onChanged: (string) {
          _debouncer.run(() {
            setState(() {
              _filteruser = userList
                  .where((u) => (u.username
                  .toLowerCase()
                  .contains(string.toLowerCase()) ||
                  u.email
                      .toString()
                      .toLowerCase()
                      .contains(string.toLowerCase())))
                  .toList();
            });
          });
        },
      ),
    );
  }

  getData() async {
    var url = Uri.parse(Urls.user);
    // try {

    try {
      final response = await http.post(url, headers: {
        "Accept": "application/json"
      }, body: {
        "action": encrypt("afiri_want_to_get_all_user_now")
      });
      print(response.body);
      var data = jsonDecode(response.body);
      if (kDebugMode) {
        print('dssd');
        print(data);
      }

      if (response.statusCode == 200) {
        userList.clear();
        _filteruser.clear();
        if (data['status'] == 'success') {
         var users = data['data'];

          for (Map i in users) {
            setState(() {
              userList.add(User.fromJson(i));
              _filteruser.add(User.fromJson(i));
              isLoading = false;
            });
          }
        } else {

        }
      } else {
        EasyLoading.showError(
          duration: Duration(milliseconds: 1500),
          AppLocalizations.of(context)!.try_again,
        );
        setState(() {
          isLoading = false;
        });
      }
    } on SocketException {
      if (kDebugMode) {
        print('bbbbbbbbb');
      }
      EasyLoading.showError(
        duration: Duration(milliseconds: 1500),
        AppLocalizations.of(context)!.verified_internet,
      );
      setState(() {
        isLoading = false;
      });
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
      setState(() {
        isLoading = false;
      });
    }
  }

  String name = '';
  String email = '';
  String phone = '';
  String role = '';
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  delete_my_user(String id) async {
    EasyLoading.show(status: "Loading...");
    var url = Uri.parse(Urls.user);
    // try {

    try {
      final response = await http.post(url, headers: {
        "Accept": "application/json"
      }, body: {
        "id": encrypt(id),
        "action": encrypt("afiri_want_to_delete_user_now")
      });
      // print(json.decode(response.body));
      var data = jsonDecode(response.body);
      if (kDebugMode) {
        print('dssd');
        print(data);
      }

      if (response.statusCode == 200) {
        if (data['status'] == 'error') {
          if (data['message'] == 'no user exit') {
            EasyLoading.showError(
              duration: Duration(milliseconds: 1500),
              AppLocalizations.of(context)!.please_not_empty,
            );
          }  else {
            EasyLoading.dismiss();
            if (kDebugMode) {
              print(data['message'] + "show error another error");
            }
          }
        } else {
          EasyLoading.dismiss();
          EasyLoading.showSuccess('Success');
          setState(() {
            isLoading = true;
          });
          getData();
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

  _showDialog_for_delete(BuildContext context, String id, ) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
            title: Text(AppLocalizations.of(context)!.attention_),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    AppLocalizations.of(context)!
                        .do_you_realy_want_to_delete_this_user,
                    style: TextStyle(
                      color: Colors.red,
                    ),
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            ),
            actions: <Widget>[
              MaterialButton(
                onPressed: () => Navigator.pop(context),
                child: Text(AppLocalizations.of(context)!.cancel_now),
              ),
              MaterialButton(
                onPressed: () {
                  delete_my_user(id);
                  Navigator.of(context).pop();

                },
                child: Text(AppLocalizations.of(context)!.validate),
              ),
            ]);
      },
    );
  }




  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const GreatHome(pos: 0)),
                (route) => false);
        return false;
      },
      child: Scaffold(
        backgroundColor: kgrey.withOpacity(0.3),
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const GreatHome(pos: 0)),
                      (route) => false);
            },
            icon: const Icon(Icons.backspace_outlined),),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
          // title: Text(AppLocalizations.of(context)!.home_message),
          title: Text(AppLocalizations.of(context)!.all_user),
          centerTitle: false,
          actions: [
            IconButton(
                onPressed: () {
                  _filteruser = [];
                  setState(() {
                    isLoading = true;
                    getData();
                  });
                },
                icon: const Icon(Icons.refresh_outlined)),
            IconButton(
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => const AddUser()),
                          (route) => false);
                },
                icon: const Icon(Icons.add)),
          ],
        ),
        body:
        isLoading
            ? const Center(child: CircularProgressIndicator())
            : Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              searchField(),
              Expanded(
                child: ListView.builder(
                  itemCount: _filteruser.length,
                  itemBuilder: (context, i) {
                    final item = _filteruser[i];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Card(
                          elevation: 10.0,
                          child: ListTile(
                            onTap: () {

                            },
                            title: Text(
                              item.username,
                              textAlign: TextAlign.left,
                            ),
                            subtitle:
                            Text("${item.email}\n ${item.role}"),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () async {
                                if (kDebugMode) {
                                  print("aaaaaaaaaaaa:   " + item.id.toString());
                                }
                                _showDialog_for_delete(context, item.id.toString());
                              },
                            ),
                            leading: IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () async {
                                // _showMyDialog(build.name!, build.type!);
                              },
                            ),
                          )),
                      );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
