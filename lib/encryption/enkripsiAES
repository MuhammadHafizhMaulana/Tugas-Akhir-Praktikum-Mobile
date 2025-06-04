import 'package:encrypt/encrypt.dart' as encrypt;

class EncryptionHelper {
  // Kunci enkripsi dengan panjang 32 byte (untuk AES-256)
  static final encrypt.Key key = encrypt.Key.fromLength(32); 
  static final encrypt.IV iv = encrypt.IV.fromLength(16);  
  
  // Enkripsi menggunakan AES
  static String encryptData(String data) {
    final encrypter = encrypt.Encrypter(encrypt.AES(key));

    // Melakukan enkripsi
    final encrypted = encrypter.encrypt(data, iv: iv);
    
    // Mengembalikan hasil enkripsi dalam format base64
    return encrypted.base64;
  }

  // Dekripsi menggunakan AES
  static String decryptData(String encryptedData) {
    final encrypter = encrypt.Encrypter(encrypt.AES(key));

    // Mendekripsi data yang telah dienkripsi (base64)
    final decrypted = encrypter.decrypt64(encryptedData, iv: iv);

    // Mengembalikan hasil dekripsi
    return decrypted;
  }
}
