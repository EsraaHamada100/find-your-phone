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

class SupportUsScreen extends StatelessWidget {
  SupportUsScreen({Key? key}) : super(key: key);
  ScrollController _scrollController =
      ScrollController(initialScrollOffset: 1.0);
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            CustomScrollableTransparentAppBar(appBarTitle: 'إدعمنا'),
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
                    'دعمك لنا يساعدنا فى تقديم الأفضل',
                    style: TextStyle(
                      color: Colors.indigo[300],
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
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
                      text: 'أريد التبرع',
                      onPressed: () {
                        paymentBottomSheet(
                          context,
                          () => vodafonePayment(context),
                        );
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
    'assets/images/support_us.svg',
    // color: Colors.red,
    // semanticsLabel: 'A red up arrow'
  );

  vodafonePayment(BuildContext context) {
    return showModalBottomSheet(
      // mainAxisSize: MainAxisSize.min,
      context: context,
      isScrollControlled: true, // only work on showModalBottomSheet function
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15))),
      builder: (_) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.2,
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'أرسل المبلغ الذى ترغب بالتبرع به لهذا الرقم   01154989491',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      wordSpacing: 10,
                      fontSize: 18,
                      color: Colors.grey[700]),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(buttonColor),
                          foregroundColor:
                              MaterialStateProperty.all(Colors.white),
                        ),
                        onPressed: () {
                          Get.back();
                          Get.back();
                          customNoActionDialog(
                            context,
                            title: 'شكرًا',
                            content: 'شكرًا على دعمك لنا نحن سعيدون جدًا بهذا '
                                'الدعم ونتمنى لك يومًا سعيدًا',
                          );
                          // Get.offAll(() => SupportUsScreen());
                        },
                        child: Text('تم'),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: OutlinedButton(
                        style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all(defaultColor),
                        ),
                        onPressed: () {
                          Get.back();
                          Get.back();

                        },
                        child: const Text('إلغاء'),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
