import 'package:find_your_phone/control/firebase_controller.dart';
import 'package:find_your_phone/view/phone_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../shared/reusable_widgets/app_bar.dart';
import '../../shared/reusable_widgets/navigation_drawer_widget.dart';
import '../../shared/reusable_widgets/phone_container.dart';
import '../../shared/reusable_widgets/scrollable_transparent_app_var.dart';

class VerifyPhonesScreen extends StatelessWidget {
  VerifyPhonesScreen({Key? key}) : super(key: key);
  FirebaseController _firebaseController = Get.find<FirebaseController>();
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            CustomAppBar(appBarTitle: 'قبول الدفع', searchable: true,),
          ],
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Obx(
                () => ListView(
                  shrinkWrap: true,
                  children: [
                    for(var phone in _firebaseController.needVerification)
                      GestureDetector(
                        onTap: () => Get.to(() => PhoneDetailsScreen(
                          phone: phone,
                          docId: _firebaseController.getDocId(phone),
                          needVerification: true,
                        ),),
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
        drawer: CustomNavigationDrawerWidget(),
        ),
    );
  }
}
