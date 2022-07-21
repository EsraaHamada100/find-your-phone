
import 'package:email_validator/email_validator.dart';
import 'package:find_your_phone/control/app_controller.dart';
import 'package:find_your_phone/control/sign_controller.dart';
import 'package:find_your_phone/shared/colors.dart';
import 'package:find_your_phone/shared/reusable_widgets/custom_sign_input_field.dart';
import 'package:find_your_phone/view/forget_password.dart';
import 'package:find_your_phone/view/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class SignInScreen extends StatelessWidget {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String? userName, email, password;
  final SignController _signController = Get.find<SignController>();
  final AppController _appController = Get.find<AppController>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  signIn(context) async {
    var formData = formKey.currentState;
    if (formData!.validate()) {
      // in order to store the data in variables
      formData.save();
      _appController.changeDrawerIndex(0);
      await _signController.signInWithEmailAndPassword(
        context,
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
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.all(20),
            width: double.maxFinite,
            height: double.maxFinite,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/user.png',
                    height: MediaQuery.of(context).size.height * 0.3,
                  ),
                  Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        // email
                        CustomSignInputField(
                          isPassword:false,
                          onSaved: (val) {
                            email = val;
                          },
                          validator: (val) {
                            if (val == null) {
                              return "اكتب بريدك الإلكترونى";
                            }
                            if(!EmailValidator.validate(val)){
                              return "اكتب بريد الكترونى صالح";
                            }
                            return null;
                          },
                          icon: Icons.email_outlined,
                          hint: 'البريد الإلكترونى',
                        ),
                        const SizedBox(height: 20),
                        CustomSignInputField(
                          // because I don't want the eye icon to appear
                          controller: _passwordController,
                          isPassword:true,
                          // obscureText: true,
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
                        TextButton(
                          onPressed: () {
                            Get.to(() => ForgetPasswordScreen());
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                'نسيت كلمة المرور؟',
                                style: TextStyle(
                                  color: buttonColor,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // sign in
                        ElevatedButton(
                          onPressed: () async {
                            await signIn(context);
                          },
                          child: Text('تسجيل الدخول'),
                          style: ButtonStyle(
                            fixedSize: MaterialStateProperty.all(
                              Size(150, 50),
                            ),
                            backgroundColor:
                                MaterialStateProperty.all(buttonColor),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),

                      ],
                    ),
                  ),

                  // create an account
                  Container(
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'لا تمتلك حسابًا',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        TextButton(
                          onPressed: () {
                            Get.to(() => SignUpScreen());
                          },
                          child: Flex(
                            direction: Axis.horizontal,
                            children: [
                              Text(
                                'إنشاء حساب',
                                style: TextStyle(
                                    color: buttonColor,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // OR
                  Row(children: const <Widget>[
                    Expanded(child: Divider()),
                    Text("أو"),
                    Expanded(child: Divider()),
                  ]),
                  SizedBox(
                    height: 20,
                  ),
                  // Sign in with google
                  ElevatedButton.icon(
                      onPressed: () async {
                        _appController.changeDrawerIndex(0);
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
                      ),
                      style: ButtonStyle(
                        minimumSize:
                            MaterialStateProperty.all(Size(double.maxFinite, 55)),
                        backgroundColor: MaterialStateProperty.all(Colors.white),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
