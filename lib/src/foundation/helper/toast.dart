import 'package:fluttertoast/fluttertoast.dart';

import '../themes/theme.dart';

abstract class ToastHelper {
  void show(String message);
  void showLong(String message);
}

class ToastHelperImpl implements ToastHelper {
  final AppTheme theme;
  ToastHelperImpl({required this.theme});

  @override
  void show(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: theme.appColors.primary,
      textColor: theme.appColors.primaryVariant,
      fontSize: 16.0,
    );
  }

  @override
  void showLong(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: theme.appColors.primary,
      textColor: theme.appColors.primaryVariant,
      fontSize: 16.0,
    );
  }
}
