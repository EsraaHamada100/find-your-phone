import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_your_phone/control/admin_controller.dart';
import 'package:find_your_phone/control/firebase_controller.dart';
import 'package:find_your_phone/model/phone_data.dart';
import 'package:find_your_phone/shared/colors.dart';
import 'package:find_your_phone/shared/reusable_widgets/components.dart';
import 'package:find_your_phone/view/found_phones_screen.dart';
import 'package:find_your_phone/view/lost_phones_screen.dart';
import 'package:find_your_phone/view/admin_screens/verify_phones_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';

import '../shared/enums.dart';

class PhoneDetailsScreen extends StatelessWidget {
  PhoneDetailsScreen({
    Key? key,
    required this.phone,
    required this.docId,
    this.myPhone,
    this.needVerification = false,
  }) : super(key: key);
  final PhoneData phone;
  final String docId;
  final bool? myPhone;
  bool needVerification;
  final AdminController _adminController = Get.find<AdminController>();
  final FirebaseController _firebaseController = Get.find<FirebaseController>();
  // final bool isLostPhone;
  /// delete phone
  void deletePhone(
    BuildContext context,
  ) async {
    Get.back();
    showLoading(context);
    bool isDeleted =
        await _firebaseController.deletePhoneFromFirebase(docId, phone);
    if (!isDeleted) {
      Get.back();
      showToast(context, 'حدث خطأ أثناءالحذف يرجى المحاوله فى وقت لاحق',
          ToastStates.error);
    } else {
      showToast(context, 'تم الحذف بنجاح', ToastStates.success);
      for (PhonesDocument doc in _firebaseController.phonesDocuments) {
        if (doc.phonesData.contains(phone)) {
          doc.phonesData.remove(phone);
        }
      }
      _firebaseController.phonesDocuments.refresh();
      if (phone.isLostPhone) {
        // we removed a lost phone
        _firebaseController.lostPhones.remove(phone);
        _firebaseController.lostPhones.refresh();
        Get.offAll(() => LostPhonesScreen());
      } else {
        // we removed a found phone
        _firebaseController.foundPhones.remove(phone);
        _firebaseController.foundPhones.refresh();
        Get.offAll(() => FoundPhonesScreen());
      }

      print('deleted');
    }
  }

