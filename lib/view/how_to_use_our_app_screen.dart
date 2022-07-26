import 'package:find_your_phone/control/admin_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../shared/enums.dart';
import '../shared/reusable_widgets/articles_list.dart';

class HowToUseOurAppScreen extends StatelessWidget {
  HowToUseOurAppScreen({Key? key}) : super(key: key);
  final AdminController _adminController = Get.find<AdminController>();
  @override
  Widget build(BuildContext context) {
    return ArticlesScreen(
      screen: Screens.howToUseOurAppScreen,
      articlesList: _adminController.howToUseOurApp,
    );
  }
}
