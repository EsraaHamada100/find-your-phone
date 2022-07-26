import 'package:find_your_phone/view/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../control/app_controller.dart';
import '../colors.dart';

class CustomAppBar extends StatelessWidget {
  AppController _appController = Get.find<AppController>();
  CustomAppBar({
    Key? key,
    required this.appBarTitle,
    // this.searchFunction,
    // if this variable is set that means we are in a screen
    // that has search either lost phone screen or found phone screen
    this.isLostPhonesScreen,
    this.searchable = false
  }) : super(key: key);

  final String appBarTitle;
  // final VoidCallback? searchFunction;
  final bool? isLostPhonesScreen;
  bool searchable;
  @override
  Widget build(BuildContext context) {
    return _appController.isDark == true ?
      SliverAppBar(
      centerTitle: true,
      backgroundColor: Colors.black26,
      elevation: 0,
      title: Text(
        appBarTitle,
        style: Theme.of(context)
            .textTheme
            .headline6!
            .copyWith(color: secondaryColor
        //Colors.white
          ),
      ),
      // leading: IconButton(
      //   icon: const Icon(Icons.search),
      //   onPressed: () {},
      //   color: Colors.black,
      // ),
      leading: IconButton(
        icon: Icon(
          Icons.menu_outlined,
          color:secondaryColor
          //Colors.white,
        ),
        onPressed: () => Scaffold.of(context).openDrawer(),
      ),
      actions: [
        searchable || isLostPhonesScreen != null
            ? IconButton(
                onPressed: () => Get.to(() =>
                    SearchScreen(isLostPhonesScreen: isLostPhonesScreen)),
                icon: Icon(Icons.search),
              )
            : Container(),
      ],
      // actionsIconTheme: IconThemeData(color: Colors.black),

      // titleTextStyle: TextStyle(color: Colors.white),
    ):
      SliverAppBar(
    centerTitle: true,
    backgroundColor: Colors.white,
    elevation: 0,
    title: Text(
    appBarTitle,
    style: Theme.of(context)
        .textTheme
        .headline6!
        .copyWith(color: Colors.black54),
    ),
    // leading: IconButton(
    //   icon: const Icon(Icons.search),
    //   onPressed: () {},
    //   color: Colors.black,
    // ),
    leading: IconButton(
    icon: Icon(
    Icons.menu_outlined,
    color: Colors.black,
    ),
    onPressed: () => Scaffold.of(context).openDrawer(),
    ),
    actions: [
    searchable || isLostPhonesScreen != null
    ? IconButton(
    onPressed: () => Get.to(() =>
    SearchScreen(isLostPhonesScreen: isLostPhonesScreen)),
    icon: Icon(Icons.search),
    )
        : Container(),
    ],
    // actionsIconTheme: IconThemeData(color: Colors.black),

    // titleTextStyle: TextStyle(color: Colors.white),
    );

  }
}
