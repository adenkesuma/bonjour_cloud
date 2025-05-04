class Supplier {
  String kodeSupplier;
  String namaSupplier;
  String? email;
  String? alamat;
  String? noTelp;
  String? docId;

  Supplier({
    required this.kodeSupplier, 
    required this.namaSupplier, 
    this.email, 
    this.alamat, 
    this.noTelp, 
    this.docId
});

  factory Supplier.fromJson(Map<String, dynamic> json) {
    return Supplier(
      kodeSupplier: json['KODE_SUPPLIER'] as String, 
      namaSupplier: json['NAMA_SUPPLIER'] as String,
      email: json['EMAIL'] as String,
      alamat: json['ALAMAT'] as String,
      noTelp: json['NOTELP'] as String,  
      docId: json['docId'] ?? "" as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'KODE_SUPPLIER': kodeSupplier,
      'NAMA_SUPPLIER': namaSupplier,
      'EMAIL': email,      
      'ALAMAT': alamat,
      'NOTELP': noTelp,
    };
  }
}