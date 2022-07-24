// ignore_for_file: use_build_context_synchronously

import 'package:find_your_phone/control/admin_controller.dart';
import 'package:find_your_phone/shared/enums.dart';
import 'package:find_your_phone/view/signin_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../shared/reusable_widgets/components.dart';
import '../view/lost_phones_screen.dart';
import 'firebase_controller.dart';

class SignController extends GetxController {
  final FirebaseController _firebaseController = Get.find<FirebaseController>();
  final AdminController _adminController = Get.find<AdminController>();
  // get user data;
  late var _userData;
  late String _userId;
  setUserData(userData, userId) {
    _userData = userData;
    _userId = userId;
  }

  get userData => _userData;
  String get userId => _userId;
  GoogleSignIn googleSignIn = GoogleSignIn();

  /// google sign in
  signInWithGoogle() async {
    try {
      final googleUser = await googleSignIn.signIn();
      if (googleUser != null) {
        final googleAuth = await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        final userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);

        _userData = userCredential.user;
        _userId = userCredential.user!.uid;

        /// get the data from firebase
        if (_firebaseController.phonesDocuments.isEmpty) {

         await _firebaseController.getPhonesDocuments();
         await _adminController.getAdminDocument();

          /// check if the user is admin or not
          debugPrint(
              'is admin in google login screen : ${_adminController.isAdmin}');
        }
        _adminController.checkAdmin(_userId);
        debugPrint('is admin = ${_adminController.isAdmin}');
        Get.offAll(() => LostPhonesScreen());
      }
    } catch (e) {
      print(e);
    }
  }

  // Sign out with google
  signOut() async {
    googleSignIn.isSignedIn().then((value) async {
      if (value) {
        await googleSignIn.signOut();
      }
      await FirebaseAuth.instance.signOut();
    });
    _adminController.setIsAdmin(false);
  }

  // sign up with email and password
  Future<void> signUpWithEmailAndPassword(
    BuildContext context, {
    required String userName,
    required String email,
    required String password,
  }) async {
    UserCredential? credential;
    final FirebaseAuth _auth = FirebaseAuth.instance;
    try {
      credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      print('user credential : ');
      print(credential);
      print('user name : ');
      User user = FirebaseAuth.instance.currentUser!;
      await user.updateDisplayName(userName);
      await user.sendEmailVerification().then((_) {
        Navigator.of(context).pop();
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                actions: [
                  OutlinedButton(
                    onPressed: () => Get.offAll(SignInScreen()),
                    child: const Text('موافق'),
                  ),
                ],
                actionsAlignment: MainAxisAlignment.center,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                content: const Text(
                  'لقد قمنا بإرسال إيميل تأكيد لك . قم بالضغط عليه ثم سجل الدخول',
                  textDirection: TextDirection.rtl,
                ),
              );
            });
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        Navigator.of(context).pop();
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                content: const Text(
                  '  هذا البريد الإكترونى موجود . يمكنك تسجيل الدخول مباشرة',
                  textDirection: TextDirection.rtl,
                ),
              );
            });
      }
    } catch (e) {
      print(e);
    }
  }

  // sign in with email and password
  Future<UserCredential?> signInWithEmailAndPassword(
    BuildContext context, {
    required String email,
    required String password,
  }) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      print('user name');
      print(credential.user!.displayName);
      if (credential.user!.emailVerified) {
        _userData = credential.user;
        _userId = credential.user!.uid;

        if (_firebaseController.phonesDocuments.isEmpty) {
          _firebaseController.getPhonesDocuments();
          _adminController.getAdminDocument();
        }
        _adminController.checkAdmin(_userId);
        Get.offAll(() => LostPhonesScreen());
      } else {
        signOut();
        Get.back();
        // a dialog that asks a user if he wanted to send a verification
        // email when his email is not verified
        sendVerificationEmailDialog(context, () async {
          await credential.user!.sendEmailVerification().then((_) {
            Get.back();
          });
        });
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Navigator.of(context).pop();
        print('No user found for that email.');
        showToast(context, 'لم يتم العثور على مستخدم لهذا البريد الإلكتروني', ToastStates.error);
      } else if (e.code == 'wrong-password') {
        Navigator.of(context).pop();
        print('Wrong password provided for that user.');
        showToast(context, 'كلمة المرور خاطئة', ToastStates.error);
      }
    }
    return null;
  }

  // password visibility
  bool _isVisible = false;
  bool get isVisible => _isVisible;
  changeVisibility() {
    _isVisible = !_isVisible;
    update();
  }

  // forgot password
  forgotPassword(BuildContext context, {required userEmail}) async {
    UserCredential? credential;
    final FirebaseAuth auth = FirebaseAuth.instance;
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: userEmail,
        password: '1',
      );
    } on FirebaseAuthException catch (e) {
      print(e.code);
      if (e.code == 'user-not-found') {
        Navigator.of(context).pop();
        print('No user found for that email.');
        customNoActionAlertDialog(
          context: context,
          content: 'لم يتم العثور على مستخدم لهذا البريد الإلكتروني',
        );
      } else if (e.code == 'wrong-password') {
        print(e.code);
        Navigator.of(context).pop();
        print('Wrong password provided for that user.');
        await auth.sendPasswordResetEmail(email: userEmail).then((value) {
          customNoActionAlertDialog(
            context: context,
            content: 'لقد قمنا بإرسال ايميل لك . اضغط عليه لتغيير كلمة المرور',
          );
        });
      } else {
        Navigator.of(context).pop();
        customNoActionAlertDialog(
            context: context, content: defaultErrorMessage);
      }
    }
  }
}
