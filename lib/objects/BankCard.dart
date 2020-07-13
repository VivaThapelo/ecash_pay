import 'dart:convert';

import 'package:flutter_string_encryption/flutter_string_encryption.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BankCard {
  String cardNumber;
  String cardHolder;
  String cardExpires;
  String cardCVV;
  bool masked;

  JsonCodec codec = new JsonCodec();

  final PlatformStringCryptor cryptor = new PlatformStringCryptor();

  BankCard({this.cardNumber, this.cardHolder, this.cardExpires, this.cardCVV});

  // Encrypting and Storing a CARD to SharedPreferences using CVV as salt
  void setBankCard() async {
    // encrypt and store
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final String salt = await cryptor.generateSalt();
      prefs.setString("salt", salt); // storing SALT safety
      final String key = await cryptor.generateKeyFromPassword(
          prefs.getString('appPin'),
          salt); // using appPIN and salt to retrieve key
      List<String> cardDetails = new List<String>();
      cardDetails.add(cardNumber);
      cardDetails.add(cardHolder);
      cardDetails.add(cardExpires);
      cardDetails.add(cardCVV);
      String cardInfo = await cryptor.encrypt(jsonEncode(cardDetails), key);
      prefs.setString('encryptedCardDetails', cardInfo);
    } catch (e) {
      print("Errorz: " + e.toString());
      return null;
    }
  }

  // Decrypting and Retrieving a CARD from SharedPreferences using AppPIN and salt
  Future<List<String>> getBankCard() async {
    // get the salt string for getting a key
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final String key = await cryptor.generateKeyFromPassword(
          prefs.getString('appPin'), prefs.getString('salt'));
      // Restore
      List<dynamic> cardDetails = await jsonDecode(
          await cryptor.decrypt(prefs.getString('encryptedCardDetails'), key));
      // List<dynamic> cardDetails = await cardDet;
      this.cardNumber = cardDetails[0];
      this.cardHolder = cardDetails[1];
      this.cardExpires = cardDetails[2];
      this.cardCVV = cardDetails[3]; // cardCVV
      return cardDetails; // - A string to encrypt.
    } catch (e) {
      print("Error: " + e.toString());
      return null;
    }
  }

  getCardNumber(bool masked) {
    this.masked = masked;
    if (this.masked && this.cardNumber != null) {
      List<String> splitCard = this.cardNumber.split(" ");
      return splitCard[0] + " **** **** " + splitCard[3];
    } else {
      return this.cardNumber;
    }
  }

  getCardHolder() {
    return this.cardHolder;
  }

  getCardExpires() {
    return this.cardExpires;
  }

  getCardCvv() {
    return this.cardCVV;
  }
}
