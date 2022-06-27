import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:umur/colors/color.dart';
import '../controllers/splash_screen_controller.dart';

class SplashScreenView extends GetView<SplashScreenController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appGreen,
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/splash.png',
          ),
          SizedBox(
            height: 70,
          ),
          Platform.isIOS
              ? CupertinoActivityIndicator(
                  radius: 15,
                  color: appWhite,
                )
              : CircularProgressIndicator(
                  color: appWhite,
                )
        ],
      ),
    ));
  }
}
