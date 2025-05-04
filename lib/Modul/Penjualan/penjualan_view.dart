import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:bonjour/Modul/Penjualan/create_penjualan_view.dart';
import 'package:bonjour/Modul/Penjualan/edit_penjualan_view.dart';
import 'package:bonjour/Modul/Penjualan/penjualan_controller.dart';
import 'package:bonjour/data.dart';
import 'package:bonjour/drawer.dart';
import 'package:bonjour/floatingactbutton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class PenjualanView extends StatefulWidget {
  const PenjualanView({super.key});

  @override
  State<PenjualanView> createState() => _PenjualanViewState();
}
class _PenjualanViewState extends State<PenjualanView> {
  TextEditingController _search = TextEditingController();

  @override
  void initState() {
    super.initState();
    final penjualanCtrl = Provider.of<PenjualanController>(context, listen: false);
    penjualanCtrl.fetchData();
  }

  void createPenjualan() {
    Get.to(CreatePenjualanView());
  }

  @override
  Widget build(BuildContext context) {
    final penjualanCtrl = Provider.of<PenjualanController>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text(AppLocalizations.of(context)!.penjualan),
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
                      penjualanCtrl.filterPenjualan(value);
                    },
                    decoration: InputDecoration(
                      labelText: 'Search',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
                Expanded(
                  child: penjualanCtrl.filteredPenjualan.isEmpty
                      ? const Center(child: Text('Penjualan Tidak Ditemukan'))
                      : ListView.builder(
                          itemCount: penjualanCtrl.filteredPenjualan.length,
                          itemBuilder: (context, index) {
                            final penjualan = penjualanCtrl.filteredPenjualan[index];
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
                                          '${penjualan.no_po}',
                                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                                        ),
                                        Text("${penjualan.bayar ? "Lunas" : "Belum Lunas"}", style: TextStyle(fontSize: 13),)
                                      ],
                                    ),
                                    Text(
                                      '${penjualan.customerName}',
                                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: const Color.fromARGB(255, 131, 131, 131)),
                                    ),
                                  ],
                                ),
                                subtitle: 
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Jumlah : ${NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(penjualan.jumlah)}',
                                        style: TextStyle(fontSize: 14),
                                      ),
                                      Divider(),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              Get.to(() => EditPenjualanView(penjualan: penjualan));
                                            },
                                            icon: Icon(Icons.edit, color: Colors.blue),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              penjualanCtrl.deletePenjualan(penjualanCtrl.filteredPenjualan[index].docId!, penjualanCtrl.filteredPenjualan[index]).then((value) => {
                                                value 
                                                ? ArtSweetAlert.show(
                                                    context: context,
                                                    artDialogArgs: ArtDialogArgs(
                                                      type: ArtSweetAlertType.success,
                                                      title: "Delete Sales Successful",
                                                      confirmButtonColor: Color.fromARGB(255, 3, 192, 0),
                                                    )
                                                  )
                                                : ArtSweetAlert.show(
                                                    context: context,
                                                    artDialogArgs: ArtDialogArgs(
                                                      type: ArtSweetAlertType.warning,
                                                      title: "Delete Sales Failed",
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
          if (penjualanCtrl.processing)
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
      floatingActionButton: FloatingActBtn(action: () => createPenjualan(), icon: Icons.add),
    );
  }
}
