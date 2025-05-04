import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:bonjour/Modul/Pembelian/create_pembelian_view.dart';
import 'package:bonjour/Modul/Pembelian/edit_pembelian_view.dart';
import 'package:bonjour/Modul/Pembelian/pembelian_controller.dart';
import 'package:bonjour/data.dart';
import 'package:bonjour/drawer.dart';
import 'package:bonjour/floatingactbutton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class PembelianView extends StatefulWidget {
  const PembelianView({super.key});

  @override
  State<PembelianView> createState() => _PembelianViewState();
}
class _PembelianViewState extends State<PembelianView> {
  TextEditingController _search = TextEditingController();

  @override
  void initState() {
    super.initState();
    final pembelianCtrl = Provider.of<PembelianController>(context, listen: false);
    pembelianCtrl.fetchData();
  }

  void createPembelian() {
    Get.to(CreatePembelianView());
  }

  @override
  Widget build(BuildContext context) {
    final pembelianCtrl = Provider.of<PembelianController>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text(AppLocalizations.of(context)!.pembelian),
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
                      pembelianCtrl.filterPembelian(value); // Filter based on the search input
                    },
                    decoration: InputDecoration(
                      labelText: 'Search',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
                Expanded(
                  child: pembelianCtrl.filteredPembelian.isEmpty
                      ? const Center(child: Text('Pembelian Tidak Ditemukan'))
                      : ListView.builder(
                          itemCount: pembelianCtrl.filteredPembelian.length,
                          itemBuilder: (context, index) {
                            final pembelian = pembelianCtrl.filteredPembelian[index];
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
                                          '${pembelian.no_po}',
                                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      '${pembelian.supplierName}',
                                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: const Color.fromARGB(255, 131, 131, 131)),
                                    ),
                                  ],
                                ),
                                subtitle: 
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Jumlah : ${NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(pembelian.jumlah)}',
                                        style: TextStyle(fontSize: 14),
                                      ),
                                      Divider(),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              Get.to(() => EditPembelianView(pembelian: pembelian));
                                            },
                                            icon: Icon(Icons.edit, color: Colors.blue),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              pembelianCtrl.deletePembelian(pembelianCtrl.filteredPembelian[index].docId!, pembelianCtrl.filteredPembelian[index]).then((value) => {
                                                value 
                                                ? ArtSweetAlert.show(
                                                    context: context,
                                                    artDialogArgs: ArtDialogArgs(
                                                      type: ArtSweetAlertType.success,
                                                      title: "Delete Pembelian Successful",
                                                      confirmButtonColor: Color.fromARGB(255, 3, 192, 0),
                                                    )
                                                  )
                                                : ArtSweetAlert.show(
                                                    context: context,
                                                    artDialogArgs: ArtDialogArgs(
                                                      type: ArtSweetAlertType.warning,
                                                      title: "Delete Pembelian Failed",
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
          if (pembelianCtrl.processing)
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
      floatingActionButton: FloatingActBtn(action: () => createPembelian(), icon: Icons.add),
    );
  }
}
