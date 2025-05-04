class Gudang {
  String kodeGudang;
  String namaGudang;
  String? alamat;
  String? kepalaGudang;
  String? docId;

  Gudang({
    required this.kodeGudang, 
    required this.namaGudang, 
    this.alamat, 
    this.kepalaGudang, 
    this.docId
  });
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Gudang && other.kodeGudang == kodeGudang;
  }

  @override
  int get hashCode => kodeGudang.hashCode;

  factory Gudang.fromJson(Map<String, dynamic> json) {
    return Gudang(
      kodeGudang: json['KODE_GUDANG'] as String, 
      namaGudang: json['NAMA_GUDANG'] as String,
      alamat: json['ALAMAT'] ?? "" as String,
      kepalaGudang: json['KEPALA_GUDANG'] ?? "" as String,
      docId: json['docId'] ?? "" as String
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'KODE_GUDANG': kodeGudang,
      'NAMA_GUDANG': namaGudang,
      'ALAMAT': alamat,
      'KEPALA_GUDANG': kepalaGudang,
    };
  }
}