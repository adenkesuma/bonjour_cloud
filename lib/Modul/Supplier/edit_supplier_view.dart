import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:bonjour/Model/supplier_model.dart';
import 'package:bonjour/Modul/Supplier/supplier_controller.dart';
import 'package:bonjour/data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class EditSupplierView extends StatefulWidget {
  final Supplier supplier;

  const EditSupplierView({Key? key, required this.supplier});

  @override
  _EditSupplierViewState createState() => _EditSupplierViewState();
}

class _EditSupplierViewState extends State<EditSupplierView> {
  late TextEditingController _kodeSupplierController;
  late TextEditingController _namaSupplierController;
  late TextEditingController _alamatController;
  late TextEditingController _emailController;
  late TextEditingController _notelpController;

  @override
  void initState() {
    super.initState();
    _kodeSupplierController = TextEditingController(text: widget.supplier.kodeSupplier);
    _namaSupplierController = TextEditingController(text: widget.supplier.namaSupplier);
    _alamatController = TextEditingController(text: widget.supplier.alamat);
    _emailController = TextEditingController(text: widget.supplier.email);
    _notelpController = TextEditingController(text: widget.supplier.noTelp);
  }

  @override
  void dispose() {
    _kodeSupplierController.dispose();
    _namaSupplierController.dispose();
    _alamatController.dispose();
    _emailController.dispose();
    _notelpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final supplierCtrl = Provider.of<SupplierController>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Supplier'),
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
                    labelText: 'Kode Supplier',
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
                  controller: _kodeSupplierController,
                  readOnly: true,
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _namaSupplierController,
                  decoration: InputDecoration(
                    labelText: 'Nama Supplier',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _alamatController,
                  decoration: InputDecoration(
                    labelText: 'Alamat',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _notelpController,
                  decoration: InputDecoration(
                    labelText: 'No Telp',
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
                          supplierCtrl.processing = true;
                        });
                        Supplier updatedSupplier = Supplier(
                          kodeSupplier: _kodeSupplierController.text,
                          namaSupplier: _namaSupplierController.text,
                          alamat: _alamatController.text,
                          email: _emailController.text,
                          noTelp: _notelpController.text,
                          docId: widget.supplier.docId
                        );
                        supplierCtrl.updateSupplier(updatedSupplier).then((value) => {
                          if (value) {
                            ArtSweetAlert.show(
                              context: context,
                              artDialogArgs: ArtDialogArgs(
                                type: ArtSweetAlertType.success,
                                title: "Update Supplier Successful",
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
          if (supplierCtrl.processing)
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
