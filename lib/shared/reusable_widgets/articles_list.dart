
import 'package:find_your_phone/control/controller.dart';
import 'package:find_your_phone/shared/colors.dart';

import 'package:find_your_phone/shared/reusable_widgets/scrollable_transparent_app_var.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../enums.dart';

class ArticlesScreen extends StatelessWidget {
  ArticlesScreen({Key? key, required this.screen}) : super(key: key);

  final AppController _controller = Get.find<AppController>();
  final Screens screen;
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            CustomScrollableTransparentAppBar(
              appBarTitle: screen == Screens.lawScreen ?'إجراءات قانونيه': 'كيفية استخدام التطبيق',
              // foregroundColor: Colors.white,
            ),
          ],
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: ListView.separated(
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (_, index) => buildArticle(
                    index: index,
                    context: context,
                  ),
                  separatorBuilder: (_, index) => Divider(),
                  itemCount: 3),
            ),
          ),
        ),
        // drawer: CustomNavigationDrawerWidget(),
      ),
    );
  }

  Widget buildArticle({required int index, required BuildContext context}) {
    return GetBuilder<AppController>(builder: (_) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            // padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: secondaryColor,
            ),
            child: InkWell(
              onTap: () {
                _controller.changeVisiblity(index);
                print(_controller.articlesList[index]['isVisible']);
              },
              child: Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.indigo[100]!.withOpacity(0.5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _controller.articlesList[index]['title'],
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    Icon(_controller.articlesList[index]['isVisible']
                        ? Icons.keyboard_arrow_down_outlined
                        : Icons.keyboard_arrow_left_outlined),
                  ],
                ),
              ),
            ),
          ),
          Visibility(
            visible: _controller.articlesList[index]['isVisible'],
            replacement: const SizedBox.shrink(),
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: secondaryColor,
              ),
              child: Text(
                _controller.articlesList[index]['body'],
                style: Theme.of(context).textTheme.bodyText1,
                textAlign: TextAlign.justify,
              ),
            ),
          ),
        ],
      );
    });
  }
}
