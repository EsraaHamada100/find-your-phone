import 'package:email_validator/email_validator.dart';
import 'package:find_your_phone/control/admin_controller.dart';
import 'package:find_your_phone/control/ui_controller.dart';
import 'package:find_your_phone/shared/reusable_widgets/custom_button.dart';
import 'package:find_your_phone/shared/reusable_widgets/custom_sign_input_field.dart';
import 'package:find_your_phone/view/admin_screens/admins_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../components.dart';
import '../../enums.dart';

addAdminBottomSheet(BuildContext context, var scaffoldKey,
    GlobalKey<FormState> formKey,) {
  late String name, email, id;
  final AdminController adminController = Get.find<AdminController>();
  final UIController uiController = Get.find<UIController>();
  return scaffoldKey.currentState!.showBottomSheet(
    (context) => Container(
      color: Colors.white,
      padding: const EdgeInsets.all(20.0),
      child: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
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
            SizedBox(
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
            SizedBox(
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
            SizedBox(
              height: 20.0,
            ),
            CustomButton(
                text: 'إضافة',
                onPressed: () async {
                  var formData = formKey.currentState;
                  if (formData!.validate()) {
                    formKey.currentState!.save();
                    showLoading(context);
                    bool result = await adminController.addAdmin(
                        id: id, name: name, email: email);
                    uiController.changeAddAdminFloatingButton();
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
                    }
                  }
                }),
          ],
        ),
      ),
    ),
    elevation: 15.0,
  );
}
