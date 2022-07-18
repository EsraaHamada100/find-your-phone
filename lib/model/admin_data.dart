class AdminDocument {
  late bool isFree;
  late String paymentNumber;
  List<AdminData> admins = [];
  List<LegalActionData> legalActions = [];
  AdminDocument.fromJson(Map<String, dynamic> json) {
    isFree = json['free'];
    paymentNumber = json['payment_number'];
    json['admins_list'].forEach((admin) {
      admins.add(AdminData.fromJson(admin));
    });

    json['legal_actions_list'].forEach((legalAction) {
      legalActions.add(LegalActionData.fromJson(legalAction));
    });
  }
}

class AdminData {
  late String id;
  late String name;
  late String email;
  AdminData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
  }
}

class LegalActionData {
  late String title;
  late String content;
  LegalActionData.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    content = json['content'];
  }
}
