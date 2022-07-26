// ignore_for_file: use_build_context_synchronously

import 'package:find_your_phone/control/admin_controller.dart';
import 'package:find_your_phone/control/app_controller.dart';
import 'package:find_your_phone/shared/enums.dart';
import 'package:find_your_phone/shared/reusable_widgets/admin_widgets/admin_components.dart';
import 'package:find_your_phone/shared/reusable_widgets/components.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../model/admin_data.dart';
import '../../shared/reusable_widgets/admin_widgets/admin_container.dart';
import '../../shared/reusable_widgets/app_bar.dart';
import '../../shared/reusable_widgets/navigation_drawer_widget.dart';

class AdminsScreen extends StatelessWidget {
  AdminsScreen({Key? key}) : super(key: key);
  var scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final AdminController _adminController = Get.find<AdminController>();
  final AppController _appController = Get.find<AppController>();

  deleteAdmin(BuildContext context, AdminData admin) async {
    Get.back();
    showLoading(context);
    bool result = await _adminController.deleteAdmin(admin);
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
        floatingActionButton: GetBuilder<AppController>(builder: (_) {
          return Padding(
            padding: EdgeInsets.all(20),
            child: FloatingActionButton(
              elevation: 5,
              child: Icon(_appController.addAdminFloatingButton
                  ? Icons.add
                  : Icons.close),
              onPressed: () {
                if (_appController.addAdminFloatingButton) {
                  addAdminBottomSheet(
                    context,
                    scaffoldKey,
                    formKey,
                  );
                } else {
                  Get.back();
                }
                _appController.changeAddAdminFloatingButton();
              },
            ),
          );
        }),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        drawer: CustomNavigationDrawerWidget(),
      ),
    );
  }
}
