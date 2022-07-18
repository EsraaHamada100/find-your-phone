// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import '../../../model/phone_data.dart';
// import '../components.dart';
//
// FloatingActionButton deletePhone(){
//   return FloatingActionButton(
//     onPressed: () {
//       print(docId);
//       print(PhoneData.toJson(phone).json);
//       customAlertDialog(context,
//           title: 'حذف الهاتف',
//           content: 'هل أنت متأكد من أنك تريد حذف الهاتف ؟',
//           confirmFunction: () async {
//             Get.back();
//             showLoading(context);
//             await FirebaseFirestore.instance
//                 .collection('phones')
//                 .doc(docId)
//                 .update({
//               'phones_list':
//               FieldValue.arrayRemove([PhoneData.toJson(phone).json])
//             });
//             for (PhonesDocument doc
//             in _firebaseController.phonesDocuments) {
//               if(doc.phonesData.contains(phone)) {
//                 doc.phonesData.remove(phone);
//               }
//             }
//             _firebaseController.phonesDocuments.refresh();
//             if(phone.isLostPhone) {
// // we removed a lost phone
//               _firebaseController.lostPhones.remove(phone);
//               _firebaseController.lostPhones.refresh();
//               Get.offAll(()=> LostPhonesScreen());
//             }else {
// // we removed a found phone
//               _firebaseController.foundPhones.remove(phone);
//               _firebaseController.foundPhones.refresh();
//               Get.offAll(()=>FoundPhonesScreen());
//             }
//
//             print('deleted');
//           });
//     },
//     child: Icon(Icons.delete),
//     backgroundColor: Colors.red,
//   );
// }
