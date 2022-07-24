import 'package:find_your_phone/view/phone_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../control/firebase_controller.dart';
import '../model/phone_data.dart';
import '../shared/reusable_widgets/app_bar.dart';
import '../shared/reusable_widgets/navigation_drawer_widget.dart';
import '../shared/reusable_widgets/phone_container.dart';
import 'add_phone.dart';

class LostPhonesScreen extends StatelessWidget {
  LostPhonesScreen({
    Key? key,
  }) : super(key: key);
  final FirebaseController _firebaseController = Get.find<FirebaseController>();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            CustomAppBar(
              appBarTitle: 'هواتف مفقوده',
              // searchFunction: () {},
              isLostPhonesScreen: true,
            ),
          ],
          body: SafeArea(
            child: Padding(
              padding:
                  EdgeInsets.only(bottom: 40, right: 20, left: 20, top: 20),
              child: Container(
                width: double.maxFinite,
                child: Obx(
                  () => ListView(
                    shrinkWrap: true,
                    children: [
                      for (PhoneData phone in _firebaseController.lostPhones)
                          GestureDetector(
                            onTap: () => Get.to(
                              () => PhoneDetailsScreen(
                                phone: phone,
                                docId: _firebaseController.getDocId(phone),
                              ),
                            ),
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
                    isLostPhone: true,
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

// ListView(
// shrinkWrap: true,
// children: [
// for (LostPhonesDocument document
// in _firebaseController.lostPhonesDocuments)
// for (LostPhoneData phone in document.phonesData)
// GestureDetector(
// onTap: () => Get.to(() => LostPhones()),
// child: PhoneContainer(
// phoneType: phone.phoneType,
// image: phone.imageUrls.isNotEmpty
// ? phone.imageUrls[0]
// : null,
// IMME1: phone.IMME1,
// IMME2: phone.IMME2,
// ),
// ),
// ],
// ),

// ListView.builder(
// shrinkWrap: true,
// // children: [
// //   for (LostPhonesDocument document
// //   in _firebaseController.lostPhonesDocuments)
// // for (LostPhoneData phone in document.phonesData)
// itemCount: _firebaseController.lostPhonesDocuments.length,
// itemBuilder:(context, i)=>ListView.builder(
// shrinkWrap: true,
// physics: ClampingScrollPhysics(),
// itemCount: _firebaseController.lostPhonesDocuments[i].phonesData.length,
// itemBuilder: (_,index)=>GestureDetector(
// onTap: () => Get.to(() => LostPhones()),
// child: PhoneContainer(
// phoneType: _firebaseController.lostPhonesDocuments[i].phonesData[index].phoneType,
// image: _firebaseController.lostPhonesDocuments[i].phonesData[index].imageUrls.isNotEmpty
// ? _firebaseController.lostPhonesDocuments[i].phonesData[index].imageUrls[0]
// : null,
// IMME1: _firebaseController.lostPhonesDocuments[i].phonesData[index].IMME1,
// IMME2: _firebaseController.lostPhonesDocuments[i].phonesData[index].IMME2,
// ),
// ),),
// // ],
// ),
