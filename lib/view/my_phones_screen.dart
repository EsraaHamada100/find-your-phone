import 'package:find_your_phone/control/firebase_controller.dart';
import 'package:find_your_phone/control/sign_controller.dart';
import 'package:find_your_phone/model/phone_data.dart';
import 'package:find_your_phone/shared/reusable_widgets/transparent_app_bar.dart';
import 'package:find_your_phone/view/phone_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../shared/reusable_widgets/phone_container.dart';

class MyPhones extends StatelessWidget {
  MyPhones({Key? key}) : super(key: key);
  final FirebaseController _firebaseController = Get.find<FirebaseController>();
  final SignController _signController = Get.find<SignController>();
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: CustomTransparentAppBar(
          appBarTitle: 'منشوراتي',
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(bottom: 40, right: 20, left: 20, top: 20),
            child: Container(
              width: double.maxFinite,
              child: ListView(
                shrinkWrap: true,
                children: [
                  for (PhonesDocument document
                      in _firebaseController.phonesDocuments)
                    for (PhoneData phone in document.phonesData)
                      if (phone.ownerId == _signController.userId)
                        GestureDetector(
                          onTap: () {
                            Get.to(
                              () => PhoneDetailsScreen(
                                phone: phone,
                                docId: document.id,
                                myPhone: true,
                              ),
                            );
                          },
                          child: PhoneContainer(
                            phoneType: phone.phoneType,
                            image: phone.imageUrls.isNotEmpty
                                ? phone.imageUrls[0]
                                : null,
                            IMME1: phone.IMME1,
                            IMME2: phone.IMME2,
                          ),
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
