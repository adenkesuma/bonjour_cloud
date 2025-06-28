### DISCLAIMER
penyusunan folder tidak menggunakan struktur seperti di tugas yaitu FE & BE, dikarenakan aplikasi bersifat mobile menggunakan stack flutter + firebase.
alhasil tidak diperlukan nya lagi folder BACKEND pada aplikasi karena BACKEND nya itu sendiri sudah di firebase tanpa menulis kode ulang, dan tidak juga diperlukan folder FRONTEND karena yang ditampilkan di repository hanya FRONTEND
MOHON BISA DIMENGERTI 🙏

#Kelompok Bonjour

# Moku 📦 — Aplikasi Mobile Inventory Gudang

**Moku** adalah aplikasi mobile inventory gudang yang dirancang untuk membantu bisnis dalam mengelola stok barang, transaksi pembelian dan penjualan, serta pelaporan operasional secara efisien. Semua fitur utama mendukung fungsi CRUD untuk memberikan fleksibilitas dan kontrol penuh terhadap data.

---

## 👥 Anggota Kelompok

| Nama Lengkap            | NIM       |
|-------------------------|-----------|
| Anderson Usman          | 221112508 |
| Aden Kesuma             | 221111805 |
| Delwin                  | 221110202 |
| Alex Ander Wijaya       | 221110286 |
| James Aprilius Clinton  | 221113477 |

---

## 🌐 URL Aplikasi Live

🔗 https://mikroskilacid-my.sharepoint.com/:u:/g/personal/221111805_students_mikroskil_ac_id/EcQPYYgWUlZAmdDiFQ0VqL8Bd7Y38cYyFUXOE8mPHvGvcg?e=mZ16Pp

---

## ☁️ Arsitektur Cloud

Aplikasi **Moku** menggunakan layanan cloud modern untuk memastikan data tersimpan dengan aman dan dapat diakses secara real-time:

### 🔸 Firebase
Digunakan sebagai penyimpanan utama semua data:
- Data customer
- Informasi gudang dan stok
- Transaksi pembelian dan penjualan
- Proses pelunasan dan pemindahan stok
- Data dashboard dan laporan

> Firebase Firestore digunakan untuk database, sedangkan Firebase Auth digunakan untuk autentikasi pengguna.

### 🔸 Cloudinary
Digunakan untuk menyimpan dan mengelola **gambar produk atau dokumen** yang diunggah oleh pengguna. Cloudinary juga mengoptimasi gambar agar cepat diakses di aplikasi mobile.

---

## 🚀 Petunjuk Penggunaan Aplikasi

1. **Login** – Masuk menggunakan akun yang terdaftar.
2. **Dashboard** – Menampilkan ringkasan data dan statistik stok.
3. **Customer** – Tambah, lihat, edit, atau hapus data pelanggan.
4. **Gudang** – Kelola data gudang dan barang.
5. **Pembelian** – Input data pembelian dari supplier.
6. **Penjualan** – Catat transaksi penjualan ke pelanggan.
7. **Pelunasan** – Kelola status pembayaran.
8. **Pemindahan** – Pindahkan stok antar gudang.
9. **Report** – Tampilkan laporan aktivitas gudang.
10. **Stock** – Lihat dan kelola ketersediaan stok barang.

> Seluruh fitur di atas mendukung fungsi CRUD (Create, Read, Update, Delete).

---

## 💻 Cara Instalasi & Menjalankan Proyek di Lokal

### 1. Clone Repositori

## 💻 Cara Instalasi & Menjalankan Proyek di Lokal (Development)

### 📦 Prasyarat

Sebelum mulai, pastikan kamu sudah menginstal:

- [Flutter SDK](https://flutter.dev/docs/get-started/install) versi terbaru
- Android Studio / VS Code (dengan plugin Flutter & Dart)
- Emulator Android ATAU perangkat Android fisik
- Akun Firebase
- Akun Cloudinary

---

## 🔧 1. Clone Proyek dari GitHub

git clone https://github.com/username/moku.git
cd moku

## 2. Install Dependency Flutter

flutter pub get


## 3. Konfigurasi Firebase
Masuk ke Firebase Console

Buat project baru bernama moku

Tambahkan aplikasi Android ke project tersebut:

Package name: com.example.moku (atau sesuai di android/app/build.gradle)

Unduh file google-services.json dari Firebase

Tempatkan file tersebut di dalam folder:

/android/app/google-services.json
Aktifkan layanan berikut di Firebase:

Authentication → metode Email/Password

Cloud Firestore → mode Start in test mode

## 4. Konfigurasi Cloudinary
Daftar atau login ke https://cloudinary.com

Masuk ke Dashboard, lalu salin:

cloud_name

api_key

api_secret

Simpan kredensial Cloudinary ini di file konfigurasi lokal (misalnya lib/config.dart) atau gunakan environment variable jika sudah setup .env

Contoh:

class CloudinaryConfig {
  static const String cloudName = 'YOUR_CLOUD_NAME';
  static const String apiKey = 'YOUR_API_KEY';
  static const String apiSecret = 'YOUR_API_SECRET';
}

## 5. Jalankan Proyek di Emulator / Device
flutter run

Link video demo aplikasi
https://mikroskilacid-my.sharepoint.com/:v:/g/personal/221111805_students_mikroskil_ac_id/EYZb0LeJ391OiYlm6pmKT_IB5yujvId6J84zkillr7qeTA?e=T1kuxT
