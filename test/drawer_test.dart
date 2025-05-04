import 'package:bonjour/drawer_for_test.dart';
import 'package:bonjour/locale_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bonjour/Modul/Login/login_controller.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  late LoginController loginCtrl;
  late LocaleProvider localeCtrl;

  setUp(() {
    loginCtrl = LoginController();
    localeCtrl = LocaleProvider();

    loginCtrl.user.username = "DW";
    loginCtrl.user.tier = "DEVELOPER";
    loginCtrl.user.module = [
      "USER", "PEMBELIAN", "PELUNASAN", "GUDANG", "PENJUALAN", "STOCK",
      "CUSTOMER", "SUPPLIER", "PEMINDAHAN", "PREMIUM"
    ];
    localeCtrl.locale = Locale('en');
  });

  testWidgets('Drawer menampilkan Username dan Tier', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => loginCtrl),
          ChangeNotifierProvider(create: (context) => localeCtrl),
        ],
        child: MaterialApp(
          locale: localeCtrl.locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            appBar: AppBar(title: Text('Test App')),
            drawer: MainDrawerTest(),
            body: Center(child: Text('Test Body')),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.menu), findsOneWidget);
    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();
    expect(find.text('DW'), findsOneWidget);
    expect(find.text('DEVELOPER'), findsOneWidget);
  });

  testWidgets('Drawer menampilkan sub Menu', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => loginCtrl),
          ChangeNotifierProvider(create: (context) => localeCtrl),
        ],
        child: MaterialApp(
          locale: localeCtrl.locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            appBar: AppBar(title: Text('Test App')),
            drawer: MainDrawerTest(),
            body: Center(child: Text('Test Body')),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.menu), findsOneWidget);
    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();
    expect(find.text('Dashboard'), findsOneWidget);
    expect(find.text('Base'), findsOneWidget);
    expect(find.text('Transactions'), findsOneWidget);
    expect(find.text('Payments'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);
    expect(find.text('Logout'), findsOneWidget);
  });

  testWidgets('Drawer ubah bahasa ke Indonesia dan menampilkan sub menu indonesia', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => loginCtrl),
          ChangeNotifierProvider(create: (context) => localeCtrl),
        ],
        child: MaterialApp(
          locale: Locale("id"),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            appBar: AppBar(title: Text('Test App')),
            drawer: MainDrawerTest(),
            body: Center(child: Text('Test Body')),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();
    expect(find.text('Beranda'), findsOneWidget);
    expect(find.text('Dasar'), findsOneWidget);
    expect(find.text('Transaksi'), findsOneWidget);
    expect(find.text('Pelunasan'), findsOneWidget);
    expect(find.text('Pengaturan'), findsOneWidget);
    expect(find.text('Keluar'), findsOneWidget);
  });

  testWidgets('Tampilkan List Menu dari Menu Base', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => loginCtrl),
          ChangeNotifierProvider(create: (context) => localeCtrl),
        ],
        child: MaterialApp(
          locale: localeCtrl.locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            appBar: AppBar(title: Text('Test App')),
            drawer: MainDrawerTest(),
            body: Center(child: Text('Test Body')),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.menu), findsOneWidget);
    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Base'));
    await tester.pumpAndSettle();
    expect(find.text('Customer'), findsOneWidget);
    expect(find.text('Supplier'), findsOneWidget);
    expect(find.text('Stock'), findsOneWidget);
    expect(find.text('Warehouse'), findsOneWidget);
  });

  testWidgets('Tampilkan List Menu dari Menu Transactions', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => loginCtrl),
          ChangeNotifierProvider(create: (context) => localeCtrl),
        ],
        child: MaterialApp(
          locale: localeCtrl.locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            appBar: AppBar(title: Text('Test App')),
            drawer: MainDrawerTest(),
            body: Center(child: Text('Test Body')),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.menu), findsOneWidget);
    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Transactions'));
    await tester.pumpAndSettle();
    expect(find.text('Sales'), findsOneWidget);
    expect(find.text('Purchases'), findsOneWidget);
    expect(find.text('Assembly'), findsOneWidget);
  });

  testWidgets('Tampilkan List Menu dari Menu Settings', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => loginCtrl),
          ChangeNotifierProvider(create: (context) => localeCtrl),
        ],
        child: MaterialApp(
          locale: localeCtrl.locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            appBar: AppBar(title: Text('Test App')),
            drawer: MainDrawerTest(),
            body: Center(child: Text('Test Body')),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.menu), findsOneWidget);
    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();
    expect(find.text('User'), findsOneWidget);
  });
}
