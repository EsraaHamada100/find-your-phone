// import 'package:find_your_phone/control/firebase_controller.dart';
// import 'package:find_your_phone/model/lost_phone.dart';
// import 'package:find_your_phone/shared/reusable_widgets/app_bar.dart';
// import 'package:find_your_phone/shared/reusable_widgets/phone_container.dart';
// import 'package:find_your_phone/view/add_phone.dart';
// import 'package:find_your_phone/view/lost_phones_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import 'navigation_drawer_widget.dart';
//
// class CustomPhonesList extends StatelessWidget {
//   CustomPhonesList({Key? key, required this.appBarTitle}) : super(key: key);
//   final String appBarTitle;
//   FirebaseController _firebaseController = Get.find<FirebaseController>();
//   @override
//   Widget build(BuildContext context) {
//     return Directionality(
//       textDirection: TextDirection.rtl,
//       child: Scaffold(
//         body: NestedScrollView(
//           headerSliverBuilder: (context, innerBoxIsScrolled) => [
//             CustomAppBar(
//               appBarTitle: appBarTitle,
//               searchFunction: () {},
//             ),
//           ],
//           body: SafeArea(
//             child: Padding(
//               padding:
//                   EdgeInsets.only(bottom: 40, right: 20, left: 20, top: 20),
//               child: Container(
//                 width: double.maxFinite,
//                 child: ListView(
//                   shrinkWrap: true,
//                   children: [
//                     for (LostPhonesDocument document
//                         in _firebaseController.lostPhonesDocuments)
//                       for (LostPhoneData phone in document.phonesData)
//                         GestureDetector(
//                           onTap: ()=>Get.to(()=>LostPhones()),
//                           child: PhoneContainer(
//                             phoneType: phone.phoneType,
//                             image: phone.imageUrls.isNotEmpty
//                                 ? phone.imageUrls[0]
//                                 : null,
//                             IMME1: phone.IMME1,
//                             IMME2: phone.IMME2,
//                           ),
//                         ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//         // body:
//         floatingActionButton: Padding(
//           padding: EdgeInsets.all(20),
//           child: FloatingActionButton(
//             elevation: 5,
//             child: Icon(Icons.add),
//             onPressed: () {
//               Get.to(AddPhone());
//             },
//           ),
//         ),
//         floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//         // bottomNavigationBar: Container(
//         //   // height: MediaQuery.of(context).size,
//         //   // width: double.maxFinite,
//         //   height: 0,
//         //   color: Colors.indigo[50],
//         // ),
//         drawer: CustomNavigationDrawerWidget(),
//       ),
//     );
//   }
//
//   Container phoneContainer(BuildContext context, LostPhoneData phoneData) {
//     return Container(
//       margin: EdgeInsets.only(bottom: 15),
//       padding: EdgeInsets.all(10),
//       width: double.maxFinite,
//       height: 120,
//       decoration: BoxDecoration(
//         boxShadow: [
//           BoxShadow(
//               color: Colors.black12,
//               // Color(0x7b3332a5),
//               offset: Offset(-4, 4),
//               blurRadius: 5,
//               spreadRadius: 0)
//         ],
//         borderRadius: BorderRadius.circular(10),
//         color: Colors.white,
//       ),
//       child: Row(
//         children: [
//           Container(
//             width: MediaQuery.of(context).size.width * 0.2,
//             height: 100,
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(5),
//               child: phoneData.imageUrls.isEmpty
//                   ? Image.asset(
//                       'assets/images/no_phone.jpg',
//                       fit: BoxFit.cover,
//                     )
//                   : Image.network(
//                       phoneData.imageUrls[0],
//                       fit: BoxFit.cover,
//                     ),
//             ),
//           ),
//           SizedBox(
//             width: 20,
//           ),
//           Expanded(
//             child: Container(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Expanded(
//                     child: Text(
//                       phoneData.phoneType,
//                       style: Theme.of(context).textTheme.bodyText1!.copyWith(
//                             color: Colors.black87,
//                             fontWeight: FontWeight.bold,
//                           ),
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ),
//                   Expanded(
//                     child: Text(
//                       'IMME1 : ${phoneData.IMME1}',
//                       style: Theme.of(context).textTheme.bodyText2!.copyWith(
//                           color: Colors.black54,
//                           fontWeight: FontWeight.w500,
//                           fontFamily: 'sans'),
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ),
//                   Expanded(
//                     child: Text(
//                       phoneData.IMME2 != null
//                           ? 'IMME2 : ${phoneData.IMME2}'
//                           : '',
//                       style: Theme.of(context).textTheme.bodyText2!.copyWith(
//                           color: Colors.black54,
//                           fontWeight: FontWeight.w500,
//                           fontFamily: 'sans'),
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
