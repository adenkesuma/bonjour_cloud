import 'package:bonjour/Modul/Customer/customer_controller.dart';
import 'package:bonjour/Modul/Gudang/gudang_controller.dart';
import 'package:bonjour/Modul/Home/dashboard_controller.dart';
import 'package:bonjour/Modul/Login/login_controller.dart';
import 'package:bonjour/Modul/Login/splash_view.dart';
import 'package:bonjour/Modul/Pelunasan/pelunasan_controller.dart';
import 'package:bonjour/Modul/Pembelian/pembelian_controller.dart';
import 'package:bonjour/Modul/Pemindahan/pemindahan_controller.dart';
import 'package:bonjour/Modul/Penjualan/penjualan_controller.dart';
import 'package:bonjour/Modul/Stock/stock_controller.dart';
import 'package:bonjour/Modul/Supplier/supplier_controller.dart';
import 'package:bonjour/Provider/cloud_firebase.dart';
import 'package:bonjour/Provider/dbcust_provider.dart';
import 'package:bonjour/locale_provider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize().then((InitializationStatus status) {});

  await Firebase.initializeApp();

  AwesomeNotifications().initialize(
    null, 
    [
      NotificationChannel(
        channelKey: 'basic_channel',
        channelName: 'Notifikasi Dasar',
        channelDescription: 'Notifikasi untuk tugas berat',
        defaultColor: Colors.blue,
        importance: NotificationImportance.High,
        ledColor: Colors.white,
      ),
    ],
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => LoginController()),
        ChangeNotifierProvider(create: (context) => StockController()),
        ChangeNotifierProvider(create: (context) => DashboardController()),
        ChangeNotifierProvider(create: (context) => PenjualanController()),
        ChangeNotifierProvider(create: (context) => PembelianController()),
        ChangeNotifierProvider(create: (context) => PemindahanController()),
        ChangeNotifierProvider(create: (context) => GudangController()),
        ChangeNotifierProvider(create: (context) => PelunasanController()),
        ChangeNotifierProvider(create: (context) => SupplierController()),
        ChangeNotifierProvider(create: (context) => CustomerController()),
        ChangeNotifierProvider(create: (context) => CustomerProvider()),
        ChangeNotifierProvider(create: (context) => CloudFirebase()),
        ChangeNotifierProvider(create: (context) => LocaleProvider()),
      ],
      child: MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      locale: Provider.of<LocaleProvider>(context).locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
