import 'package:dropdown_search/dropdown_search.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:umur/animation/fadeanimation.dart';
import 'package:umur/colors/color.dart';
import 'package:umur/model/age.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(builder: (controller) {
      return Scaffold(
        backgroundColor: appWhite,
        appBar: AppBar(
          backgroundColor: appGreen,
          title: Text('Hitung Umur',
              style: GoogleFonts.lato(
                  color: appWhite, fontSize: 20, fontWeight: FontWeight.bold)),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                FocusManager.instance.primaryFocus?.unfocus();
                Get.bottomSheet(
                    Padding(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: Form(
                        key: controller.formKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: Container(
                          decoration: BoxDecoration(
                              color: appWhite,
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(20),
                                  topLeft: Radius.circular(20))),
                          padding: EdgeInsets.symmetric(
                              vertical: 30, horizontal: 30),
                          child: Center(
                            child: ListView(
                              children: [
                                Center(
                                    child: Text("Masukan Data Anda",
                                        style: GoogleFonts.lato(
                                            color: appBlack,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold))),
                                SizedBox(
                                  height: 30,
                                ),
                                TextFormField(
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Nama tidak boleh kosong";
                                    } else {
                                      return null;
                                    }
                                  },
                                  autocorrect: false,
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  keyboardType: TextInputType.name,
                                  controller: controller.nameC,
                                  decoration: InputDecoration(
                                      labelText: "Nama",
                                      labelStyle: GoogleFonts.lato(
                                          color: appBlack,
                                          fontSize: 16,
                                          fontWeight: FontWeight.normal),
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)))),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                TextFormField(
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Tanggal tidak boleh kosong";
                                    } else {
                                      return null;
                                    }
                                  },
                                  readOnly: true,
                                  autocorrect: false,
                                  controller: controller.dateC,
                                  decoration: InputDecoration(
                                      labelText: "Tanggal Lahir",
                                      labelStyle: GoogleFonts.lato(
                                          color: appBlack,
                                          fontSize: 16,
                                          fontWeight: FontWeight.normal),
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)))),
                                  onTap: () {
                                    showDatePicker(
                                            builder: (context, child) {
                                              return Theme(
                                                  data: Theme.of(context).copyWith(
                                                      colorScheme:
                                                          ColorScheme.light(
                                                              primary:
                                                                  appGreen),
                                                      textButtonTheme:
                                                          TextButtonThemeData(
                                                              style: TextButton
                                                                  .styleFrom(
                                                                      primary:
                                                                          appRed))),
                                                  child: child!);
                                            },
                                            helpText: "Pilih tanggal lahir",
                                            cancelText: "Batal",
                                            confirmText: "Pilih",
                                            fieldLabelText: "Pilih tanggal",
                                            fieldHintText:
                                                "Masukan tanggal lahir",
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime(1940),
                                            lastDate: DateTime(2025),
                                            initialEntryMode:
                                                DatePickerEntryMode.calendar)
                                        .then((value) {
                                      if (value != null) {
                                        controller.dateC.text =
                                            controller.convertDateTimeDisplay(
                                                value.toString());
                                        controller.ageNow();
                                        controller.nextBirthday();
                                      }
                                    });
                                  },
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                DropdownSearch<String>(
                                  validator: (String? item) {
                                    if (item == null)
                                      return "Pilih jenis kelamin";
                                    else if (item == "Jenis Kelamin")
                                      return "Anda belum pilih jenis kelamin";
                                    else
                                      return null;
                                  },
                                  popupProps: PopupProps.menu(
                                    showSelectedItems: true,
                                  ),
                                  items: [
                                    "Laki-Laki",
                                    "Perempuan",
                                  ],
                                  dropdownSearchDecoration: InputDecoration(
                                      labelText: "Jenis Kelamin",
                                      labelStyle: GoogleFonts.lato(
                                          color: appBlack,
                                          fontSize: 16,
                                          fontWeight: FontWeight.normal),
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)))),
                                  onChanged: (value) {
                                    controller.jenisKelamin = value!;
                                  },
                                ),
                                SizedBox(
                                  height: 45,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          primary: appGreen,
                                          fixedSize: Size(120, 50),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15.0))),
                                      onPressed: () {
                                        Get.back();
                                        controller.nameC.text = "";
                                        controller.dateC.text = "";
                                      },
                                      child: Text("Batal",
                                          style: GoogleFonts.lato(
                                              color: appWhite,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                    Obx(() => ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              primary: appGreen,
                                              fixedSize: Size(120, 50),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15.0))),
                                          onPressed: () {
                                            if (controller.isLoading.isFalse) {
                                              controller.addData();
                                              controller.nameC.text = "";
                                              controller.dateC.text = "";
                                              controller.kondisiAwal();
                                              controller.searchC.clear();
                                            }
                                          },
                                          child: controller.isLoading.isFalse
                                              ? Text("Tambah")
                                              : CircularProgressIndicator(),
                                        )),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    isDismissible: false);
              },
              icon: Icon(Icons.add),
              iconSize: 30,
              color: appWhite,
            ),
            // IconButton(
            //     icon: Icon(Icons.search),
            //     onPressed: () {
            //       showSearch(
            //         context: context,
            //         delegate: SearchWidget(),
            //       );
            //     }),
          ],
        ),
        body: SafeArea(
          child: ListView(
            physics: BouncingScrollPhysics(),
            children: [
              SizedBox(height: 10),
              CustomTextField(),
              SizedBox(
                height: 10,
              ),
              controller.valuess.isEmpty
                  // Data Tidak Hasil Pencarian (Awal)
                  ? DataAwal()
                  // Data Pencarian (Custom)
                  : controller.listAge.length == 0
                      ? Center(
                          child: Text("Data tidak ditemukan",
                              style: GoogleFonts.lato(
                                  color: appBlack,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold)))
                      : DataCustom()
            ],
          ),
        ),
        bottomNavigationBar: Obx(
          () => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              controller.isAdLoad.isTrue
                  ? Container(
                      height: controller.bannerAd.size.height.toDouble(),
                      width: controller.bannerAd.size.width.toDouble(),
                      child: AdWidget(ad: controller.bannerAd),
                    )
                  : SizedBox()
            ],
          ),
        ),
      );
    });
  }
}

