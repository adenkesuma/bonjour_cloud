import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:bonjour/Modul/Gudang/create_gudang_view.dart';
import 'package:bonjour/Modul/Gudang/edit_gudang_view.dart';
import 'package:bonjour/Modul/Gudang/gudang_controller.dart';
import 'package:bonjour/data.dart';
import 'package:bonjour/drawer.dart';
import 'package:bonjour/floatingactbutton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GudangView extends StatefulWidget {
  const GudangView({super.key});

  @override
  State<GudangView> createState() => _GudangViewState();
}

class _GudangViewState extends State<GudangView> {
  TextEditingController _search = TextEditingController();

  @override
  void initState() {
    super.initState();
    final gudangCtrl = Provider.of<GudangController>(context, listen: false);
    gudangCtrl.fetchData();
  }

  void createGudang () {
    Get.to(CreateGudangView());
  }

  @override
  Widget build(BuildContext context) {
    final gudangCtrl = Provider.of<GudangController>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text(AppLocalizations.of(context)!.gudang),
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
                  gudangCtrl.filterGudangs(value);
                },
                decoration: InputDecoration(
                  labelText: 'Search',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
            Expanded(
              child: gudangCtrl.filteredGudang.isEmpty 
              ? const Center(child: Text('Gudang Tidak Ditemukan')) 
              : ListView.builder(
                itemCount: gudangCtrl.filteredGudang.length,
                itemBuilder: (context, index) {
                  final gudang = gudangCtrl.filteredGudang[index];
                  return Container(
                    margin: EdgeInsets.only(bottom: 15),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(31, 172, 169, 169),
                      borderRadius: BorderRadius.circular(15)
                    ),
                    child: ListTile(
                      title: Text('${gudangCtrl.filteredGudang[index].namaGudang}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),),
                      trailing: SizedBox(
                        width: 100,
                        child: Row(
                          children: [
                            Expanded(
                              child: IconButton(
                                onPressed: () {
                                  Get.to(EditGudangView(gudang: gudang));
                                }, 
                                icon: Icon(Icons.edit, color: Colors.blue,)
                              ),
                            ),
                            Expanded(
                              child: IconButton(
                                onPressed: () {
                                  gudangCtrl.deleteGudang(gudangCtrl.filteredGudang[index].docId!).then((value) => {
                                    value 
                                    ? ArtSweetAlert.show(
                                        context: context,
                                        artDialogArgs: ArtDialogArgs(
                                          type: ArtSweetAlertType.success,
                                          title: "Delete Stock Successful",
                                          confirmButtonColor: Color.fromARGB(255, 3, 192, 0),
                                        )
                                      )
                                    : ArtSweetAlert.show(
                                        context: context,
                                        artDialogArgs: ArtDialogArgs(
                                          type: ArtSweetAlertType.warning,
                                          title: "Delete Stock Failed",
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
                        '${gudangCtrl.filteredGudang[index].kodeGudang}',
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
      floatingActionButton: FloatingActBtn(action: () => createGudang(), icon: Icons.add,),
    );
  }
}