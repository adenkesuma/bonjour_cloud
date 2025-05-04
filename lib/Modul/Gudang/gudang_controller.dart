import 'package:bonjour/Model/gudang_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GudangController with ChangeNotifier{
  final CollectionReference dbgudang = FirebaseFirestore.instance.collection('dbgudang');

  List<Gudang> dataGudang = [];
  List<Gudang> filteredGudang = [];
  bool fetching = false;
  bool processing = false;
 
  Future<void> fetchData() async {
    try {
      QuerySnapshot querySnapshot = await dbgudang.get();
      dataGudang = querySnapshot.docs
          .map((doc) => Gudang.fromJson({...doc.data() as Map<String, dynamic>, "docId": doc.id}))
          .toList();
      filteredGudang = List.from(dataGudang);
      notifyListeners();
    } catch (e) {
      print("Error : $e");
    }
  }

  Future<Gudang> getGudang(String kodeGudang) async {
    try {
      QuerySnapshot querySnapshot = await dbgudang
          .where('KODE_GUDANG', isEqualTo: kodeGudang)
          .limit(1)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        var gudangData = querySnapshot.docs.first.data() as Map<String, dynamic>;
        return Gudang.fromJson(gudangData);
      } else {
        throw Exception('Gudang not found');
      }
    } catch (e) {
      throw Exception('Error fetching gudang: $e');
    }
  }

  void filterGudangs(String query) {
    if (query.isEmpty) {
      filteredGudang = List.from(dataGudang);
    } else {
      filteredGudang = dataGudang.where((gudang) {
        return gudang.namaGudang.toLowerCase().contains(query.toLowerCase()) ||
            gudang.kodeGudang.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
    notifyListeners();
  }

  Future<bool> addNewGudang(Gudang gudang) async {
    processing = true;
    notifyListeners(); 
    try {
      Map<String, dynamic> gudangdata = {...gudang.toJson()};
      await dbgudang.add(gudangdata);
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
      await dbgudang.doc(gudang.docId).update(updatedData);
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
      await dbgudang.doc(docId).delete();
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
