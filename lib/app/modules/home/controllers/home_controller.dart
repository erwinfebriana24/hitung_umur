import 'package:age_calculator/age_calculator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:umur/colors/color.dart';
import 'package:umur/model/age.dart';

class HomeController extends GetxController {
  var age;
  TextEditingController dateC = TextEditingController();
  TextEditingController nameC = TextEditingController();
  TextEditingController searchC = TextEditingController();
  final formKey = GlobalKey<FormState>(); // form validator key
  RxBool isLoading = false.obs;
  // DateTime b = DateTime(2022, 05, 27);
  late String jenisKelamin;
  late DateDuration dateDuration;
  var convert;
  var formatted;
  var year1;
  var month1;
  var day1;
  var year2;
  var month2;
  var day2;
  late BannerAd bannerAd;
  InterstitialAd? interstitialAd;
  RxBool isAdLoad = false.obs;

  ////////////Pencarian////////////////////
  List<Age> listAge = <Age>[];
  var listData = AgeManager.getAllNote();
  var valuess = "";
  //////////////////////////////////////////
  String convertDateTimeDisplay(String date) {
    final DateFormat displayFormater = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');
    final DateFormat serverFormater = DateFormat('yyyy-MM-dd');
    final DateTime displayDate = displayFormater.parse(date);
    formatted = serverFormater.format(displayDate);
    return formatted;
  }

  void ageNow() {
    convert = DateTime.tryParse(formatted);
    dateDuration = AgeCalculator.age(convert);
    var data = dateDuration.toString();
    var splitData = data.split(" ");
    final Map<int, String> values = {
      for (int i = 0; i < splitData.length; i++) i: splitData[i]
    };
    var _year = values[1];
    year1 = int.parse(_year!.replaceAll(',', ''));
    var _month = values[3];
    month1 = int.parse(_month!.replaceAll(',', ''));
    var _day = values[5];
    day1 = int.parse(_day!.replaceAll(',', ''));
  }

  void nextBirthday() {
    convert = DateTime.tryParse(formatted);
    dateDuration = AgeCalculator.timeToNextBirthday(convert);
    var data = dateDuration.toString();
    var splitData = data.split(" ");
    final Map<int, String> values = {
      for (int i = 0; i < splitData.length; i++) i: splitData[i]
    };
    var _year = values[1];
    year2 = int.parse(_year!.replaceAll(',', ''));
    var _month = values[3];
    month2 = int.parse(_month!.replaceAll(',', ''));
    var _day = values[5];
    day2 = int.parse(_day!.replaceAll(',', ''));
  }

  void addData() async {
    isLoading.value = true;
    try {
      final isValid = formKey.currentState!.validate();
      var age = Age()
        ..nama = nameC.text
        ..tanggal_lahir = dateC.text
        ..jenis_kelamin = jenisKelamin
        ..hari_umur = day1.toString()
        ..bulan_umur = month1.toString()
        ..tahun_umur = year1.toString()
        ..hari_ultah = day2.toString()
        ..bulan_ultah = month2.toString()
        ..tahun_ultah = year2.toString();
      if (isValid) {
        final box = AgeManager.getAllNote();
        var idIncrement = await box.add(age);
        age.id = idIncrement;
        print(idIncrement);
        age.save();
        isLoading.value = false;
        Get.back();
        initInititialAd();
        Get.snackbar("Berhasil", "Berhasil menambahkan data",
            colorText: appWhite,
            icon: Icon(Icons.check, color: appWhite),
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: appGreen,
            margin: EdgeInsets.all(15),
            duration: Duration(seconds: 3),
            dismissDirection: DismissDirection.horizontal,
            forwardAnimationCurve: Curves.easeOutBack);
      } else {
        isLoading.value = false;
      }
    } catch (e) {
      isLoading.value = false;
      // Get.snackbar("Gagal", "${e}",
      //     colorText: appWhite,
      //     icon: Icon(
      //       Icons.close,
      //       color: appWhite,
      //     ),
      //     snackPosition: SnackPosition.BOTTOM,
      //     backgroundColor: appGreen,
      //     margin: EdgeInsets.all(15),
      //     duration: Duration(seconds: 3),
      //     dismissDirection: DismissDirection.horizontal,
      //     forwardAnimationCurve: Curves.easeOutBack);
    }
  }

  void initBannerAd() async {
    bannerAd = BannerAd(
        size: AdSize.banner,
        adUnitId: "ca-app-pub-6607178927612423/2193633434",
        listener: BannerAdListener(onAdLoaded: (ad) {
          isAdLoad.value = true;
          print(isAdLoad);
        }, onAdFailedToLoad: (ad, error) {
          ad.dispose();
        }),
        request: AdRequest());
    await bannerAd.load();
  }

  void initInititialAd() {
    InterstitialAd.load(
        adUnitId: 'ca-app-pub-6607178927612423/1152014502',
        request: AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            interstitialAd = ad;
            interstitialAd!.show();
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('InterstitialAd failed to load: $error');
          },
        ));
  }

  onSearch(String search) {
    var data = listData.values.toList();
    listAge = data
        .where((element) => element.nama!.toLowerCase().contains(search))
        .toList();
        valuess = search;
        print(valuess);
    update();
  }

  kondisiAwal() {
    var data = listData.values.toList();
    listAge = data;
    valuess = "";
    update();
  }

  @override
  void onInit() {
    kondisiAwal();
    initBannerAd();
    super.onInit();
  }
}
