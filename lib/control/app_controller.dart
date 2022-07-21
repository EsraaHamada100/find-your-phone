import 'package:find_your_phone/shared/cache/cache_helper.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:image_picker/image_picker.dart';

import '../shared/enums.dart';

class AppController extends GetxController {
  // BottomBarButtons _tappedButton = BottomBarButtons.Home;
  // BottomBarButtons get tappedButton => _tappedButton;
  @override
  onReady() {
    super.onReady();
    print("The task controller is ready");
  }
  //
  // changeButton(BottomBarButtons newButton){
  //   _tappedButton = newButton;
  //   update();
  // }

  int _drawerIndex = 0;
  int get drawerIndex => _drawerIndex;

  changeDrawerIndex(int index) {
    _drawerIndex = index;
    update();
  }


  /// law screen body text articles list
  // List<Map<String, dynamic>> articlesList = [
  //   {
  //     "title": 'كيف تقوم بإبلاغ الشرطه ؟',
  //     "body": ' يتعرض العديد من المواطنين لأزمة سرقة الهاتف المحمول، وذلك تحديداَ بعد ظهور إصدارات جديدة ومتطورة مرتفعة الأثمان، ما أدى لجعلها مطمعاً لتلك العصابات، إلا أنه على الرغم من حماية القانون لحق المواطنين، الذين يتعرضون لتلك السرقات، إلا أن كثيراً منهم يجهلون الخطوات القانونية الواجب اتباعها لحفظ تلك الحقوق.' +
  //         ' في التقرير التالي، يلقى"اليوم السابع" الضوء على إشكالية الإجراءات القانونية المتبعة لاسترداد الهاتف المحمول المسروق حرصا على ملفك الشخصي في هاتفك وبما أنه يحتوي على أمور خاصة عديدة لتوسع ثورة التكنولوجية والمعلومات في هذا الإطار فقد رصدنا معرفة إجراءات استرجاع فونك المفقود من خلال طريقتين تكون الطريقة الأولى فى 10 خطوات رئيسية يتبعها المواطن في حالة تعرض هاتفه المحمول للسرقة - بحسب الخبير القانوني والمحامي سامح رسلان. ',
  //     "isVisible": false,
  //   },
  //   {
  //     "title": 'كيف تقوم بإبلاغ الشرطه ؟',
  //     "body": ' يتعرض العديد من المواطنين لأزمة سرقة الهاتف المحمول، وذلك تحديداَ بعد ظهور إصدارات جديدة ومتطورة مرتفعة الأثمان، ما أدى لجعلها مطمعاً لتلك العصابات، إلا أنه على الرغم من حماية القانون لحق المواطنين، الذين يتعرضون لتلك السرقات، إلا أن كثيراً منهم يجهلون الخطوات القانونية الواجب اتباعها لحفظ تلك الحقوق.' +
  //         ' في التقرير التالي، يلقى"اليوم السابع" الضوء على إشكالية الإجراءات القانونية المتبعة لاسترداد الهاتف المحمول المسروق حرصا على ملفك الشخصي في هاتفك وبما أنه يحتوي على أمور خاصة عديدة لتوسع ثورة التكنولوجية والمعلومات في هذا الإطار فقد رصدنا معرفة إجراءات استرجاع فونك المفقود من خلال طريقتين تكون الطريقة الأولى فى 10 خطوات رئيسية يتبعها المواطن في حالة تعرض هاتفه المحمول للسرقة - بحسب الخبير القانوني والمحامي سامح رسلان. ',
  //     "isVisible": false,
  //   },
  //   {
  //     "title": 'كيف تقوم بإبلاغ الشرطه ؟',
  //     "body": ' يتعرض العديد من المواطنين لأزمة سرقة الهاتف المحمول، وذلك تحديداَ بعد ظهور إصدارات جديدة ومتطورة مرتفعة الأثمان، ما أدى لجعلها مطمعاً لتلك العصابات، إلا أنه على الرغم من حماية القانون لحق المواطنين، الذين يتعرضون لتلك السرقات، إلا أن كثيراً منهم يجهلون الخطوات القانونية الواجب اتباعها لحفظ تلك الحقوق.' +
  //         ' في التقرير التالي، يلقى"اليوم السابع" الضوء على إشكالية الإجراءات القانونية المتبعة لاسترداد الهاتف المحمول المسروق حرصا على ملفك الشخصي في هاتفك وبما أنه يحتوي على أمور خاصة عديدة لتوسع ثورة التكنولوجية والمعلومات في هذا الإطار فقد رصدنا معرفة إجراءات استرجاع فونك المفقود من خلال طريقتين تكون الطريقة الأولى فى 10 خطوات رئيسية يتبعها المواطن في حالة تعرض هاتفه المحمول للسرقة - بحسب الخبير القانوني والمحامي سامح رسلان. ',
  //     "isVisible": false,
  //   }
  // ];
// change visibility
//   void changeVisibility(int index) {
//     articlesList[index]['isVisible'] = !articlesList[index]['isVisible'];
//     update();
//   }

  /// change language
  final languageList = ['العربية'];
  String selectedLanguage = 'العربية';
  void changeLanguage(String newLanguage) {
    selectedLanguage = newLanguage;
    update();
  }

  /// change mode
  bool _isDark = CacheHelper.getMode(key: 'isDark')!;
  bool get isDark => _isDark;
  void changeMode() {
    _isDark = !_isDark;
    CacheHelper.setMode(
        key: 'isDark', value: _isDark);
    update();
  }
}
