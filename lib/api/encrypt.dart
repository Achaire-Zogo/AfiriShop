import 'package:encrypt/encrypt.dart';

final key = Key.fromUtf8("kufulismartlockislachoixaveczaza");
final iv = IV.fromUtf8("hellotoutlemonde");

String encrypt(String text) {
  final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
  final finalcrypt = encrypter.encrypt(text, iv: iv);
  return finalcrypt.base64;
}

String decrypt(String text) {
  final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
  final decrypt = encrypter.decrypt(Encrypted.fromBase64(text), iv: iv);
  return decrypt;
}
