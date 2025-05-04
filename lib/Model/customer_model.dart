class Customer {
  String kodeCustomer;
  String namaCustomer;
  String? email;
  String? alamat;
  String? noTelp;
  String? docId;


  Customer({
    required this.kodeCustomer, 
    required this.namaCustomer, 
    this.email, 
    this.alamat, 
    this.noTelp, 
    this.docId
});

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      kodeCustomer: json['KODE_CUSTOMER'] as String, 
      namaCustomer: json['NAMA_CUSTOMER'] as String,
      email: json['EMAIL'] as String,
      alamat: json['ALAMAT'] as String,
      noTelp: json['NOTELP'] as String, 
      docId: json['docId'] ?? "" as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'KODE_CUSTOMER': kodeCustomer,
      'NAMA_CUSTOMER': namaCustomer,
      'EMAIL': email,      
      'ALAMAT': alamat,
      'NOTELP': noTelp,
    };
  }
}