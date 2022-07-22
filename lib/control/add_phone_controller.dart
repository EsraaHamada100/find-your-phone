import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_your_phone/control/firebase_controller.dart';
import 'package:find_your_phone/control/sign_controller.dart';
import 'package:find_your_phone/view/lost_phones_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import '../model/phone_data.dart';
import '../view/found_phones_screen.dart';

class AddPhoneController extends GetxController {
  /*---- -upload images when adding a new lost phone ----*/
  final _currentUser = FirebaseAuth.instance.currentUser;
  RxList<XFile> _imagesFileList = <XFile>[].obs;
  List<XFile> get imagesFileList => _imagesFileList;
  final ImagePicker _picker = ImagePicker();
  // final CollectionReference lostPhonesRef =
  //     FirebaseFirestore.instance.collection('lost phones');
  // final CollectionReference foundPhoneRef =
  //     FirebaseFirestore.instance.collection('found phones');
  final CollectionReference phonesRef =
      FirebaseFirestore.instance.collection('phones');
  final _userController = Get.find<SignController>();
  final FirebaseController _firebaseController = Get.find<FirebaseController>();

  /// pick and change phone images
  void pickPhoneImages() async {
    final List<XFile>? selectedImages =
        await _picker.pickMultiImage(imageQuality: 85);
    if (selectedImages!.isNotEmpty) {
      clearPhoneImages();
      print("The length of list is" + '${_imagesFileList.length}');
      for (int i = 0; (i < 3 && i < selectedImages.length); i++) {
        _imagesFileList.add(selectedImages[i]);
      }
    }
    print(_imagesFileList.length);
    // update();
  }

  /// clear phone images
  void clearPhoneImages() {
    _imagesFileList.clear();
  }

  /// uploading phone images to firebase storage
  Future<List<String>> uploadPhoneImages() async {
    List<File> imageFiles = <File>[];
    List<String> imageNames = <String>[];
    List<String> imageUrls = <String>[];
    _imagesFileList.forEach((image) {
      imageFiles.add(File(image.path));
      String imageName = basename(image.path);
      int random = Random().nextInt(10000);
      imageName = '$random$imageName';
      imageNames.add(imageName);
    });
    for (int i = 0; i < imageFiles.length; i++) {
      var refStorage =
          FirebaseStorage.instance.ref("images").child(imageNames[i]);
      // Upload the image
      await refStorage.putFile(imageFiles[i]);
      // get the network url of the photo
      var url = await refStorage.getDownloadURL();
      imageUrls.add(url);
      print("url : $url");
    }
    return imageUrls;
  }

  /// add a new phone to firebase database

  addPhone({
    required String phoneType,
    String? phoneDescription,
    required String IMME1,
    String? IMME2,
    required String phoneNumber,
    String? whatsAppNumber,
    String? facebookAccount,
    required bool isLostPhone,
    required String addedDate,
    required String? paymentNumber,
  }) async {
    // urls of phone images
    List<String> imageUrls = await uploadPhoneImages();

    // making a map that has a new phone data
    Map<String, dynamic> newPhone = {
      'phone_type': phoneType,
      'IMME1': IMME1,
      'owner_id': _userController.userId,
      'added_date': addedDate,
      'lost_phone': isLostPhone,
      'phone_number': phoneNumber,
      // 'owner_id': _userController.userData.uid,
    };
    newPhone.addIf(
        phoneDescription != null, 'phone_description', phoneDescription);
    newPhone.addIf(IMME2 != null, 'IMME2', IMME2);
    // newPhone.addIf(phoneNumber != null, 'phone_number', phoneNumber);
    newPhone.addIf(whatsAppNumber != null, 'whats_app_number', whatsAppNumber);
    newPhone.addIf(
        facebookAccount != null, 'facebook_account', facebookAccount);
    newPhone.addIf(imageUrls.isNotEmpty, 'image_urls', imageUrls);
    newPhone.addIf(paymentNumber != null, 'payment_number', paymentNumber);
    _addPhoneToFirebase(newPhone, isLostPhone);
    // to update the list every time a new verified phone added
    // making it seems like real time database
    if (paymentNumber == null) {
      PhoneData phoneData = PhoneData(
        phoneType: phoneType,
        phoneDescription: phoneDescription,
        IMME1: IMME1,
        IMME2: IMME2,
        imageUrls: imageUrls,
        phoneNumber: phoneNumber,
        whatsAppNumber: whatsAppNumber,
        facebookAccount: facebookAccount,
        isLostPhone: isLostPhone,
        addedDate: addedDate,
        paymentNumber: paymentNumber,
        ownerId: _userController.userId,
      );
      _firebaseController.phonesDocuments[0].phonesData.insert(0, phoneData);
      if (isLostPhone) {
        _firebaseController.lostPhones.insert(0, phoneData);
        _firebaseController.lostPhones.refresh();
        Get.offAll(() => LostPhonesScreen());
      } else {
        _firebaseController.foundPhones.insert(0, phoneData);
        _firebaseController.foundPhones.refresh();
        Get.offAll(() => FoundPhonesScreen());
      }
    } else {
      // the phone is not verified
      Get.back();
    }

    // clearing the image list after adding them to database
    clearPhoneImages();
  }

  _addPhoneToFirebase(Map<String, dynamic> newPhone, bool isLostPhone) async {
    PhonesDocument lastDoc =
        _firebaseController.phonesDocuments[0] as PhonesDocument;
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
        _firebaseController.phonesDocuments.insert(0, phonesDocument);
      });
    }
  }
}
