import 'package:find_your_phone/control/controller.dart';
import 'package:find_your_phone/shared/colors.dart';
import 'package:find_your_phone/shared/enums.dart';
import 'package:find_your_phone/shared/reusable_widgets/navigation_drawer_widget.dart';

import 'package:find_your_phone/shared/reusable_widgets/app_bar.dart';
import 'package:find_your_phone/shared/reusable_widgets/scrollable_transparent_app_var.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../shared/reusable_widgets/articles_list.dart';

class LawScreen extends StatelessWidget {
  LawScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ArticlesScreen(screen: Screens.lawScreen,);
  }

}
