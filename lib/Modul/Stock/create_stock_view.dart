import 'dart:io';
import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:bonjour/Model/stock_model.dart';
import 'package:bonjour/Modul/Stock/stock_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:bonjour/data.dart';
import 'package:provider/provider.dart';

class CreateStockView extends StatefulWidget {
  const CreateStockView({Key? key}) : super(key: key);

  @override
  State<CreateStockView> createState() => _CreateStockViewState();
}

class _CreateStockViewState extends State<CreateStockView> {
  late TextEditingController kodeStock;
  late TextEditingController namaStock;
  late TextEditingController kodeJenisProduk;
  late TextEditingController satuan;
  late TextEditingController deskripsi;
  late TextEditingController hargaJual;
  late TextEditingController hargaBeli;
  late TextEditingController hargaMinimum;
  late TextEditingController saldoAwal;

  bool aktif = true;
  File? _imageFile;
  final picker = ImagePicker();
  String imgurl = defaultStockImg;


  @override
  void initState() {
    super.initState();
    kodeStock = TextEditingController(text: '');
    namaStock = TextEditingController(text: '');
    kodeJenisProduk = TextEditingController(text: '');
    satuan = TextEditingController(text: '');
    deskripsi = TextEditingController(text: '');
    hargaJual = TextEditingController(text: '0');
    hargaBeli = TextEditingController(text: '0'); 
    hargaMinimum = TextEditingController(text: '0'); 
    saldoAwal = TextEditingController(text: '0'); 
  }

  @override
  void dispose() {
    kodeStock.dispose();
    namaStock.dispose();
    kodeJenisProduk.dispose();
    satuan.dispose();
    deskripsi.dispose();
    hargaJual.dispose();
    hargaBeli.dispose();
    hargaMinimum.dispose();
    saldoAwal.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final stockCtrl = Provider.of<StockController>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text('Add Stock'),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: _imageFile != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(
                              _imageFile!,
                              width: 150,
                              height: 150,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              Icons.camera_alt,
                              color: Colors.grey[800],
                              size: 50,
                            ),
                          ),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    decoration: InputDecoration(labelText: 'Kode Stock'),
                    controller: kodeStock,
                  ),
                  SizedBox(height: 16),
                  TextField(
                    decoration: InputDecoration(labelText: 'Nama Stock'),
                    controller: namaStock,
                  ),
                  SizedBox(height: 16),
                  TextField(
                    decoration: InputDecoration(labelText: 'Kode Jenis Produk'),
                    controller: kodeJenisProduk,
                  ),
                  SizedBox(height: 16),
                  TextField(
                    decoration: InputDecoration(labelText: 'Satuan'),
                    controller: satuan,
                  ),
                  SizedBox(height: 16),
                  TextField(
                    decoration: InputDecoration(labelText: 'Deskripsi'),
                    controller: deskripsi,
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Text('Status Stock'),
                      SizedBox(width: 10),
                      Switch(
                        value: aktif == true,
                        onChanged: (value) {
                          setState(() {
                            aktif = value ? true : false;
                          });
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  TextField(
                    decoration: InputDecoration(labelText: 'Harga Jual'),
                    keyboardType: TextInputType.number,
                    controller: hargaJual,
                  ),
                  SizedBox(height: 16),
                  TextField(
                    decoration: InputDecoration(labelText: 'Harga Beli'),
                    keyboardType: TextInputType.number,
                    controller: hargaBeli,
                  ),
                  SizedBox(height: 16),
                  TextField(
                    decoration: InputDecoration(labelText: 'Harga Minimum'),
                    keyboardType: TextInputType.number,
                    controller: hargaMinimum,
                  ),
                  SizedBox(height: 16),
                  TextField(
                    decoration: InputDecoration(labelText: 'Saldo Awal'),
                    keyboardType: TextInputType.number,
                    controller: saldoAwal,
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () async {
                          setState(() {
                            stockCtrl.processing = true;
                          });
                          if (_imageFile != null) {
                            String valueImg = await stockCtrl.uploadImage(_imageFile);
                            imgurl = valueImg;
                            if (valueImg=='') {
                              ArtSweetAlert.show(
                                context: context,
                                artDialogArgs: ArtDialogArgs(
                                  type: ArtSweetAlertType.warning,
                                  title: "Upload Image Failed",
                                  confirmButtonColor: Color.fromARGB(255, 3, 192, 0),
                                )
                              );
                              setState(() {
                                stockCtrl.processing = false;
                              });
                              return;
                            }
                          }
                          Stock stock = Stock(
                            kodeStock: kodeStock.text, 
                            namaStock: namaStock.text, 
                            kodeJenisProduk: kodeJenisProduk.text, 
                            satuan: satuan.text, 
                            aktif: aktif,
                            deskripsi: deskripsi.text,
                            hargaBeli: double.parse(hargaBeli.text),
                            hargaJual: double.parse(hargaJual.text),
                            hargaMinimum: double.parse(hargaMinimum.text),
                            img: imgurl,
                            saldoAwal: double.parse(saldoAwal.text)
                          );
                          stockCtrl.addNewStock(stock).then((value) => {
                            if (value) {
                              ArtSweetAlert.show(
                                context: context,
                                artDialogArgs: ArtDialogArgs(
                                  type: ArtSweetAlertType.success,
                                  title: "Add Stock Successful",
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
                  )
                ],
              ),
            ),
          ),
          if (stockCtrl.processing)
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
