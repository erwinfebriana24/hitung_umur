import 'dart:async';
import 'package:get/get.dart';
import 'package:umur/app/routes/app_pages.dart';

class SplashScreenController extends GetxController {
 
 Future loading() async{
   return await Timer(Duration(seconds: 3), () {
      Get.offAndToNamed(Routes.HOME);
    });
 }
 @override
  void onInit() {
    loading();
    super.onInit();
  }
}