class CustomTextField extends StatelessWidget {
  final controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10),
      child: TextFormField(
        style: GoogleFonts.lato(
            color: appWhite, fontSize: 14, fontWeight: FontWeight.normal),
        onChanged: (value) {
          controller.onSearch(value);
        },
        keyboardType: TextInputType.emailAddress,
        autocorrect: false,
        controller: controller.searchC,
        decoration: InputDecoration(
          fillColor: appGreen,
          filled: true,
          prefixIcon: Icon(
            Icons.search,
            color: appWhite,
          ),
          suffixIcon: IconButton(
              onPressed: () {
                controller.searchC.clear();
                controller.kondisiAwal();
                FocusManager.instance.primaryFocus?.unfocus();
              },
              icon: Icon(
                Icons.clear,
                color: appWhite,
              )),
          hintText: 'Cari',
          hintStyle: GoogleFonts.lato(
              color: appWhite, fontSize: 14, fontWeight: FontWeight.normal),
          border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.all(Radius.circular(20))),
        ),
      ),
    );
  }
}

class DataCustom extends StatelessWidget {
  final controller = Get.put(HomeController());
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
          physics: ScrollPhysics(),
          shrinkWrap: true,
          itemCount: controller.listAge.length,
          itemBuilder: (context, index) {
            Age age = controller.listAge[index];
            return FadeAnimation(
                delay: 0.8 * index,
                child: Slidable(
                    endActionPane:
                        ActionPane(motion: BehindMotion(), children: [
                      SlidableAction(
                        onPressed: (value) {
                          Get.defaultDialog(
                              barrierDismissible: false,
                              title: "Peringatan",
                              content: Text(
                                  "Yakin akan menghapus ${age.nama} ?",
                                  style: GoogleFonts.lato(
                                      color: appBlack,
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal)),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Get.back();
                                    },
                                    child: Text(
                                      "Tidak",
                                      style: GoogleFonts.lato(
                                          color: appGreen,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    )),
                                TextButton(
                                    onPressed: () async {
                                      await age.delete();
                                      Get.back();
                                      controller.searchC.clear();
                                      controller.kondisiAwal();
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();
                                      Get.snackbar(
                                          "Berhasil", "Berhasil menghapus data",
                                          colorText: appWhite,
                                          icon: Icon(Icons.check,
                                              color: appWhite),
                                          snackPosition: SnackPosition.BOTTOM,
                                          backgroundColor: appGreen,
                                          margin: EdgeInsets.all(15),
                                          duration: Duration(seconds: 3),
                                          dismissDirection:
                                              DismissDirection.horizontal,
                                          forwardAnimationCurve:
                                              Curves.easeOutBack);
                                    },
                                    child: Text(
                                      "Yakin",
                                      style: GoogleFonts.lato(
                                          color: appGreen,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ))
                              ]);
                        },
                        backgroundColor: appRed,
                        icon: Icons.delete,
                        label: "Hapus",
                      ),
                    ]),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: appBlack, width: 1),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      color: appGreen,
                      margin: EdgeInsets.fromLTRB(12, 10, 12, 10),
                      child: ListTile(
                        contentPadding:
                            EdgeInsets.only(top: 10, bottom: 10, left: 20),
                        title: Text("${age.nama}",
                            style: GoogleFonts.lato(
                                color: appWhite,
                                fontSize: 20,
                                fontWeight: FontWeight.bold)),
                        leading: CircleAvatar(
                          backgroundColor: appRed,
                          backgroundImage: AssetImage('assets/cake.png'),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Text("Tanggal Lahir : ${age.tanggal_lahir}",
                                style: GoogleFonts.lato(
                                    color: appWhite,
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal)),
                            SizedBox(
                              height: 10,
                            ),
                            Text("Jenis Kelamin : ${age.jenis_kelamin}",
                                style: GoogleFonts.lato(
                                    color: appWhite,
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal)),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                                "Umur : ${age.tahun_umur} Tahun, ${age.bulan_umur} Bulan, ${age.hari_umur} Hari",
                                style: GoogleFonts.lato(
                                    color: appWhite,
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal)),
                            SizedBox(
                              height: 10,
                            ),
                            age.tahun_ultah == "1"
                                ? Text(
                                    "Ulang Tahun : ${age.tahun_ultah} Tahun Lagi",
                                    style: GoogleFonts.lato(
                                        color: appWhite,
                                        fontSize: 16,
                                        fontWeight: FontWeight.normal))
                                : Text(
                                    "Ulang Tahun : ${age.hari_ultah} Hari, ${age.bulan_ultah} Bulan Lagi",
                                    style: GoogleFonts.lato(
                                        color: appWhite,
                                        fontSize: 16,
                                        fontWeight: FontWeight.normal))
                          ],
                        ),
                      ),
                    )));
          }),
    );
  }
}

