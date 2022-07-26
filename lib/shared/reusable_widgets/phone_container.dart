import 'package:find_your_phone/control/app_controller.dart';
import 'package:find_your_phone/control/firebase_controller.dart';
import 'package:find_your_phone/control/sign_controller.dart';
import 'package:find_your_phone/model/phone_data.dart';
import 'package:find_your_phone/shared/colors.dart';
import 'package:find_your_phone/shared/reusable_widgets/components.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../view/phone_details_screen.dart';

class PhoneContainer extends StatelessWidget {
  PhoneContainer(
      {required this.phoneType,
      required this.image,
      required this.IMME1,
      required this.IMME2,
      required this.phone,
      Key? key})
      : super(key: key);
  String? image;
  String phoneType;
  String IMME1;
  String? IMME2;
  PhoneData phone;
  final FirebaseController _firebaseController = Get.find<FirebaseController>();
  final AppController _appController = Get.find<AppController>();
  final SignController _signController = Get.find<SignController>();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        bool result = await _appController.checkInternetConnection(context);
        if(result) {
          Get.back();
          Get.to(
          () => PhoneDetailsScreen(
            myPhone: phone.ownerId == _signController.userId?true:false,
            phone: phone,
            docId: _firebaseController.getDocId(phone),
          ),
        );
        }
      },
      child:_appController.isDark == true
          ? Container(
        margin: EdgeInsets.only(bottom: 15),
        padding: EdgeInsets.all(10),
        width: double.maxFinite,
        height: 120,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: Colors.black12,
                // Color(0x7b3332a5),
                offset: Offset(-4, 4),
                blurRadius: 5,
                spreadRadius: 0)
          ],
          borderRadius: BorderRadius.circular(10),
          color: darkColor2,
        ),
        child: Row(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.2,
              height: 100,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: image == null
                    ? Image.asset(
                        'assets/images/no_phone.jpg',
                        fit: BoxFit.cover,
                      )
                    : Image.network(
                        image!,
                        fit: BoxFit.cover,
                        errorBuilder: (BuildContext context, Object exception,
                            StackTrace? stackTrace) {
                          return noInternetImage();
                        },
                      ),
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Expanded(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        phoneType,
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                              color: secondaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'IMME1 : $IMME1',
                        style: Theme.of(context).textTheme.bodyText2!.copyWith(
                            color: secondaryColor,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'sans'),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        IMME2 != null ? 'IMME2 : $IMME2' : '',
                        style: Theme.of(context).textTheme.bodyText2!.copyWith(
                            // color: Colors.black54,
                            color:secondaryColor,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'sans'),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      )
          : Container(
        margin: EdgeInsets.only(bottom: 15),
        padding: EdgeInsets.all(10),
        width: double.maxFinite,
        height: 120,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: Colors.black12,
                // Color(0x7b3332a5),
                offset: Offset(-4, 4),
                blurRadius: 5,
                spreadRadius: 0)
          ],
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Row(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.2,
              height: 100,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: image == null
                    ? Image.asset(
                  'assets/images/no_phone.jpg',
                  fit: BoxFit.cover,
                )
                    : Image.network(
                  image!,
                  fit: BoxFit.cover,
                  errorBuilder: (BuildContext context, Object exception,
                      StackTrace? stackTrace) {
                    return noInternetImage();
                  },
                ),
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Expanded(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        phoneType,
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'IMME1 : $IMME1',
                        style: Theme.of(context).textTheme.bodyText2!.copyWith(
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'sans'),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        IMME2 != null ? 'IMME2 : $IMME2' : '',
                        style: Theme.of(context).textTheme.bodyText2!.copyWith(
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'sans'),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      )
    );
  }
}
