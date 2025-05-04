import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:bonjour/Model/supplier_model.dart';
import 'package:bonjour/Modul/Supplier/supplier_controller.dart';
import 'package:bonjour/data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class CreateSupplierView extends StatefulWidget {
  const CreateSupplierView({super.key});

  @override
  State<CreateSupplierView> createState() => _CreateSupplierViewState();
}

class _CreateSupplierViewState extends State<CreateSupplierView> {

  late TextEditingController _kodeSupplierController;
  late TextEditingController _namaSupplierController;
  late TextEditingController _alamatController;
  late TextEditingController _emailController;
  late TextEditingController _notelpController;

  void initState() {
    super.initState();
    _kodeSupplierController = TextEditingController(text: '');
    _namaSupplierController = TextEditingController(text: '');
    _alamatController = TextEditingController(text: '');
    _emailController = TextEditingController(text: '');
    _notelpController = TextEditingController(text: '');
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
        backgroundColor: primaryColor,
        title: Text('Add Supplier'),
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
                  controller: _kodeSupplierController,
                  decoration: InputDecoration(
                    labelText: 'Kode Supplier',
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _namaSupplierController,
                  decoration: InputDecoration(
                    labelText: 'Nama Supplier',
                  ),
                ),
                SizedBox(height: 10),
                // ALAMAT Input Field
                TextField(
                  controller: _alamatController,
                  decoration: InputDecoration(
                    labelText: 'Alamat',
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _notelpController,
                  decoration: InputDecoration(
                    labelText: 'No Telp',
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
                          supplierCtrl.processing = true;
                        });
                        Supplier supplier = Supplier(
                          kodeSupplier: _kodeSupplierController.text,
                          namaSupplier: _namaSupplierController.text,
                          alamat: _alamatController.text,
                          email: _emailController.text,
                          noTelp: _notelpController.text,
                        );
                        supplierCtrl.addNewSupplier(supplier).then((value) => {
                          if (value) {
                            ArtSweetAlert.show(
                              context: context,
                              artDialogArgs: ArtDialogArgs(
                                type: ArtSweetAlertType.success,
                                title: "Add Supplier Successful",
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
          if (supplierCtrl.processing)
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