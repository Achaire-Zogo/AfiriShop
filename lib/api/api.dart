import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../urls/all_url.dart';

class API {
  postRequest({
     required String route ,
    required var data
  }) async {
    String url = Urls.baseURL + route;
    try {
      return await http.post(
        Uri.parse(url),
        body: data,
        headers: _header(),
      );
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      return 'error';
    }
  }

  _header() => {
    'Content-type': 'application/json',
    'Accept': 'application/json',
  };
}
