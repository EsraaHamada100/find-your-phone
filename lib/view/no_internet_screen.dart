import 'package:find_your_phone/control/app_controller.dart';
import 'package:find_your_phone/shared/colors.dart';
import 'package:find_your_phone/shared/reusable_widgets/custom_button.dart';
import 'package:find_your_phone/view/lost_phones_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class NoInternetScreen extends StatelessWidget {
  NoInternetScreen({Key? key}) : super(key: key);
  final AppController _appController = Get.find<AppController>();
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              SvgPicture.asset(
                'assets/images/no_internet_page_image.svg',
                height: MediaQuery.of(context).size.height * 0.7,
                // color: Colors.red,
                // semanticsLabel: 'A red up arrow'
              ),
              Text('حدث خطأ ما يمكنك إعادة المحاولة', style: Theme.of(context).textTheme.headline5!.copyWith(color: buttonColor, fontWeight: FontWeight.bold,),),
              SizedBox(height: 20,),
              CustomButton(
                text: 'أعد المحاولة',
                onPressed: () async {
                  bool result =
                      await _appController.checkInternetConnection(context);
                  if(result){
                    Get.off(()=> LostPhonesScreen());
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
