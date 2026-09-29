# Product Requirement Document (PRD)
## Aplikasi Toko Digital Sederhana (Offline-First)

---

| Informasi Dokumen | Detail |
| :--- | :--- |
| **Nama Proyek** | `toko_digital_app` |
| **Mata Pelajaran** | Pemrograman Perangkat Bergerak |
| **Model Pembelajaran**| Project-Based Learning (PjBL) |
| **Alokasi Waktu** | 4 JP $\times$ 45 Menit |
| **Platform / Tech** | Flutter (Dart), SQLite (`sqflite`), State Management (`provider`) |
| **Versi Dokumen** | 1.0.0 |

---

## 1. Ringkasan Eksekutif & Tujuan Proyek

### 1.1 Ringkasan
`toko_digital_app` adalah aplikasi e-commerce Android/iOS berbasis Flutter yang berfokus pada kemampuan *offline-first*. Aplikasi ini memungkinkan pengguna melihat katalog produk lokal, menambahkan barang ke keranjang belanja, memperbarui kuantitas barang, dan menghitung total belanja secara otomatis tanpa ketergantungan pada koneksi internet.

### 1.2 Tujuan Utama
1. **Responsivitas & UI Bebas Error:** Mengembangkan antarmuka aplikasi yang bebas dari masalah *layout overflow* (garis kuning-hitam) pada berbagai ukuran layar.
2. **Arsitektur Modular:** Membangun struktur direktori proyek yang rapi dan terorganisir sesuai *best practice* Flutter.
3. **Persistensi Data Lokal:** Menyimpan data produk dan keranjang belanja secara permanen menggunakan SQLite sehingga data tetap tersimpan saat aplikasi ditutup (*app restart*).
4. **Pengelolaan State Reaktif:** Mengimplementasikan paket `provider` agar perubahan data pada keranjang belanja langsung memperbarui tampilan antarmuka pengguna (UI) secara real-time.

---

## 2. Struktur Arsitektur & Direktori Proyek

Proyek Flutter akan dibuat dengan nama paket `toko_digital_app`. Seluruh logika dan komponen aplikasi dalam folder `lib/` wajib dipisah secara modular:

```text
lib/
├── helpers/
│   └── db_helper.dart      # Logika koneksi dan operasi database SQLite
├── models/
│   ├── product_model.dart  # Class Model untuk Master Produk
│   └── cart_model.dart     # Class Model untuk Item Keranjang
├── providers/
│   └── cart_provider.dart  # State management reaktif menggunakan Provider
├── pages/
│   ├── catalog_page.dart   # Halaman Utama (Daftar/Katalog Produk)
│   └── cart_page.dart      # Halaman Keranjang Belanja
└── main.dart               # Entry point aplikasi & inisialisasi Provider
```

---

## 3. Spesifikasi Database & Persistensi Data

Aplikasi menggunakan pustaka `sqflite` dan `path`. File database dikelola melalui file pembantu `lib/helpers/db_helper.dart`.

### 3.1 Skema Database (`db_helper.dart`)

#### Tabel 1: `master_products`
Tabel ini menyimpan daftar produk yang tersedia di toko.

| Nama Kolom | Tipe Data | Keterangan |
| :--- | :--- | :--- |
| `id` | `INTEGER` | Primary Key, Auto Increment |
| `name` | `TEXT` | Nama produk |
| `price` | `INTEGER` / `REAL` | Harga produk per unit |

#### Tabel 2: `local_cart`
Tabel ini menyimpan daftar barang yang dimasukkan oleh pengguna ke dalam keranjang belanja.

| Nama Kolom | Tipe Data | Keterangan |
| :--- | :--- | :--- |
| `id` | `INTEGER` | Primary Key, Auto Increment |
| `product_id` | `INTEGER` | Foreign Key / Referensi ID dari `master_products` |
| `name` | `TEXT` | Nama produk |
| `price` | `INTEGER` / `REAL` | Harga produk per unit |
| `quantity` | `INTEGER` | Jumlah item yang dibeli |

---

## 4. Kebutuhan Fungsional (Functional Requirements)

### FR-1: Konfigurasi & Inisialisasi Proyek (LKPD 1)
- **FR-1.1:** Dibuat proyek Flutter baru dengan nama `toko_digital_app`.
- **FR-1.2:** Dipasang *dependencies* utama pada file `pubspec.yaml`:
  - `sqflite` (Persistensi database lokal)
  - `path` (Penanganan path file sistem)
  - `provider` (State management reaktif)
