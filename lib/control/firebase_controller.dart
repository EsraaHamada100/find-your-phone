import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_your_phone/model/admin_data.dart';
import 'package:find_your_phone/model/found_phone.dart';
import 'package:find_your_phone/shared/reusable_widgets/components.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../model/lost_phone.dart';
import '../model/phone_data.dart';

class FirebaseController extends GetxController {
  @override
  void onReady() {
    super.onReady();
    print('the firebase controller is ready');
  }

  CollectionReference phonesRef =
      FirebaseFirestore.instance.collection('phones');
  CollectionReference adminRef = FirebaseFirestore.instance.collection('admin');
  RxList phonesDocuments = [].obs;
  RxList lostPhones = [].obs;
  RxList foundPhones = [].obs;
  RxList needVerification = [].obs;
  String adminDocId = 'X8SwuPWCuaevsHVzH1gC';
  void getPhonesDocuments() async {
    print('we are reading ');
    await FirebaseFirestore.instance
        .collection('phones')
        .orderBy('time', descending: true)
        .get()
        .then((value) {
      value.docs.forEach((doc) {
        print('=============================');
        print('we are in phone document');
        print('=============================');
        print(doc.data());
        PhonesDocument phonesDocument =
            PhonesDocument.fromJson(doc.data(), doc.id);
        phonesDocuments.add(phonesDocument);
      });
    });
    phonesDocuments.forEach((doc) {
      print('phone found document data');
      print('==========================');
      print(doc.id);
      print(doc.time);
      for (int i = doc.phonesData.length - 1; i >= 0; i--) {
        if (doc.phonesData[i].isLostPhone &&
            doc.phonesData[i].paymentNumber == null) {
          lostPhones.add(doc.phonesData[i]);
        } else {
          foundPhones.add(doc.phonesData[i]);
        }
        if (doc.phonesData[i].paymentNumber != null) {
          needVerification.add(doc.phonesData[i]);
        }
      }
      // doc.phonesData.forEach((phone) {
      //
      // });
      print('end phone found document data');
    });
  }

  Future<AdminDocument?> getAdminDocument() async {
    try {
      AdminDocument? adminDocument;

      await FirebaseFirestore.instance
          .collection('admin')
          .doc(adminDocId)
          .get()
          .then((value) {
        // print(value.data());
        adminDocument = AdminDocument.fromJson(value.data()!);
      });
      return adminDocument;
    } catch (e, stackTrace) {
      print(e);
      print(stackTrace);
    }
    return null;
  }

  Future<bool> deletePhoneFromFirebase(String docId, PhoneData phone) async {
    bool imagesDeleted = await _deletePhoneImages(phone);
    if (imagesDeleted) {
      await phonesRef.doc(docId).update({
        'phones_list': FieldValue.arrayRemove([PhoneData.toJson(phone).json])
      });
      return true;
    } else {
      return false;
    }
  }

  Future<bool> verifyPhone(String docId, PhoneData phone) async {
    try {
      DocumentReference docRef = phonesRef.doc(docId);
      WriteBatch batch = FirebaseFirestore.instance.batch();
      batch.update(docRef, {
        'phones_list': FieldValue.arrayRemove([PhoneData.toJson(phone).json]),
      });
      phone.paymentNumber = null;
      batch.update(docRef, {
        'phones_list': FieldValue.arrayUnion([PhoneData.toJson(phone).json]),
      });

      batch.commit();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> _deletePhoneImages(PhoneData phone) async {
    for (String imageUrl in phone.imageUrls) {
      try {
        print('we are deleting $imageUrl');
        // await FirebaseStorage.instance.refFromURL(imageUrl).delete();
        await FirebaseStorage.instance.refFromURL(imageUrl).delete();
      } catch (e) {
        print(e);
        return false;
      }
    }
    return true;
  }

  String getDocId(PhoneData phone) {
    for (PhonesDocument document in phonesDocuments) {
      if (document.phonesData.contains(phone)) {
        return document.id;
      }
    }
    return '';
  }

  Future<bool> addAdmin(Map<String, dynamic> admin) async {
    try {
      await adminRef.doc(adminDocId).update({
        'admins_list': FieldValue.arrayUnion([admin])
      });
      return true;
    } catch (e) {
      return false;
    }
  }
}
