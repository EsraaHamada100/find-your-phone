// ignore_for_file: use_build_context_synchronously

import 'package:find_your_phone/control/controller.dart';
import 'package:find_your_phone/shared/colors.dart';
import 'package:find_your_phone/shared/enums.dart';
import 'package:find_your_phone/shared/reusable_widgets/app_bar.dart';
import 'package:find_your_phone/shared/reusable_widgets/navigation_drawer_widget.dart';
import 'package:find_your_phone/view/admin_screens/change_payment_data_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../control/admin_controller.dart';
import '../shared/reusable_widgets/add_phone_input_field.dart';
import '../shared/reusable_widgets/admin_widgets/admin_components.dart';
import '../shared/reusable_widgets/components.dart';
import '../shared/reusable_widgets/custom_sign_input_field.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({Key? key}) : super(key: key);
  // var scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final AdminController adminController = Get.find<AdminController>();
  final AppController _controller = Get.find<AppController>();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            CustomAppBar(appBarTitle: 'الإعدادات'),
          ],
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: GetBuilder<AppController>(builder: (_) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'اللغة  ( language )',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.start,
                    ),
                    const SizedBox(height: 5),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white,
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: DropdownButton(
                        isExpanded: true,
                        hint: Text(
                          _controller.selectedLanguage,
                          style: TextStyle(fontSize: 16),
                        ),
                        icon: Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.grey,
                        ),
                        iconSize: 32,
                        elevation: 4,
                        style: Theme.of(context).textTheme.bodyText2,
                        underline: Container(
                          height: 0,
                        ),
                        // we write DropDownMenuItem<String> because it will show the numbers as a string in the menu
                        items: _controller.languageList
                            .map<DropdownMenuItem<String>>(
                              (String value) => DropdownMenuItem<String>(
                                value: value.toString(),
                                child: Text(
                                  value,
                                  textAlign: TextAlign.end,
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            _controller.changeLanguage(newValue);
                          }
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'الثيمات',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.start,
                    ),
                    const SizedBox(height: 5),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white,
                      ),
                      padding: EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('الوضع الداكن'),
                          Switch(
                            activeColor: defaultColor,
                            value: _controller.isDark,
                            onChanged: (_) {
                              _controller.changeMode();
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (adminController.isAdmin)
                      Center(
                        child: OutlinedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(defaultColor),
                            foregroundColor:
                                MaterialStateProperty.all(Colors.white),
                            padding: MaterialStateProperty.all(
                              const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
                              ),
                            ),
                            elevation: MaterialStateProperty.all(2),
                          ),
                          onPressed: () {
                            changePaymentDataBottomSheet(context);
                          },
                          child: Text('تغيير بيانات الدفع'),
                        ),
                      ),
                  ],
                );
              }),
            ),
          ),
        ),
        drawer: CustomNavigationDrawerWidget(),
      ),
    );
  }

  changePaymentDataBottomSheet(BuildContext context) {
    TextEditingController paymentNumberController = TextEditingController();
    TextEditingController paymentAmountController = TextEditingController();
    paymentNumberController.text = adminController.adminDocument != null
        ? adminController.adminDocument!.paymentNumber
        : '';
    paymentAmountController.text = adminController.adminDocument != null
        ? adminController.adminDocument!.paymentAmount.toString()
        : '';
    bool isFree = adminController.isFree;
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
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.5,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text(
                      'بيانات الدفع',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        CustomSignInputField(
                          controller: paymentNumberController,
                          // onSaved: (val) {
                          //   if (val != null && val.trim() != '') {
                          //     // paymentNumber = val.trim();
                          //   }
                          // },
                          validator: (val) {
                            if (val == null || val.trim() == '') {
                              return 'أكتب رقم هاتف صحيح';
                            }
                            if (val.trim().length != 10 &&
                                val.trim().length != 11) {
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
                          controller: paymentAmountController,
                          // onSaved: (val) {
                          //   if (val != null && val.trim() != '') {
                          //     // paymentNumber = val.trim();
                          //   }
                          // },
                          validator: (val) {
                            if (val == null || val.trim() == '') {
                              return 'أكتب مبلغ صحيح';
                            }
                            if (val.trim().length > 5) {
                              return 'مبلغ غير صحيح';
                            }
                            return null;
                          },
                          hint: " اكتب المبلغ",
                          icon: Icons.monetization_on_rounded,
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'مجانًا',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: buttonColor,
                                ),
                              ),
                              GetBuilder<AdminController>(builder: (context) {
                                return Switch(
                                  activeColor: defaultColor,
                                  value: adminController.isFree,
                                  onChanged: (_) {
                                    adminController.changeIsFree();
                                  },
                                );
                              }),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(buttonColor),
                                  foregroundColor:
                                      MaterialStateProperty.all(Colors.white),
                                ),
                                onPressed: () async {
                                  Get.back();
                                  showLoading(context);
                                  var formData = formKey.currentState;
                                  if (formData!.validate()) {
                                    formKey.currentState!.save();
                                    bool result =
                                        await adminController.changePaymentData(
                                      paymentNumber:
                                          paymentNumberController.text,
                                      paymentAmount: double.parse(
                                        paymentAmountController.text,
                                      ),
                                    );
                                    if (result) {
                                      Get.back();
                                      showToast(
                                        context,
                                        'تم تغيير بيانات الدفع بنجاح',
                                        ToastStates.success,
                                      );
                                    } else {
                                      Get.back();
                                      showToast(
                                        context,
                                        'حدث خطأ أثناء حفظ البيانات يرجى'
                                        ' المحاوله لاحقًا',
                                        ToastStates.error,
                                      );
                                    }
                                  }
                                },
                                child: const Text('تم'),
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              child: OutlinedButton(
                                style: ButtonStyle(
                                  foregroundColor:
                                      MaterialStateProperty.all(defaultColor),
                                ),
                                onPressed: () {
                                  if (isFree != adminController.isFree) {
                                    adminController.changeIsFree();
                                  }
                                  Get.back();
                                },
                                child: const Text('إلغاء'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
