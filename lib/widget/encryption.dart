import 'package:encrypt/encrypt.dart' as encrypt;

class AccountEncryption {
  static encryptWithAESKey(String data) {
    encrypt.Key aesKey = encrypt.Key.fromLength(16);
    final encrypter = encrypt.Encrypter(encrypt.AES(aesKey));
    if (data.isNotEmpty) {
      encrypt.Encrypted encryptedData =
          encrypter.encrypt(data, iv: encrypt.IV.fromLength(16));
      return encryptedData.base64;
    } else if (data.isEmpty) {
      // ignore: avoid_print
      print('Data is empty');
    }
  }

  static decryptWithAESKey(String data) {
    encrypt.Key aesKey = encrypt.Key.fromLength(16);
    final encrypter = encrypt.Encrypter(encrypt.AES(aesKey));
    encrypt.Encrypted encrypted = encrypt.Encrypted.fromBase64(data);
    if (data.isNotEmpty) {
      String decryptedData =
          encrypter.decrypt(encrypted, iv: encrypt.IV.fromLength(16));
      return decryptedData;
    } else if (data.isEmpty) {
      print('Chats is empty');
    }
  }
}
