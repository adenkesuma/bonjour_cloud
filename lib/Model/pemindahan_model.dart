import 'package:cloud_firestore/cloud_firestore.dart';

class Pemindahan {
  String no_po;
  String gudang;
  String gudangName;
  DateTime tanggal;
  List<dynamic> item;
  double jumlah;
  bool status;
  String? docId;

  Pemindahan({
    required this.no_po, 
    required this.gudang, 
    required this.gudangName, 
    required this.tanggal, 
    required this.item, 
    required this.jumlah,
    required this.status,
    this.docId,
});

  factory Pemindahan.fromJson(Map<String, dynamic> json) {
    final timestamp = json['tanggal'];
    DateTime dateTime;

    if (timestamp is Timestamp) {
      dateTime = timestamp.toDate();
    } else if (timestamp is String) {
      dateTime = DateTime.parse(timestamp);
    } else {
      dateTime = DateTime.now();
    }

    return Pemindahan(
      no_po: json['no_po'] as String, 
      gudang: json['gudang'] ?? "" as String,
      gudangName: json['gudangName'] ?? "" as String,
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
      'gudang': gudang,
      'tanggal': tanggal,
      'item': item,
      'jumlah': jumlah,
      'status': status,
    };
  }
}