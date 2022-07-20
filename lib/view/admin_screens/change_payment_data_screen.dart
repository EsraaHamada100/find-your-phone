import 'package:find_your_phone/control/admin_controller.dart';
import 'package:find_your_phone/shared/reusable_widgets/custom_sign_input_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../shared/colors.dart';
import '../../shared/reusable_widgets/scrollable_transparent_app_var.dart';

class ChangePaymentDataScreen extends StatelessWidget {
  ChangePaymentDataScreen({Key? key}) : super(key: key);
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final AdminController _adminController = Get.find<AdminController>();
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            CustomScrollableTransparentAppBar(
              appBarTitle: 'تغيير بيانات الدفع',
            ),
          ],
          body: Padding(
            padding: EdgeInsets.all(20),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  CustomSignInputField(
                    onSaved: (val) {
                      if (val != null && val.trim() != '') {
                        // paymentNumber = val.trim();
                      }
                    },
                    validator: (val) {
                      if (val == null || val.trim() == '') {
                        return 'أكتب رقم هاتف صحيح';
                      }
                      if (val.trim().length != 10 && val.trim().length != 11) {
                        return 'رقم هاتف غير صالح';
                      }
                      return null;
                    },
                    hint: " اكتب الرقم الذى سيرسل إليه المبلغ",
                    icon: Icons.phone,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomSignInputField(
                    onSaved: (val) {
                      if (val != null && val.trim() != '') {
                        // paymentNumber = val.trim();
                      }
                    },
                    validator: (val) {
                      if (val == null || val.trim() == '') {
                        return 'أكتب مبلغ صحيح';
                      }
                      if (val.trim().length != 10 && val.trim().length != 11) {
                        return 'رقم هاتف غير صالح';
                      }
                      return null;
                    },
                    hint: " اكتب المبلغ",
                    icon: Icons.monetization_on_rounded,
                    keyboardType: TextInputType.number,
                  ),
                  GetBuilder<AdminController>(
                    builder: (context) {
                      return Switch(
                        activeColor: defaultColor,
                        value: _adminController.isFree,
                        onChanged: (_) {
                          _adminController.changeIsFree();
                        },
                      );
                    }
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
