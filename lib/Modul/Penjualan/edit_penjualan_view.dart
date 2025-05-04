import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:bonjour/Model/customer_model.dart';
import 'package:bonjour/Model/gudang_model.dart';
import 'package:bonjour/Model/item_model.dart';
import 'package:bonjour/Model/penjualan_model.dart';
import 'package:bonjour/Model/stock_model.dart';
import 'package:bonjour/Modul/Customer/customer_controller.dart';
import 'package:bonjour/Modul/Gudang/gudang_controller.dart';
import 'package:bonjour/Modul/Penjualan/daftar_customer.dart';
import 'package:bonjour/Modul/Penjualan/daftar_stock.dart';
import 'package:bonjour/Modul/Penjualan/penjualan_controller.dart';
import 'package:bonjour/Modul/Stock/stock_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bonjour/data.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EditPenjualanView extends StatefulWidget {
  final Penjualan penjualan;

  const EditPenjualanView({Key? key, required this.penjualan});

  @override
  State<EditPenjualanView> createState() => _EditPenjualanViewState();
}

class _EditPenjualanViewState extends State<EditPenjualanView> {
  late TextEditingController noPo;
  late TextEditingController namaCustomer;
  late TextEditingController tanggal;
  late TextEditingController namabrg;
  late TextEditingController qty;
  late TextEditingController hrg;

  DateTime selectedDate = DateTime.now();
  List<Item> listItems = [];
  Customer? selectCust;
  Stock? selectStock;
  double jumlahcur = 0.0;
  double totalInv = 0.0;
  Item? selectEdit;
  List<Gudang> listgudang = [];
  Gudang? selectGudang;


    @override
  void initState() {
    super.initState();
    noPo = TextEditingController(text: widget.penjualan.no_po);
    tanggal = TextEditingController(
      text: DateFormat('EEE, dd MMM yyyy').format(widget.penjualan.tanggal),
    );
    namaCustomer = TextEditingController(text: "");
    namabrg = TextEditingController(text: '');
    qty = TextEditingController(text: '');
    hrg = TextEditingController(text: '');
    fetchGudang();
    getData();
  }

  @override
  void dispose() {
    noPo.dispose();
    namaCustomer.dispose();
    namabrg.dispose();
    qty.dispose();
    hrg.dispose();
    super.dispose();
  }

  void count() {
    setState(() {
      if (qty.text.isEmpty || hrg.text.isEmpty) {
        jumlahcur = 0.0;
        return;
      }
      jumlahcur = double.parse(qty.text) * double.parse(hrg.text);
    });
  }

  Future<void> getData() async {
    try {
      selectCust = await Provider.of<CustomerController>(context, listen: false)
          .getCustomer(widget.penjualan.customer);
      if (!mounted) return; 

      setState(() {
        namaCustomer = TextEditingController(text: selectCust!.namaCustomer);
      });

      List<Item> prevItem = [];
      for (var element in widget.penjualan.item) {
        String kodeLokasi = element['kode lokasi'];
        Gudang namaGudang = await Provider.of<GudangController>(context, listen: false)
            .dataGudang
            .firstWhere((e) => e.kodeGudang == kodeLokasi);

        element['kode lokasi'] = namaGudang;
        prevItem.add(Item.fromJson({...element as Map<String, dynamic>}));
        element['kode lokasi'] = kodeLokasi;
      }

      if (!mounted) return; 
      setState(() {
        listItems = prevItem;
      });

      counttotal();
    } catch (e) {
      print("Error in getData: $e");
      
    }
  }

  Future<void> fetchGudang() async {
    try {
      await Provider.of<GudangController>(context, listen: false).fetchData();
      if (!mounted) return; 
      listgudang = Provider.of<GudangController>(context, listen: false).dataGudang;
    } catch (e) {
      print("Error fetching Gudang data: $e");
      
    }
  }

  Future<void> _selectCustomerFromDialog(BuildContext context) async {
    await Provider.of<CustomerController>(context, listen: false).fetchData();
    showDialog<Customer>(
      context: context,
      builder: (BuildContext context) {
        final customerList = Provider.of<CustomerController>(context).dataCustomer;
        return CustomerSelectDialog(
          customerList: customerList,
          onCustomerSelected: (selected) {
            setState(() {
              selectCust = selected;
              namaCustomer.text = "${selected.kodeCustomer} - ${selected.namaCustomer}";
            });
          },
        );
      },
    );
  }

  Future<void> _selectStockFromDialog(BuildContext context) async {
    await Provider.of<StockController>(context, listen: false).fetchData();
    showDialog<Customer>(
      context: context,
      builder: (BuildContext context) {
        final stockList = Provider.of<StockController>(context).dataStock;
        return StockSelectDialog(
          stockList: stockList,
          onStockSelected: (selected) {
            setState(() {
              selectStock = selected;
              namabrg.text = "${selected.namaStock}";
            });
          },
        );
      },
    );
  }

