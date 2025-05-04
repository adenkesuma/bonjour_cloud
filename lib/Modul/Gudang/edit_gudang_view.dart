import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:bonjour/Model/gudang_model.dart';
import 'package:bonjour/data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:bonjour/Modul/Gudang/gudang_controller.dart';

class EditGudangView extends StatefulWidget {
  final Gudang gudang; // To identify which Gudang to edit

  const EditGudangView({Key? key, required this.gudang});

  @override
  _EditGudangViewState createState() => _EditGudangViewState();
}

class _EditGudangViewState extends State<EditGudangView> {
  late TextEditingController _kodeGudangController;
  late TextEditingController _namaGudangController;
  late TextEditingController _alamatController;
  late TextEditingController _kepalaGudangController;

  @override
  void initState() {
    super.initState();
    _kodeGudangController = TextEditingController(text: widget.gudang.kodeGudang);
    _namaGudangController = TextEditingController(text: widget.gudang.namaGudang);
    _alamatController = TextEditingController(text: widget.gudang.alamat);
    _kepalaGudangController = TextEditingController(text: widget.gudang.kepalaGudang);
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
        title: Text('Edit Gudang'),
        backgroundColor: primaryColor,
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
                TextField(
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                    labelText: 'Kode Gudang',
                    labelStyle: TextStyle(
                      color: Colors.grey[700],
                      fontWeight: FontWeight.bold,
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                        color: Colors.grey[400]!,
                        width: 1.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                        color: Colors.grey[500]!,
                        width: 1.5,
                      ),
                    ),
                  ),
                  controller: _kodeGudangController,
                  readOnly: true,
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _namaGudangController,
                  decoration: InputDecoration(
                    labelText: 'NAMA_GUDANG',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _alamatController,
                  decoration: InputDecoration(
                    labelText: 'ALAMAT',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _kepalaGudangController,
                  decoration: InputDecoration(
                    labelText: 'KEPALA_GUDANG',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () async {
                        setState(() {
                          gudangCtrl.processing = true;
                        });
                        Gudang updatedGudang = Gudang(
                          kodeGudang: _kodeGudangController.text,
                          namaGudang: _namaGudangController.text,
                          alamat: _alamatController.text,
                          kepalaGudang: _kepalaGudangController.text,
                          docId: widget.gudang.docId
                        );
                        gudangCtrl.updateGudang(updatedGudang).then((value) => {
                          if (value) {
                            ArtSweetAlert.show(
                              context: context,
                              artDialogArgs: ArtDialogArgs(
                                type: ArtSweetAlertType.success,
                                title: "Update Gudang Successful",
                                confirmButtonColor: Color.fromARGB(255, 3, 192, 0),
                                onConfirm: () {
                                  Get.back();
                                  Get.back();
                                },
                              ),
                            ),
                          }
                        });
                      },
                      icon: Icon(Icons.save, color: Colors.white),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                      ),
                      label: Text('Save'),
                    ),
                    SizedBox(width: 20),
                    ElevatedButton.icon(
                      onPressed: () {
                        Get.back();
                      },
                      icon: Icon(Icons.cancel, color: Colors.white),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                      label: Text('Cancel'),
                    ),
                    SizedBox(width: 20),
                  ],
                ),
              ],
            ),
          ),
          if (gudangCtrl.processing)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.4),
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
