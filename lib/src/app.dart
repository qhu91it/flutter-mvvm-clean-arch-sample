import 'package:device_preview/device_preview.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loader_overlay/loader_overlay.dart';

import 'domain/usercases/usercases.dart';
import 'foundation/common/common.dart';
import 'foundation/themes/theme.dart';
import 'injected.dart';
import 'presentation/presentation.dart';

class MyApp extends ConsumerStatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends ConsumerState<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    ref.watch(appLifecycleProvider.notifier).state = state;
  }

  @override
  void didChangeMetrics() {
    // orientation
    final appOrientation = ref.watch(appOrientationProvider.notifier);
    appOrientation.state =
        CheckOrientationImpl(size: WidgetsBinding.instance.window.physicalSize);
    // theme mode
    var brightness = SchedulerBinding.instance.window.platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    final themeMode = ref.watch(appThemeModeProvider.notifier);
    themeMode.state = isDarkMode ? ThemeMode.dark : ThemeMode.light;
  }

  @override
  Widget build(BuildContext context) {
    // setting rotate
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    // Setup screen util
    final appOrientation = ref.watch(appOrientationProvider.notifier);
    Size size;
    if (appOrientation.state.isMobile) {
      size = const Size(640, 1136); // iphone 5
    } else {
      size = const Size(768, 1024); // iPad mini
    }
    return ScreenUtilInit(
      designSize: size,
      minTextAdapt: true,
      splitScreenMode: true,
      useInheritedMediaQuery: true,
      builder: (_, __) {
        final theme = ref.watch(appThemeProvider);
        final themeMode = ref.watch(appThemeModeProvider);
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          theme: theme.data.copyWith(
            pageTransitionsTheme: const PageTransitionsTheme(builders: {
              TargetPlatform.android: CupertinoPageTransitionsBuilder(),
              TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
            }),
          ),
          darkTheme: AppTheme.dark().data,
          themeMode: themeMode,
          builder: (context, child) => DevicePreview.appBuilder(
            context,
            MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
              child: LoaderOverlay(
                useDefaultLoading: false,
                overlayWidget: const Center(child: CircularProgressIndicator()),
                child: FlavorBanner(
                  show: kDebugMode,
                  child: child ?? Container(),
                ),
              ),
            ),
          ),
          home: const HomePage(),
          onGenerateRoute: Routers().generator,
        );
      },
    );
  }
}
