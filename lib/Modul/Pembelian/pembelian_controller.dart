import 'package:bonjour/Model/pembelian_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class PembelianController with ChangeNotifier {
  final CollectionReference dbstock = FirebaseFirestore.instance.collection('dbstock');
  final CollectionReference dbsupplier = FirebaseFirestore.instance.collection('dbsupplier');
  final CollectionReference dbpembelian = FirebaseFirestore.instance.collection('dbpembelian');
  final CollectionReference dbtransaction = FirebaseFirestore.instance.collection('dbtransaction');

  List<Pembelian> dataPembelian = [];
  bool fetching = false;
  bool processing = false;

  List<Pembelian> filteredPembelian = [];

  Future<void> fetchData() async {
    try {
      QuerySnapshot querySnapshot = await dbpembelian.get();
      QuerySnapshot querycust = await dbsupplier.get();
      Map<String, String> supplierMap = {
        for (var cust in querycust.docs)
          cust['KODE_SUPPLIER']: (cust.data() as Map<String, dynamic>)['NAMA_SUPPLIER']
      };
      dataPembelian = querySnapshot.docs
        .map((doc) {
          var data = doc.data() as Map<String, dynamic>;
          return Pembelian.fromJson({
            ...data,
            "docId": doc.id,
            "supplierName": supplierMap[data['supplier']]
          });
        })
      .toList();
      
      filteredPembelian = List.from(dataPembelian);
      notifyListeners();
    } catch (e) {
      print("Error : $e");
    }
  }

  void filterPembelian(String query) {
    if (query.isEmpty) {
      filteredPembelian = List.from(dataPembelian);
    } else {
      filteredPembelian = dataPembelian.where((pembelian) {
        return pembelian.no_po.toLowerCase().contains(query.toLowerCase()) ||
            pembelian.supplier.toLowerCase().contains(query.toLowerCase()) ||
            pembelian.supplierName.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
    notifyListeners();
  }

  Future<bool> addNewPembelian(Pembelian pembelian) async {
    processing = true;
    notifyListeners();
    try {
      Map<String, dynamic> pembelianData = {
        ...pembelian.toJson(),
        'item': pembelian.item.map((item) => item.toJson()).toList(),
      };
      DocumentReference pembelianRef = await dbpembelian.add(pembelianData);
      String pembelianDocId = pembelianRef.id;
      pembelian.item.forEach((element) async {
        Map<String, dynamic> data = {
          ...element.toJson(), 
          "no_faktur": pembelian.no_po,
          "tanggal": pembelian.tanggal,
          "type": 'PURCHASES',
          "pembelian_id": pembelianDocId,
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

  Future<bool> updatePembelian(Pembelian pembelian) async {
    processing = true;
    notifyListeners();
    try {
      Map<String, dynamic> updatedData = {
        ...pembelian.toJson(),
        'item': pembelian.item.map((item) => item.toJson()).toList(),
      };
      await dbpembelian.doc(pembelian.docId).update(updatedData);
      QuerySnapshot existingTransactions = await dbtransaction
        .where('pembelian_id', isEqualTo: pembelian.docId)
        .get();
      for (var doc in existingTransactions.docs) {
        await dbtransaction.doc(doc.id).delete();
      }
      pembelian.item.forEach((element) async {
        Map<String, dynamic> data = {
          ...element.toJson(),
          "no_faktur": pembelian.no_po,
          "tanggal": pembelian.tanggal,
          "type": 'PURCHASES',
          "pembelian_id": pembelian.docId,
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

  Future<bool> deletePembelian(String docId, Pembelian pembelian) async {
    processing = true;
    notifyListeners(); 
    try {
      await dbpembelian.doc(docId).delete();
      pembelian.item.forEach((element) async {
        var transactionRef = dbtransaction.where("pembelian_id", isEqualTo: docId);
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