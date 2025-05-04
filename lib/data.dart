import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String namaCompany = 'Company Name';
Color primaryColor = Color(0xFF023f90);
// msi network image
String logoCompany = 'https://raw.githubusercontent.com/Delwinnn/IMG/refs/heads/main/MokuLogo.png';
const apikey = "BONJOURXMOKU";
String linkImg = "https://res.cloudinary.com/dj1kph9pm/image/upload/";
String defaultStockImg = 'v1731230363/public/no-img-available.webp';
String cloudname = "dj1kph9pm";

String formatcurrency (double value) {
  return NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(value);
}