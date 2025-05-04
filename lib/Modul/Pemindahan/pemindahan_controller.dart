import 'package:bonjour/Model/gudang_model.dart';
import 'package:bonjour/Model/pemindahan_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class PemindahanController with ChangeNotifier {
  final CollectionReference dbstock = FirebaseFirestore.instance.collection('dbstock');
  final CollectionReference dbassembly = FirebaseFirestore.instance.collection('dbassembly');
  final CollectionReference dbtransaction = FirebaseFirestore.instance.collection('dbtransaction');

  List<Pemindahan> dataPemindahan = [];
  bool fetching = false;
  bool processing = false;

  List<Pemindahan> filteredPemindahan = [];

  Future<void> fetchData() async {
    try {
      QuerySnapshot querySnapshot = await dbassembly.get();
      dataPemindahan = querySnapshot.docs
        .map((doc) {
          var data = doc.data() as Map<String, dynamic>;
          return Pemindahan.fromJson({
            ...data,
            "docId": doc.id,
          });
        })
      .toList();
      
      filteredPemindahan = List.from(dataPemindahan);
      notifyListeners();
    } catch (e) {
      print("Error : $e");
    }
  }

  void filterPemindahan(String query) {
    if (query.isEmpty) {
      filteredPemindahan = List.from(dataPemindahan);
    } else {
      filteredPemindahan = dataPemindahan.where((pemindahan) {
        return pemindahan.no_po.toLowerCase().contains(query.toLowerCase()) ||
            pemindahan.gudang.toLowerCase().contains(query.toLowerCase()) ||
            pemindahan.gudangName.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
    notifyListeners();
  }

  Future<bool> addNewPemindahan(Pemindahan pemindahan, Gudang gudang) async {
    processing = true;
    notifyListeners();
    try {
      Map<String, dynamic> pemindahanData = {
        ...pemindahan.toJson(),
        'item': pemindahan.item.map((item) => item.toJson()).toList(),
      };
      DocumentReference pemindahanRef = await dbassembly.add(pemindahanData);
      String pemindahanDocId = pemindahanRef.id;
      pemindahan.item.forEach((element) async {
        Map<String, dynamic> data = {
          ...element.toJson(), 
          "no_faktur": pemindahan.no_po,
          "tanggal": pemindahan.tanggal,
          "type": 'PEMINDAHAN IN',
          "pemindahan_id": pemindahanDocId,
        };
        await dbtransaction.add(data);
        element.kodeLokasi = gudang;
        Map<String, dynamic> dataOut = {
          ...element.toJson(), 
          "no_faktur": pemindahan.no_po,
          "tanggal": pemindahan.tanggal,
          "type": 'PEMINDAHAN OUT',
          "pemindahan_id": pemindahanDocId,
        };
        await dbtransaction.add(dataOut);
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

  Future<bool> updatePemindahan(Pemindahan pemindahan, Gudang gudang) async {
    processing = true;
    notifyListeners();
    try {
      Map<String, dynamic> updatedData = {
        ...pemindahan.toJson(),
        'item': pemindahan.item.map((item) => item.toJson()).toList(),
      };
      await dbassembly.doc(pemindahan.docId).update(updatedData);
      QuerySnapshot existingTransactions = await dbtransaction
        .where('pemindahan_id', isEqualTo: pemindahan.docId)
        .get();
      for (var doc in existingTransactions.docs) {
        await dbtransaction.doc(doc.id).delete();
      }
      pemindahan.item.forEach((element) async {
        Map<String, dynamic> data = {
          ...element.toJson(),
          "no_faktur": pemindahan.no_po,
          "tanggal": pemindahan.tanggal,
          "type": 'PURCHASES',
          "pemindahan_id": pemindahan.docId,
        };
        await dbtransaction.add(data);
        element.kodeLokasi = gudang;
        Map<String, dynamic> dataOut = {
          ...element.toJson(), 
          "no_faktur": pemindahan.no_po,
          "tanggal": pemindahan.tanggal,
          "type": 'PEMINDAHAN OUT',
          "pemindahan_id": pemindahan.docId,
        };
        await dbtransaction.add(dataOut);
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

  Future<bool> deletePemindahan(String docId, Pemindahan pemindahan) async {
    processing = true;
    notifyListeners(); 
    try {
      await dbassembly.doc(docId).delete();
      pemindahan.item.forEach((element) async {
        var transactionRef = dbtransaction.where("pemindahan_id", isEqualTo: docId);
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