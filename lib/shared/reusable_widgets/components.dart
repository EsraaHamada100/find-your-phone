import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../colors.dart';
import '../enums.dart';
import 'custom_sign_input_field.dart';

const String defaultErrorMessage = 'حدث خطأ ما يرجى المحاوله فى وقت لاحق';
showLoading(context) {
  return showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          title: Text('please wait'),
          content: SizedBox(
            height: 50,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        );
      });
}

// email
emailField({required email}) {
  CustomSignInputField(
    isPassword: false,
    onSaved: (val) {
      email = val;
    },
    validator: (val) {
      if (val == null) {
        return "اكتب بريدك الإلكترونى";
      }
      if (val.length > 100) {
        return "اكتب بريد الكترونى صالح";
      }
      if (val.length < 2) {
        return "اكتب بريد الكترونى صالح";
      }
      return null;
    },
    icon: Icons.email_outlined,
    hint: 'البريد الإلكترونى',
  );
}

// password
passwordField({
  required TextEditingController? passwordController,
  required password,
}) {
  return CustomSignInputField(
    isPassword: true,
    controller: passwordController,
    onSaved: (val) {
      password = val;
    },
    validator: (val) {
      if (val == null) {
        return "اكتب كلمة مرور";
      }
      if (val.length > 100) {
        return "اكتب كلمة مرور اقصر. نهتم بالأمان ولكن ليس لهذه الدرجه :)";
      }
      if (val.length < 6) {
        return "كلمة المرور يجب أن تكون أكثر من 6 أحرف";
      }
      return null;
    },
    icon: Icons.password,
    hint: 'كلمة المرور',
  );
}

customAlertDialog(BuildContext context,
    {String? title,
    required String content,
    required void Function() confirmFunction}) {
  showDialog(
      context: context,
      builder: (_) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: Center(
                child: Text(
              title ?? '',
              style: TextStyle(fontWeight: FontWeight.w600),
            )),
            content: Text(
              content,
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            actionsAlignment: MainAxisAlignment.spaceAround,
            actions: [
              // The "Yes" button
              TextButton(onPressed: confirmFunction, child: Text('نعم')),
              TextButton(
                  onPressed: () {
                    // Close the dialog
                    Navigator.of(context).pop();
                  },
                  child: Text('لا')),
            ],
          ),
        );
      });
}


customThanksDialog(
  BuildContext context, {
  required String title,
  required String content,
}) {
  showDialog(
    context: context,
    builder: (_) => Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
        content: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('assets/images/thanks_image.jpg'),
              Text(
                title,
                style: Theme.of(context).textTheme.headline5,
              ),
              Text(
                content,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

customNoActionAlertDialog({
  required BuildContext context,
  required String content,
}) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: Text(
            content,
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.center,
            style: const TextStyle(height: 2),
          ),
          contentPadding: const EdgeInsets.all(20),
        );
      });
}

void showToast(BuildContext context, String content, ToastStates state) {
  final scaffold = ScaffoldMessenger.of(context);
  scaffold.showSnackBar(
    SnackBar(
      content: Row(
        children: [
          Icon(
            state == ToastStates.error ? Icons.error : Icons.gpp_good,
            color: Colors.white,
          ),
          SizedBox(width: 5),
          Text(
            content,
          ),
        ],
      ),
      backgroundColor: state == ToastStates.error ? Colors.red : Colors.green,
      //   action: SnackBarAction(
      //       label: 'UNDO', onPressed: scaffold.hideCurrentSnackBar),
    ),
  );
}

paymentBottomSheet(BuildContext context, dynamic Function()? onTap) {
  return showModalBottomSheet(
    context: context,
    builder: (_) {
      return Container(
        height: MediaQuery.of(context).size.height * 0.3,
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Text(
              'اختر طريقة دفع',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                paymentCard(
                  'assets/images/vodafone_icon.svg',
                  'Vodafone Cash',
                  onTap,
                ),
                const SizedBox(width: 20),
                paymentCard(
                  'assets/images/google_icon.svg',
                  'Google Pay',
                  () {
                    // addPhoneData(context);
                  },
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}

paymentCard(String svgAssetImage, String text, dynamic Function()? onTap) {
  return Expanded(
    child: GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 5,
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              SvgPicture.asset(
                svgAssetImage,
                width: 75,
                height: 75,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(text),
            ],
          ),
        ),
      ),
    ),
  );
}

sendVerificationEmailDialog(BuildContext context, void Function()? onPressed){
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          actions: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                            onPressed: onPressed,
                            child: Text(
                              ' أرسل إيميل تأكيد اخر',
                              style: TextStyle(
                                  color: buttonColor,
                                  fontWeight: FontWeight.w400),
                            )),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Get.back(),
                          child: Text(
                            'تجاهل',
                            style: TextStyle(
                              color: buttonColor,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
          actionsAlignment: MainAxisAlignment.spaceAround,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: const Text('لم يتم تأكيد هذا الإيميل',
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.center),
        );
      });
}

SvgPicture noInternetImage(){
  return SvgPicture.asset(
    'assets/images/no-internet-connection.svg',
    // color: Colors.red,
    // semanticsLabel: 'A red up arrow'
  );
}