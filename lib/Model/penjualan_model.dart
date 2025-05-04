import 'package:cloud_firestore/cloud_firestore.dart';

class Penjualan {
  String no_po;
  String customer;
  String customerName;
  DateTime tanggal;
  List<dynamic> item;
  double jumlah;
  bool status;
  bool bayar;
  String? docId;

  Penjualan({
    required this.no_po, 
    required this.customer, 
    required this.customerName, 
    required this.tanggal, 
    required this.item, 
    required this.jumlah,
    required this.status,
    this.bayar = false,
    this.docId,
});

  factory Penjualan.fromJson(Map<String, dynamic> json) {
    final timestamp = json['tanggal'];
    DateTime dateTime;

    if (timestamp is Timestamp) {
      dateTime = timestamp.toDate();
    } else if (timestamp is String) {
      dateTime = DateTime.parse(timestamp);
    } else {
      dateTime = DateTime.now();
    }

    return Penjualan(
      no_po: json['no_po'] as String, 
      customer: json['customer'] ?? "" as String,
      customerName: json['customerName'] ?? "" as String,
      tanggal: dateTime,
      item: json['item'] as List<dynamic>,
      jumlah: json['jumlah'].toDouble() ?? 0.0 as double,
      status: json['status'] as bool,
      bayar: json['bayar'] ?? false as bool,
      docId: json['docId'] ?? "" as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'no_po': no_po,
      'customer': customer,
      'tanggal': tanggal,
      'item': item,
      'jumlah': jumlah,
      'status': status,
      'bayar': bayar,
    };
  }
}