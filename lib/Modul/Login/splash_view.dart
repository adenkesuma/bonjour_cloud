import 'dart:async';

import 'package:bonjour/Modul/Home/dashboard_view.dart';
import 'package:bonjour/Modul/Login/login_controller.dart';
import 'package:bonjour/Modul/Login/login_view.dart';
import 'package:bonjour/data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  
  @override
  void initState() {
    super.initState();
    initialize();
  }

  Future<void> initialize() async {
    final loginCtrl = Provider.of<LoginController>(context, listen: false);
    await loginCtrl.getPref();
    if (loginCtrl.user.status) {
      Get.offAll(DashboardView());
    } else {
      Get.offAll(LoginView());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        color: primaryColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage('${logoCompany}')
                )
              ),
            ),
            SizedBox(height: 20),
            CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 5,
            )
          ],
        ),
      ),
    );
  }
}