import 'dart:async';

import 'package:device_preview/device_preview.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'src/app.dart';
import 'src/foundation/common/common.dart';
import 'src/foundation/helper/helper.dart';

void main() async {
  // Setup log
  if (!kReleaseMode) {
    setLogLevel(LogLevel.all, errorTrackLine: 2);
  } else {
    setLogLevel(LogLevel.error, errorTrackLine: 0);
    debugPrint = (message, {wrapWidth}) {};
  }
  WidgetsFlutterBinding.ensureInitialized();
  await ScreenUtil.ensureScreenSize();
  await EasyLocalization.ensureInitialized();
  runZonedGuarded(() {
    runApp(
      EasyLocalization(
        supportedLocales: Constants.locales,
        path: 'assets/translations',
        fallbackLocale: Constants.locales[0],
        child: ProviderScope(
          child: DevicePreview(
            enabled: !kReleaseMode && Constants.enablePreview,
            builder: (_) => const MyApp(),
          ),
        ),
      ),
    );
  }, (error, stack) {
    logE(error.toString());
  });
}
