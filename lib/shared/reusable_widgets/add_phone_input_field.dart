import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';

class AddPhoneInputField extends StatelessWidget {
  AddPhoneInputField({
    Key? key,
    required this.title,
    required this.hint,
    this.onSaved,
    this.validator,
    this.controller,
    this.arabicText = false,
    this.keyboardType,
  }) : super(key: key);
  final String title;
  final String hint;
  final TextEditingController? controller;
  final Function(String?)? onSaved;
  final String? Function(String?)? validator;
  final bool arabicText;
  final TextInputType? keyboardType;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 15, bottom: 7),
            child: Text(
              title,
              style: Theme.of(context).textTheme.headline6!.copyWith(
                    color: Colors.black54,
                  ),
            ),
          ),
          Container(
            // padding: const EdgeInsets.symmetric(vertical: 4),
            // margin: const EdgeInsets.only(left: 14),
            // width: double.maxFinite,
            // height: 52,
            // decoration: BoxDecoration(
            //   borderRadius: BorderRadius.circular(12),
            //   border: Border.all(color: Colors.grey),
            // ),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    onSaved: onSaved,
                    validator: validator,
                    controller: controller,
                    autofocus: false,
                    keyboardType: keyboardType,
                    cursorColor:
                        Get.isDarkMode ? Colors.grey[100] : Colors.grey[600],
                    // readOnly: widget != null ? true : false,
                    style: Theme.of(context).textTheme.bodyText1,textDirection: arabicText? TextDirection.rtl : TextDirection.ltr,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 17, horizontal: 10),
                      hintText: hint,
                      hintStyle: Theme.of(context)
                          .textTheme
                          .bodyText2!
                          .copyWith(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(width: 1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                // if the widget is null we will just send an empty container
                // widget ?? Container(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}