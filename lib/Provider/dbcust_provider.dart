import 'package:bonjour/Model/customer_model.dart';
import 'package:bonjour/database/database_customer.dart';
import 'package:flutter/material.dart';

class CustomerProvider with ChangeNotifier {
  final CustomerDB _CustomerDB = CustomerDB();
  List<Customer> _customerList = [];

  CustomerProvider() {
    initialize();
  }

  List<Customer> get customerList => _customerList;

  Future<void> initialize() async {
    await _CustomerDB.initialize();
    await fetchCustomer();
  }

  Future<void> fetchCustomer() async {
    _customerList = await _CustomerDB.fetch();
    notifyListeners();
  }

  Future<void> addCustomer(Customer cust) async {
    await _CustomerDB.insert(cust);
    fetchCustomer();
  }

  Future<void> updateCustomer(Customer cust) async {
    await _CustomerDB.update(cust);
    fetchCustomer();
  }

  Future<void> deleteCustomer(String kodeCust) async {
    await _CustomerDB.delete(kodeCust);
    fetchCustomer();
  }
}
