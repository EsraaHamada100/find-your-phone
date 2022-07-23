import 'package:email_validator/email_validator.dart';
import 'package:find_your_phone/control/sign_controller.dart';
import 'package:find_your_phone/shared/colors.dart';
import 'package:find_your_phone/shared/reusable_widgets/custom_sign_input_field.dart';
import 'package:find_your_phone/view/lost_phones_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../shared/reusable_widgets/components.dart';

class ForgetPasswordScreen extends StatelessWidget {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String? email;
  // final TextEditingController _emailController = TextEditingController();
  final SignController _signController = Get.find<SignController>();
  forgotPassword(BuildContext context) async {
    var formData = formKey.currentState;
    if (formData!.validate()) {
      formData.save();
      await _signController.forgotPassword(
        context,
        userEmail: email,
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
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image(
                      image: AssetImage('assets/images/forgot_password.png'),
                    ),
                  ),
                  Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        // name
                        // TextFormField(
                        //   onSaved: (val) {
                        //     email = val;
                        //   },
                        //   validator: (val) {
                        //     if (val == null) {
                        //       return "write an email";
                        //     }
                        //     if (val.length > 100) {
                        //       return "Write an email not your life story :)";
                        //     }
                        //     if (val.length < 2) {
                        //       return "No one has email less than two characters lol";
                        //     }
                        //     return null;
                        //   },
                        //   decoration: const InputDecoration(
                        //     prefixIcon: Icon(Icons.email),
                        //     hintText: 'البريد الإلكترونى',
                        //     border: OutlineInputBorder(
                        //       borderSide: BorderSide(width: 1),
                        //     ),
                        //   ),
                        // ),

                        // CustomSignInputField(
                        //     onSaved: (val) {
                        //       email = val;
                        //     },
                        //     validator: (val) {
                        //       print('values $val');
                        //       if (val == null ) {
                        //         print(val);
                        //         return 'هذا الإيميل غير صالح';
                        //       }else if(EmailValidator.validate(val)){
                        //       return 'غير صالح';}else {
                        //         return 'falj';
                        //       }
                        //     },
                        //     icon: Icons.email,
                        //     hint:
                        //         'البريد الإلكترونى',
                        //     isPassword: false),
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
                        SizedBox(
                          height: 30,
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            // UserCredential? response = await signIn(context);
                            // print(response);
                            // if (response != null) {
                            //   print(response.user!.email);
                            //   Navigator.of(context).pushReplacement(
                            //     MaterialPageRoute(
                            //       builder: (BuildContext context) =>
                            //           LostPhones(),
                            //     ),
                            //   );
                            // }
                            await forgotPassword(context);
                          },
                          child: Text('أرسل إيميل تأكيد'),
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
