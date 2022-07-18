import 'package:find_your_phone/control/controller.dart';
import 'package:find_your_phone/shared/colors.dart';
import 'package:find_your_phone/shared/reusable_widgets/app_bar.dart';
import 'package:find_your_phone/shared/reusable_widgets/navigation_drawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../shared/reusable_widgets/add_phone_input_field.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({Key? key}) : super(key: key);

  AppController _controller = Get.find<AppController>();
  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              CustomAppBar(appBarTitle: 'الإعدادات'),
            ],
            body: SafeArea(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: GetBuilder<AppController>(
                  builder: (_) {
                    return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'اللغة  ( language )',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 20,
                                    ),
                                    textAlign: TextAlign.start,
                                  ),
                                  SizedBox(height: 20),
                                  Container(

                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: Colors.white,
                                    ),
                                    padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                    child: DropdownButton(
                                      isExpanded: true,
                                      hint: Text(
                                            _controller.selectedLanguage,
                                            style: TextStyle(fontSize: 16),
                                          ),
                                      icon: Icon(
                                        Icons.keyboard_arrow_down,
                                        color: Colors.grey,
                                      ),
                                      iconSize: 32,
                                      elevation: 4,
                                      style: Theme.of(context).textTheme.bodyText2,
                                      underline: Container(
                                        height: 0,
                                      ),
                                      // we write DropDownMenuItem<String> because it will show the numbers as a string in the menu
                                      items: _controller.languageList
                                          .map<DropdownMenuItem<String>>(
                                            (String value) => DropdownMenuItem<String>(
                                              value: value.toString(),
                                              child: Text(
                                                value,
                                                textAlign: TextAlign.end,
                                              ),
                                            ),
                                          )
                                          .toList(),
                                      onChanged: (String? newValue) {
                                        if (newValue != null) {
                                          _controller.changeLanguage(newValue);
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                          SizedBox(height: 20,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                             const Text(
                                'الثيمات',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 20,
                                ),
                                textAlign: TextAlign.start,
                              ),
                              const SizedBox(height: 20),
                              Container(

                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.white,
                                ),
                                padding :EdgeInsets.all(10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('الوضع الداكن'),
                                    Switch(
                                      activeColor: defaultColor,
                                        value: _controller.isDark, onChanged: (_){
                                      _controller.changeMode();
                                    })
                                  ],
                                ),
                              ),
                            ],
                          ),

                        ],
                      );
                  }
                ),

              ),
            ),
          ),
          drawer: CustomNavigationDrawerWidget(),
        ),);
  }
}
