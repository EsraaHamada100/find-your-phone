import 'package:get/get.dart';

class UIController extends GetxController{

  bool _addAdminFloatingButton = true;

  get addAdminFloatingButton => _addAdminFloatingButton;
  changeAddAdminFloatingButton(){
    _addAdminFloatingButton = ! _addAdminFloatingButton;
    update();
  }

}