- **FR-1.3:** Pembentukan struktur folder `helpers/`, `models/`, `providers/`, dan `pages/` di dalam `lib/`.

### FR-2: Halaman Katalog Produk (LKPD 2 & 3)
- **FR-2.1:** Menampilkan daftar produk master dalam bentuk grid (`GridView`) atau kartu (`Card`).
- **FR-2.2:** Setiap kartu produk menampilkan:
  - Gambar/Ikon produk.
  - Nama produk.
  - Harga produk (Format Rupiah).
  - Tombol **"Tambah ke Keranjang"** (*Add to Cart*).
- **FR-2.3:** Saat tombol "Tambah ke Keranjang" ditekan, produk akan disimpan/diperbarui pada tabel `local_cart` melalui `CartProvider`.

### FR-3: Halaman Keranjang Belanja (LKPD 2 & 3)
- **FR-3.1:** Menampilkan daftar seluruh barang yang ada di tabel `local_cart`.
- **FR-3.2:** Setiap item keranjang menyediakan kontrol kuantitas:
  - Tombol penambah kuantitas (`+`).
  - Tombol pengurang kuantitas (`-`). Jika kuantitas berkurang menjadi $0$, item akan dihapus dari tabel `local_cart`.
- **FR-3.3:** Perhitungan kalkulasi total biaya belanjaan secara otomatis:
  $$\text{Total Biaya} = \sum_{i=1}^{n} (\text{Harga}_i \times \text{Kuantitas}_i)$$
- **FR-3.4:** Tampilan UI otomatis memperbarui total harga secara *real-time* saat terjadi perubahan kuantitas item.

### FR-4: Manajemen State & Offline Persistence (LKPD 4)
- **FR-4.1:** Seluruh operasi CRUD keranjang (`insert`, `update`, `delete`, `query`) diakses melalui `CartProvider`.
- **FR-4.2:** Menggunakan `ChangeNotifier` pada `CartProvider` dan `Consumer` / `context.watch()` pada UI untuk memastikan reaktivitas.
- **FR-4.3:** Data keranjang belanja harus bertahan (*persistent*) ketika aplikasi ditutup total (*app restart*).

---

## 5. Kebutuhan Non-Fungsional (Non-Functional Requirements)

### NFR-1: Bebas Layout Overflow
- Tampilan antarmuka wajib menerapkan pencegahan garis kuning-hitam (*overflow UI*) dengan memanfaatkan widget responsif seperti `Expanded`, `Flexible`, `SingleChildScrollView`, atau `FittedBox`.

### NFR-2: Performa & Responsivitas Tampilan
- Transisi antara Katalog Produk dan Keranjang Belanja berjalan mulus tanpa lag.
- Pembaruan angka total harga di keranjang berlangsung secara instan ($<100\text{ ms}$) saat tombol kuantitas ditekan.

---

## 6. Alur Penggunaan & Rancangan Antarmuka (User Flow)

```text
[Buka Aplikasi]
       │
       ▼
[Inisialisasi DB SQLite & Provider]
       │
       ▼
[Halaman Katalog Produk (catalog_page.dart)]
   ├── Tampilkan Produk (GridView/Card)
   └── Klik "Tambah ke Keranjang"
           │
           ▼
     (Simpan/Update data di local_cart via SQLite)
           │
           ▼
[Navigasi ke Halaman Keranjang (cart_page.dart)]
   ├── Tampilkan Item di Keranjang
   ├── Ubah Kuantitas (+ / -) ──► Re-kalkulasi Total
   └── Restart Aplikasi ──► Data Tetap Tersimpan
```

---

## 7. Rencana Kerja & Checklist Implementasi

- [ ] **Langkah 1 (LKPD 1):** Inisialisasi proyek `toko_digital_app`, sesuaikan folder `lib/`, dan install package (`sqflite`, `path`, `provider`).
- [ ] **Langkah 2 (LKPD 4):** Buat `db_helper.dart` dan buat skema tabel `master_products` serta `local_cart`.
- [ ] **Langkah 3 (LKPD 4):** Buat `ProductModel`, `CartModel`, dan setup `CartProvider` untuk logika database reaktif.
- [ ] **Langkah 4 (LKPD 2 & 3):** Bangun UI `catalog_page.dart` (GridView, Card, Handling Overflow).
- [ ] **Langkah 5 (LKPD 2 & 3):** Bangun UI `cart_page.dart` (ListTile, Tombol `+`/`-`, Total Harga).
- [ ] **Langkah 6:** Uji coba *restart* aplikasi untuk memastikan data di keranjang tidak hilang.