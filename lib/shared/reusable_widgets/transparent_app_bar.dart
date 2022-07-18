import 'package:find_your_phone/shared/colors.dart';
// import 'package:flutter/material.dart';
// // unscrollable
// class CustomTransparentAppBar extends StatelessWidget implements PreferredSize{
//   CustomTransparentAppBar({Key? key, required this.appBarTitle, this.backgroundColor, this.foregroundColor})
//       :preferredSize = Size.fromHeight(kToolbarHeight),super(key: key);
//
//
//   @override
//   Widget build(BuildContext context) {
//     return AppBar(
//       key: _scaffoldKey,
//       centerTitle: true,
//       backgroundColor: backgroundColor ?? secondaryColor,
//       elevation: 0,
//       title: Text(
//         appBarTitle,
//       ),
//       foregroundColor: foregroundColor??Colors.black,
//     );
//   }
//
//   @override
//   final Size preferredSize; // default is 56.0
//
//   @override
//   _CustomAppBarState createState() => _CustomAppBarState()
//
//   @override
//   // TODO: implement child
//   Widget get child => throw UnimplementedError();
//
//   @override
//   // TODO: implement preferredSize
//   Size get preferredSize => throw UnimplementedError();
// }
//
// CustomAppBar({Key key}) : preferredSize = Size.fromHeight(kToolbarHeight), super(key: key);
//
// @override
// final Size preferredSize; // default is 56.0
//
// @override
// _CustomAppBarState createState() => _CustomAppBarState()


import 'package:flutter/material.dart';

class CustomTransparentAppBar extends StatefulWidget implements PreferredSizeWidget {
  CustomTransparentAppBar({ required this.appBarTitle, this.backgroundColor, this.foregroundColor, Key? key}) : preferredSize = Size.fromHeight(kToolbarHeight), super(key: key);
  final String appBarTitle;
  final Color? backgroundColor;
  final Color? foregroundColor;
  @override
  final Size preferredSize; // default is 56.0

  @override
  _CustomTransparentAppBarState createState() => _CustomTransparentAppBarState(appBarTitle, backgroundColor, foregroundColor);
}

class _CustomTransparentAppBarState extends State<CustomTransparentAppBar>{
  final String appBarTitle;
  final Color? backgroundColor;
  final Color? foregroundColor;

  _CustomTransparentAppBarState(this.appBarTitle, this.backgroundColor, this.foregroundColor);
  @override
  Widget build(BuildContext context) {
    return AppBar(
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