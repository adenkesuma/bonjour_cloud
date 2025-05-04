import 'package:cloud_firestore/cloud_firestore.dart';

class Firebase_penjualan {
  final CollectionReference penjualan =
      FirebaseFirestore.instance.collection('dbpenjualan');
  final CollectionReference pembelian =
      FirebaseFirestore.instance.collection('dbpembelian');

  Future<void> addPenjualan(String customer, DateTime tanggal, String noPo,
      bool status, List<Map<String, dynamic>> items) async {
    try {
      await penjualan.add({
        'customer': customer,
        'tanggal': tanggal,
        'no_po': noPo,
        'status': status,
        'item': items, // Simpan langsung seluruh list
      });
      print('Data berhasil ditambahkan');
    } catch (e) {
      print('Gagal menambahkan data: $e');
    }
  }

  Future<List<Map<String, dynamic>>> readPenjualan() async {
    List<Map<String, dynamic>> Polist = [];
    try {
      QuerySnapshot data = await penjualan.get();
      data.docs.forEach((ele) {
        Polist.add(ele.data() as Map<String, dynamic>);
      });
      return Polist;
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<void> addPembelian(String customer, DateTime tanggal, String kodeBeli,
      String status, List<Map<String, dynamic>> items) async {
    try {
      await pembelian.add({
        'Supplier': customer,
        'Tanggal': tanggal,
        'kodeBeli': kodeBeli,
        'status': status,
        'item': items, // Simpan langsung seluruh list
      });
      print('Data berhasil ditambahkan');
    } catch (e) {
      print('Gagal menambahkan data: $e');
    }
  }

  Future<List<Map<String, dynamic>>> readpembelian() async {
    List<Map<String, dynamic>> Polist = [];
    try {
      QuerySnapshot data = await pembelian.get();
      data.docs.forEach((ele) {
        Polist.add(ele.data() as Map<String, dynamic>);
      });
      return Polist;
    } catch (e) {
      print(e);
      return [];
    }
  }
}
