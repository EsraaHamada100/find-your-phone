// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:email_validator/email_validator.dart';
import 'package:find_your_phone/control/app_controller.dart';
import 'package:find_your_phone/control/sign_controller.dart';
import 'package:find_your_phone/shared/colors.dart';
import 'package:find_your_phone/shared/reusable_widgets/custom_sign_input_field.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../shared/enums.dart';
import '../shared/reusable_widgets/components.dart';

class SignUpScreen extends StatelessWidget {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String? userName, email, password;
  // UserCredential? credential;
  final _passwordController = TextEditingController();
  final _signController = Get.find<SignController>();
  final AppController _appController = Get.find<AppController>();
  SignUpScreen({super.key});

  signUp(BuildContext context) async {
    var formData = formKey.currentState;

    // final FirebaseAuth _auth = FirebaseAuth.instance;
    if (formData!.validate()) {
      bool result = await _appController.checkInternetConnection(context);
      if(!result){
        return;
      }
      formData.save();

      await _signController.signUpWithEmailAndPassword(
        context,
        userName: userName!,
        email: email!,
        password: password!,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: secondaryColor,
          elevation: 0,
          foregroundColor: buttonColor,
        ),
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.all(25),
            width: double.maxFinite,
            height: double.maxFinite,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  ElevatedButton.icon(
                      onPressed: () async {
                        bool result = await _appController
                            .checkInternetConnection(context);
                        if (!result) {
                          return;
                        }
                        await _signController.signInWithGoogle();
                      },
                      label: Text(
                        'تسجيل الدخول باستخدام حساب جوجل',
                        style: Theme.of(context).textTheme.button,
                      ),
                      icon: SvgPicture.asset(
                        'assets/images/google_icon.svg',
                        height: 30,
                        width: 30,
                        // color: Colors.red,
                        // semanticsLabel: 'A red up arrow'
                      ),
                      style: ButtonStyle(
                        minimumSize: MaterialStateProperty.all(
                            Size(double.maxFinite, 55)),
                        backgroundColor:
                            MaterialStateProperty.all(Colors.indigo[100]),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      )),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    children: const <Widget>[
                      Expanded(child: Divider()),
                      Text("أو"),
                      Expanded(child: Divider()),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 30),
                        CustomSignInputField(
                            isPassword: false,
                            onSaved: (val) {
                              userName = val;
                            },
                            validator: (val) {
                              if (val == null) {
                                return "اكتب إسمك";
                              }
                              if (val.length > 50) {
                                return "اكتب اسمك وليس تاريخ البشرية";
                              }
                              if (val.length < 2) {
                                return "اكتب إسمًا صالح";
                              }
                              return null;
                            },
                            icon: Icons.account_circle_outlined,
                            hint: 'الإسم'),
                        const SizedBox(height: 20),
                        // email
                        CustomSignInputField(
                          isPassword: false,
                          onSaved: (val) {
                            email = val;
                          },
                          validator: (val) {
                            if (val == null) {
                              return "اكتب بريدك الإلكترونى";
                            }
                            if (!EmailValidator.validate(val)) {
                              return "اكتب بريد الكترونى صالح";
                            }
                            return null;
                          },
                          icon: Icons.email_outlined,
                          hint: 'البريد الإلكترونى',
                        ),
                        SizedBox(height: 20),
                        // password
                        CustomSignInputField(
                          isPassword: true,
                          controller: _passwordController,
                          onSaved: (val) {
                            password = val;
                          },
                          validator: (val) {
                            if (val == null) {
                              return "اكتب كلمة مرور";
                            }
                            if (val.length > 100) {
                              return "اكتب كلمة مرور اقصر. نهتم بالأمان ولكن ليس لهذه الدرجه :)";
                            }
                            if (val.length < 6) {
                              return "كلمة المرور يجب أن تكون أكثر من 6 أحرف";
                            }
                            return null;
                          },
                          icon: Icons.password,
                          hint: 'كلمة المرور',
                        ),
                        SizedBox(height: 20),
                        // rewrite password
                        CustomSignInputField(
                          isPassword: true,
                          validator: (val) {
                            if (val == null) {
                              return "يجب تأكيد كلمة المرور";
                            }
                            if (val != _passwordController.text) {
                              return "كلمة المرور غير متطابقة";
                            }
                            return null;
                          },
                          icon: Icons.password,
                          hint: 'تأكيد كلمة المرور',
                        ),
                        SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: () async {
                            await signUp(context);
                          },
                          child: Text('إنشاء حساب'),
                          style: ButtonStyle(
                            fixedSize: MaterialStateProperty.all(
                              Size(150, 50),
                            ),
                            backgroundColor:
                                MaterialStateProperty.all(buttonColor),
                          ),
                        ),
                        SizedBox(
                          height: 10,
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
    );
  }
}
