import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class PhonesDocument {
  late String id;
  late int time;
  List<PhoneData> phonesData = [];
  PhonesDocument(
      {required this.id, required this.time, required this.phonesData});
  PhonesDocument.fromJson(Map<String, dynamic> json, this.id) {
    time = json['time'];
    json['phones_list'].forEach((phone) {
      phonesData.add(PhoneData.fromJson(phone));
    });
  }
}

class PhoneData {
  late String phoneType;
  String? phoneDescription;
  late String IMME1;
  String? IMME2;
  late String phoneNumber;
  String? whatsAppNumber;
  String? facebookAccount;
  List<String> imageUrls = [];
  late String ownerId;
  late bool isLostPhone;
  late String addedDate;
  String? paymentNumber;
  Map<String, Object> json = <String, Object>{};
  PhoneData({
    required this.phoneType,
    this.phoneDescription,
    required this.IMME1,
    this.IMME2,
    required this.phoneNumber,
    this.whatsAppNumber,
    this.facebookAccount,
    required this.imageUrls,
    required this.isLostPhone,
    required this.addedDate,
    required this.ownerId,
    this.paymentNumber,
  });
  PhoneData.fromJson(Map<String, dynamic> json) {
    phoneType = json['phone_type']!;
    IMME1 = json['IMME1']!;
    isLostPhone = json['lost_phone']!;
    phoneNumber = json['phone_number']!;
    addedDate = json['added_date'];
    ownerId = json['owner_id'];
    phoneDescription = json.containsKey('phone_description')
        ? json['phone_description']
        : null;
    IMME2 = json.containsKey('IMME2') ? json['IMME2'] : null;

    whatsAppNumber =
        json.containsKey('whats_app_number') ? json['whats_app_number'] : null;
    facebookAccount =
        json.containsKey('facebook_account') ? json['facebook_link'] : null;
    if (json.containsKey('image_urls')) {
      for (String image in json['image_urls']) {
        imageUrls.add(image);
      }
    }
    paymentNumber =
        json.containsKey('payment_number') ? json['payment_number'] : null;
  }

  PhoneData.toJson(PhoneData phone) {

    json["phone_type"] = phone.phoneType;
    json["IMME1"] = phone.IMME1;
    json["lost_phone"] = phone.isLostPhone;
    json["phone_number"] = phone.phoneNumber;
    json["added_date"] = phone.addedDate;
    json['owner_id'] = phone.ownerId;
    if (phone.phoneDescription != null) {
      json['phone_description'] = phone.phoneDescription!;
    }
    if (phone.imageUrls.isNotEmpty) {
      json['image_urls'] = phone.imageUrls;
    }
    if (phone.IMME2 != null) {
      json['IMME2'] = phone.IMME2!;
    }
    if (phone.whatsAppNumber != null) {
      json['whats_app_number'] = phone.whatsAppNumber!;
    }
    if (phone.facebookAccount != null) {
      json['facebook_account'] = phone.facebookAccount!;
    }
    if (phone.paymentNumber != null) {
      json['payment_number'] = phone.paymentNumber!;
    }
    // docRef.update("diaryUploadModelList", FieldValue.arrayRemove(json));
  }
  @override
  String toString() {
    return '{'
        'phoneType : $phoneType, '
        'phoneDescription : $phoneDescription ,'
        'IMME1 :$IMME1,'
        'IMME2 :$IMME2,'
        'phoneNumber : $phoneNumber ,'
        'whatsAppNumber : $whatsAppNumber,'
        'facebookAccount : $facebookAccount ,'
        'isLost phone : $isLostPhone ,'
        '}';
  }
}
