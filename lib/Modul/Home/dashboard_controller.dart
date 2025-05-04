import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DashboardController with ChangeNotifier {
  final CollectionReference dbtransaction =
      FirebaseFirestore.instance.collection('dbtransaction');

  Map<String, double> data = {};


  Future<Map<String, double>> fetchData() async {
    // Initialize sales data for each day of the week
    Map<String, double> salesData = {
      'Mon': 0,
      'Tue': 0,
      'Wed': 0,
      'Thu': 0,
      'Fri': 0,
      'Sat': 0,
      'Sun': 0,
    };

    try {
      print("Fetching transactions from Firestore...");
      QuerySnapshot queryTrans = await dbtransaction.get();

      DateTime now = DateTime.now();

      for (var element in queryTrans.docs) {
        var data = element.data() as Map<String, dynamic>;
        if (data['type'] == "SALES") {
          DateTime transDate = (data['tanggal'] as Timestamp).toDate();
          double totalInvoice = (data['jumlah'] as num).toDouble();
          int difference = now.difference(transDate).inDays;
          if (difference >= 0 && difference < 7) {
            String day = DateFormat('EEE').format(transDate);
            salesData[day] = (salesData[day] ?? 0) + totalInvoice;
          }
        }
      }
      data = salesData;

      notifyListeners();
      return salesData;
    } catch (e) {
      print("Error fetching data: $e");
      return salesData; // Return current state of salesData on error
    }
  }

  Future<Map<String, double>> fetchDatas() async {
    // Initialize sales data for each day of the week
    Map<String, double> salesData = {
      'Mon': 0,
      'Tue': 0,
      'Wed': 0,
      'Thu': 0,
      'Fri': 0,
      'Sat': 0,
      'Sun': 0,
    };

    try {
      print("Fetching transactions from Firestore...");
      QuerySnapshot queryTrans = await dbtransaction.get();

      DateTime now = DateTime.now();

      for (var element in queryTrans.docs) {
        var data = element.data() as Map<String, dynamic>;
        print("Processing document: $data");  // Check document format
        if (data.containsKey('tanggal') && data.containsKey('jumlah')) {
          try {
            DateTime transactionDate = (data['tanggal'] as Timestamp).toDate();
            double totalInvoice = (data['jumlah'] as num).toDouble();

            int difference = now.difference(transactionDate).inDays;

            // Check if the transaction falls within the last 7 days
            if (difference >= 0 && difference < 7) {
              String day = DateFormat('EEE').format(transactionDate); // e.g., Mon, Tue
              salesData[day] = (salesData[day] ?? 0) + totalInvoice;
            }
          } catch (e) {
            print("Data parsing error: $e");
          }
        } else {
          print("Invalid data format: $data");
        }
      }

      print("Sales data: $salesData"); // Log final data
      data = salesData;
      notifyListeners();
      return salesData;
    } catch (e) {
      print("Error fetching data: $e");
      return salesData; // Return current state of salesData on error
    }
  }

}
