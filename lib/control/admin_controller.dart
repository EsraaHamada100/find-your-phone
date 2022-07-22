import 'package:find_your_phone/control/firebase_controller.dart';
import 'package:find_your_phone/model/admin_data.dart';
import 'package:find_your_phone/shared/enums.dart';
import 'package:get/get.dart';

import '../model/phone_data.dart';

class AdminController extends GetxController {
  final FirebaseController _firebaseController = Get.find<FirebaseController>();
  bool _isAdmin = false;
  bool _isFree = false;
  get isAdmin => _isAdmin;
  setIsAdmin(bool isAdmin) {
    _isAdmin = isAdmin;
  }

  AdminDocument? adminDocument;
  RxList legalActions = [].obs;
  RxList admins = [].obs;
  final DateTime now = DateTime.now();

  RxList<dynamic> howToUseOurApp = [
    ArticleData(
      'هواتف مفقودة',
      'فى هذه الصفحه ستجد الهواتف المفقودة التى يبحث عنها أصحابها , أذا فقدت هاتفك يمكنك إضافته عن طريق الضغط على + أسفل الصفحة وكتابة بيانات الهاتف  وستقوم بدفع مبلغ رمزي كمصاريف للإضافة و بعدها سيستمر الهاتف فى الظهور حتى بداية نفس الشهر الذي أضيف فيه من العام التالى , كما يمكنك البحث فيها فى حالة أنك وجدت هاتفا وتريد معرفة صاحب الهاتف .',
      false,
    ),
    ArticleData(
      'هواتف لا يعُرف أصحابها',
      'فى هذه الصفحه ستجد الهواتف التى تم إيجادها ولم يعثر بعد على أصحابها فإذا كنت قد فقدت هاتفك يمكنك البحث فى هذه الصفحة لترى إذا عثر أحدهم عليه , أو يمكنك إضافة هاتف قد عثرت عليه وتبحث عن صاحبه وتكون الإضافة مجانية تماما .',
      false,
    ),
    ArticleData(
      'إجراءات قانونية',
      'فى هذه الصفحه ستجد بعض الإجراءات القانونية التي يمكنك اتخاذها للعثور على هاتفك وهذه الإجراءات يمكنك الإستفاده منها إذا كنت تعيش فى جمهورية مصر العربية .',
      false,
    ),
    ArticleData(
      'تواصل معنا',
      'يمكنك الذهاب إلى هذه الصفحه إذا رغبت بتقديم اقتراح أو شكوى وسنكون سعيدين جدا بتلقى اقتراحاتكم وشكاويكم والرد عليها فى أقرب وقت',
      false,
    ),
  ].obs;

  /// get the document that has all admin nessecary data including :
  /// payment number , admins list, legal actions list ...etc
  Future<bool> getAdminDocument() async {
    adminDocument = await _firebaseController.getAdminDocument();
    print(adminDocument);
    if (adminDocument != null) {
      print('admin Document is not equal to null');
      legalActions.addAll(adminDocument!.legalActions);
      admins.addAll(adminDocument!.admins);
      _isFree = adminDocument!.isFree;
      print('is free value is $_isFree');
      return true;
    }
    return false;
  }

  /// check if there is a 100% discount
  get isFree => _isFree;
  changeIsFree() {
    _isFree = !_isFree;
    update();
  }

  /// check if the user is admin or not to see his privileges
  checkAdmin(String id) {
    print('adminsData');
    print(admins);
    print(id);
    admins.forEach((admin) async {
      if (admin.id == id) {
        _isAdmin = true;

        if (now.day == 1) {
          deletePhonesAfterOneYear();
        }
        if (now.day == 1 || now.day == 8 || now.day == 15 || now.day == 21) {
          deleteNotVerifiedPhonesAfterOneWeek();
        }
      }
    });
  }

  /// to verify that this user pay the amount of money and publish his data
  Future<bool> verifyPhone(String docId, PhoneData phone) async {
    bool verified = await _firebaseController.verifyPhone(docId, phone);
    if (verified) {
      _firebaseController.needVerification.remove(phone);
      _firebaseController.needVerification.refresh();
      _firebaseController.lostPhones.insert(0, phone);
    }
    return verified;
  }

