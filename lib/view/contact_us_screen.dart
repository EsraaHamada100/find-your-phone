import 'package:find_your_phone/control/admin_controller.dart';
import 'package:find_your_phone/shared/reusable_widgets/custom_button.dart';

import 'package:find_your_phone/shared/reusable_widgets/scrollable_transparent_app_var.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../control/app_controller.dart';


class ContactUsScreen extends StatelessWidget {
  ContactUsScreen({Key? key}) : super(key: key);
  // ScrollController _scrollController =
  //     ScrollController(initialScrollOffset: 1.0);
  final AdminController _adminController = Get.find<AdminController>();
  AppController _appController = Get.find<AppController>();
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            _appController.isDark == true
            ?
            CustomScrollableTransparentAppBar(appBarTitle: 'تواصل معنا',
            backgroundColor: Colors.black26,)
                : CustomScrollableTransparentAppBar(appBarTitle: 'تواصل معنا',
              backgroundColor:Colors.indigo[50],)
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
                  const SizedBox(
                    height: 40,
                  ),
                  Container(
                    width: double.maxFinite,
                    height: 60,
                    child: CustomButton(
                      text: 'البريد الإلكترونى للتواصل',
                      onPressed: () async {
                        String url =
                            'mailto:to'
                            '${_adminController.adminDocument!.connectEmail}';
                        try {
                          await launchUrl(Uri.parse(url));
                        } catch (e) {
                          print(e);
                        }
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

  SvgPicture svgIcon = SvgPicture.asset(
    'assets/images/contact_us_image.svg',
  );
}
