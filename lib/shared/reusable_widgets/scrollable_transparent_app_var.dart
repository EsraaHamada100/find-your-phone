import 'package:find_your_phone/shared/colors.dart';
import 'package:flutter/material.dart';

class CustomScrollableTransparentAppBar extends StatelessWidget {
  const CustomScrollableTransparentAppBar({Key? key, required this.appBarTitle, this.backgroundColor, this.foregroundColor})
      : super(key: key);

  final String appBarTitle;
  final Color? backgroundColor;
  final Color? foregroundColor;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      centerTitle: true,
      backgroundColor: backgroundColor ?? secondaryColor,
      elevation: 0,
      title: Text(
        appBarTitle,
      ),
      foregroundColor: foregroundColor??Colors.black,
    );
  }
}