  /// add admin
  Future<bool> addAdmin(
      {required String id, required String name, required String email}) async {
    Map<String, dynamic> newAdmin = {
      'id': id,
      'name': name,
      'email': email,
    };
    bool result = await _firebaseController.addAdmin(newAdmin);
    if (result) {
      AdminData admin = AdminData(id, name, email);
      admins.add(admin);
    }

    return result;
  }

  Future<bool> deleteAdmin(AdminData admin) async {
    bool result = await _firebaseController.deleteAdmin(admin);
    if (result) {
      admins.remove(admin);
    }
    return result;
  }

  Future<bool> changePaymentData({
    required String paymentNumber,
    required double paymentAmount,
  }) async {
    bool result = await _firebaseController.changePaymentData(
        paymentNumber, paymentAmount, _isFree);
    if (result && adminDocument != null) {
      adminDocument!.paymentNumber = paymentNumber;
      adminDocument!.isFree = _isFree;
      adminDocument!.paymentAmount = paymentAmount;
      return true;
    } else {
      return false;
    }
  }

  // change the email that you allow user to connect on
  Future<bool> changeConnectEmail({
    required String email,
  }) async {
    bool result = await _firebaseController.changeConnectEmail(email);
    if (result && adminDocument != null) {
      adminDocument!.connectEmail = email;
      return true;
    } else {
      return false;
    }
  }

// change visibility
  void changeLegalActionArticleVisibility(int index) {
    legalActions[index].isVisible = !legalActions[index].isVisible;
    update();
  }

  void changeHowToUseOurAppArticleVisibility(int index) {
    howToUseOurApp[index].isVisible = !howToUseOurApp[index].isVisible;
    update();
  }

  /// add admin
  Future<bool> addLegalActionArticle(
      {required String title, required String content}) async {
    Map<String, dynamic> newArticle = {
      'title': title,
      'content': content,
    };
    bool result = await _firebaseController.addLegalActionArticle(newArticle);
    if (result) {
      ArticleData article = ArticleData(title, content, false);
      legalActions.add(article);
    }

    return result;
  }

  Future<bool> deleteLegalActionArticle(int index) async {
    bool result =
        await _firebaseController.deleteLegalActionArticle(legalActions[index]);
    if (result) {
      legalActions.removeAt(index);
    }
    return result;
  }

  deletePhonesAfterOneYear() async {
    for (PhonesDocument doc in _firebaseController.phonesDocuments) {
      // delete empty phone documents
      if (doc.phonesData.isEmpty) {
        await _firebaseController.deleteDocument(doc.id);
        continue;
      }
      for (PhoneData phone in doc.phonesData) {
        List<String> date = phone.addedDate.split('-');
        int year = int.parse(date[0]);
        int month = int.parse(date[1]);
        if (now.year > year && (now.month >= month)) {
          _firebaseController.deletePhoneFromFirebase(doc.id, phone);
        }
      }
    }
  }

  deleteNotVerifiedPhonesAfterOneWeek() async {
    List<PhoneData> needRemove = [];
    int month, day;
    for (PhoneData phone in _firebaseController.needVerification) {
      List<String> date = phone.addedDate.split('-');
      month = int.parse(date[1]);
      day = int.parse(date[2]);
      if (day + 7 > 30) {
        if (now.month > month && now.day >= (day + 7) % 30) {
          _firebaseController.deletePhoneFromFirebase(
            _firebaseController.getDocId(phone),
            phone,
          );
          needRemove.add(phone);
        }
      } else if (now.day >= day + 7 || now.month > month) {
        print('we are in delete not verified phones');
        _firebaseController.deletePhoneFromFirebase(
          _firebaseController.getDocId(phone),
          phone,
        );
        needRemove.add(phone);
      }
    }

    /// we removed phones from needVerification we do that here
    /// because we can't remove from the list while iterating it
    for (PhoneData phone in needRemove) {
      _firebaseController.needVerification.remove(phone);
    }
  }
}
