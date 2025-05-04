import 'package:bonjour/Model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CloudFirebase with ChangeNotifier {
  final CollectionReference user = FirebaseFirestore.instance.collection('dbuser');
  final CollectionReference module = FirebaseFirestore.instance.collection('dbmodule');
  bool processuser = false;
  List<User> allUsers = [];
  List<User> filteredUsers = [];

  Future<User?> loginAcc(String nama, String pass) async {
    try {
      QuerySnapshot searchResults = await user
          .where("NAMA", isEqualTo: nama)
          .where("PASSWORD", isEqualTo: pass)
          .get();
      if (searchResults.docs.isNotEmpty) {
        var userData = {
          ...searchResults.docs.first.data() as Map<String, dynamic>,
          'docId': searchResults.docs.first.id,
        };
        return User.fromJson(userData);
      } else {
        return null;
      }
    } catch (e) {
      print("Error : $e");
      return null;
    }
  }

  Future<void> getUser() async {
    try {
      QuerySnapshot querySnapshot = await user.get();
      allUsers = querySnapshot.docs
          .map((doc) => User.fromJson({...doc.data() as Map<String, dynamic>, "docId": doc.id}))
          .toList();
      filteredUsers = List.from(allUsers);
      print(filteredUsers);
      notifyListeners();
    } catch (e) {
      print("Error : $e");
    }
  }

  void filterUsers(String query) {
    filteredUsers = allUsers
        .where((user) =>
            user.username!.toLowerCase().contains(query.toLowerCase()) ||
            (user.namaLengkap ?? "").toLowerCase().contains(query.toLowerCase()))
        .toList();
    notifyListeners();
  }

  Future<bool> deleteUser(String docId) async {
    processuser = true;
    notifyListeners(); 
    try {
      await user.doc(docId).delete();
      await getUser();
      processuser = false;
      notifyListeners(); 
      return true;
    } catch (e) {
      print("Error : $e");
      processuser = false;
      notifyListeners(); 
      return false;
    }
  }

  Future<List> getModule() async {
    try {
      QuerySnapshot querySnapshot = await module.get();
      return querySnapshot.docs
          .map((doc) => (doc.data() as Map<String, dynamic>)['MODULE'] as String)
          .toList();
    } catch (e) {
      print("Error : $e");
      return [];
    }
  }

  Future<bool> editUser(User updatedUser) async {
    processuser = true;
    notifyListeners();
    try {
      Map<String, dynamic> updatedData = {
        'NAMA': updatedUser.username,
        'PASSWORD': updatedUser.pass,
        'TIER': updatedUser.tier,
        'NAMA_LENGKAP': updatedUser.namaLengkap,
        'MODULE': updatedUser.module,
      };
      await user.doc(updatedUser.docId).update(updatedData);
      await getUser();
      processuser = false;
      notifyListeners();
      return true;
    } catch (e) {
      print("Error : $e");
      processuser = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> createUser(User userModel) async {
    processuser = true;
    notifyListeners(); 
    try {
      Map<String, dynamic> userData = {
        'NAMA': userModel.username,
        'PASSWORD': userModel.pass,
        'TIER': userModel.tier,
        'NAMA_LENGKAP': userModel.namaLengkap,
        'MODULE': userModel.module,
      };
      await user.add(userData);
      processuser = false;
      await getUser();
      notifyListeners(); 
      return true;
    } catch (e) {
      print("Error : $e");
      processuser = false;
      notifyListeners(); 
      return false;
    }
  }
}
