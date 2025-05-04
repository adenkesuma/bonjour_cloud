import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:bonjour/Modul/Supplier/create_supplier_view.dart';
import 'package:bonjour/Modul/Supplier/edit_supplier_view.dart';
import 'package:bonjour/Modul/Supplier/supplier_controller.dart';
import 'package:bonjour/data.dart';
import 'package:bonjour/drawer.dart';
import 'package:bonjour/floatingactbutton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SupplierView extends StatefulWidget {
  const SupplierView({super.key});

  @override
  State<SupplierView> createState() => _SupplierViewState();
}

class _SupplierViewState extends State<SupplierView> {
  TextEditingController _search = TextEditingController();

  @override
  void initState() {
    super.initState();
    final supplierCtrl = Provider.of<SupplierController>(context, listen: false);
    supplierCtrl.fetchData();
  }

  void CreateSupplier () {
    Get.to(CreateSupplierView());
  }

  @override
  Widget build(BuildContext context) {
    final supplierCtrl = Provider.of<SupplierController>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text(AppLocalizations.of(context)!.supplier),
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
                  supplierCtrl.filterSupplier(value);
                },
                decoration: InputDecoration(
                  labelText: 'Search',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
            Expanded(
              child: supplierCtrl.filteredSupplier.isEmpty 
              ? const Center(child: Text('Supplier Tidak Ditemukan')) 
              : ListView.builder(
                itemCount: supplierCtrl.filteredSupplier.length,
                itemBuilder: (context, index) {
                  final supplier = supplierCtrl.filteredSupplier[index];
                  return Container(
                    margin: EdgeInsets.only(bottom: 15),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(31, 172, 169, 169),
                      borderRadius: BorderRadius.circular(15)
                    ),
                    child: ListTile(
                      title: Text('${supplierCtrl.filteredSupplier[index].kodeSupplier}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),),
                      trailing: SizedBox(
                        width: 100,
                        child: Row(
                          children: [
                            Expanded(
                              child: IconButton(
                                onPressed: () {
                                  Get.to(EditSupplierView(supplier: supplier));
                                }, 
                                icon: Icon(Icons.edit, color: Colors.blue,)
                              ),
                            ),
                            Expanded(
                              child: IconButton(
                                onPressed: () {
                                  supplierCtrl.deleteSupplier(supplierCtrl.filteredSupplier[index].docId!).then((value) => {
                                    value 
                                    ? ArtSweetAlert.show(
                                        context: context,
                                        artDialogArgs: ArtDialogArgs(
                                          type: ArtSweetAlertType.success,
                                          title: "Delete Supplier Successful",
                                          confirmButtonColor: Color.fromARGB(255, 3, 192, 0),
                                        )
                                      )
                                    : ArtSweetAlert.show(
                                        context: context,
                                        artDialogArgs: ArtDialogArgs(
                                          type: ArtSweetAlertType.warning,
                                          title: "Delete Supplier Failed",
                                          confirmButtonColor: Color.fromARGB(255, 3, 192, 0),
                                        )
                                      )
                                  },);
                                }, 
                                icon: Icon(Icons.delete, color: Colors.red,)
                              ),
                            ),
                          ],
                        ),
                      ), 
                      subtitle: Text(
                        '${supplierCtrl.filteredSupplier[index].namaSupplier}',
                        style: TextStyle(
                          fontSize: 12, 
                          fontWeight: FontWeight.w500
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActBtn(action: () => CreateSupplier(), icon: Icons.add,),
    );
  }
}