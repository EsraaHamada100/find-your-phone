import 'package:email_validator/email_validator.dart';
import 'package:find_your_phone/control/sign_controller.dart';
import 'package:find_your_phone/shared/colors.dart';
import 'package:find_your_phone/shared/reusable_widgets/custom_sign_input_field.dart';
import 'package:find_your_phone/view/lost_phones_screen.dart';
import 'package:find_your_phone/view/signin_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../shared/reusable_widgets/components.dart';

class SignUpScreen extends StatelessWidget {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String? userName, email, password;
  // UserCredential? credential;
  final _passwordController = TextEditingController();
  final _signController = Get.find<SignController>();

  SignUpScreen({super.key});
  // signIn(BuildContext context) async {
  //   var formData = formKey.currentState;
  //   if (formData!.validate()) {
  //     // in order to store the data in variables
  //     formData.save();
  //     try {
  //       showLoading(context);
  //       final credential =
  //           await FirebaseAuth.instance.signInWithEmailAndPassword(
  //         email: email!,
  //         password: password!,
  //       );
  //       return credential;
  //     } on FirebaseAuthException catch (e) {
  //       if (e.code == 'user-not-found') {
  //         Navigator.of(context).pop();
  //         print('No user found for that email.');
  //         showDialog(
  //             context: context,
  //             builder: (context) {
  //               return AlertDialog(
  //                 shape: RoundedRectangleBorder(
  //                   borderRadius: BorderRadius.circular(20),
  //                 ),
  //                 title: Icon(Icons.warning_amber_rounded),
  //                 content: const Text('No user found for that email'),
  //               );
  //             });
  //       } else if (e.code == 'wrong-password') {
  //         Navigator.of(context).pop();
  //         print('Wrong password provided for that user.');
  //         showDialog(
  //             context: context,
  //             builder: (context) {
  //               return AlertDialog(
  //                 shape: RoundedRectangleBorder(
  //                   borderRadius: BorderRadius.circular(20),
  //                 ),
  //                 title: Icon(Icons.warning_amber_rounded),
  //                 content: const Text('Wrong password provided for that user.'),
  //               );
  //             });
  //       }
  //     }
  //     //   try {
  //     //     final credential =
  //     //         await FirebaseAuth.instance.createUserWithEmailAndPassword(
  //     //       email: email!,
  //     //       password: password!,
  //     //     );
  //     //     return credential;
  //     //   } on FirebaseAuthException catch (e) {
  //     //     if (e.code == 'weak-password') {
  //     //       print('The password provided is too weak.');
  //     //     } else if (e.code == 'email-already-in-use') {
  //     //       showDialog(
  //     //         context: context,
  //     //         builder: (context) {
  //     //           return AlertDialog(
  //     //               shape: RoundedRectangleBorder(
  //     //                 borderRadius: BorderRadius.circular(20),
  //     //               ),
  //     //               title: Icon(Icons.warning_amber_rounded),
  //     //               content: const Text('This email is already registered'),);
  //     //         }
  //     //       );
  //     //     }
  //     //   } catch (e) {
  //     //     print(e);
  //     //   }
  //     // } else {
  //     //   print('Not Valid');
  //     // }
  //   }
  // }

  signUp(BuildContext context) async {
    var formData = formKey.currentState;

    // final FirebaseAuth _auth = FirebaseAuth.instance;
    if (formData!.validate()) {
      formData.save();
      await _signController.signUpWithEmailAndPassword(
        context,
        userName: userName!,
        email: email!,
        password: password!,
      );
      // try {
      //   showLoading(context);
      //   credential = await _auth.createUserWithEmailAndPassword(
      //     email: email!,
      //     password: password!,
      //   );
      //   print('user credential : ');
      //   print(credential);
      //   print('user name : ');
      //   print(userName);
      //   // await credential!.user!.updateDisplayName(userName);
      //   await FirebaseAuth.instance.currentUser!.updateDisplayName(userName);
      //   _signController.setUserData(credential!.user);
      //   return credential;
      // } on FirebaseAuthException catch (e) {
      //   if (e.code == 'weak-password') {
      //     print('The password provided is too weak.');
      //   } else if (e.code == 'email-already-in-use') {
      //     Navigator.of(context).pop();
      //     showDialog(
      //         context: context,
      //         builder: (context) {
      //           return AlertDialog(
      //             shape: RoundedRectangleBorder(
      //               borderRadius: BorderRadius.circular(20),
      //             ),
      //             content: const Text(
      //               '  هذا البريد الإكترونى موجود . يمكنك تسجيل الدخول مباشرة',
      //               textDirection: TextDirection.rtl,
      //             ),
      //           );
      //         });
      //   }
      //   return null;
      // } catch (e) {
      //   print(e);
      //   return null;
      // }
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
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    children: const <Widget>[
                      Expanded(child: Divider()),
                      Text("أو"),
                      Expanded(child: Divider()),
                    ],
                  ),
                  SizedBox(
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
                        SizedBox(height: 20),
                        // password
                        CustomSignInputField(
                          isPassword:true,
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
                          isPassword:true,
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
