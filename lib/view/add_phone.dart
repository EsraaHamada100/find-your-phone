import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_your_phone/control/add_phone_controller.dart';
import 'package:find_your_phone/control/admin_controller.dart';
import 'package:find_your_phone/control/controller.dart';
import 'package:find_your_phone/control/sign_controller.dart';
import 'package:find_your_phone/shared/colors.dart';
import 'package:find_your_phone/shared/reusable_widgets/components.dart';
import 'package:find_your_phone/shared/reusable_widgets/custom_button.dart';
import 'package:find_your_phone/shared/reusable_widgets/add_phone_input_field.dart';
import 'package:find_your_phone/shared/reusable_widgets/scrollable_transparent_app_var.dart';
import 'package:find_your_phone/view/lost_phones_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AddPhone extends StatelessWidget {
  AddPhone({
    required this.isLostPhone,
    Key? key,
  }) : super(key: key);

  final bool isLostPhone;
  final AddPhoneController _controller = Get.find<AddPhoneController>();
  final AdminController _adminController = Get.find<AdminController>();
  final SignController _signController = Get.find<SignController>();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  GlobalKey<FormState> formKey2 = GlobalKey<FormState>();
  late String type;
  String? description;
  late String IMME1;
  String? IMME2;
  late String phoneNumber;
  String? whatsAppNumber;
  String? facebookAccount;
  String? paymentNumber;
  bool verified = true;
  bool validateData() {
    var formData = formKey.currentState;
    if (formData!.validate()) {
      return true;
    } else {
      return false;
    }
  }

  addPhoneData(BuildContext context) async {
    if (validateData()) {
      formKey.currentState!.save();
      showLoading(context);
      DateTime now = DateTime.now();

      await _controller.addPhone(
        phoneType: type,
        phoneDescription: description,
        IMME1: IMME1,
        IMME2: IMME2,
        phoneNumber: phoneNumber,
        whatsAppNumber: whatsAppNumber,
        facebookAccount: facebookAccount,
        isLostPhone: isLostPhone,
        addedDate: '${now.year}-${now.month}-${now.day}',
        paymentNumber: paymentNumber,
      );
      // Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            CustomScrollableTransparentAppBar(appBarTitle: 'أضف هاتف'),
          ],
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Obx(
                () => SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 170,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (_controller.imagesFileList.isEmpty)
                              OutlinedButton.icon(
                                style: ButtonStyle(
                                  foregroundColor: MaterialStateProperty.all(
                                      Colors.indigo[300]),
                                ),
                                onPressed: () {
                                  _controller.pickPhoneImages();
                                },
                                label: Text('Upload phone images'),
                                icon: Icon(Icons.upload),
                              ),
                            if (_controller.imagesFileList.isNotEmpty)
                              Container(
                                width: double.maxFinite,
                                height: 120,
                                child: GridView.builder(
                                  itemCount: _controller.imagesFileList.length,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 3,
                                  ),
                                  itemBuilder: (_, int index) {
                                    return Image.file(
                                      File(_controller
                                          .imagesFileList[index].path),
                                      fit: BoxFit.cover,
                                    );
                                  },
                                ),
                              ),
                            if (_controller.imagesFileList.isNotEmpty)
                              // buttons to change and remove images
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  OutlinedButton.icon(
                                    style: ButtonStyle(
                                      foregroundColor:
                                          MaterialStateProperty.all(
                                              Colors.indigo[400]),
                                      fixedSize: MaterialStateProperty.all(
                                        Size(150, 30),
                                      ),
                                    ),
                                    onPressed: () {
                                      _controller.pickPhoneImages();
                                    },
                                    label: Text('تغير الصور'),
                                    icon: Icon(Icons.change_circle_outlined),
                                  ),
                                  OutlinedButton.icon(
                                    style: ButtonStyle(
                                      foregroundColor:
                                          MaterialStateProperty.all(
                                              Colors.indigo[400]),
                                      fixedSize: MaterialStateProperty.all(
                                        Size(150, 30),
                                      ),
                                    ),
                                    onPressed: () {
                                      _controller.clearPhoneImages();
                                    },
                                    label: Text('حذف الصور'),
                                    icon: Icon(Icons.delete_outline),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                      Form(
                        key: formKey,
                        child: Column(
                          children: [
                            AddPhoneInputField(
                              onSaved: (val) {
                                if (val != null && val.trim() != '') {
                                  type = val.trim();
                                }
                              },
                              validator: (val) {
                                if (val == null || val.trim() == '') {
                                  return 'ادخل نوع الهاتف';
                                }
                                return null;
                              },
                              title: "نوع الهاتف",
                              hint: "اكتب نوع هاتفك",
                            ),
                            AddPhoneInputField(
                              arabicText: true,
                              onSaved: (val) {
                                if (val != null && val.trim() != '') {
                                  description = val.trim();
                                }
                              },
                              title: "الوصف",
                              hint: "اكتب وصف لهاتفك",
                            ),
                            AddPhoneInputField(
                              onSaved: (val) {
                                if (val != null && val.trim() != '') {
                                  IMME1 = val.trim();
                                }
                              },
                              validator: (val) {
                                if (val == null || val.trim() == '') {
                                  return 'يجب إدخال الرقم التسلسلى IMME';
                                }
                                if (val.trim().length != 15) {
                                  return 'IMME يجب أن يكون مكون من 15 رمزًا';
                                }
                                return null;
                              },
                              title: " الرقم التسلسلي " " IMEI1 : ",
                              hint: "اكتب الرقم التسلسلى لهاتفك",
                            ),
                            AddPhoneInputField(
                              onSaved: (val) {
                                if (val != null && val.trim() != '') {
                                  IMME2 = val.trim();
                                }
                              },
                              validator: (val) {
                                if (val == null || val.trim() == '') {
                                  return null;
                                } else if (val.trim().length != 15) {
                                  return 'IMME يجب أن يكون مكون من 15 رمزًا';
                                }
                                return null;
                              },
                              title: " الرقم التسلسلي " " IMEI2 : ",
                              hint: " اكتب الرقم التسلسلى الثانى لهاتفك إن وجد",
                            ),
                            Divider(),
                            SizedBox(height: 30),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: defaultColor,
                              ),
                              child: Text(
                                'معلومات التواصل',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6!
                                    .copyWith(color: secondaryColor),
                              ),
                            ),
                            AddPhoneInputField(
                              onSaved: (val) {
                                if (val != null && val.trim() != '') {
                                  phoneNumber = val.trim();
                                }
                              },
                              validator: (val) {
                                if (val == null || val.trim() == '') {
                                  return 'أكتب رقم هاتف للتواصل';
                                }
                                if (val.trim().length < 4 ||
                                    val.trim().length > 20) {
                                  return 'رقم هاتف غير صالح';
                                }
                                return null;
                              },
                              title: "رقم الهاتف",
                              hint: " اكتب رقم هاتفك للتواصل",
                            ),
                            AddPhoneInputField(
                              onSaved: (val) {
                                if (val != null && val.trim() != '') {
                                  whatsAppNumber = val.trim();
                                }
                              },
                              validator: (val) {
                                if (val == null || val.trim() == '') {
                                  return null;
                                }
                                if (val.trim().length < 4 ||
                                    val.trim().length > 20) {
                                  return 'رقم هاتف غير صالح';
                                }
                                if (val.trim()[0] != '+') {
                                  return 'اكتب كود الدوله قبل رقم الهاتف';
                                }
                                return null;
                              },
                              title: "رقم الواتساب",
                              hint: "اكتب رقم يوجد عليه حساب واتساب",
                            ),
                            AddPhoneInputField(
                              onSaved: (val) {
                                if (val != null && val.trim() != '') {
                                  facebookAccount = val.trim();
                                }
                              },
                              // https://www.facebook.com
                              validator: (val) {
                                if (val == null || val.trim() == '') {
                                  return null;
                                }
                                if (val
                                    .trim()
                                    .startsWith('https://www.facebook.com')) {
                                  return null;
                                }
                                return 'لينك حساب الفيسبوك غير صحيح إذا كنت لا تمتلك واحدًا يمكنك ترك الحقل فارغًا';
                              },
                              title: "حساب الفيسبوك",
                              hint: "ضع لينك حساب الفيسبوك هنا",
                            ),
                            SizedBox(height: 40),
                            CustomButton(
                              text: 'أضف الهاتف',
                              onPressed: () {
                                if (validateData()) {
                                  if (_adminController.isAdmin ||
                                      _adminController.adminDocument!.isFree) {
                                    addPhoneData(context);
                                  } else {
                                    customAlertDialog(
                                      context,
                                      title: 'إضافة هاتف',
                                      content:
                                          'يجب دفع مبلغ 10 جنيه لإضافة هاتفك,'
                                          ' هل تريد إكمال عملية الإضافة ؟',
                                      confirmFunction: () {
                                        Get.back();
                                        paymentBottomSheet(
                                          context,
                                          () => vodafonePayment(context),
                                        );
                                      },
                                    );
                                  }
                                }
                                // paymentBottomSheet(context);
                                // addPhoneData(context);
                              },
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
        ),
      ),
    );
  }

  vodafonePayment(BuildContext context) {
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
                height: MediaQuery.of(context).size.height * 0.4,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'أرسل ${_adminController.adminDocument!.paymentAmount} جنيه لهذا الرقم   ${_adminController.adminDocument!.paymentNumber}',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          wordSpacing: 10,
                          fontSize: 18,
                          color: Colors.grey[700]),
                    ),
                    Text(
                      'ثم قم بكتابة الرقم الذى أرسلت منه المبلغ',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          wordSpacing: 10,
                          fontSize: 18,
                          color: Colors.grey[700]),
                    ),
                    Form(
                      key: formKey2,
                      child: AddPhoneInputField(
                        keyboardType: TextInputType.number,
                        onSaved: (val) {
                          if (val != null && val.trim() != '') {
                            paymentNumber = val.trim();
                          }
                        },
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
                        title: "رقم الهاتف",
                        hint: " اكتب الرقم الذى أرسلت منه المبلغ",
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              var formData = formKey2.currentState;
                              if (formData!.validate()) {
                                formData.save();
                                Get.offAll(() => LostPhonesScreen());
                                addPhoneData(context);
                              }
                            },
                            child: Text('تم'),
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              Get.back();
                              Get.back();
                            },
                            child: Text('إلغاء'),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
