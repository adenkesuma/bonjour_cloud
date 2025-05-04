import 'package:cloud_firestore/cloud_firestore.dart';

class Pembelian {
  String no_po;
  String supplier;
  String supplierName;
  DateTime tanggal;
  List<dynamic> item;
  double jumlah;
  bool status;
  String? docId;

  Pembelian({
    required this.no_po, 
    required this.supplier, 
    required this.supplierName, 
    required this.tanggal, 
    required this.item, 
    required this.jumlah,
    required this.status,
    this.docId,
});

  factory Pembelian.fromJson(Map<String, dynamic> json) {
    final timestamp = json['tanggal'];
    DateTime dateTime;

    if (timestamp is Timestamp) {
      dateTime = timestamp.toDate();
    } else if (timestamp is String) {
      dateTime = DateTime.parse(timestamp);
    } else {
      dateTime = DateTime.now();
    }

    return Pembelian(
      no_po: json['no_po'] as String, 
      supplier: json['supplier'] ?? "" as String,
      supplierName: json['supplierName'] ?? "" as String,
      tanggal: dateTime,
      item: json['item'] as List<dynamic>,
      jumlah: json['jumlah'].toDouble() ?? 0.0 as double,
      status: json['status'] as bool,
      docId: json['docId'] ?? "" as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'no_po': no_po,
      'supplier': supplier,
      'tanggal': tanggal,
      'item': item,
      'jumlah': jumlah,
      'status': status,
    };
  }
}