import 'package:dewikreatif/pages/onboarding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Permission.camera.request();
  await Permission.storage.request();
  await Permission.location.request();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => MaterialApp(
        title: 'dewikreatif',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          textTheme: Typography.englishLike2021.apply(fontSizeFactor: 1.sp),
        ),
        home: const OnBoarding(),
      ),
    );
  }
}
