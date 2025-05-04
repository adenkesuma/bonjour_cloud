import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:bonjour/Model/customer_model.dart';
import 'package:bonjour/Modul/Customer/customer_controller.dart';
import 'package:bonjour/data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class EditCustomerView extends StatefulWidget {
  final Customer customer;

  const EditCustomerView({Key? key, required this.customer});

  @override
  _EditCustomerViewState createState() => _EditCustomerViewState();
}

class _EditCustomerViewState extends State<EditCustomerView> {
  late TextEditingController _kodeCustomerController;
  late TextEditingController _namaCustomerController;
  late TextEditingController _alamatController;
  late TextEditingController _emailController;
  late TextEditingController _notelpController;

  @override
  void initState() {
    super.initState();
    _kodeCustomerController = TextEditingController(text: widget.customer.kodeCustomer);
    _namaCustomerController = TextEditingController(text: widget.customer.namaCustomer);
    _alamatController = TextEditingController(text: widget.customer.alamat);
    _emailController = TextEditingController(text: widget.customer.email);
    _notelpController = TextEditingController(text: widget.customer.noTelp);
  }

  @override
  void dispose() {
    _kodeCustomerController.dispose();
    _namaCustomerController.dispose();
    _alamatController.dispose();
    _emailController.dispose();
    _notelpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final customerCtrl = Provider.of<CustomerController>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Customer'),
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
                    labelText: 'Kode Customer',
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
                  controller: _kodeCustomerController,
                  readOnly: true,
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _namaCustomerController,
                  decoration: InputDecoration(
                    labelText: 'Nama Customer',
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
                          customerCtrl.processing = true;
                        });
                        Customer updatedCustomer = Customer(
                          kodeCustomer: _kodeCustomerController.text,
                          namaCustomer: _namaCustomerController.text,
                          alamat: _alamatController.text,
                          email: _emailController.text,
                          noTelp: _notelpController.text,
                          docId: widget.customer.docId
                        );
                        customerCtrl.updateCustomer(updatedCustomer).then((value) => {
                          if (value) {
                            ArtSweetAlert.show(
                              context: context,
                              artDialogArgs: ArtDialogArgs(
                                type: ArtSweetAlertType.success,
                                title: "Update Customer Successful",
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
          if (customerCtrl.processing)
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
