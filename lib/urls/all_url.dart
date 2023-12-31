class Urls {
  static const String baseURL = "https://stat.provarescore.com/api";
  //static const String baseURL = "http://192.168.8.122:8000/api";

  static const String user = "$baseURL/auth";
  static const String product = "$baseURL/product";
  static const String vente = "$baseURL/vente";
  static const String recup = "$baseURL/vente_recup_day";
  static const String getMonth = "$baseURL/vente_recup_month";
  static const String getweek = "$baseURL/vente_recup_week";
  static const String getYear = "$baseURL/vente_recup_year";
  static const String getDetails = "$baseURL/produit_details";

  static const String userAvatar = "https://ui-avatars.com/api/?name=";
  static const String appVersion = '1.0.0';
}
