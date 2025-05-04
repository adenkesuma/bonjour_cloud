class Item {
  String kodeStock;
  String namaStock;
  dynamic kodeLokasi;
  double qty;
  double harga;
  double jumlah;

  Item({
    required this.kodeStock,
    required this.namaStock,
    required this.kodeLokasi,
    required this.qty,
    required this.harga,
    required this.jumlah,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      kodeStock: json['kode barang'] as String,
      namaStock: json['nama barang'] as String,
      kodeLokasi: json['kode lokasi'] as dynamic,
      qty: json['qty'].toDouble() as double,
      harga: json['harga'].toDouble() as double,
      jumlah: json['jumlah'].toDouble() as double,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'kode barang': kodeStock,
      'nama barang': namaStock,
      'kode lokasi': kodeLokasi.kodeGudang,
      'qty': qty,
      'harga': harga,
      'jumlah': jumlah,
    };
  }
}
