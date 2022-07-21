// import 'package:flutter/material.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
//
// class CustomInputField extends StatelessWidget {
//   const CustomInputField(
//       {Key? key,
//         required this.title,
//         required this.hint,
//         this.controller,
//         this.widget})
//       : super(key: key);
//   final String title;
//   final String hint;
//   final TextEditingController? controller;
//   final Widget? widget;
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.only(top: 16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: EdgeInsets.only(left: 15,bottom: 7),
//             child: Text(
//               title,
//               style: Theme.of(context).textTheme.bodyText1,
//             ),
//           ),
//           Container(
//             padding: const EdgeInsets.only(top: 8),
//             margin: const EdgeInsets.only(left: 14),
//             width: double.maxFinite,
//             height: 52,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(12),
//               border: Border.all(color: Colors.grey),),
//             child: Row(
//               children: [
//                 Expanded(
//                     child: TextFormField(
//                       controller: controller,
//                       autofocus: false,
//                       cursorColor: Get.isDarkMode? Colors.grey[100]:Colors.grey[600],
//                       readOnly: widget!= null ?true : false,
//                       style: Theme.of(context).textTheme.bodyText2,
//                       decoration: InputDecoration(
//                         contentPadding: const EdgeInsets.only(left: 10, bottom: 20),
//                         hintText: hint,
//                         hintStyle: Theme.of(context).textTheme.bodyText2,
//                         enabledBorder: UnderlineInputBorder(
//                           borderSide: BorderSide(
//                             color: context.theme.backgroundColor,
//                             width: 0,
//                           ),
//                         ),
//                         focusedBorder:UnderlineInputBorder(
//                           borderSide: BorderSide(
//                             color: context.theme.backgroundColor,
//                             width: 0,
//                           ),
//                         ),
//                       ),
//                     )),
//                 // if the widget is null we will just send an empty container
//                 widget ?? Container(),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:find_your_phone/control/sign_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomSignInputField extends StatelessWidget {
  CustomSignInputField({
    Key? key,
    this.controller,
    this.onSaved,
    this.obscureText = false,
    required this.validator,
    required this.icon,
    required this.hint,
    this.isPassword,
    this.keyboardType,
    this.minLines,
  }) : super(key: key);
  final TextEditingController? controller;
  final void Function(String?)? onSaved;
  final String? Function(String?)? validator;
  final IconData? icon;
  final String hint;
  bool? isPassword;
  TextInputType? keyboardType;
  int? minLines;
  bool obscureText;
  final SignController _signController = Get.find<SignController>();
  @override
  Widget build(BuildContext context) {
    return GetBuilder<SignController>(builder: (_) {
      return TextFormField(
        controller: controller,
        onSaved: onSaved,
        validator: validator,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          prefixIcon: Icon(
            icon,
          ),
          suffixIcon: isPassword != null && isPassword!
              ? IconButton(
                  onPressed: () => _signController.changeVisibility(),
                  icon: Icon(_signController.isVisible
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined))
              : null,
          hintText: hint,
          border: const OutlineInputBorder(
            borderSide: BorderSide(width: 1),
          ),
        ),
        minLines: minLines,
        maxLines: minLines ?? 1,
        obscureText:
            (isPassword != null && isPassword! && !_signController.isVisible)
                ? true
                : obscureText,
      );
    });
  }
}
