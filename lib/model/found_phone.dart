// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class FoundPhonesDocument {
//   late String id;
//   late int time;
//   List<FoundPhoneData> phonesData = [];
//   FoundPhonesDocument.fromJson(Map<String, dynamic> json, this.id){
//     time = json['time'];
//     json['phones_list'].forEach((phone){
//       phonesData.add(FoundPhoneData.fromJson(phone));
//     });
//   }
// }
//
// class FoundPhoneData {
//   late String phoneType;
//   String? phoneDescription;
//   late String IMME1;
//   String? IMME2;
//   String? phoneNumber;
//   String? whatsAppNumber;
//   String? facebookAccount;
//   List<String> imageUrls = [];
//   late String ownerId;
//   FoundPhoneData({required this.phoneType, this.phoneDescription, required this.IMME1, this.IMME2, this.phoneNumber, this.whatsAppNumber, this.facebookAccount, required this.imageUrls});
//   FoundPhoneData.fromJson(Map<String, dynamic> json) {
//     phoneType = json['phone_type']!;
//     IMME1 = json['IMME1']!;
//     phoneDescription = json.containsKey('phone_description')
//         ? json['phone_description']
//         : null;
//     IMME2 = json.containsKey('IMME2') ? json['IMME2'] : null;
//     phoneNumber = json.containsKey('phone') ? json['phone'] : null;
//     whatsAppNumber = json.containsKey('what\'s_app_number')
//         ? json['what\'s_app_number']
//         : null;
//     facebookAccount =
//     json.containsKey('facebook_link') ? json['facebook_link'] : null;
//     if (json.containsKey('imageUrls')) {
//       for(String image in json['imageUrls']){
//         imageUrls.add(image);
//       }
//
//     }
//
//   }
//   @override
//   String toString() {
//     return '{phoneType : $phoneType, '
//         'phoneDescription : $phoneDescription ,'
//         ' IMME1 :$IMME1,'
//         'IMME2 :$IMME2,'
//         ' phoneNumber : $phoneNumber , whatsAppNumber : $whatsAppNumber,'
//         ' facebookAccount : $facebookAccount ';
//   }
// }
