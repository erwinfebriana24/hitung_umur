import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:umur/colors/color.dart';
import 'package:umur/model/age.dart';

class SearchWidget extends SearchDelegate<Age> {
  @override
  SearchWidget() : super(searchFieldLabel: "Cari");

  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
        appBarTheme: AppBarTheme(backgroundColor: appGreen),
        inputDecorationTheme: InputDecorationTheme(
            border: InputBorder.none,
            hintStyle: GoogleFonts.lato(
                color: appGrey, fontSize: 16, fontWeight: FontWeight.bold)),
        textTheme: TextTheme(
            headline6: GoogleFonts.lato(
                color: appWhite, fontSize: 16, fontWeight: FontWeight.bold)));
  }

  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(
          Icons.clear,
          color: appWhite,
        ),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        Get.back();
        // for closing the search page and going back
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return SearchFinder(query: query);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return SearchFinder(query: query);
  }
}

class SearchFinder extends StatelessWidget {
  final String query;

  const SearchFinder({Key? key, required this.query}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<Age>>(
        valueListenable: AgeManager.getAllNote().listenable(),
        builder: (context, box, _) {
          var result = query.isEmpty
              ? box.values.toList()
              : box.values
                  .where(
                      (element) => element.nama!.toLowerCase().contains(query))
                  .toList();
          return result.isEmpty
              ? Center(
                  child: Text("Data tidak ditemukan", style: GoogleFonts.lato(
                          color: appBlack,
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  itemCount: result.length,
                  itemBuilder: (context, index) {
                    Age age = result[index];
                    return Card(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: appBlack, width: 1),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      color: appGreen,
                      margin: EdgeInsets.fromLTRB(12, 10, 12, 10),
                      child: ListTile(
                        contentPadding:
                            EdgeInsets.only(top: 10, bottom: 10, left: 10),
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
                                "Umur : ${age.tahun_umur} Tahun ${age.bulan_umur} Bulan ${age.hari_umur} Hari",
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
                                    "Ulang Tahun : ${age.hari_ultah} Hari ${age.bulan_ultah} Bulan Lagi",
                                    style: GoogleFonts.lato(
                                        color: appWhite,
                                        fontSize: 16,
                                        fontWeight: FontWeight.normal))
                          ],
                        ),
                        trailing: IconButton(
                          onPressed: () {
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
                          icon: Icon(Icons.delete),
                          color: appWhite2,
                        ),
                      ),
                    );
                  });
        });
  }
}
