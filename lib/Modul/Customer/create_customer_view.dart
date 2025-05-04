import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:bonjour/Model/customer_model.dart';
import 'package:bonjour/Modul/Customer/customer_controller.dart';
import 'package:bonjour/data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class CreateCustomerView extends StatefulWidget {
  const CreateCustomerView({super.key});

  @override
  State<CreateCustomerView> createState() => _CreateCustomerViewState();
}

class _CreateCustomerViewState extends State<CreateCustomerView> {

  late TextEditingController _kodeCustomerController;
  late TextEditingController _namaCustomerController;
  late TextEditingController _alamatController;
  late TextEditingController _emailController;
  late TextEditingController _notelpController;

  void initState() {
    super.initState();
    _kodeCustomerController = TextEditingController(text: '');
    _namaCustomerController = TextEditingController(text: '');
    _alamatController = TextEditingController(text: '');
    _emailController = TextEditingController(text: '');
    _notelpController = TextEditingController(text: '');
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
        backgroundColor: primaryColor,
        title: Text('Add Customer'),
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
                  controller: _kodeCustomerController,
                  decoration: InputDecoration(
                    labelText: 'Kode Customer',
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _namaCustomerController,
                  decoration: InputDecoration(
                    labelText: 'Nama Customer',
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
                          customerCtrl.processing = true;
                        });
                        Customer customer = Customer(
                          kodeCustomer: _kodeCustomerController.text,
                          namaCustomer: _namaCustomerController.text,
                          alamat: _alamatController.text,
                          email: _emailController.text,
                          noTelp: _notelpController.text,
                        );
                        customerCtrl.addNewCustomer(customer).then((value) => {
                          if (value) {
                            ArtSweetAlert.show(
                              context: context,
                              artDialogArgs: ArtDialogArgs(
                                type: ArtSweetAlertType.success,
                                title: "Add Customer Successful",
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
          if (customerCtrl.processing)
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