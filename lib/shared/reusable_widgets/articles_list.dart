// ignore_for_file: use_build_context_synchronously

import 'package:find_your_phone/control/admin_controller.dart';
import 'package:find_your_phone/control/app_controller.dart';
import 'package:find_your_phone/model/admin_data.dart';
import 'package:find_your_phone/shared/colors.dart';
import 'package:find_your_phone/shared/reusable_widgets/admin_widgets/admin_components.dart';

import 'package:find_your_phone/shared/reusable_widgets/scrollable_transparent_app_var.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../enums.dart';
import 'components.dart';
import 'custom_sign_input_field.dart';

class ArticlesScreen extends StatelessWidget {
  ArticlesScreen({Key? key, required this.screen, required this.articlesList})
      : super(key: key);

  final AppController _controller = Get.find<AppController>();
  final AdminController _adminController = Get.find<AdminController>();
  final AppController _appController = Get.find<AppController>();
  final Screens screen;
  RxList articlesList;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  deleteArticle(BuildContext context, int index) async {
    Get.back();
    bool isConnected = await _controller.checkInternetConnection(context);
    if (isConnected) {
      bool result = await _adminController.deleteLegalActionArticle(index);
      Get.back();
      if (result) {
        showToast(
          context,
          'تم الحذف بنجاح',
          ToastStates.success,
        );
      } else {
        showToast(
          context,
          'حدث خطأ أثناء الحذف برجاء المحاوله لاحقًا',
          ToastStates.error,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            CustomScrollableTransparentAppBar(
              appBarTitle: screen == Screens.lawScreen
                  ? 'إجراءات قانونيه'
                  : 'كيفية استخدام التطبيق',
              // foregroundColor: Colors.white,
            ),
          ],
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Obx(
                () => ListView.separated(
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (_, index) => buildArticle(
                          index: index,
                          context: context,
                        ),
                    separatorBuilder: (_, index) => Divider(),
                    itemCount: articlesList.length),
              ),
            ),
          ),
        ),

        floatingActionButton:
            (screen == Screens.lawScreen && _adminController.isAdmin)
                ? Padding(
                    padding: EdgeInsets.all(20),
                    child: FloatingActionButton(
                      elevation: 5,
                      child: Icon(Icons.add),
                      onPressed: () {
                        customBottomSheet(context, form(context));
                      },
                    ),
                  )
                : Container(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        // drawer: CustomNavigationDrawerWidget(),
      ),
    );
  }

  Widget buildArticle({required int index, required BuildContext context}) {
    return GetBuilder<AdminController>(builder: (_) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            // padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: _appController.isDark? darkColor1: secondaryColor,
            ),
            child: GestureDetector(
              onTap: () {
                screen == Screens.lawScreen
                    ? _adminController.changeLegalActionArticleVisibility(index)
                    : _adminController
                        .changeHowToUseOurAppArticleVisibility(index);
                // print(_controller.articlesList[index]['isVisible']);
              },
              onLongPress: () async {
                if (screen == Screens.lawScreen) {
                  customAlertDialog(
                    context,
                    title: 'حذف المقالة',
                    content: 'هل أنت متأكد من أنك تريد حذف المقالة ؟',
                    confirmFunction: () {
                      deleteArticle(context, index);
                    },
                  );
                }
              },
              child: Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: _appController.isDark? darkColor1: Colors.indigo[100]!.withOpacity(0.5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        articlesList[index].title,
                        style: Theme.of(context).textTheme.headline6,
                        maxLines: 3,
                      ),
                    ),
                    Icon(articlesList[index].isVisible
                        ? Icons.keyboard_arrow_down_outlined
                        : Icons.keyboard_arrow_left_outlined),
                  ],
                ),
              ),
            ),
          ),
          Visibility(
            visible: articlesList[index].isVisible,
            replacement: const SizedBox.shrink(),
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: _appController.isDark? darkColor1: secondaryColor,
              ),
              child: Text(
                articlesList[index].content,
                style: Theme.of(context).textTheme.bodyText1,
                textAlign: TextAlign.justify,
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget form(BuildContext context) {
    late String title, description;
    AdminController adminController = Get.find<AdminController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Center(
          child: Text(
            'إضافة مقالة',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Form(
          key: formKey,
          child: Column(
            children: [
              CustomSignInputField(
                onSaved: (val) {
                  title = val!;
                },
                validator: (val) {
                  if (val == null || val.trim() == '') {
                    return 'أكتب عنوانًا';
                  }
                  if (val.trim().length < 4) {
                    return 'عنوان غير صالح';
                  }
                  return null;
                },
                hint: " اكتب عنوان المقالة",
                icon: Icons.text_fields,
              ),
              const SizedBox(
                height: 20,
              ),
              CustomSignInputField(
                onSaved: (value) {
                  description = value!;
                },
                validator: (value) {
                  if (value == null || value.trim() == '') {
                    return 'أكتب  المقالة';
                  }
                  if (value.trim().length < 10) {
                    return 'المقالة صغيره جدًا';
                  }
                  return null;
                },
                icon: null,
                hint: 'قم بكتابة التفاصيل هنا',
                keyboardType: TextInputType.multiline,
                minLines: 8,
              ),
              const SizedBox(
                height: 20,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(buttonColor),
                        foregroundColor:
                            MaterialStateProperty.all(Colors.white),
                      ),
                      onPressed: () async {
                        var formData = formKey.currentState;
                        if (formData!.validate()) {
                          formKey.currentState!.save();
                          bool isConnected = await _controller
                              .checkInternetConnection(context);
                          if (isConnected) {
                            Get.back();
                            Get.back();
                            bool result =
                                await _adminController.addLegalActionArticle(
                                    title: title, content: description);
                            Get.back();
                            if (result) {
                              showToast(context, 'تمت إضافة المقالة بنجاح',
                                  ToastStates.success);
                            } else {
                              showToast(
                                  context,
                                  'لم نستطع إضافة المقالة يرجى المحاولة لاحقًا',
                                  ToastStates.error);
                            }
                          }else {
                            // to get back from bottomSheet
                            Get.back();
                          }
                        }
                      },
                      child: const Text('تم'),
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
                      },
                      child: const Text('إلغاء'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
