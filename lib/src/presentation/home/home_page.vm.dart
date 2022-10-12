import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../foundation/helper/helper.dart';

class HomePageViewModel {
  void showLog(LogLevel lv) {
    switch (lv) {
      case LogLevel.debug:
        logD('This is DEBUG log');
        break;
      case LogLevel.info:
        logI('This is INFO log');
        break;
      case LogLevel.warn:
        logW('This is WARNING log');
        break;
      case LogLevel.error:
        logE('This is ERROR log');
        break;
      default:
        break;
    }
  }
}

final homePageViewModelProvider = Provider<HomePageViewModel>((ref) {
  return HomePageViewModel();
});