  void addStock() {
    setState(() {
      if (namabrg.text.isNotEmpty &&
          qty.text.isNotEmpty &&
          hrg.text.isNotEmpty &&
          selectGudang != null) {
        Item newStock = Item(
          kodeStock: selectStock!.kodeStock,
          namaStock: selectStock!.namaStock,
          kodeLokasi: selectGudang!,
          qty: double.parse(qty.text),
          harga: double.parse(hrg.text),
          jumlah: jumlahcur,
        );
        listItems.add(newStock);
        namabrg.clear();
        qty.clear();
        hrg.clear();
        selectGudang = null;
        jumlahcur = 0.0;
      } else {
        ArtSweetAlert.show(
          context: context,
          artDialogArgs: ArtDialogArgs(
            type: ArtSweetAlertType.warning,
            title: "Data belum lengkap",
            confirmButtonColor: Color.fromARGB(255, 3, 192, 0),
          ),
        );
      }
      counttotal();
    });
  }

  void editStock() {
    setState(() {
      if (namabrg.text.isNotEmpty &&
          qty.text.isNotEmpty &&
          hrg.text.isNotEmpty &&
          selectGudang != null) {
        Item updatedStock = Item(
          kodeStock: selectStock!.kodeStock,
          namaStock: selectStock!.namaStock,
          kodeLokasi: selectGudang!,
          qty: double.parse(qty.text),
          harga: double.parse(hrg.text),
          jumlah: jumlahcur,
        );
        int index = listItems.indexWhere((element) => element == selectEdit);
        if (index != -1) {
          listItems[index] = updatedStock;
        }
        namabrg.clear();
        qty.clear();
        hrg.clear();
        jumlahcur = 0.0;
        selectGudang = null;
        selectEdit = null;
      } else {
        ArtSweetAlert.show(
          context: context,
          artDialogArgs: ArtDialogArgs(
            type: ArtSweetAlertType.warning,
            title: "Data belum lengkap",
            confirmButtonColor: Color.fromARGB(255, 3, 192, 0),
          ),
        );
      }
      counttotal();
    });
  }

  void deleteButton(Item item) {
    setState(() {
      listItems.removeWhere((element) => element == item);
      counttotal();
    });
  }

  void counttotal() {
    setState(() {
      double total = 0;
      listItems.forEach((element) {
        total += element.jumlah;
      });
      totalInv = total;
    });
  }

  void editButton(Item item) async {
    selectStock = await Provider.of<StockController>(context, listen: false).getStock(item.kodeStock);
    if (!mounted) return; 

    setState(() {
      selectEdit = item;
      namabrg.text = item.namaStock;
      selectGudang = item.kodeLokasi;
      qty.text = item.qty.toInt().toString();
      hrg.text = item.harga.toInt().toString();
      jumlahcur = item.qty * item.harga;
    });
  }

