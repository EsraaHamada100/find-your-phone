import 'package:find_your_phone/control/app_controller.dart';
import 'package:find_your_phone/control/firebase_controller.dart';
import 'package:find_your_phone/model/phone_data.dart';
import 'package:find_your_phone/shared/colors.dart';
import 'package:find_your_phone/shared/reusable_widgets/custom_sign_input_field.dart';
import 'package:find_your_phone/view/phone_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../shared/reusable_widgets/phone_container.dart';


class SearchScreen extends StatefulWidget {
  const SearchScreen({required this.isLostPhonesScreen, Key? key})
      : super(key: key);
  final bool? isLostPhonesScreen;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  // BottomBarButtons buttonTapped = BottomBarButtons.Home;
  // bool isLostPhonesScreen;
  final FirebaseController _firebaseController = Get.find<FirebaseController>();
  final TextEditingController _searchController = TextEditingController();
  final List<PhoneData> _allResults = [];
  List<PhoneData> _resultsList = [];
  @override
  void initState() {
    // that means we are in verify paying screen
    // not in lost phones or found phones
    if (widget.isLostPhonesScreen == null) {
      for (PhonesDocument phonesDocument
          in _firebaseController.phonesDocuments) {
        for (PhoneData phoneData in phonesDocument.phonesData) {
          if (phoneData.paymentNumber != null) {
            _allResults.add(phoneData);
          }
        }
      }
    } else if (widget.isLostPhonesScreen!) {
      for (PhoneData phoneData in _firebaseController.lostPhones) {
        _allResults.add(phoneData);
      }
    } else {
      for (PhoneData phoneData in _firebaseController.foundPhones) {
        _allResults.add(phoneData);
      }
    }

    _resultsList = _allResults;
    _searchController.addListener(_onSearchChanged);
    super.initState();
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  _onSearchChanged() {
    searchResultsList();
    print(_searchController.text);
  }

  searchResultsList() {
    List<PhoneData> showResults = [];
    if (_searchController.text != "") {
      if (widget.isLostPhonesScreen != null) {
        for (PhoneData phone in _allResults) {
          if (phone.IMME1.contains(_searchController.text) ||
              (phone.IMME2 != null &&
                  phone.IMME2!.contains(_searchController.text))) {
            showResults.add(phone);
          }
        }
      } else {
        // that means we are searching in verify phone so we want
        // to search by payment mobile number
        for (PhoneData phone in _allResults) {
          if (phone.paymentNumber!.contains(_searchController.text)) {
            showResults.add(phone);
          }
        }
      }
    } else {
      showResults = List.from(_allResults);
    }
    setState(() {
      _resultsList = showResults;
    });
  }

  @override
  Widget build(BuildContext context) {
    AppController _appController = Get.find<AppController>();
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor:_appController.isDark? Colors.black26 : secondaryColor,
          iconTheme: IconThemeData(color:_appController.isDark? Colors.white : buttonColor),
          title: Text(
            widget.isLostPhonesScreen != null
                ? widget.isLostPhonesScreen!
                    ? 'بحث فى الهواتف المفقوده'
                    : 'بحث فى الهواتف التى لا يُعرف أصحابها'
                : 'قبول الدفع',
            style: Theme.of(context)
                .textTheme
                .bodyText1!
                .copyWith(color: _appController.isDark? Colors.white :Colors.grey[700]),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                CustomSignInputField(
                  controller: _searchController,
                  validator: (val) {},
                  icon: Icons.search,
                  hint: widget.isLostPhonesScreen != null
                      ? 'اكتب ال IMME '
                      : 'اكتب رقم الهاتف الذى تمت منه عملية الدفع',
                  isPassword: false,
                ),
                SizedBox(height: 20),
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      for (PhoneData result in _resultsList)
                        GestureDetector(
                          onTap: () => Get.to(
                            () => PhoneDetailsScreen(
                              phone: result,
                              docId: _firebaseController.getDocId(result),
                              needVerification:
                                  widget.isLostPhonesScreen == null
                                      ? true
                                      : false,
                            ),
                          ),
                          child: PhoneContainer(
                            phone: result,
                            phoneType: result.phoneType,
                            image: result.imageUrls.isNotEmpty
                                ? result.imageUrls[0]
                                : null,
                            IMME1: result.IMME1,
                            IMME2: result.IMME2,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // bottomNavigationBar: buildBottomNavigationBar(),
        // drawer: CustomNavigationDrawerWidget(),
      ),
    );
  }
  // String getDocId(PhoneData phone){
  //   for (PhonesDocument document in _firebaseController.phonesDocuments) {
  //     if(document.phonesData.contains(phone)){
  //       return document.id;
  //     }
  //   }
  //   return '';
  // }
  // searchPhone(String query) {
  //
  //     for (PhoneData phone in _firebaseController.lostPhones) {
  //       if (phone.IMME1.startsWith(query) ||
  //           (phone.IMME2 != null && phone.IMME2!.startsWith(query))) {
  //         return 'hello';
  //       }
  //   }
  // }
}
