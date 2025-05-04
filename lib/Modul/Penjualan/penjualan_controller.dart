import 'package:bonjour/Model/penjualan_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class PenjualanController with ChangeNotifier {
  final CollectionReference dbstock = FirebaseFirestore.instance.collection('dbstock');
  final CollectionReference dbcustomer = FirebaseFirestore.instance.collection('dbcustomer');
  final CollectionReference dbpenjualan = FirebaseFirestore.instance.collection('dbpenjualan');
  final CollectionReference dbtransaction = FirebaseFirestore.instance.collection('dbtransaction');

  List<Penjualan> dataPenjualan = [];
  bool fetching = false;
  bool processing = false;

  List<Penjualan> filteredPenjualan = [];

  Future<void> fetchData() async {
    try {
      QuerySnapshot querySnapshot = await dbpenjualan.get();
      QuerySnapshot querycust = await dbcustomer.get();
      Map<String, String> customerMap = {
        for (var cust in querycust.docs)
          cust['KODE_CUSTOMER']: (cust.data() as Map<String, dynamic>)['NAMA_CUSTOMER']
      };
      dataPenjualan = querySnapshot.docs
        .map((doc) {
          var data = doc.data() as Map<String, dynamic>;
          return Penjualan.fromJson({
            ...data,
            "docId": doc.id,
            "customerName": customerMap[data['customer']]
          });
        })
      .toList();
      
      filteredPenjualan = List.from(dataPenjualan);
      notifyListeners();
    } catch (e) {
      print("Error : $e");
    }
  }

  void filterPenjualan(String query) {
    if (query.isEmpty) {
      filteredPenjualan = List.from(dataPenjualan);
    } else {
      filteredPenjualan = dataPenjualan.where((penjualan) {
        return penjualan.no_po.toLowerCase().contains(query.toLowerCase()) ||
            penjualan.customer.toLowerCase().contains(query.toLowerCase()) ||
            penjualan.customerName.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
    notifyListeners();
  }

  Future<bool> addNewPenjualan(Penjualan penjualan) async {
    processing = true;
    notifyListeners();
    try {
      Map<String, dynamic> penjualanData = {
        ...penjualan.toJson(),
        'item': penjualan.item.map((item) => item.toJson()).toList(),
      };
      DocumentReference penjualanRef = await dbpenjualan.add(penjualanData);
      String penjualanDocId = penjualanRef.id;
      penjualan.item.forEach((element) async {
        Map<String, dynamic> data = {
          ...element.toJson(), 
          "no_faktur": penjualan.no_po,
          "tanggal": penjualan.tanggal,
          "type": 'SALES',
          "penjualan_id": penjualanDocId,
        };
        await dbtransaction.add(data);
      });
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

  Future<bool> updatePenjualan(Penjualan penjualan) async {
    processing = true;
    notifyListeners();
    try {
      Map<String, dynamic> updatedData = {
        ...penjualan.toJson(),
        'item': penjualan.item.map((item) => item.toJson()).toList(),
      };
      await dbpenjualan.doc(penjualan.docId).update(updatedData);
      QuerySnapshot existingTransactions = await dbtransaction
        .where('penjualan_id', isEqualTo: penjualan.docId)
        .get();
      for (var doc in existingTransactions.docs) {
        await dbtransaction.doc(doc.id).delete();
      }
      penjualan.item.forEach((element) async {
        Map<String, dynamic> data = {
          ...element.toJson(),
          "no_faktur": penjualan.no_po,
          "tanggal": penjualan.tanggal,
          "type": 'SALES',
          "penjualan_id": penjualan.docId,
        };
        await dbtransaction.add(data);
      });
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

  Future<bool> deletePenjualan(String docId, Penjualan penjualan) async {
    processing = true;
    notifyListeners(); 
    try {
      await dbpenjualan.doc(docId).delete();
      penjualan.item.forEach((element) async {
        var transactionRef = dbtransaction.where("penjualan_id", isEqualTo: docId);
        var querySnapshot = await transactionRef.get();
        for (var doc in querySnapshot.docs) {
          await doc.reference.delete();
        }
      });
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