class DataAwal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final GlobalKey<ExpansionTileCardState> cardA = new GlobalKey();
    return ValueListenableBuilder<Box<Age>>(
        valueListenable: AgeManager.getAllNote().listenable(),
        builder: (context, box, _) {
          var allAge = box.values.toList();
          if (allAge.length == 0) {
            return Column(
              children: [
                Container(
                  width: size.width * .50,
                  height: size.height * .30,
                  child: Lottie.asset("assets/hello.json"),
                ),
                Text("Ayo mulai menghitung umur ",
                    style: GoogleFonts.lato(
                        color: appBlack,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
              ],
            );
          } else {
            return ListView.builder(
                physics: ScrollPhysics(),
                shrinkWrap: true,
                itemCount: allAge.length,
                itemBuilder: (context, index) {
                  Age age = allAge[index];
                  return FadeAnimation(
                      delay: 0.8 * index,
                      child: Slidable(
                          endActionPane:
                              ActionPane(motion: BehindMotion(), children: [
                            SlidableAction(
                              onPressed: (value) {
                                Get.defaultDialog(
                                    barrierDismissible: false,
                                    title: "Peringatan",
                                    content: Text(
                                        "Yakin akan menghapus ${age.nama} ?",
                                        style: GoogleFonts.lato(
                                            color: appBlack,
                                            fontSize: 16,
                                            fontWeight: FontWeight.normal)),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Get.back();
                                          },
                                          child: Text(
                                            "Tidak",
                                            style: GoogleFonts.lato(
                                                color: appGreen,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          )),
                                      TextButton(
                                          onPressed: () async {
                                            await age.delete();
                                            Get.back();
                                            Get.snackbar("Berhasil",
                                                "Berhasil menghapus data",
                                                colorText: appWhite,
                                                icon: Icon(Icons.check,
                                                    color: appWhite),
                                                snackPosition:
                                                    SnackPosition.BOTTOM,
                                                backgroundColor: appGreen,
                                                margin: EdgeInsets.all(15),
                                                duration: Duration(seconds: 3),
                                                dismissDirection:
                                                    DismissDirection.horizontal,
                                                forwardAnimationCurve:
                                                    Curves.easeOutBack);
                                          },
                                          child: Text(
                                            "Yakin",
                                            style: GoogleFonts.lato(
                                                color: appGreen,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ))
                                    ]);
                              },
                              backgroundColor: appRed,
                              icon: Icons.delete,
                              label: "Hapus",
                            ),
                          ]),
                          child: ExpansionTileCard(
                            trailing: Icon(
                                Icons.arrow_drop_down_circle_outlined,
                                color: appWhite),
                            initialPadding: EdgeInsets.fromLTRB(12, 10, 12, 10),
                            finalPadding: EdgeInsets.fromLTRB(12, 10, 12, 10),
                            expandedTextColor: appWhite,
                            expandedColor: appGreen,
                            baseColor: appGreen,
                            // key: cardA,
                            leading: CircleAvatar(
                              backgroundColor: appRed,
                              backgroundImage: AssetImage('assets/cake.png'),
                            ),
                            title: Text("${age.nama}",
                                style: GoogleFonts.lato(
                                    color: appWhite,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold)),
                            subtitle: Text(
                                "Lahir : ${age.tanggal_lahir}",
                                style: GoogleFonts.lato(
                                    color: appWhite,
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal)),
                            children: [
                              Divider(
                                color: Colors.grey,
                                thickness: 1,
                                height: 1,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                // height: size.height * .20,
                                alignment: Alignment.topLeft,
                                margin: EdgeInsets.symmetric(
                                    horizontal: size.width * .05),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Jenis Kelamin : ${age.jenis_kelamin}",
                                        style: GoogleFonts.lato(
                                            color: appWhite,
                                            fontSize: 16,
                                            fontWeight: FontWeight.normal)),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                        "Umur : ${age.tahun_umur} Tahun, ${age.bulan_umur} Bulan, ${age.hari_umur} Hari",
                                        style: GoogleFonts.lato(
                                            color: appWhite,
                                            fontSize: 16,
                                            fontWeight: FontWeight.normal)),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    age.tahun_ultah == "1"
                                        ? Text(
                                            "Ulang Tahun : ${age.tahun_ultah} Tahun Lagi",
                                            style: GoogleFonts.lato(
                                                color: appWhite,
                                                fontSize: 16,
                                                fontWeight: FontWeight.normal))
                                        : Text(
                                            "Ulang Tahun : ${age.hari_ultah} Hari, ${age.bulan_ultah} Bulan Lagi",
                                            style: GoogleFonts.lato(
                                                color: appWhite,
                                                fontSize: 16,
                                                fontWeight: FontWeight.normal)),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    // ButtonBar(
                                    //   alignment: MainAxisAlignment.center,
                                    //   children: [
                                    //     IconButton(
                                    //         onPressed: () {
                                    //           cardA.currentState?.collapse();
                                    //         },
                                    //         icon: Icon(
                                    //           Icons.arrow_upward,
                                    //           color: appWhite,
                                    //         )),
                                    //   ],
                                    // )
                                  ],
                                ),
                              ),
                            ],
                          )));
                });
          }
        });
  }
}
