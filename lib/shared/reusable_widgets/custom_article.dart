//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import '../../control/admin_controller.dart';
// import '../colors.dart';
//
// class CustomArticleContainer extends StatelessWidget {
//   const CustomArticleContainer({Key? key}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<AdminController>(builder: (_) {
//       return Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             // padding: EdgeInsets.all(20),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(12),
//               color: secondaryColor,
//             ),
//             child: GestureDetector(
//               onTap: () {
//                 screen == Screens.lawScreen
//                     ? _adminController.changeLegalActionArticleVisibility(index)
//                     : _adminController
//                     .changeHowToUseOurAppArticleVisibility(index);
//                 // print(_controller.articlesList[index]['isVisible']);
//               },
//               onLongPress: () async {
//                 if (screen == Screens.lawScreen) {
//                   customAlertDialog(
//                     context,
//                     title: 'حذف المقالة',
//                     content: 'هل أنت متأكد من أنك تريد حذف المقالة ؟',
//                     confirmFunction: () {
//                       deleteArticle(context, index);
//                     },
//                   );
//                 }
//               },
//               child: Container(
//                 padding: EdgeInsets.all(15),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(12),
//                   color: Colors.indigo[100]!.withOpacity(0.5),
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       screen == Screens.lawScreen
//                           ? _adminController.legalActions[index].title
//                           : _adminController.legalActions[index].title,
//                       style: Theme.of(context).textTheme.headline6,
//                     ),
//                     Icon(_adminController.legalActions[index].isVisible
//                         ? Icons.keyboard_arrow_down_outlined
//                         : Icons.keyboard_arrow_left_outlined),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           Visibility(
//             visible: screen == Screens.lawScreen
//                 ? _adminController.legalActions[index].isVisible
//                 : _adminController.howToUseOurApp[index].isVisible,
//             replacement: const SizedBox.shrink(),
//             child: Container(
//               padding: EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(12),
//                 color: secondaryColor,
//               ),
//               child: Text(
//                 screen == Screens.lawScreen
//                     ? _adminController.legalActions[index].content
//                     : _adminController.howToUseOurApp[index].content,
//                 style: Theme.of(context).textTheme.bodyText1,
//                 textAlign: TextAlign.justify,
//               ),
//             ),
//           ),
//         ],
//       );
//     });
//   }
// }
