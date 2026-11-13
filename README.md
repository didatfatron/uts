# MoneyMate – Personal Finance Tracker

MoneyMate adalah aplikasi pencatatan keuangan pribadi berbasis Flutter yang membantu pengguna mencatat pemasukan dan pengeluaran, memantau saldo, serta melihat ringkasan aktivitas keuangan dalam satu aplikasi.

Aplikasi ini dikembangkan sebagai proyek Ujian Tengah Semester (UTS) dengan menerapkan pengelolaan state, integrasi REST API, database Supabase, dan arsitektur aplikasi yang terstruktur.

## Fitur Utama

- **Dashboard:** Menampilkan ringkasan saldo, total pemasukan, dan total pengeluaran.
- **Manajemen Transaksi:** Menampilkan daftar transaksi pemasukan dan pengeluaran.
- **Tambah Transaksi:** Menambahkan data pemasukan atau pengeluaran.
- **Detail Transaksi:** Melihat informasi lengkap suatu transaksi.
- **Edit Transaksi:** Memperbarui data transaksi.
- **Hapus Transaksi:** Menghapus transaksi dengan konfirmasi.
- **Statistik:** Menampilkan ringkasan aktivitas keuangan.
- **Profile & Settings:** Menampilkan halaman profil dan pengaturan.
- **Exchange Rate:** Mengambil informasi nilai tukar USD ke IDR melalui REST API.
- **Responsive Layout:** Menyesuaikan tampilan berdasarkan ukuran layar.

## Teknologi yang Digunakan

| Teknologi | Kegunaan |
|---|---|
| Flutter | Framework pengembangan aplikasi |
| Dart | Bahasa pemrograman |
| Provider | State management |
| Supabase | Backend dan database |
| PostgreSQL | Penyimpanan data transaksi |
| REST API | Mengambil data nilai tukar |
| HTTP | Komunikasi dengan REST API |
| Git & GitHub | Version control dan penyimpanan kode |

## Arsitektur Aplikasi

Proyek menggunakan pemisahan tanggung jawab agar kode lebih terstruktur dan mudah dikembangkan.

```text
lib/
├── models/
│   ├── transaction.dart
│   └── exchange_rate.dart
│
├── services/
│   ├── transaction_service.dart
│   └── exchange_rate_service.dart
│
├── repositories/
│   ├── transaction_repository.dart
│   └── exchange_rate_repository.dart
│
├── providers/
│   ├── transaction_provider.dart
│   └── exchange_rate_provider.dart
│
├── screens/
│   ├── dashboard_screen.dart
│   ├── transactions_screen.dart
│   ├── transaction_detail_screen.dart
│   ├── add_transaction_screen.dart
│   ├── edit_transaction_screen.dart
│   ├── statistics_screen.dart
│   ├── profile_screen.dart
│   └── main_navigation_screen.dart
│
├── widgets/
│   ├── summary_card.dart
│   ├── transaction_tile.dart
│   └── exchange_rate_widget.dart
│
├── theme/
│   └── app_theme.dart
│
└── main.dart
```

Alur pengelolaan data:

**Screen → Provider → Repository → Service → Supabase / REST API**

## Database

MoneyMate menggunakan Supabase dengan database PostgreSQL.

Tabel utama: `transactions`

| Kolom | Tipe Data | Keterangan |
|---|---|---|
| id | UUID | Primary key |
| user_id | UUID | Identitas pengguna |
| title | TEXT | Nama transaksi |
| category | TEXT | Kategori transaksi |
| amount | NUMERIC | Nominal transaksi |
| type | TEXT | Income atau expense |
| date | TIMESTAMPTZ | Tanggal transaksi |
| description | TEXT | Deskripsi tambahan |
| created_at | TIMESTAMPTZ | Waktu data dibuat |

Operasi database yang diterapkan:
- Create: Menambahkan transaksi.
- Read: Mengambil dan menampilkan transaksi.
- Update: Memperbarui transaksi.
- Delete: Menghapus transaksi.

Keamanan data menggunakan Row Level Security (RLS) agar pengguna hanya dapat mengakses transaksi miliknya sendiri.

## REST API

Aplikasi menggunakan Frankfurter API untuk mengambil nilai tukar mata uang USD terhadap IDR.

Endpoint:

`https://api.frankfurter.dev/v1/latest?base=USD&symbols=IDR`

Data API diproses menjadi model ExchangeRate dan ditampilkan pada Dashboard.

## Tampilan Aplikasi

Dokumentasi tampilan aplikasi tersedia pada folder screenshot proyek.

Beberapa tampilan yang didokumentasikan:
- Dashboard
- Daftar transaksi
- Form tambah transaksi
- Detail dan edit transaksi
- Statistik
- Profile & Settings
- Integrasi database Supabase

## Cara Menjalankan Aplikasi

### Persyaratan

- Flutter SDK
- Dart SDK
- Android Studio atau Visual Studio Code
- Android SDK
- Akun dan proyek Supabase

### Instalasi

1. Clone repository:

```bash
git clone https://github.com/didatfatron/uts.git
```

2. Masuk ke direktori proyek:

```bash
cd uts
```

3. Install dependencies:

```bash
flutter pub get
```

4. Konfigurasikan URL proyek Supabase dan publishable key pada inisialisasi Supabase di `lib/main.dart`.

5. Jalankan aplikasi:

```bash
flutter run
```

Untuk menjalankan melalui Chrome:

```bash
flutter run -d chrome
```

## Build APK

Untuk membuat APK release Android:

```bash
flutter build apk --release
```

Jika proses build berhasil, file APK tersedia di:

```text
build/app/outputs/flutter-apk/app-release.apk
```

## Pengujian

Pengujian aplikasi meliputi:
- Menampilkan data transaksi.
- Menambahkan transaksi pemasukan dan pengeluaran.
- Mengubah data transaksi.
- Menghapus transaksi dengan konfirmasi.
- Menampilkan data dari Supabase.
- Mengambil data nilai tukar melalui REST API.
- Menangani kondisi loading, error, dan data kosong.
- Menguji penyesuaian tampilan pada ukuran layar berbeda.

## Repository

GitHub: https://github.com/didatfatron/uts

---

**MoneyMate – Personal Finance Tracker**

Dikembangkan menggunakan Flutter dan Dart.