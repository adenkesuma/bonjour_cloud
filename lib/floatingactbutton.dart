import 'package:bonjour/data.dart';
import 'package:flutter/material.dart';

class FloatingActBtn extends StatelessWidget {
  final VoidCallback action;
  final IconData icon;
  const FloatingActBtn({super.key, required this.action, required this.icon});


  @override
  Widget build(BuildContext context) {
    return  Container(
      margin: EdgeInsets.all(5),
      width: 60,
      height: 60,
      child: FloatingActionButton(
        onPressed: action,
        child: Icon(icon, size: 30,),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    );
  }
}