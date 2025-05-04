import 'dart:convert';
import 'dart:io';
import 'package:bonjour/Model/stock_model.dart';
import 'package:bonjour/data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class StockController with ChangeNotifier {
  final CollectionReference dbstock = FirebaseFirestore.instance.collection('dbstock');
  final CollectionReference dbtransaction = FirebaseFirestore.instance.collection('dbtransaction');

  List<Stock> dataStock = [];
  bool fetching = false;
  bool processing = false;

  List<Stock> filteredStock = [];

  Future<void> fetchData() async {
    try {
      QuerySnapshot querySnapshot = await dbstock.get();
      QuerySnapshot queryTrans = await dbtransaction.get();
      dataStock = querySnapshot.docs
          .map((doc) => Stock.fromJson({...doc.data() as Map<String, dynamic>, "docId": doc.id}))
          .toList();
      int? posmin;
      queryTrans.docs.forEach((element) {
        if (element['type']=="SALES") {
          posmin = -1;
        } else if (element['type']=="PURCHASES") {
          posmin = 1;
        } else if (element['type']=="PEMINDAHAN IN") {
          posmin = 1;
        } else if (element['type']=="PEMINDAHAN OUT") {
          posmin = -1;
        }
         for (var stock in dataStock) {
          if (stock.kodeStock == element['kode barang']) {
            // Ensure per-location map is initialized
            stock.perloc ??= {};

            // Update the stock for the specific location
            String location = element['kode lokasi']; // Replace with the actual location key
            stock.perloc![location] = (stock.perloc![location] ?? 0) +
                (posmin! * (element['qty'] ?? 0));

            // Recalculate currentstock as the sum of all per-location stock
            stock.currentstock = stock.perloc!.values.fold(0, (sum, value) => sum + value);
            break;
          }
        }
      });
      dataStock.forEach((element) {
        element.currentstock += element.saldoAwal;
      });
      filteredStock = List.from(dataStock);
      notifyListeners();
    } catch (e) {
      print("Error : $e");
    }
    
  }

  Future<Stock> getStock(String kodeStock) async {
    try {
      QuerySnapshot querySnapshot = await dbstock
          .where('KODE_STOCK', isEqualTo: kodeStock)
          .limit(1)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        var stockData = querySnapshot.docs.first.data() as Map<String, dynamic>;
        return Stock.fromJson(stockData);
      } else {
        throw Exception('stock not found');
      }
    } catch (e) {
      throw Exception('Error fetching stock: $e');
    }
  }

  void filterStocks(String query) {
    if (query.isEmpty) {
      filteredStock = List.from(dataStock);
    } else {
      filteredStock = dataStock.where((stock) {
        return stock.namaStock.toLowerCase().contains(query.toLowerCase()) ||
            stock.kodeStock.toLowerCase().contains(query.toLowerCase()) ||
            stock.kodeJenisProduk.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
    notifyListeners();
  }

  Future<String> uploadImage(File? imageFile) async {
    final url = Uri.parse("https://api.cloudinary.com/v1_1/$cloudname/upload");
    final req = http.MultipartRequest('POST', url)
    ..fields['upload_preset'] = 'nr2ebs90'
    ..files.add(await http.MultipartFile.fromPath('file', imageFile!.path));
    final resp = await req.send();
    if (resp.statusCode == 200) {
      final respData = await resp.stream.toBytes();
      final respString = String.fromCharCodes(respData);
      final jsondecode = json.decode(respString);
      final fulllink = Uri.parse(jsondecode['url']);
      String imgurl = '${fulllink.pathSegments[fulllink.pathSegments.length - 2]}/${fulllink.pathSegments.last}';
      return imgurl;
    }
    else {
      return "";
    }
  }

   Future<bool> addNewStock(Stock stock) async {
    processing = true;
    notifyListeners(); 
    try {
      Map<String, dynamic> stockdata = {...stock.toJson()};
      await dbstock.add(stockdata);
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
    // final url = Uri.parse('https://api-bonjour.netlify.app/.netlify/functions/server/stocks');
    // try {
    //   final response = await http.post(
    //     url,
    //     headers: {
    //       'Content-Type': 'application/json',
    //     },
    //     body: json.encode({...stock.toJson(),'token':apikey}),
    //   );
    //   if (response.statusCode == 201) {
    //     print('Stock created: ${response.body}');
    //     await fetchData();
    //     processing = false;
    //     notifyListeners();
    //     return true;
    //   } else {
    //     print('Failed to create stock: ${response.body}');
    //     processing = false;
    //     notifyListeners();
    //     return false;
    //   }
    // } catch (e) {
    //   print("Error: $e");
    //   processing = false;
    //   notifyListeners();
    //   return false;
    // }
  }

  Future<bool> updateStock(Stock stock) async {
    processing = true;
    notifyListeners();
    try {
      Map<String, dynamic> updatedData = {...stock.toJson()};
      await dbstock.doc(stock.docId).update(updatedData);
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
    // try {
    //   final response = await http.patch(
    //     Uri.parse('https://api-bonjour.netlify.app/.netlify/functions/server/stocks/$kodeStock'),
    //     headers: {'Content-Type': 'application/json'},
    //     body: json.encode({...stock.toJson(), "token":apikey}),
    //   );

    //   if (response.statusCode == 200) {
    //     print('Stock edited: ${response.body}');
    //     await fetchData();
    //     processing = false;
    //     notifyListeners();
    //     return true;
    //   } else {
    //     print(response.body);
    //     processing = false;
    //     notifyListeners();
    //     return false;
    //   }
    // } catch (e) {
    //   print('errr');
    //   processing = false;
    //   notifyListeners();
    //   return false;
    // }
  }  

  Future<bool> deleteStock(String docId) async {
    processing = true;
    notifyListeners(); 
    try {
      await dbstock.doc(docId).delete();
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
    // processing = true;
    // notifyListeners(); 

    // try {
    //   final response = await http.delete(Uri.parse('https://api-bonjour.netlify.app/.netlify/functions/server/stocks/${kodeStock}'),body: {'token':apikey});
    //   if (response.statusCode != 200) {
    //     print('Fail to delete stock');
    //     processing = false;
    //     notifyListeners();
    //     return false;
    //   } else {
    //     await fetchData();
    //     print('Delete successful');
    //     processing = false;
    //     notifyListeners();
    //     return true;
    //   }
    // } catch (e) {
    //   print("Error: $e");
    //   processing = false;
    //   notifyListeners();
    //   return false;
    // }
  }



}
