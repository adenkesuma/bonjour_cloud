import 'dart:math';

import 'package:bonjour/Model/gudang_model.dart';
import 'package:bonjour/Model/penjualan_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';


class PelunasanController with ChangeNotifier{
  final CollectionReference dbpenjualan = FirebaseFirestore.instance.collection('dbpenjualan');
  final CollectionReference dbpelunasan = FirebaseFirestore.instance.collection('dbpelunasan');

  List<Penjualan> dataPenjualan = [];
  List<Penjualan> filteredPenjualan = [];
  bool fetching = false;
  bool processing = false;
 
  void tampilkanNotifikasi(String judul, String isi) {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: Random().nextInt(1000), 
        channelKey: 'basic_channel',
        title: judul,
        body: isi,
      ),
    );
  }

  Future<void> fetchData() async {
    try {
      QuerySnapshot querySnapshot = await dbpenjualan.get();
      dataPenjualan = querySnapshot.docs
        .map((doc) => Penjualan.fromJson({
              ...doc.data() as Map<String, dynamic>,
              "docId": doc.id,
            }))
        .where((penjualan) {
          return penjualan.bayar != true;
        })
        .toList();
      filteredPenjualan = List.from(dataPenjualan);
      notifyListeners();
    } catch (e) {
      print("Error : $e");
    }
  }


  Future<bool> bayar (String idPenjualan, String no_po) async {
    processing = true;
    notifyListeners();
    try {
      await dbpenjualan.doc(idPenjualan).update({"bayar" : true});
      await dbpelunasan.add({
        'no_po': no_po,
        'date': DateTime.now(),
      });
      tampilkanNotifikasi("Pelunasan", "Pelunasan ${no_po} berhasil");
      await fetchData();
      processing = false;
      notifyListeners();
      return true;
    } catch (e) {
      print("Error : $e");
      processing = false;
      notifyListeners();
      return false;
    }
  }

  
    void filterPenjualan(String query) {
    if (query.isEmpty) {
      filteredPenjualan = List.from(dataPenjualan);
    } else {
      filteredPenjualan = dataPenjualan.where((element) {
        return element.no_po.toLowerCase().contains(query.toLowerCase()) ||
            element.customer.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
    notifyListeners();
  }


  Future<bool> addNewGudang(Gudang gudang) async {
    processing = true;
    notifyListeners(); 
    try {
      Map<String, dynamic> gudangdata = {...gudang.toJson()};
      await dbpenjualan.add(gudangdata);
      processing = false;
      await fetchData();
      notifyListeners(); 
      return true;
    } catch (e) {
      print("Error : $e");
      processing = false;
      notifyListeners(); 
      return false;
    }
  }

  Future<bool> updateGudang(Gudang gudang) async {
    processing = true;
    notifyListeners();
    try {
      Map<String, dynamic> updatedData = {...gudang.toJson()};
      await dbpenjualan.doc(gudang.docId).update(updatedData);
      await fetchData();
      processing = false;
      notifyListeners();
      return true;
    } catch (e) {
      print("Error : $e");
      processing = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteGudang(String docId) async {
    processing = true;
    notifyListeners(); 
    try {
      await dbpenjualan.doc(docId).delete();
      await fetchData();
      processing = false;
      notifyListeners(); 
      return true;
    } catch (e) {
      print("Error : $e");
      processing = false;
      notifyListeners(); 
      return false;
    }
  }

}
