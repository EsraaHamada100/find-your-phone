import 'package:find_your_phone/control/add_phone_controller.dart';
import 'package:find_your_phone/control/admin_controller.dart';
import 'package:find_your_phone/control/controller.dart';
import 'package:find_your_phone/control/sign_controller.dart';
import 'package:get/get.dart';

import 'firebase_controller.dart';

Future<void> init() async{
  Get.lazyPut(()=>AppController());
  Get.lazyPut(() => SignController());
  Get.lazyPut(() => FirebaseController());
  Get.lazyPut(() => AddPhoneController());
  Get.lazyPut(() => AdminController());
}