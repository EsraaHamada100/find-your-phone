import 'package:find_your_phone/control/add_phone_controller.dart';
import 'package:find_your_phone/control/admin_controller.dart';
import 'package:find_your_phone/control/controller.dart';
import 'package:find_your_phone/control/firebase_controller.dart';
import 'package:find_your_phone/control/sign_controller.dart';
import 'package:find_your_phone/shared/cache/cache_helper.dart';
import 'package:find_your_phone/shared/cache/get_storage.dart';
import 'package:find_your_phone/shared/colors.dart';
import 'package:find_your_phone/view/lost_phones_screen.dart';
import 'package:find_your_phone/view/signin_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:find_your_phone/control/init_controllers.dart' as controllers;
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

bool isLogin = false;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await controllers.init();
  await CacheHelper.init();
  // await GetStorage.init('user');
  await Firebase.initializeApp();
  FirebaseController firebaseController = Get.find<FirebaseController>();
  AdminController adminController = Get.find<AdminController>();
  SignController signController = Get.find<SignController>();
  // GetStorage box = GetStorage('user');
  var user = FirebaseAuth.instance.currentUser;
  if(user != null){
    isLogin = true;
    print('we are in email and password sign in ');
    print(user);
    print('end of user data');
    /// check if the user is the admin of the app

    /// set user data to access it through the app
    if(user.emailVerified){
      signController.setUserData(user, user.uid);
    }else {
      signController.setUserData(user, user.uid);
    }

    // print('in get storage we have :');
    // print(box.read('user_data'));
    // print(box.read('user_id'));
    // firebaseController.getLostPhonesDocuments();
    // firebaseController.getFoundPhonesDocuments();
    firebaseController.getPhonesDocuments();
    bool done = await adminController.getAdminDocument();
    print('done $done');
    if(done){
      adminController.checkAdmin(user.uid);
    }

  }else {
    isLogin = false;
  }
  // if (user == null) {
  //   await GoogleSignIn().isSignedIn().then((value) {
  //     if (value) {
  //       isLogin = true;
  //       print('you have signed in with google');
  //
  //       signController.setUserData(
  //         signController.googleSignIn.currentUser,
  //         signController.googleSignIn.currentUser?.id,
  //       );
  //       print('Your id is ${signController.userId}');
  //       print('Your data is ${signController.userData}');
  //
  //       adminController.checkAdmin(signController.googleSignIn.currentUser!.id);
  //       print(signController.userData);
  //       // firebaseController.getLostPhonesDocuments();
  //       // firebaseController.getFoundPhonesDocuments();
  //       firebaseController.getPhonesDocuments();
  //     } else {
  //       isLogin = false;
  //     }
  //   });
  // } else {
  //   isLogin = true;
  //   print('we are in email and password sign in ');
  //   print(user);
  //   print('end of user data');
  //   /// check if the user is the admin of the app
  //   adminController.checkAdmin(user.uid);
  //   /// set user data to access it through the app
  //   if(user.emailVerified){
  //     signController.setUserData(user, user.uid);
  //   }else {
  //     signController.setUserData(user, user.uid);
  //   }
  //
  //   // print('in get storage we have :');
  //   // print(box.read('user_data'));
  //   // print(box.read('user_id'));
  //   // firebaseController.getLostPhonesDocuments();
  //   // firebaseController.getFoundPhonesDocuments();
  //   firebaseController.getPhonesDocuments();
  // }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  // This widget is the root of your application.
  AppController _controller = Get.find<AppController>();
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppController>(
      // I do that to prevent SignController from deleted automatically
      builder: (builder) => GetBuilder<SignController>(builder: (context) {
        return GetBuilder<AddPhoneController>(builder: (context) {
          return GetBuilder<AdminController>(builder: (context) {
            return GetMaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Flutter Demo',

              theme: ThemeData(
                // fontFamily: 'DroidKufi',
                // primaryColor: Color(0xe3ede4ff),
                appBarTheme: AppBarTheme(
                  color: defaultColor,
                  systemOverlayStyle: SystemUiOverlayStyle(
                    statusBarColor: Colors.indigo[100],
                    statusBarIconBrightness: Brightness.dark,
                  ),
                  actionsIconTheme: IconThemeData(color: Colors.black),
                ),
                drawerTheme: DrawerThemeData(),

                iconTheme: IconThemeData(color: Colors.black),
                floatingActionButtonTheme: FloatingActionButtonThemeData(
                  backgroundColor: defaultColor,
                ),
                scaffoldBackgroundColor: Colors.indigo[50],

                textTheme: const TextTheme(
                  button: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      color: Colors.black54),
                  bodyText1: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              darkTheme: ThemeData(
                // scaffoldBackgroundColor: Colors.black12,
                // we make the primary color for the whole application is deepOrange
                primarySwatch: Colors.deepOrange,
                appBarTheme: const AppBarTheme(
                  // it's responsible for the bar above The AppBar which has battery/wifi/etc
                  systemOverlayStyle: SystemUiOverlayStyle(
                    statusBarColor: Colors.indigo,
                    statusBarIconBrightness: Brightness.light,
                  ),
                  backgroundColor: Colors.black12,
                  elevation: 0,
                  titleTextStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                  iconTheme: IconThemeData(color: Colors.white),
                ),
                bottomNavigationBarTheme: const BottomNavigationBarThemeData(
                  unselectedItemColor: Colors.grey,
                  type: BottomNavigationBarType.fixed,
                ),
                textTheme: const TextTheme(
                  bodyText2: TextStyle(
                    color: Colors.white70,
                  ),
                  bodyText1: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                      color: Colors.white),
                ),
                brightness: Brightness.dark,
              ),
              themeMode: _controller.isDark ? ThemeMode.dark : ThemeMode.light,
              // Color(0xff063970)
              home: isLogin ? LostPhonesScreen() : SignInScreen(),
            );
          });
        });
      }),
    );
  }
}
