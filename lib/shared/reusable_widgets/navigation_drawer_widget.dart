import 'package:find_your_phone/control/admin_controller.dart';
import 'package:find_your_phone/control/firebase_controller.dart';
import 'package:find_your_phone/control/sign_controller.dart';
import 'package:find_your_phone/shared/colors.dart';
import 'package:find_your_phone/view/admin_screens/admins_screen.dart';
import 'package:find_your_phone/view/how_to_use_our_app_screen.dart';
import 'package:find_your_phone/view/profile.dart';
import 'package:find_your_phone/view/support_us_screen.dart';
import 'package:find_your_phone/view/admin_screens/verify_phones_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../control/app_controller.dart';
import '../../view/contact_us_screen.dart';
import '../../view/found_phones_screen.dart';
import '../../view/law_screen.dart';
import '../../view/lost_phones_screen.dart';
import '../../view/setting_screen.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

class CustomNavigationDrawerWidget extends StatelessWidget {
  CustomNavigationDrawerWidget({Key? key}) : super(key: key);

  final AppController _appController = Get.find<AppController>();
  final SignController _signController = Get.find<SignController>();
  final FirebaseController _firebaseController = Get.find<FirebaseController>();
  final AdminController _adminController = Get.find<AdminController>();
  @override
  Widget build(BuildContext context) {
    // String? userName = '';
    final String name = _signController.userData.displayName ?? 'مستخدم';

    final String email = (_signController.userData.email != null &&
            _signController.userData.email != "")
        ? _signController.userData.email
        : _signController.userData.providerData[0].email;
    String? imageURL;
    // try {
    //   // if this call fail it means we access with google account
    //   _signController.userData.providerData[0].providerId ;
    //   imageURL = null;
    // } catch(e){
    //   imageURL = _signController.userData.photoUrl;
    // }

    // that means we access with google account
    if (_signController.userData.email == null ||
        _signController.userData.email.trim() == "") {
      imageURL = _signController.userData.providerData[0].photoURL;
    }
    return Drawer(
      // material do a good effect when you press in the listTile
      child: Material(
        color: Colors.indigo[300],
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 20),
          children: <Widget>[
            SizedBox(height: 50),
            buildHeader(
                name: name,
                email: email,
                imageURL: imageURL,
                context: context,
                onClicked: () {
                  _appController.changeDrawerIndex(-1);
                }),
            SizedBox(height: 16),
            buildMenuItem(
              context,
              text: 'هواتف مفقودة',
              icon: Icons.phone_android_rounded,
              onClicked: () {
                // _appController.changeButton(BottomBarButtons.Home);
                _appController.changeDrawerIndex(0);
                Get.off(LostPhonesScreen());
              },
              index: 0,
            ),
            SizedBox(
              height: 16,
            ),
            buildMenuItem(
              context,
              text: 'هاتف من ؟',
              icon: Icons.edgesensor_high,
              onClicked: () {
                _appController.changeDrawerIndex(1);
                Get.off(() => FoundPhonesScreen());
              },
              index: 1,
            ),
            if (_adminController.isAdmin)
              Column(
                children: [
                  const SizedBox(
                    height: 16,
                  ),
                  buildMenuItem(context,
                      text: 'قبول الدفع',
                      icon: Icons.balance_outlined, onClicked: () {
                    _appController.changeDrawerIndex(2);
                    Get.to(() => VerifyPhonesScreen());
                  }, index: 2),
                  const SizedBox(
                    height: 16,
                  ),
                  buildMenuItem(context,
                      text: 'المشرفون',
                      icon: Icons.admin_panel_settings, onClicked: () {
                    _appController.changeDrawerIndex(3);
                    Get.off(() => AdminsScreen());
                    // Get.offAll(()=>Admin);
                  }, index: 3),
                ],
              ),
            const SizedBox(
              height: 16,
            ),
            buildMenuItem(
              context,
              text: 'إجراءات قانونية',
              icon: Icons.balance_outlined,
              onClicked: () {
                // _appController.changeDrawerIndex(3);
                Get.to(() => LawScreen());
              },
              index: 4,
            ),
            SizedBox(
              height: 16,
            ),
            buildMenuItem(
              context,
              text: 'إعدادات',
              icon: Icons.settings,
              onClicked: () {
                _appController.changeDrawerIndex(5);
                Get.off(() => SettingsScreen());
              },
              index: 5,
            ),
            SizedBox(
              height: 16,
            ),
            if (!_adminController.isAdmin)
              Column(
                children: [
                  Divider(color: Colors.white70),
                  buildMenuItem(
                    context,
                    text: 'كيفية استخدام التطبيق',
                    icon: Icons.question_mark_outlined,
                    onClicked: () {
                      // _appController.changeDrawerIndex(4);
                      Get.to(() => HowToUseOurAppScreen());
                    },
                    index: 6,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  buildMenuItem(
                    context,
                    text: 'إدعمنا',
                    icon: Icons.monetization_on_rounded,
                    onClicked: () {
                      // _appController.changeDrawerIndex(5);
                      Get.to(() => SupportUsScreen());
                    },
                    index: 7,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  buildMenuItem(
                    context,
                    text: 'تواصل معنا',
                    icon: Icons.monetization_on_rounded,
                    onClicked: () {
                      // _appController.changeDrawerIndex(5);
                      Get.to(() => ContactUsScreen());
                    },
                    index: 8,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  // the item of Drawer menu
  Widget buildMenuItem(BuildContext context,
      {required String text,
      required IconData icon,
      required VoidCallback onClicked,
      required int index}) {
    const color = Colors.white;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: (index == _appController.drawerIndex)
            ? selectedItemColor
            : Colors.transparent,
      ),
      child: ListTile(
        hoverColor: Colors.white70,
        contentPadding: EdgeInsets.all(10),
        leading: Icon(
          icon,
          color: color,
        ),
        title: Text(
          text,
          style: Theme.of(context).textTheme.headline6!.copyWith(color: color),
        ),
        onTap: () {
          // to close the drawer after navigate to another page
          Navigator.of(context).pop();
          onClicked();
        },
      ),
    );
  }

// the header that has the email and name and a circle with a letter
  Widget buildHeader({
    required String name,
    required String email,
    required String? imageURL,
    required BuildContext context,
    required VoidCallback onClicked,
  }) {
    return InkWell(
      onTap: () {
        Get.to(
            () => UserProfileScreen(name: name, email: email, image: imageURL));
      },
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '$name',
                    style: Theme.of(context)
                        .textTheme
                        .headline6!
                        .copyWith(color: Colors.white),
                  ),
                  SizedBox(height: 5),
                  Text(
                    '$email',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2!
                        .copyWith(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.indigo[50],
                ),
                child: imageURL == null
                    ? noUserImage()
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(1000),
                        child: Image.network(
                          imageURL,
                          fit: BoxFit.fill,
                          errorBuilder: (BuildContext context, Object exception,
                              StackTrace? stackTrace) {
                            return noUserImage();
                          },
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // this function will be used when the user sign in with email and password
  // or there is no internet to upload user image
  Center noUserImage() {
    return Center(
        child: Icon(
      Icons.account_circle_rounded,
      size: 75,
      color: defaultColor,
    ));
  }
}