  @override
  Widget build(BuildContext context) {
    final penjualanCtrl = Provider.of<PenjualanController>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text('Edit Penjualan'),
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
                  SizedBox(height: 5),
                  TextFormField(
                    controller: tanggal,
                    decoration: InputDecoration(
                      labelText: 'Tanggal',
                      suffixIcon: Icon(Icons.calendar_today),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 10,
                      ),
                    ),
                    readOnly: true,
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          selectedDate = pickedDate;
                          tanggal.text = DateFormat('EEE, dd MMM yyyy').format(pickedDate);
                        });
                      }
                    },
                    validator: (value) =>
                        value!.isEmpty ? 'Tanggal tidak boleh kosong' : null,
                  ),
                  SizedBox(height: 20),
                  AbsorbPointer(
                    child: TextFormField(
                      controller: noPo,
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: 'No. PO',
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.grey[200], // Light gray background
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey[400]!), // Light gray border
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey[400]!), // Same border for disabled
                        ),
                        labelStyle: TextStyle(color: Colors.black), // Keep label text sharp
                      ),
                      style: TextStyle(color: Colors.black), // Keep input text sharp
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: namaCustomer,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Customer',
                      border: OutlineInputBorder(),
                    ),
                    onTap: () => _selectCustomerFromDialog(context), 
                    validator: (value) => value!.isEmpty ? 'Customer is required' : null,
                  ),
                  SizedBox(height: 10),
                  Divider(thickness: 2,),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey, width: 1),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: namabrg,
                          readOnly: true,
                          decoration: InputDecoration(
                            labelText: 'Stock',
                            border: OutlineInputBorder(),
                          ),
                          onTap: () => _selectStockFromDialog(context), 
                        ),
                        SizedBox(height: 10),
                        DropdownButtonFormField<Gudang>(
                          value: selectGudang,
                          decoration: InputDecoration(
                            labelText: 'Gudang',
                            border: OutlineInputBorder(),
                          ),
                          items: listgudang.map((location) {
                            return DropdownMenuItem<Gudang>(
                              value: location,
                              child: Text("${location.namaGudang}"),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectGudang = value;
                            });
                          },
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          controller: qty,
                          decoration: InputDecoration(
                            labelText: 'Qty',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            count();
                          },
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          controller: hrg,
                          decoration: InputDecoration(
                            labelText: 'Harga',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                          onChanged: (value) {
                            count();
                          },
                        ),
                        SizedBox(height: 10),
                        Divider(thickness: 2,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text('${formatcurrency(jumlahcur)}'),
                          ],
                        ),
                        Divider(thickness: 2,),
                        SizedBox(height: 8),
                        selectEdit==null
                        ? Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                              ),
                              onPressed: addStock,
                              child: Text('Add'),
                            ),
                          ],
                        )
                        : Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                              ),
                              onPressed: editStock,
                              child: Text('Edit'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Divider(thickness: 2,),
                  SizedBox(height: 10),
                  Text("List Items"),
                  Divider(thickness: 2,),
                  listItems.length>0
                  ? ListView.builder(
                    shrinkWrap: true, 
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: listItems.length,
                    itemBuilder: (context, index) {
                      final item = listItems[index];
                      return Card(
                        child: ListTile(
                          title: Text(
                            item.namaStock,
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("${item.qty} x ${formatcurrency(item.harga)}"),
                                  Text("${item.kodeLokasi.kodeGudang}")
                                ],
                              ),
                              Divider(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("${formatcurrency(item.jumlah)}", style: TextStyle(color: Colors.black),),
                                  Row(
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          editButton(item);
                                        },
                                        icon: Icon(Icons.edit),
                                        color: Colors.blue,
                                        padding: EdgeInsets.zero,
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          deleteButton(item);
                                        },
                                        icon: Icon(Icons.delete),
                                        color: Colors.red,
                                        padding: EdgeInsets.zero,
                                      ),
                                    ],
                                  ),
                                ],
                              )
                          ],
                          ),
                        ),
                      );
                    },
                  )
                  : Center(
                    child: Text("Item masih kosong"),
                  ),
                  SizedBox(height: 5,),
                  Divider(thickness: 2,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Total",style: TextStyle(fontWeight: FontWeight.bold),),
                      Text('${formatcurrency(totalInv)}',style: TextStyle(fontWeight: FontWeight.bold),),
                    ],
                  ),
                  Divider(thickness: 2,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          if (noPo.text=="") {
                            ArtSweetAlert.show(
                              context: context,
                              artDialogArgs: ArtDialogArgs(
                                type: ArtSweetAlertType.warning,
                                title: "No PO tidak boleh kosong",
                                confirmButtonColor: Color.fromARGB(255, 3, 192, 0),
                                onConfirm: () {
                                  Get.back();
                                }
                              )
                            );
                            return;
                          }
                          if (namaCustomer.text=="") {
                            ArtSweetAlert.show(
                              context: context,
                              artDialogArgs: ArtDialogArgs(
                                type: ArtSweetAlertType.warning,
                                title: "Customer tidak boleh kosong",
                                confirmButtonColor: Color.fromARGB(255, 3, 192, 0),
                                onConfirm: () {
                                  Get.back();
                                }
                              )
                            );
                            return;
                          }
                          if (listItems.length==0) {
                            ArtSweetAlert.show(
                              context: context,
                              artDialogArgs: ArtDialogArgs(
                                type: ArtSweetAlertType.warning,
                                title: "List item belum ada",
                                confirmButtonColor: Color.fromARGB(255, 3, 192, 0),
                                onConfirm: () {
                                  Get.back();
                                }
                              )
                            );
                            return;
                          }
                          if (listItems.length>0 && noPo.text!="" && namaCustomer.text!="") {
                            Penjualan penjualan = Penjualan(
                              no_po: noPo.text, 
                              customer: selectCust!.kodeCustomer, 
                              customerName: selectCust!.namaCustomer, 
                              tanggal: selectedDate, 
                              item: listItems, 
                              jumlah: totalInv, 
                              status: false,
                              docId: widget.penjualan.docId
                            );
                            penjualanCtrl.updatePenjualan(penjualan).then((value) => {
                            if (value) {
                              ArtSweetAlert.show(
                                context: context,
                                artDialogArgs: ArtDialogArgs(
                                  type: ArtSweetAlertType.success,
                                  title: "Edit Penjualan Successful",
                                  confirmButtonColor: Color.fromARGB(255, 3, 192, 0),
                                  onConfirm: () {
                                    Get.back();
                                    Get.back();
                                  }
                                )
                              ),
                            }
                          });
                          }
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
                        onPressed: () {
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
          if (penjualanCtrl.processing)
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
