// ignore_for_file: use_build_context_synchronously

import 'package:find_your_phone/control/admin_controller.dart';
import 'package:find_your_phone/control/firebase_controller.dart';
import 'package:find_your_phone/control/ui_controller.dart';
import 'package:find_your_phone/model/found_phone.dart';
import 'package:find_your_phone/model/phone_data.dart';
import 'package:find_your_phone/shared/colors.dart';
import 'package:find_your_phone/shared/enums.dart';
import 'package:find_your_phone/shared/reusable_widgets/admin_widgets/admin_components.dart';
import 'package:find_your_phone/shared/reusable_widgets/components.dart';
import 'package:find_your_phone/shared/reusable_widgets/phones_list.dart';
import 'package:find_your_phone/view/law_screen.dart';
import 'package:find_your_phone/view/lost_phones_screen.dart';
import 'package:find_your_phone/view/phone_details_screen.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../model/admin_data.dart';
import '../../shared/reusable_widgets/admin_widgets/admin_container.dart';
import '../../shared/reusable_widgets/app_bar.dart';
import '../../shared/reusable_widgets/navigation_drawer_widget.dart';
import '../../shared/reusable_widgets/phone_container.dart';
import '../add_phone.dart';

class AdminsScreen extends StatelessWidget {
  AdminsScreen({Key? key}) : super(key: key);
  var scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  // BottomBarButtons buttonTapped = BottomBarButtons.Home;
  final FirebaseController _firebaseController = Get.find<FirebaseController>();
  final AdminController _adminController = Get.find<AdminController>();
  final UIController _uiController = Get.find<UIController>();

  deleteAdmin(BuildContext context,AdminData admin) async{
    Get.back();
    showLoading(context);
    bool result =
    await _adminController.deleteAdmin(admin);
    Get.back();
    if (result) {
      showToast(
        context,
        'تم الحذف بنجاح',
        ToastStates.success,
      );
    } else {
      showToast(
        context,
        'حدث خطأ أثناء الحذف برجاء المحاوله لاحقًا',
        ToastStates.error,
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        key: scaffoldKey,
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            CustomAppBar(
              appBarTitle: 'المشرفون',
              // searchFunction: () {},
              // isLostPhonesScreen: false,
            ),
          ],
          body: SafeArea(
            child: Padding(
              padding:
                  EdgeInsets.only(bottom: 60, right: 20, left: 20, top: 10),
              child: Container(
                width: double.maxFinite,
                child: Obx(
                  () => ListView(
                    shrinkWrap: true,
                    children: [
                      for (AdminData admin in _adminController.admins)
                        GestureDetector(
                          onTap: () {},
                          onLongPress: () async {
                            customAlertDialog(
                              context,
                              title: 'حذف المشرف',
                              content: 'هل أنت متأكد من أنك تريد حذف المشرف ؟',
                              confirmFunction: () {
                                deleteAdmin(context, admin);
                              },
                            );

                          },
                          child: AdminContainer(
                            name: admin.name,
                            email: admin.email,
                            id: admin.id,
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
        floatingActionButton: GetBuilder<UIController>(builder: (_) {
          return Padding(
            padding: EdgeInsets.all(20),
            child: FloatingActionButton(
              elevation: 5,
              child: Icon(_uiController.addAdminFloatingButton
                  ? Icons.add
                  : Icons.close),
              onPressed: () {
                if (_uiController.addAdminFloatingButton) {
                  addAdminBottomSheet(
                    context,
                    scaffoldKey,
                    formKey,
                  );
                } else {
                  Get.back();
                }
                _uiController.changeAddAdminFloatingButton();
              },
            ),
          );
        }),
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
