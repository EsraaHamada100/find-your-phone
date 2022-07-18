import 'package:flutter/material.dart';

import '../shared/enums.dart';
import '../shared/reusable_widgets/articles_list.dart';

class HowToUseOurAppScreen extends StatelessWidget {
  HowToUseOurAppScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ArticlesScreen(screen: Screens.howToUseOurAppScreen,);
  }

}