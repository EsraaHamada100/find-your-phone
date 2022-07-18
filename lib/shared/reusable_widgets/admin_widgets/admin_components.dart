import 'package:find_your_phone/shared/reusable_widgets/custom_sign_input_field.dart';
import 'package:flutter/material.dart';

addAdminBottomSheet(
    BuildContext context, var scaffoldKey, dynamic Function()? onTap) {
  return scaffoldKey.currentState!.showBottomSheet(
    (context) => Container(
      color: Colors.white,
      padding: EdgeInsets.all(20.0),
      child: Form(
        // key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(),
            CustomSignInputField(
              validator: (value) {},
              icon: Icons.numbers,
              hint: 'اكتب الرقم التعريفي',
              isPassword: false,
            ),
            SizedBox(
              height: 20.0,
            ),
            CustomSignInputField(
              validator: (value) {},
              icon: Icons.text_fields,
              hint: 'اكتب اسم المشرف',
              isPassword: false,
            ),
            SizedBox(
              height: 20.0,
            ),
            CustomSignInputField(
              validator: (value) {},
              icon: Icons.email_outlined,
              hint: 'اكتب البريد الإلكترونى',
              isPassword: false,
            ),
            SizedBox(
              height: 20.0,
            ),
          ],
        ),
      ),
    ),
    elevation: 15.0,
  );
}
