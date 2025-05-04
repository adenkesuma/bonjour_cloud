import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:bonjour/Modul/Pemindahan/create_pemindahan_view.dart';
import 'package:bonjour/Modul/Pemindahan/edit_pemindahan_view.dart';
import 'package:bonjour/Modul/Pemindahan/pemindahan_controller.dart';
import 'package:bonjour/data.dart';
import 'package:bonjour/drawer.dart';
import 'package:bonjour/floatingactbutton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class PemindahanView extends StatefulWidget {
  const PemindahanView({super.key});

  @override
  State<PemindahanView> createState() => _PemindahanViewState();
}
class _PemindahanViewState extends State<PemindahanView> {
  TextEditingController _search = TextEditingController();

  @override
  void initState() {
    super.initState();
    final pemindahanCtrl = Provider.of<PemindahanController>(context, listen: false);
    pemindahanCtrl.fetchData();
  }

  void createPemindahan() {
    Get.to(CreatePemindahanView());
  }

  @override
  Widget build(BuildContext context) {
    final pemindahanCtrl = Provider.of<PemindahanController>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text(AppLocalizations.of(context)!.pemindahan),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      drawer: MainDrawer(),
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: TextField(
                    controller: _search,
                    onChanged: (value) {
                      pemindahanCtrl.filterPemindahan(value); // Filter based on the search input
                    },
                    decoration: InputDecoration(
                      labelText: 'Search',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
                Expanded(
                  child: pemindahanCtrl.filteredPemindahan.isEmpty
                      ? const Center(child: Text('Pemindahan Tidak Ditemukan'))
                      : ListView.builder(
                          itemCount: pemindahanCtrl.filteredPemindahan.length,
                          itemBuilder: (context, index) {
                            final pemindahan = pemindahanCtrl.filteredPemindahan[index];
                            return Container(
                              margin: EdgeInsets.only(bottom: 15),
                              decoration: BoxDecoration(
                                color: Color.fromARGB(31, 172, 169, 169),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: ListTile(
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '${pemindahan.no_po}',
                                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      '${pemindahan.gudang}',
                                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: const Color.fromARGB(255, 131, 131, 131)),
                                    ),
                                  ],
                                ),
                                subtitle: 
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Jumlah : ${NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(pemindahan.jumlah)}',
                                        style: TextStyle(fontSize: 14),
                                      ),
                                      Divider(),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              Get.to(() => EditPemindahanView(pemindahan: pemindahan));
                                            },
                                            icon: Icon(Icons.edit, color: Colors.blue),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              pemindahanCtrl.deletePemindahan(pemindahanCtrl.filteredPemindahan[index].docId!, pemindahanCtrl.filteredPemindahan[index]).then((value) => {
                                                value 
                                                ? ArtSweetAlert.show(
                                                    context: context,
                                                    artDialogArgs: ArtDialogArgs(
                                                      type: ArtSweetAlertType.success,
                                                      title: "Delete Pemindahan Successful",
                                                      confirmButtonColor: Color.fromARGB(255, 3, 192, 0),
                                                    )
                                                  )
                                                : ArtSweetAlert.show(
                                                    context: context,
                                                    artDialogArgs: ArtDialogArgs(
                                                      type: ArtSweetAlertType.warning,
                                                      title: "Delete Pemindahan Failed",
                                                      confirmButtonColor: Color.fromARGB(255, 3, 192, 0),
                                                    )
                                                  )
                                              });
                                            },
                                            icon: Icon(Icons.delete, color: Colors.red),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
          if (pemindahanCtrl.processing)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.4), // Dark background
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActBtn(action: () => createPemindahan(), icon: Icons.add),
    );
  }
}
