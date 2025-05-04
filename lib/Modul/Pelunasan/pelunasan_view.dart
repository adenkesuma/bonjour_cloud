import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:bonjour/Modul/Gudang/gudang_controller.dart';
import 'package:bonjour/Modul/Pelunasan/pelunasan_controller.dart';
import 'package:bonjour/data.dart';
import 'package:bonjour/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PelunasanView extends StatefulWidget {
  const PelunasanView({super.key});

  @override
  State<PelunasanView> createState() => _PelunasanViewState();
}

class _PelunasanViewState extends State<PelunasanView> {
  TextEditingController _search = TextEditingController();

  @override
  void initState() {
    super.initState();
    final pelunasanCtrl = Provider.of<PelunasanController>(context, listen: false);
    pelunasanCtrl.fetchData();
  }
  

  @override
  Widget build(BuildContext context) {
    final pelunasanCtrl = Provider.of<PelunasanController>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text(AppLocalizations.of(context)!.pelunasan),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      drawer: MainDrawer(),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 15),
              child: TextField(
                controller: _search,
                onChanged: (value) {
                  pelunasanCtrl.filterPenjualan(value);
                },
                decoration: InputDecoration(
                  labelText: 'Search',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
            Expanded(
              child: pelunasanCtrl.filteredPenjualan.isEmpty 
              ? const Center(child: Text('Penjualan sudah Lunas')) 
              : ListView.builder(
                itemCount: pelunasanCtrl.filteredPenjualan.length,
                itemBuilder: (context, index) {
                  final penjualan = pelunasanCtrl.filteredPenjualan[index];
                  return Container(
                    margin: EdgeInsets.only(bottom: 15),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(31, 172, 169, 169),
                      borderRadius: BorderRadius.circular(15)
                    ),
                    child: ListTile(
                      title: Text(
                        '${penjualan.no_po}',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      trailing: SizedBox(
                        width: 100,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            ArtSweetAlert.show(
                              context: context,
                              artDialogArgs: ArtDialogArgs(
                                type: ArtSweetAlertType.warning,
                                title: "Confirm Payment",
                                text: "Are you sure you want to proceed with the payment?",
                                confirmButtonText: "Yes",
                                cancelButtonText: "Cancel",
                                confirmButtonColor: Color.fromARGB(255, 3, 192, 0),
                                cancelButtonColor: Color.fromARGB(255, 192, 3, 0), 
                                showCancelBtn: true,
                                onCancel: () {
                                  Get.back();
                                },
                                onConfirm: () {
                                  Get.back();
                                  pelunasanCtrl.bayar(penjualan.docId!, penjualan.no_po).then((value) => {
                                    value 
                                    ? ArtSweetAlert.show(
                                        context: context,
                                        artDialogArgs: ArtDialogArgs(
                                          type: ArtSweetAlertType.success,
                                          title: "Payment Successful",
                                          confirmButtonColor: Color.fromARGB(255, 3, 192, 0),
                                        ),
                                      )
                                    : ArtSweetAlert.show(
                                        context: context,
                                        artDialogArgs: ArtDialogArgs(
                                          type: ArtSweetAlertType.warning,
                                          title: "Payment Failed",
                                          confirmButtonColor: Color.fromARGB(255, 3, 192, 0),
                                        )
                                      )
                                  });
                                }
                              ),
                            );
                          },
                          icon: Icon(
                            Icons.attach_money,
                            color: Colors.greenAccent,
                            size: 20,
                          ),
                          label: Text(
                            'Pay',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          style: ElevatedButton.styleFrom(
                            elevation: 6,
                            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 12),
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            textStyle: TextStyle(fontSize: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      subtitle: Text(
                        '${penjualan.customer}',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}