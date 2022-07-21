import 'package:find_your_phone/control/admin_controller.dart';
import 'package:find_your_phone/shared/colors.dart';
import 'package:find_your_phone/shared/reusable_widgets/app_bar.dart';
import 'package:find_your_phone/shared/reusable_widgets/custom_button.dart';
import 'package:find_your_phone/shared/reusable_widgets/add_phone_input_field.dart';
import 'package:find_your_phone/shared/reusable_widgets/navigation_drawer_widget.dart';
import 'package:find_your_phone/shared/reusable_widgets/scrollable_transparent_app_var.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../shared/reusable_widgets/components.dart';
import 'lost_phones_screen.dart';

class ContactUsScreen extends StatelessWidget {
  ContactUsScreen({Key? key}) : super(key: key);
  // ScrollController _scrollController =
  //     ScrollController(initialScrollOffset: 1.0);
  final AdminController _adminController = Get.find<AdminController>();
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            CustomScrollableTransparentAppBar(appBarTitle: 'تواصل معنا'),
          ],
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(flex: 1, child: svgIcon),
                  SizedBox(
                    height: 40,
                  ),
                  Text(
                    'يمكنك التواصل معنا لتقديم إقتراح أو شكوى',
                    style: TextStyle(
                      color: Colors.indigo[300],
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  // InputField(
                  //   title: '',
                  //   hint: 'ضع المبلغ الذى تريد التبرع به بالجنيه المصرى',
                  // ),
                  SizedBox(
                    height: 40,
                  ),
                  Container(
                    width: double.maxFinite,
                    height: 60,
                    child: CustomButton(
                      text: 'البريد الإلكترونى للتواصل',
                      onPressed: () {
                      },
                    ),
                  ),
                  Spacer(),
                ],
              ),
            ),
          ),
        ),
        // drawer: CustomNavigationDrawerWidget(),
      ),
    );
  }

  // final String assetName = 'assets/images/support_us.svg';
  Widget svgIcon = SvgPicture.asset(
    'assets/images/contact_us_image.svg',
    // color: Colors.red,
    // semanticsLabel: 'A red up arrow'
  );

}
