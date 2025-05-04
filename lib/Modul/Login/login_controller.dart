import 'dart:convert';

import 'package:bonjour/Modul/Home/dashboard_view.dart';
import 'package:bonjour/Modul/Login/login_view.dart';
import 'package:bonjour/Model/user_model.dart';
import 'package:bonjour/Provider/cloud_firebase.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController with ChangeNotifier{
  late SharedPreferences pref;
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  bool errname = false;
  bool errpass = false;
  bool obscure = true;
  User user = User();

  // List acc = [
  //   ['EXE','FIN','MAR','PUR','INV'],
  //   ['EXECUTIVE','FINANCE','MARKETING','PURCHASING','INVENTORY'],
  //   ['123','456','123','456','123']
  // ];

  void login() async {
    if (username.text.trim() == "") {
      username.clear();
      password.clear();
      errname = true;
      notifyListeners();
      return;
    };

    User? result = await CloudFirebase().loginAcc(username.text.toUpperCase(), password.text);
    if (result!=null) {
      result.pass = "";
      user = result;
      savePref();
      username.clear();
      password.clear();
      Get.offAll(DashboardView());
      return;
    }
    username.clear();
    password.clear();
    errpass = true;
    notifyListeners();
  }

  void savePref () async {
    pref = await SharedPreferences.getInstance();
    pref.setString('USER',jsonEncode(user));
  }
  Future<void> getPref () async {
    pref = await SharedPreferences.getInstance();
    String tempuser = pref.getString('USER') ?? "";
    user = tempuser!="" ? User.fromJson(jsonDecode(tempuser)) : User();
  }

  void logout() {
    user.status = false;
    savePref();
    Get.offAll(LoginView());
  }

  void onOffSecure () {
    obscure = !obscure;
    notifyListeners();
  }
}
