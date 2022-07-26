import 'package:find_your_phone/shared/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../control/app_controller.dart';

class CustomScrollableTransparentAppBar extends StatelessWidget {
  const CustomScrollableTransparentAppBar({Key? key, required this.appBarTitle, this.backgroundColor, this.foregroundColor})
      : super(key: key);

  final String appBarTitle;
  final Color? backgroundColor;
  final Color? foregroundColor;

  @override
  Widget build(BuildContext context) {
  final   AppController _appController = Get.find<AppController>();
    return SliverAppBar(
      centerTitle: true,
      backgroundColor: _appController.isDark == false? backgroundColor ?? secondaryColor : backgroundColor?? darkColor2,
      elevation: 0,
      title: Text(
        appBarTitle,
      ),
      foregroundColor: foregroundColor??Colors.black,
    );
  }
}
