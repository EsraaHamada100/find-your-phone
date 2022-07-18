import 'package:find_your_phone/control/firebase_controller.dart';
import 'package:find_your_phone/model/admin_data.dart';
import 'package:get/get.dart';

import '../model/phone_data.dart';

class AdminController extends GetxController{
  final FirebaseController _firebaseController = Get.find<FirebaseController>();
  bool _isAdmin = false;
  get isAdmin => _isAdmin;
  setIsAdmin(bool isAdmin){
    _isAdmin = isAdmin;
  }
  AdminDocument? adminDocument ;
  RxList legalActions = [].obs;
  RxList admins = [].obs;
  /// get the document that has all admin nessecary data including :
  /// payment number , admins list, legal actions list ...etc
  Future<bool> getAdminDocument() async{
    adminDocument = await _firebaseController.getAdminDocument();
    print(adminDocument);
    if(adminDocument != null){
      print('admin Document is not equal to null');
      legalActions.addAll(adminDocument!.legalActions);
      admins.addAll(adminDocument!.admins);
      return true;
    }
    return false;
  }
  /// check if the user is admin or not to see it's privileges
  checkAdmin(String id){
    print('adminsData');
    print(admins);
    print(id);
    admins.forEach((admin) {
      if (admin.id == id) {
        _isAdmin = true;
      }
    });
  }
  /// to verify that this user pay the amount of money and publish his data
  Future<bool> verifyPhone(String docId, PhoneData phone) async{
    bool verified = await _firebaseController
        .verifyPhone(docId, phone);
    if (verified) {
      _firebaseController.needVerification
          .remove(phone);
      _firebaseController.needVerification.refresh();
      _firebaseController.lostPhones.insert(0, phone);
    }
    return verified;
  }
  /// add admin
  Future<bool> addAdmin({required String id, required String name, required String email})async{
    Map<String, dynamic> newAdmin = {
      'id': id,
      'name' : name,
      'email' : email,
    };
    bool result = await _firebaseController.addAdmin(newAdmin);

    return result;
  }

}