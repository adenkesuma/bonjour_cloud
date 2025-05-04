import 'package:bonjour/Modul/Customer/customer_view.dart';
import 'package:bonjour/Modul/Gudang/gudang_view.dart';
import 'package:bonjour/Modul/Home/dashboard_view.dart';
import 'package:bonjour/Modul/Login/login_controller.dart';
import 'package:bonjour/Modul/Pelunasan/pelunasan_view.dart';
import 'package:bonjour/Modul/Pembelian/pembelian_view.dart';
import 'package:bonjour/Modul/Pemindahan/pemindahan_view.dart';
import 'package:bonjour/Modul/Penjualan/penjualan_view.dart';
import 'package:bonjour/Modul/Stock/stock_view.dart';
import 'package:bonjour/Modul/Supplier/supplier_view.dart';
import 'package:bonjour/Modul/User/user_view.dart';
import 'package:bonjour/analytic_helper.dart';
import 'package:bonjour/data.dart';
import 'package:bonjour/locale_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class MainDrawer extends StatefulWidget {
  @override
  State<MainDrawer> createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  MyAnalyticsHelper analytic = MyAnalyticsHelper();

  @override
  Widget build(BuildContext context) {
    final loginCtrl = Provider.of<LoginController>(context, listen: false);
    final localeCtrl = Provider.of<LocaleProvider>(context);
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: primaryColor,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage('${logoCompany}')),
                      borderRadius: BorderRadius.circular(100)),
                  width: 100,
                  height: 100,
                ),
                SizedBox(
                  width: 20,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${loginCtrl.user.username}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 23,
                      ),
                    ),
                    Text(
                      '${loginCtrl.user.tier}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                      ),
                    ),
                    SizedBox(height: 10,),
                    Center(
                      child: Container(
                        width: 60,
                        height: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(color: Colors.blue, width: 2),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  localeCtrl.changeLanguage(Locale("en"));
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: localeCtrl.locale==Locale("en") ? Colors.blue : Colors.white,
                                    borderRadius: BorderRadius.horizontal(
                                      left: Radius.circular(25),
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    "EN",
                                    style: TextStyle(
                                      color: localeCtrl.locale==Locale("en") ? Colors.white : Colors.blue,
                                      fontWeight: FontWeight.bold, fontSize: 14
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  localeCtrl.changeLanguage(Locale("id"));
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: localeCtrl.locale!=Locale('en') ? Colors.blue : Colors.white,
                                    borderRadius: BorderRadius.horizontal(
                                      right: Radius.circular(25),
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    "ID",
                                    style: TextStyle(
                                      color: localeCtrl.locale!=Locale('en') ? Colors.white : Colors.blue,
                                      fontWeight: FontWeight.bold,fontSize: 14
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.home, color: primaryColor),
                    title: Text(AppLocalizations.of(context)!.dashboard),
                    onTap: () {
                      analytic.navigatorEvent("Dashboard");
                      Get.offAll(DashboardView());
                    },
                  ),
                  ExpansionTile(
                    leading: Icon(Icons.menu_book, color: primaryColor),
                    childrenPadding:
                        EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                    title: Text(AppLocalizations.of(context)!.base),
                    children: [
                      if (loginCtrl.user.module!.contains("CUSTOMER"))
                      ListTile(
                        leading: Icon(
                          Icons.group,
                          color: primaryColor,
                        ),
                        title: Text(AppLocalizations.of(context)!.customer),
                        onTap: () {
                          analytic.navigatorEvent("Customer");
                          Get.offAll(CustomerView());
                        },
                      ),
                      if (loginCtrl.user.module!.contains("SUPPLIER"))
                      ListTile(
                        leading: Icon(
                          Icons.group,
                          color: primaryColor,
                        ),
                        title: Text(AppLocalizations.of(context)!.supplier),
                        onTap: () {
                          analytic.navigatorEvent("Supplier");
                          Get.offAll(SupplierView());
                        },
                      ),
                      if (loginCtrl.user.module!.contains("STOCK"))
                      ListTile(
                        leading: Icon(
                          Icons.warehouse,
                          color: primaryColor,
                        ),
                        title: Text(AppLocalizations.of(context)!.stock),
                        onTap: () {
                          analytic.navigatorEvent("Stock");
                          Get.offAll(StockView());
                        },
                      ),
                      if (loginCtrl.user.module!.contains("GUDANG"))
                      ListTile(
                        leading: Icon(
                          Icons.store,
                          color: primaryColor,
                        ),
                        title: Text(AppLocalizations.of(context)!.gudang),
                        onTap: () {
                          analytic.navigatorEvent("Gudang");
                          Get.offAll(GudangView());
                        },
                      ),
                    ],
                  ),
                  ExpansionTile(
                    leading: Icon(Icons.monetization_on, color: primaryColor),
                    childrenPadding:
                        EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                    title: Text(AppLocalizations.of(context)!.transaksi),
                    children: [
                      if (loginCtrl.user.module!.contains("PENJUALAN"))
                      ListTile(
                        leading: Icon(Icons.receipt_long, color: primaryColor),
                        title: Text(AppLocalizations.of(context)!.penjualan),
                        onTap: () {
                          analytic.navigatorEvent("Penjualan");
                          Get.offAll(PenjualanView());
                        },
                      ),
                      if (loginCtrl.user.module!.contains("PEMBELIAN"))
                      ListTile(
                        leading: Icon(Icons.receipt_long, color: primaryColor),
                        title: Text(AppLocalizations.of(context)!.pembelian),
                        onTap: () {
                          analytic.navigatorEvent("Pembelian");
                          Get.offAll(PembelianView());
                        },
                      ),
                      if (loginCtrl.user.module!.contains("PEMINDAHAN"))
                      ListTile(
                        leading: Icon(Icons.receipt_long, color: primaryColor),
                        title: Text(AppLocalizations.of(context)!.pemindahan),
                        onTap: () {
                          analytic.navigatorEvent("Pemindahan");
                          Get.offAll(PemindahanView());
                        },
                      ),
                    ],
                  ),
                  if (loginCtrl.user.module!.contains("PELUNASAN"))
                  ListTile(
                    leading: Icon(Icons.payments, color: primaryColor),
                    title: Text(AppLocalizations.of(context)!.pelunasan),
                    onTap: () {
                      analytic.navigatorEvent("Pelunasan");
                      Get.offAll(PelunasanView());
                    },
                  ),
                  ExpansionTile(
                    leading: Icon(Icons.settings, color: primaryColor),
                    childrenPadding:
                        EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                    title: Text(AppLocalizations.of(context)!.settings),
                    children: [
                      if (loginCtrl.user.module!.contains("USER"))
                      ListTile(
                        leading: Icon(
                          Icons.person,
                          color: primaryColor,
                        ),
                        title: Text(AppLocalizations.of(context)!.user),
                        onTap: () {
                          analytic.navigatorEvent("User");
                          Get.offAll(UserView());
                        },
                      ),
                    ],
                  ),
                  ListTile(
                    leading: Icon(Icons.logout),
                    title: Text(AppLocalizations.of(context)!.logout),
                    textColor: Colors.red,
                    iconColor: Colors.red,
                    onTap: () {
                      analytic.navigatorEvent("Logout");
                      loginCtrl.logout();
                    }
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
