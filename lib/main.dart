import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lahal_application/data/datasources/local/storage_utility.dart';
import 'package:lahal_application/utils/constants/app_sizer.dart';
import 'package:lahal_application/utils/routes/app_pages.dart';
import 'package:lahal_application/utils/theme/app_theme.dart';
import 'package:lahal_application/utils/theme/app_tokens.dart';
import 'package:device_preview/device_preview.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppLocalStorage.init("user_pref");
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // SystemChrome.setEnabledSystemUIMode(
    //   SystemUiMode.manual,
    //   overlays: [
    //     SystemUiOverlay.top,
    //     SystemUiOverlay.bottom,
    //   ],
    // );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Lahal',
      //App supports Light Mode + Dark Mode. for this line
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      // Let MaterialApp inherit DevicePreview’s media query & locale. Test UI on multiple device sizes without real phones.
      locale: DevicePreview.locale(context),
      builder: (context, child) {
        // Set system UI overlay style globally this Status bar color
        // Navigation bar color
        // Icon brightness
        SystemChrome.setSystemUIOverlayStyle(
          const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.light,
            systemNavigationBarColor: Colors.white,
            systemNavigationBarIconBrightness: Brightness.dark,
            systemNavigationBarDividerColor: Colors.white,
          ),
        );

        // - AppRes
        AppRes.init(context);
        // Get.put(ProfileSetupController(repo: ProfileSetupRepoImpl()));
        // 1) First let DevicePreview wrap the child.
        child = DevicePreview.appBuilder(context, child);

        // 2) Our responsive logic.
        final mq = MediaQuery.of(context);

        // --- Responsive TEXT (width * user accessibility) ---
        const designWidth = 430.0;
        final widthScale = (mq.size.width / designWidth).clamp(0.90, 1.20);
        final userScale = mq.textScaler;
        final textScale = TextScaler.linear(userScale.scale(1.0) * widthScale);

        // --- Responsive TOKENS (spacing/radius/icon/appbar) ---
        final tokens = AppTokens.fromWidth(width: mq.size.width);

        // Inject/replace AppTokens in ThemeData.extensions. Creates spacing, padding, radius, icon sizes based on screen width.
        final base = Theme.of(context);
        final exts = List<ThemeExtension>.from(base.extensions.values);
        final idx = exts.indexWhere((e) => e is AppTokens);
        if (idx >= 0) {
          exts[idx] = tokens;
        } else {
          exts.add(tokens);
        }
        final themed = base.copyWith(extensions: exts);

        return Theme(
          data: themed,
          child: MediaQuery(
            data: mq.copyWith(textScaler: textScale),
            child: child,
          ),
        );
      },
      routerConfig: AppGoRouter.router,
    );
  }
}
