import 'package:find_your_phone/control/admin_controller.dart';
import 'package:find_your_phone/shared/cache/cache_helper.dart';
import 'package:find_your_phone/shared/cache/get_storage.dart';
import 'package:find_your_phone/view/signin_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
// import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

import '../shared/colors.dart';
import '../shared/enums.dart';
import '../shared/reusable_widgets/components.dart';
import '../view/lost_phones_screen.dart';
import 'firebase_controller.dart';

class SignController extends GetxController {
  // BottomBarButtons _tappedButton = BottomBarButtons.Home;
  // BottomBarButtons get tappedButton => _tappedButton;
  final FirebaseController _firebaseController = Get.find<FirebaseController>();
  final AdminController _adminController = Get.find<AdminController>();
  // GetStorage box = GetStorage('user');
  @override
  onReady() {
    super.onReady();
    print("The Sign controller is ready");
  }

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
  // sign in with google
  // signInWithGoogle() async {
  //   try {
  //     await googleSignIn.signIn().then((value){
  //       _userData = value;
  //       _userId = value!.id;
  //       _adminController.checkAdmin(_userId);
  //
  //       Get.offAll(() => LostPhonesScreen());
  //     });
  //   } on Exception catch (e) {
  //     print(e);
  //   }

  //   if (_firebaseController.phonesDocuments.isEmpty) {
  //     // _firebaseController.getLostPhonesDocuments();
  //     // _firebaseController.getFoundPhonesDocuments();
  //     _firebaseController.getPhonesDocuments();
  //   }
  // }

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
          _firebaseController.getPhonesDocuments();
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

      // await MyGetStorage.remove(key: 'user_id');
      // await MyGetStorage.remove(key: 'user_data');
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
      showLoading(context);
      credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      print('user credential : ');
      print(credential);
      print('user name : ');
      // print(userName);
      // await credential!.user!.updateDisplayName(userName);
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
                    child: Text('موافق'),
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
      // _userData = credential.user;

      // Get.offAll(()=>LostPhones());
      // return credential;
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
      // return null;
    } catch (e) {
      print(e);
      // return null;
    }
  }

  // sign in with email and password
  Future<UserCredential?> signInWithEmailAndPassword(
    BuildContext context, {
    required String email,
    required String password,
  }) async {
    try {
      showLoading(context);
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      print('user name');
      print(credential.user!.displayName);
      if (credential.user!.emailVerified) {
        _userData = credential.user;
        _userId = credential.user!.uid;
        // box.write('user_data',  _userData);
        // box.write('user_id', _userId);
        if (_firebaseController.phonesDocuments.isEmpty) {
          // _firebaseController.getLostPhonesDocuments();
          // _firebaseController.getFoundPhonesDocuments();
          _firebaseController.getPhonesDocuments();
          _adminController.getAdminDocument();
        }
        _adminController.checkAdmin(_userId);
        Get.offAll(() => LostPhonesScreen());
      } else {
        signOut();
        Get.back();
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                actions: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                  onPressed: () async {
                                    await credential.user!
                                        .sendEmailVerification()
                                        .then((_) {
                                      Get.back();
                                    });
                                  },
                                  child: Text(
                                    ' أرسل إيميل تأكيد اخر',
                                    style: TextStyle(
                                        color: buttonColor,
                                        fontWeight: FontWeight.w400),
                                  )),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => Get.back(),
                                child: Text(
                                  'تجاهل',
                                  style: TextStyle(
                                    color: buttonColor,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
                actionsAlignment: MainAxisAlignment.spaceAround,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                content: const Text('لم يتم تأكيد هذا الإيميل',
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.center),
              );
            });
      }
      // return credential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Navigator.of(context).pop();
        print('No user found for that email.');
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                content: const Text('No user found for that email'),
              );
            });
      } else if (e.code == 'wrong-password') {
        Navigator.of(context).pop();
        print('Wrong password provided for that user.');
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                title: Icon(Icons.warning_amber_rounded),
                content: const Text('Wrong password provided for that user.'),
              );
            });
      }
    }
    return null;
    // return null;
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
    showLoading(context);
    UserCredential? credential;
    final FirebaseAuth auth = FirebaseAuth.instance;
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: userEmail,
        password: '1',
      );

      // return credential;
    } on FirebaseAuthException catch (e) {
      print(e.code);
      if (e.code == 'user-not-found') {
        Navigator.of(context).pop();
        print('No user found for that email.');
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                content: const Text('No user found for that email'),
              );
            });
      } else {
        Navigator.of(context).pop();
        print('Wrong password provided for that user.');
        await auth.sendPasswordResetEmail(email: userEmail).then((value) {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  // contentTextStyle: TextStyle(),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  // title: Icon(Icons.warning_amber_rounded),
                  content: const Text(
                    'لقد قمنا بإرسال ايميل لك . اضغط عليه لتغيير كلمة المرور',
                    textDirection: TextDirection.rtl,
                  ),
                );
              });
        });
      }
    }
  }
}
