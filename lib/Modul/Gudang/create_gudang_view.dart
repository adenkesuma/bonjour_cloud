import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:bonjour/Model/gudang_model.dart';
import 'package:bonjour/Modul/Gudang/gudang_controller.dart';
import 'package:bonjour/data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class CreateGudangView extends StatefulWidget {
  const CreateGudangView({super.key});

  @override
  State<CreateGudangView> createState() => _CreateGudangViewState();
}

class _CreateGudangViewState extends State<CreateGudangView> {

  late TextEditingController _kodeGudangController;
  late TextEditingController _namaGudangController;
  late TextEditingController _alamatController;
  late TextEditingController _kepalaGudangController;

  void initState() {
    super.initState();
    _kodeGudangController = TextEditingController(text: '');
    _namaGudangController = TextEditingController(text: '');
    _alamatController = TextEditingController(text: '');
    _kepalaGudangController = TextEditingController(text: '');
  }

  @override
  void dispose() {
    _kodeGudangController.dispose();
    _namaGudangController.dispose();
    _alamatController.dispose();
    _kepalaGudangController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gudangCtrl = Provider.of<GudangController>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text('Add Gudang'),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // KODE_GUDANG Input Field
                TextField(
                  controller: _kodeGudangController,
                  decoration: InputDecoration(
                    labelText: 'KODE GUDANG',
                  ),
                ),
                SizedBox(height: 10),
                // NAMA_GUDANG Input Field
                TextField(
                  controller: _namaGudangController,
                  decoration: InputDecoration(
                    labelText: 'NAMA GUDANG',
                  ),
                ),
                SizedBox(height: 10),
                // ALAMAT Input Field
                TextField(
                  controller: _alamatController,
                  decoration: InputDecoration(
                    labelText: 'ALAMAT',
                  ),
                ),
                SizedBox(height: 10),
                // KEPALA_GUDANG Input Field
                TextField(
                  controller: _kepalaGudangController,
                  decoration: InputDecoration(
                    labelText: 'KEPALA GUDANG',
                  ),
                ),
                SizedBox(height: 20),
                // Submit Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () async {
                        setState(() {
                          gudangCtrl.processing = true;
                        });
                        Gudang gudang = Gudang(
                          kodeGudang: _kodeGudangController.text,
                          namaGudang: _namaGudangController.text,
                          alamat: _alamatController.text,
                          kepalaGudang: _kepalaGudangController.text
                        );
                        gudangCtrl.addNewGudang(gudang).then((value) => {
                          if (value) {
                            ArtSweetAlert.show(
                              context: context,
                              artDialogArgs: ArtDialogArgs(
                                type: ArtSweetAlertType.success,
                                title: "Add Gudang Successful",
                                confirmButtonColor: Color.fromARGB(255, 3, 192, 0),
                                onConfirm: () {
                                  Get.back();
                                  Get.back();
                                }
                              )
                            ),
                          }
                        });
                      },
                      icon: Icon(Icons.save, color: Colors.white),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white
                      ),
                      label: Text('Save'),
                    ),
                    SizedBox(width: 20,),
                    ElevatedButton.icon(
                      onPressed: () async {
                        Get.back();
                      }, 
                      icon: Icon(Icons.cancel, color: Colors.white),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white
                      ),
                      label: Text('Cancel'),
                    ),
                    SizedBox(width: 20,),
                  ],
                ),
              ],
            ),
          ),
          if (gudangCtrl.processing)
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
    );
  }
}