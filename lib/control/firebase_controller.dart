import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_your_phone/model/admin_data.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
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
  getPhonesDocuments() async {
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
          print('we add a phone to it ${needVerification.length}');
        }
      }
      // doc.phonesData.forEach((phone) {
      //
      // });
      print('end phone found document data');
    });
  }
  // adding a phone to firebase
  addPhoneToFirebase(Map<String, dynamic> newPhone, bool isLostPhone) async {
    PhonesDocument lastDoc =
    phonesDocuments[0] as PhonesDocument;
    int listLength = lastDoc.phonesData.length;

    print(listLength);
    if (listLength < 2000) {
      await phonesRef.doc(lastDoc.id).update({
        'phones_list': FieldValue.arrayUnion([newPhone])
      });
    } else {
      await phonesRef.add({
        'time': lastDoc.time + 1,
        'phones_list': FieldValue.arrayUnion([newPhone])
      });

      var lastDocRef =
      await phonesRef.orderBy('time', descending: true).limit(1).get();
      lastDocRef.docs.forEach((doc) {
        String id = doc.id;
        int time = doc['time'];
        PhoneData phoneData = PhoneData.fromJson(doc['phones_list'][0]);
        PhonesDocument phonesDocument =
        PhonesDocument(id: id, time: time, phonesData: [phoneData]);
        phonesDocuments.insert(0, phonesDocument);
      });
    }
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

  deleteDocument(String docId) async {
    try {
      await phonesRef.doc(docId).delete();
    } catch (e) {
      print(e);
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

  /// add admin to firebase
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

  /// delete admin from firebase
  Future<bool> deleteAdmin(AdminData admin) async {
    try {
      await adminRef.doc(adminDocId).update({
        'admins_list': FieldValue.arrayRemove([AdminData.toJson(admin).json])
      });
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  /// change payment data in firebase
  changePaymentData(
      String paymentNumber, double paymentAmount, bool isFree) async {
    try {
      await adminRef.doc(adminDocId).update({
        'payment_number': paymentNumber,
        'payment_amount': paymentAmount,
        'free': isFree,
      });
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  /// add legal action article to firebase
  Future<bool> addLegalActionArticle(
      Map<String, dynamic> legalActionArticle) async {
    try {
      await adminRef.doc(adminDocId).update({
        'legal_actions_list': FieldValue.arrayUnion([legalActionArticle])
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  /// delete legal action article from firebase
  Future<bool> deleteLegalActionArticle(ArticleData legalActionArticle) async {
    try {
      await adminRef.doc(adminDocId).update({
        'legal_actions_list': FieldValue.arrayRemove(
            [ArticleData.toJson(legalActionArticle).json])
      });
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  /// change payment data in firebase
  Future<bool> changeConnectEmail(
      String email) async {
    try {
      await adminRef.doc(adminDocId).update({
        'connect_email': email,

      });
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
