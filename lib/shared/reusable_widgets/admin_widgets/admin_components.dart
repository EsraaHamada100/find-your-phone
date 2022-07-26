import 'package:email_validator/email_validator.dart';
import 'package:find_your_phone/control/admin_controller.dart';
import 'package:find_your_phone/control/app_controller.dart';
import 'package:find_your_phone/shared/reusable_widgets/custom_button.dart';
import 'package:find_your_phone/shared/reusable_widgets/custom_sign_input_field.dart';
import 'package:find_your_phone/view/admin_screens/admins_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../colors.dart';
import '../components.dart';
import '../../enums.dart';

addAdminBottomSheet(
  BuildContext context,
  var scaffoldKey,
  GlobalKey<FormState> formKey,
) {
  late String name, email, id;
  final AdminController adminController = Get.find<AdminController>();
  // final UIController uiController = Get.find<UIController>();
  final AppController appController = Get.find<AppController>();
  return scaffoldKey.currentState!.showBottomSheet(
    (context) => Container(
      color: appController.isDark?darkColor2: Colors.white,
      padding: const EdgeInsets.all(20.0),
      child: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 20,
            ),
            CustomSignInputField(
              onSaved: (value) {
                id = value!;
              },
              validator: (value) {
                if (value == null || value.trim() == '') {
                  return 'ادخل رقم تعريفى';
                }
                return null;
              },
              icon: Icons.numbers,
              hint: 'اكتب الرقم التعريفي',
            ),
            const SizedBox(
              height: 30.0,
            ),
            CustomSignInputField(
              onSaved: (value) {
                name = value!;
              },
              validator: (value) {
                if (value == null || value.trim() == '') {
                  return 'أدخل اسمًا';
                }
                if (value.length < 2) {
                  return 'أدخل اسمًا صالحًا';
                }
              },
              icon: Icons.text_fields,
              hint: 'اكتب اسم المشرف',
            ),
            const SizedBox(
              height: 20.0,
            ),
            CustomSignInputField(
              onSaved: (value) {
                email = value!;
              },
              validator: (value) {
                if (value == null || value.trim() == '') {
                  return 'أدخل بريد الكتروني ';
                }
                if (!EmailValidator.validate(value)) {
                  return "اكتب بريد الكتروني صالح";
                }
                return null;
              },
              icon: Icons.email_outlined,
              hint: 'اكتب البريد الإلكتروني',
            ),
            const SizedBox(
              height: 20.0,
            ),
            CustomButton(
                text: 'إضافة',
                onPressed: () async {
                  var formData = formKey.currentState;
                  if (formData!.validate()) {
                    formKey.currentState!.save();
                    bool isConnected = await appController.checkInternetConnection(context);
                    if(isConnected){
                    bool result = await adminController.addAdmin(
                        id: id, name: name, email: email);
                    appController.changeAddAdminFloatingButton();
                    if (result) {
                      Get.offAll(() => AdminsScreen());
                      showToast(
                          context, 'تم الإضافة بنجاح', ToastStates.success);
                    } else {
                      Get.back();
                      showToast(
                          context,
                          'حدث خطأ أثناء الإضافة يرجى المحاولة لاحقًا',
                          ToastStates.error);
                    }}
                  }
                }),
          ],
        ),
      ),
    ),
    elevation: 15.0,
  );
}
customBottomSheet(BuildContext context, Widget form) {

  return showModalBottomSheet(
    // mainAxisSize: MainAxisSize.min,
    context: context,
    isScrollControlled: true, // only work on showModalBottomSheet function
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(15),
        topRight: Radius.circular(15),
      ),
    ),
    builder: (_) {
      // I used wrap here to make the bottom sheet as height as
      // it's content
      return Wrap(
        children: [
          Directionality(
            textDirection: TextDirection.rtl,
            child: Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: Container(
                // height: MediaQuery.of(context).size.height * 0.56,
                padding: const EdgeInsets.all(20),
                child: form,
              ),
            ),
          ),
        ],
      );
    },
  );
}

