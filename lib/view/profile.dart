import 'package:find_your_phone/control/sign_controller.dart';
import 'package:find_your_phone/view/my_phones_screen.dart';
import 'package:find_your_phone/view/signin_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../control/app_controller.dart';
import '../shared/colors.dart';
import '../shared/reusable_widgets/components.dart';

class UserProfileScreen extends StatelessWidget {
  UserProfileScreen(
      {Key? key, required this.name, required this.email, required this.image})
      : super(key: key);
  final String name;
  final String email;
  final String? image;
  final SignController _signController = Get.find<SignController>();
 final  AppController _appController = Get.find<AppController>();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'الملف الشخصى',
            style: TextStyle( color:_appController.isDark?  Colors.grey[300] : Colors.black,),
          ),
          centerTitle: true,
          backgroundColor: _appController.isDark? Colors.black54 : secondaryColor,
          elevation: 0,
          iconTheme: IconThemeData(color: _appController.isDark?  Colors.grey[300] : Colors.black,),
        ),
        body: Container(
          color:  _appController.isDark? Colors.black26: secondaryColor,
          padding: EdgeInsets.all(20),
          width: double.maxFinite,
          height: double.maxFinite,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              image != null
                  ? CircleAvatar(
                      radius: 75,
                      backgroundImage: NetworkImage(
                        image!,
                      ),
                    )
                  : // Center(
                  Icon(
                      Icons.account_circle_rounded,
                      size: 120,
                      color: defaultColor,
                    ),
              Text(
                '$name',
                style: Theme.of(context).textTheme.headline6,
              ),
              const SizedBox(height: 10),
              Text(
                '$email',
                style: Theme.of(context).textTheme.bodyText2!,
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 40,
              ),
              buildCard(
                context: context,
                text: 'منشوراتي',
                icon: Icons.arrow_forward_ios,
                onTap: () {
                  Get.to(()=>MyPhones());
                },
              ),
              SizedBox(
                height: 15,
              ),
              buildCard(
                  context: context,
                  text: 'تسجيل الخروج',
                  icon: Icons.logout,
                  onTap: () {
                    customAlertDialog(
                      context,
                      title: 'تسجيل الخروج',
                      content: 'هل تريد تسجيل الخروج ؟',
                      confirmFunction: () {
                        _signController.signOut();
                        Get.offAll(() => SignInScreen());
                      },
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }

  GestureDetector buildCard(
      {required BuildContext context,
      required String text,
      required IconData icon,
      required void Function()? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 1,
        color:_appController.isDark? Colors.black54 : secondaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                text,
                style: Theme.of(context).textTheme.headline5,



              ),
              Icon(icon),
            ],
          ),
        ),
      ),
    );
  }
  //
  // void confirmSignOut(BuildContext context) {
  //   showDialog(
  //       context: context,
  //       builder: (BuildContext ctx) {
  //         return Directionality(
  //           textDirection: TextDirection.rtl,
  //           child: AlertDialog(
  //             title: const Text('تسجيل الخروج'),
  //             content: const Text('هل تريد تسجيل الخروج ؟'),
  //             actionsAlignment: MainAxisAlignment.spaceAround,
  //             actions: [
  //               // The "Yes" button
  //               TextButton(
  //                   onPressed: () {
  //                     _signController.signOut();
  //                     Get.offAll(() => SignInScreen());
  //                   },
  //                   child: const Text('نعم')),
  //               TextButton(
  //                   onPressed: () {
  //                     // Close the dialog
  //                     Navigator.of(context).pop();
  //                   },
  //                   child: const Text('لا')),
  //             ],
  //           ),
  //         );
  //       });
  // }
}
