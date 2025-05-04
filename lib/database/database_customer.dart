import 'dart:async';
import 'package:bonjour/Model/customer_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class CustomerDB {
  String tableName = "customer";
  String columnKode = "kodeCust";
  String columnNama = "namaCust";
  String columnEmail = "email";
  String columnAlamat = "alamat";
  String columnTelp = "noTelp";
  Database? _database;

  Future<void> initialize() async {
    _database = await _initDatabase("customer.db");
  }

  Future<Database> _initDatabase(String dbName) async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, dbName);
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await createTable(db);
      },
    );
  }

  Future<void> createTable(Database db) async {
    await db.execute(
        'CREATE TABLE $tableName ($columnKode TEXT PRIMARY KEY, $columnNama TEXT, $columnEmail TEXT, $columnAlamat TEXT, $columnTelp TEXT)');
  }

  Future<List<Customer>> fetch() async {
    if (_database == null) {
      throw Exception("Database not initialized.");
    }
    List data = await _database!.query(tableName);
    return data.map((e) {
      return Customer(
        kodeCustomer: e["kodeCust"],
        namaCustomer: e["namaCust"],
        email: e["email"],
        alamat: e["alamat"],
        noTelp: e["noTelp"],
      );
    }).toList();
  }

  Future<int> insert(Customer cust) async {
    if (_database == null) {
      throw Exception("Database not initialized.");
    }
    return await _database!.insert(
        tableName, {"kodeCust": cust.kodeCustomer, "namaCust": cust.namaCustomer, "email": cust.email, "alamat": cust.alamat, "noTelp": cust.noTelp});
  }

  Future<int> update(Customer cust) async {
    if (_database == null) {
      throw Exception("Database not initialized.");
    }
    return await _database!.update(
        tableName, {"kodeCust": cust.kodeCustomer, "namaCust": cust.namaCustomer, "email": cust.email, "alamat": cust.alamat, "noTelp": cust.noTelp},
        where: "kodeCust = ?", whereArgs: [cust.kodeCustomer]);
  }

  Future<int> delete(String kodeCust) async {
    if (_database == null) {
      throw Exception("Database not initialized.");
    }
    return await _database!.delete(tableName, where: "kodeCust = ?", whereArgs: [kodeCust]);
  }
}
