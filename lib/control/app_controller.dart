import 'dart:io';

import 'package:find_your_phone/shared/cache/cache_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../shared/enums.dart';
import '../shared/reusable_widgets/components.dart';

class AppController extends GetxController {

  int _drawerIndex = 0;
  int get drawerIndex => _drawerIndex;

  changeDrawerIndex(int index) {
    _drawerIndex = index;
    update();
  }

  /// change language
  final languageList = ['العربية'];
  String selectedLanguage = 'العربية';
  void changeLanguage(String newLanguage) {
    selectedLanguage = newLanguage;
    update();
  }

  /// change mode
  bool _isDark = CacheHelper.getMode(key: 'isDark')!;
  bool get isDark => _isDark;
  void changeMode() {
    _isDark = !_isDark;
    CacheHelper.setMode(
        key: 'isDark', value: _isDark);
    update();
  }

  /// change the shape of  floating button when you open
  /// it in add admin page
  bool _addAdminFloatingButton = true;

  get addAdminFloatingButton => _addAdminFloatingButton;
  changeAddAdminFloatingButton(){
    _addAdminFloatingButton = ! _addAdminFloatingButton;
    update();
  }
  // to check if the user is connected or not when
  // perform firebase changing
  Future<bool> checkInternetConnection(BuildContext context) async {
    try {
      await InternetAddress.lookup('example.com');
    } on SocketException catch (_) {
      showToast(
        context,
        'لا يوجد إتصال بالإنترنت',
        ToastStates.error,
      );
      return false;
    }
    showLoading(context);
    return true;
  }

  bool circularAvatarError = false;
  setCircularAvatarError(bool value){
    circularAvatarError = value;
    update();
  }
}
