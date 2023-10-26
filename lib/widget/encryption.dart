import 'package:encrypt/encrypt.dart';

const String aesKey = "Your16CharacterK";

String decrypt(String keyString, Encrypted encryptedData) {
  final key = Key.fromUtf8(keyString);
  final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
  final initVector = IV.fromUtf8(keyString.substring(0, 16));
  return encrypter.decrypt(encryptedData, iv: initVector);
}

Encrypted encrypt(String keyString, String plainText) {
  final key = Key.fromUtf8(keyString);
  final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
  final initVector = IV.fromUtf8(keyString.substring(0, 16));
  Encrypted encryptedData = encrypter.encrypt(plainText, iv: initVector);
  return encryptedData;
}
