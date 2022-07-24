import 'package:find_your_phone/control/firebase_controller.dart';
import 'package:find_your_phone/model/phone_data.dart';
import 'package:find_your_phone/view/phone_details_screen.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';


import '../shared/reusable_widgets/app_bar.dart';
import '../shared/reusable_widgets/navigation_drawer_widget.dart';
import '../shared/reusable_widgets/phone_container.dart';
import 'add_phone.dart';


class FoundPhonesScreen extends StatelessWidget {
  FoundPhonesScreen({Key? key}) : super(key: key);
  // BottomBarButtons buttonTapped = BottomBarButtons.Home;
  FirebaseController _firebaseController = Get.find<FirebaseController>();
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            CustomAppBar(
              appBarTitle: 'هواتف لا يُعرف أصحابها',
              // searchFunction: () {},
              isLostPhonesScreen: false,
            ),
          ],
          body: SafeArea(
            child: Padding(
              padding:
                  EdgeInsets.only(bottom: 40, right: 20, left: 20, top: 20),
              child: Container(
                width: double.maxFinite,
                child: Column(
                  children: [
                    Obx(
                      () => ListView(
                        shrinkWrap: true,
                        children: [
                          for (PhoneData phone
                              in _firebaseController.foundPhones)
                            GestureDetector(
                              onTap: () => Get.to(() => PhoneDetailsScreen(
                                    phone: phone,
                                    docId: _firebaseController.getDocId(phone),
                                  )),
                              child: PhoneContainer(
                                phone: phone,
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
                  ],
                ),
              ),
            ),
          ),
        ),
        // body:
        floatingActionButton: Padding(
          padding: EdgeInsets.all(20),
          child: FloatingActionButton(
            elevation: 5,
            child: Icon(Icons.add),
            onPressed: () {
              Get.to(() => AddPhone(
                    isLostPhone: false,
                  ));
            },
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        // bottomNavigationBar: Container(
        //   // height: MediaQuery.of(context).size,
        //   // width: double.maxFinite,
        //   height: 0,
        //   color: Colors.indigo[50],
        // ),
        drawer: CustomNavigationDrawerWidget(),
      ),
    );
  }
}
