import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:umur/model/age.dart';
import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.initialize();
  await Hive.initFlutter();
  Hive.registerAdapter(AgeAdapter());
  await Hive.openBox<Age>('age');
  runApp(
    GetMaterialApp(
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      initialRoute: Routes.SPLASH_SCREEN,
      getPages: AppPages.routes,
    ),
  );
}
