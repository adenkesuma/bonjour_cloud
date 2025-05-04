import 'package:bonjour/Model/customer_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CustomerController with ChangeNotifier {
  final CollectionReference dbcustomer =
      FirebaseFirestore.instance.collection('dbcustomer');

  List<Customer> dataCustomer = [];
  List<Customer> filteredCustomer = [];
  bool fetching = false;
  bool processing = false;

  Future<void> fetchData() async {
    try {
      QuerySnapshot querySnapshot = await dbcustomer.get();
      dataCustomer = querySnapshot.docs
          .map((doc) => Customer.fromJson(
              {...doc.data() as Map<String, dynamic>, "docId": doc.id}))
          .toList();
      filteredCustomer = List.from(dataCustomer);
      print(filteredCustomer);
      notifyListeners();
    } catch (e) {
      print("Error : $e");
    }
  }

  Future<Customer> getCustomer(String kodeCust) async {
    try {
      QuerySnapshot querySnapshot = await dbcustomer
          .where('KODE_CUSTOMER', isEqualTo: kodeCust)
          .limit(1)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        var customerData = querySnapshot.docs.first.data() as Map<String, dynamic>;
        return Customer.fromJson(customerData);
      } else {
        throw Exception('Customer not found');
      }
    } catch (e) {
      throw Exception('Error fetching customer: $e');
    }
  }

  void filterCustomer(String query) {
    if (query.isEmpty) {
      filteredCustomer = List.from(dataCustomer);
    } else {
      filteredCustomer = dataCustomer.where((customer) {
        return customer.namaCustomer
                .toLowerCase()
                .contains(query.toLowerCase()) ||
            customer.kodeCustomer.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
    notifyListeners();
  }

  Future<bool> addNewCustomer(Customer customer) async {
    processing = true;
    notifyListeners();
    try {
      Map<String, dynamic> customerData = {...customer.toJson()};
      await dbcustomer.add(customerData);
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

  Future<bool> updateCustomer(Customer customer) async {
    processing = true;
    notifyListeners();
    try {
      Map<String, dynamic> updatedData = {...customer.toJson()};
      await dbcustomer.doc(customer.docId).update(updatedData);
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

  Future<bool> deleteCustomer(String docId) async {
    processing = true;
    notifyListeners();
    try {
      await dbcustomer.doc(docId).delete();
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
