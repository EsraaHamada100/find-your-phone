class AdminDocument {
  late bool isFree;
  late String paymentNumber;
  late double paymentAmount;
  late String connectEmail;
  List<AdminData> admins = [];
  List<ArticleData> legalActions = [];
  AdminDocument.fromJson(Map<String, dynamic> json) {
    isFree = json['free'];
    paymentAmount = json['payment_amount'];
    paymentNumber = json['payment_number'];
    connectEmail = json['connect_email'];
    json['admins_list'].forEach((admin) {
      admins.add(AdminData.fromJson(admin));
    });

    json['legal_actions_list'].forEach((legalAction) {
      legalActions.add(ArticleData.fromJson(legalAction));
    });
  }
}

class AdminData {
  late String id;
  late String name;
  late String email;
  Map<String, Object> json = <String, Object>{};
  AdminData(this.id, this.name, this.email);
  AdminData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
  }
  AdminData.toJson(AdminData admin){
    json['id'] = admin.id;
    json['name'] = admin.name;
    json['email'] = admin.email;
  }

}

class ArticleData {
  late String title;
  late String content;
  late bool isVisible;
  Map<String, Object> json = <String, Object>{};
  ArticleData(this.title, this.content, this.isVisible);
  ArticleData.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    content = json['content'];
    isVisible = false;
  }
  ArticleData.toJson(ArticleData legalActionData){
    json['title'] = legalActionData.title;
    json['content'] = legalActionData.content;
  }
}
