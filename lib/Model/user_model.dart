class User {
  String? username;
  String? pass;
  String? tier;
  String? namaLengkap;
  bool status;
  String? docId;
  List? module;

  User([
    this.username, 
    this.pass, 
    this.tier, 
    this.namaLengkap, 
    this.status = false,
    this.docId,
    this.module
  ]);

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      json['NAMA'] ?? "" as String, 
      json['PASSWORD'] ?? "" as String, 
      json['TIER'] ?? "" as String,
      json['NAMA_LENGKAP'] ?? "" as String,
      json['STATUS'] ?? true as bool,
      json['docId'] ?? "" as String,
      json['MODULE'] ?? [] as List
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'NAMA': username,
      'PASSWORD': pass,
      'TIER': tier,
      'NAMA_LENGKAP': namaLengkap,
      'STATUS': status,
      'DOCID': docId,
      "MODULE": module
    };
  }
}