  /// new verifiedPhone
  // PhoneData verifiedPhone(PhoneData oldPhone){
  //   Map<String, dynamic> newPhone = {
  //     'phone_type': oldPhone.phoneType,
  //     'IMME1': oldPhone.IMME1,
  //     'owner_id': oldPhone.ownerId,
  //     'added_date': oldPhone.addedDate,
  //     'lost_phone': oldPhone.isLostPhone,
  //     'phone_number': oldPhone.phoneNumber,
  //     // 'owner_id': _userController.userData.uid,
  //   };
  //   newPhone.addIf(
  //       oldPhone.phoneDescription != null, 'phone_description', oldPhone.phoneDescription);
  //   newPhone.addIf(oldPhone.IMME2 != null, 'IMME2', oldPhone.IMME2);
  //   // newPhone.addIf(phoneNumber != null, 'phone_number', phoneNumber);
  //   newPhone.addIf(oldPhone.whatsAppNumber != null, 'whats_app_number', oldPhone.whatsAppNumber);
  //   newPhone.addIf(
  //       oldPhone.facebookAccount != null, 'facebook_account', oldPhone.facebookAccount);
  //   newPhone.addIf(oldPhone.imageUrls.isNotEmpty, 'image_urls', oldPhone.imageUrls);
  //   return newPhone;
  // }
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'تفاصيل الهاتف',
            style: TextStyle(color: Colors.grey[700]),
          ),
          centerTitle: true,
          backgroundColor: secondaryColor,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black),
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  phoneImages(phone.imageUrls),
                  const SizedBox(
                    height: 40,
                  ),
                  Container(
                    width: double.maxFinite,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 30),
                    decoration: const BoxDecoration(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(50)),
                      color: Colors.white,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            phone.phoneType,
                            style: Theme.of(context)
                                .textTheme
                                .headline5!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        textContainer(context, 'IMME1 : ', phone.IMME1),
                        if (phone.IMME2 != null)
                          Column(
                            children: [
                              textContainer(context, 'IMME2 : ', phone.IMME2!),
                              const Divider(),
                            ],
                          ),

                        if (phone.phoneDescription != null)
                          phoneDescriptionContainer(context),
                        const Divider(),
                        const SizedBox(height: 30),
                        contactInformation(context, 'معلومات التواصل'),
                        const SizedBox(height: 30),
                        // phone number container
                        if (phone.phoneNumber != null)
                          inputField(
                            context: context,
                            text: phone.phoneNumber!,
                            icon: Icons.phone,
                          ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            if (phone.facebookAccount != null)
                              ElevatedButton.icon(
                                style: ButtonStyle(
                                  padding: MaterialStateProperty.all(
                                    EdgeInsets.symmetric(
                                      horizontal: 15,
                                      vertical: 7,
                                    ),
                                  ),
                                ),
                                label: Text('فيسبوك'),
                                icon: Icon(Icons.facebook_outlined),
                                onPressed: () async {
                                  // _makePhoneCall(phone.phoneNumber);
                                  String url = phone.facebookAccount!;
                                  try {
                                    await launchUrl(Uri.parse(url));
                                  } catch (e) {
                                    print(e);
                                  }
                                },
                              ),
                            if (phone.whatsAppNumber != null)
                              ElevatedButton.icon(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.green),
                                  padding: MaterialStateProperty.all(
                                    EdgeInsets.symmetric(
                                      horizontal: 15,
                                      vertical: 7,
                                    ),
                                  ),
                                ),
                                label: Text('واتساب'),
                                icon: Icon(Icons.whatsapp_outlined),
                                onPressed: () async {
                                  // _makePhoneCall(phone.phoneNumber);
                                  String url =
                                      "whatsapp://send?phone=${phone.whatsAppNumber}";
                                  try {
                                    await launchUrl(Uri.parse(url));
                                  } catch (e) {
                                    print(e);
                                  }
                                },
                              ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: (_adminController.isAdmin ||
                (myPhone != null && myPhone == true))
            ? Padding(
                padding: EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FloatingActionButton(
                      heroTag: 'btn1',
                      onPressed: () {
                        print(docId);
                        print(PhoneData.toJson(phone).json);
                        customAlertDialog(
                          context,
                          title: 'حذف الهاتف',
                          content: 'هل أنت متأكد من أنك تريد حذف الهاتف ؟',
                          confirmFunction: () {
                            deletePhone(context);
                          },
                        );
                      },
                      child: Icon(Icons.delete),
                      backgroundColor: Colors.red,
                    ),
                    if (needVerification && _adminController.isAdmin)
                      FloatingActionButton(
                        heroTag: 'btn2',
                        onPressed: () {
                          print(docId);
                          print(PhoneData.toJson(phone).json);
                          customAlertDialog(
                            context,
                            title: 'إضافة الهاتف',
                            content: 'هل أنت متأكد من أنك تريد إضافة الهاتف ؟',
                            confirmFunction: () async {
                              showLoading(context);
                              bool verified = await _adminController
                                  .verifyPhone(docId, phone);
                              if (verified) {
                                Get.offAll(() => VerifyPhonesScreen());
                                // ignore: use_build_context_synchronously
                                showToast(context, 'تم إضافة الهاتف بنجاح',
                                    ToastStates.success);
                              } else {
                                // ignore: use_build_context_synchronously
                                showToast(context, 'حدث خطأ أثناء إضافة الهاتف',
                                    ToastStates.error);
                              }
                            },
                          );
                        },

                        backgroundColor: Colors.green,
                        child: const Icon(
                          Icons.check_outlined,
                        ),
                      ),
                  ],
                ),
              )
            : Container(),
      ),
    );
  }

  CarouselSlider phoneImages(List<String> phoneImages) {
    return CarouselSlider(
      items: phoneImages.isNotEmpty
          ? phoneImages
              .map(
                (image) => ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image(
                    image: NetworkImage(image.toString()),
                    width: double.maxFinite,
                    fit: BoxFit.cover,
                  ),
                ),
              )
              .toList()
          : [
              ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: const Image(
                  image: AssetImage('assets/images/no_phone.jpg'),
                  // width: double.maxFinite,
                  fit: BoxFit.cover,
                ),
              ),
            ],
      options: CarouselOptions(
        height: 270,
        enableInfiniteScroll: false,
        // that will make the image take all the slider width
        // if this is 0.8 or something else some other photos
        // will appear from the two sides
        viewportFraction: 0.8,
        enlargeCenterPage: true,
      ),
    );
  }

  Container textContainer(BuildContext context, String title, String text) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: Row(children: [
        Text(
          title,
          style: Theme.of(context)
              .textTheme
              .bodyLarge!
              .copyWith(fontWeight: FontWeight.w500),
        ),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  fontWeight: FontWeight.w500,
                  letterSpacing: 3,
                ),
            textAlign: TextAlign.end,
            textDirection: TextDirection.ltr,
          ),
        ),
      ]),
    );
  }

  Container inputField(
      {required BuildContext context,
      required IconData icon,
      required String text}) {
    TextEditingController controller = TextEditingController(text: text);
    return Container(
      margin: EdgeInsets.only(bottom: 30),
      child: TextField(
        style: TextStyle(
          fontSize: 17,
          letterSpacing: 3,
          fontWeight: FontWeight.w500,
        ),
        controller: controller,
        readOnly: true,
        decoration: InputDecoration(
          suffixIcon: Icon(icon, color: buttonColor),
          border: OutlineInputBorder(
            borderSide: BorderSide(width: 1, color: defaultColor!),
          ),
        ),
      ),
    );
  }

  phoneDescriptionContainer(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      width: 2.0,
                      color: buttonColor!,
                    ),
                  ),
                ),
                child: Text(
                  'وصف الهاتف',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    shadows: [
                      Shadow(
                        offset: Offset(1, 1),
                        color: Colors.grey,
                        blurRadius: 5,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Text(
          phone.phoneDescription!,
          textAlign: TextAlign.justify,
          style: Theme.of(context).textTheme.bodyText1,
        ),
      ],
    );
  }

  contactInformation(BuildContext context, String text) {
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: defaultColor,
        ),
        child: Text(
          text,
          style: Theme.of(context)
              .textTheme
              .headline6!
              .copyWith(color: secondaryColor),
        ),
      ),
    );
  }
}
