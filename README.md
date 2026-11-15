# RE:STYLE Mobile

**Sustainable Digital Wardrobe Platform**  
**Proyek Akhir Semester Pemrograman Berbasis Platform (CSGE602022)**  
Fakultas Ilmu Komputer, Universitas Indonesia — Semester Gasal 2026/2027  
**Kelompok 12-A**

## 1. Deskripsi Aplikasi

RE:STYLE adalah platform *digital wardrobe* yang membantu pengguna, khususnya mahasiswa, mengelola pakaian pribadi, memadupadankan outfit, serta menerapkan kebiasaan *slow fashion* dan *conscious shopping*. Aplikasi ini dikembangkan untuk membantu mengurangi pembelian pakaian impulsif, memaksimalkan pemakaian koleksi yang telah dimiliki, dan mendukung gaya hidup yang lebih berkelanjutan.

**RE:STYLE Mobile** merupakan pengembangan aplikasi berbasis Flutter dari situs web RE:STYLE yang telah dibuat pada Proyek Tengah Semester (PTS). Data aplikasi mobile tetap dikelola oleh backend Django yang sama dan diakses melalui *web service* berbasis **Django REST Framework (DRF)**. Dengan demikian, Flutter bukan aplikasi dengan data statis yang berdiri sendiri.

Fitur utama yang direncanakan untuk versi mobile meliputi:

- **Digital Closet:** Mengelola koleksi pakaian berdasarkan kategori, warna, gaya, dan status ketersediaan.
- **Mix & Match Outfit Builder:** Membuat dan menyimpan kombinasi outfit dari item Digital Closet.
- **Weekly Outfit Planner & Weather Recommendation:** Menjadwalkan outfit mingguan dan mengakses informasi cuaca melalui integrasi layanan terkait.
- **Conscious Shopping Reminder:** Mengelola wishlist dan membantu pengguna mempertimbangkan pembelian barang yang mirip dengan koleksi yang dimiliki.
- **Fashion Community:** Berbagi inspirasi fashion melalui postingan dan interaksi antarpengguna, termasuk menandai item dari Digital Closet yang dapat dilihat dan ditambahkan ke Wishlist pengguna lain.

Untuk versi mobile, kelompok menyepakati lima modul utama. Cakupan final memperluas fitur inti sesuai hasil diskusi kelompok, namun tetap memisahkan target **Checkpoint 1** dan **pengumpulan akhir**. Fitur yang belum termasuk scope final tidak dianggap sebagai kewajiban implementasi mobile.

## 2. Anggota Kelompok

| Nama | NPM |
|---|---|
|Salwa Hafiza Aqila|2506624392|
|Hasya Azzahra Rangkuti|2506617512|
|Salsabilla Hasan|2506548660|
|Aulia Nur Shiva|2506619316|
|Fadly Atief Nauval|2506624940|

## 3. Scoping Modul dan Pembagian Kerja

Kelompok 12-A menyepakati **lima modul utama** sebagai cakupan pengembangan RE:STYLE Mobile. Setiap anggota melanjutkan modulnya dari proyek web PTS, dengan tanggung jawab: (1) menyediakan endpoint menggunakan **Django REST Framework** pada backend Django PTS, dan (2) membangun halaman Flutter yang mengakses data backend melalui API. Tabel berikut adalah **target implementasi untuk pengumpulan akhir**, bukan pernyataan bahwa semua fitur sudah selesai.

### 3.1 Rincian Modul dan Fitur CRUD Mobile

Tabel ini menjelaskan **target implementasi Flutter sampai pengumpulan akhir (9 Desember 2026)**. Setiap modul menggunakan REST API pada proyek Django PTS, bukan data dummy sebagai sumber data final. Informasi kolom Create, Read, Update, dan Delete menjelaskan kemampuan pengguna, bukan jaminan bahwa setiap aksi harus memakai HTTP method yang bernama sama.

| Modul | Penanggung Jawab | Deskripsi & Ruang Lingkup Mobile | Create | Read | Update | Delete |
|---|---|---|---|---|---|---|
| **1. Digital Closet (Wardrobe Management)** | **Aulia Nur Shiva** | Mengelola koleksi pakaian pribadi dengan informasi nama, kategori, warna, material, gaya, foto, dan status ketersediaan. Menyediakan data pakaian untuk Mix & Match, penandaan item pada post Community, serta pencocokan Wishlist. Kategori dipilih manual, bukan melalui AI. | Menambahkan item pakaian dengan data utama dan foto; atribut pendukung mengikuti field model PTS yang tersedia. | Menampilkan daftar dan detail pakaian; pencarian dan filter berdasarkan kategori, warna, serta style. | Mengedit data item dan memperbarui status *Ready to Wear/In the Wash* sesuai aturan kategori di backend. | Menghapus pakaian milik pengguna dari koleksi. |
| **2. Mix & Match Outfit Builder** | **Salwa Hafiza Aqila** | Membuat kombinasi outfit dari item Digital Closet (atasan, bawahan/dress, outerwear, sepatu, aksesori), menyimpan kombinasi, serta menyediakan data outfit untuk Planner. | Memilih pakaian dan membuat outfit baru, lalu menyimpannya ke akun pengguna. | Menampilkan pilihan item Closet, daftar *saved outfits*, dan detail komposisi setiap outfit. Menyediakan fitur **shuffle** dan **reset** pemilihan outfit pada antarmuka. | Mengubah nama atau komposisi outfit yang telah tersimpan, termasuk mengganti item penyusunnya. | Menghapus outfit tersimpan milik pengguna. |
| **3. Weekly Outfit Planner & Weather Recommendation** | **Fadly Atief Nauval** | Merencanakan pemakaian outfit melalui kalender mingguan. Menggunakan data outfit dari Mix & Match dan informasi cuaca melalui layanan yang telah digunakan di PTS. Aturan ketersediaan pakaian mengikuti backend. | Menambahkan jadwal outfit pada tanggal/hari tertentu dengan memilih outfit tersimpan. | Menampilkan kalender mingguan, outfit per hari, detail jadwal, serta informasi cuaca untuk lokasi/periode yang didukung API. | Mengganti outfit atau tanggal dari jadwal yang sudah dibuat. | Menghapus/membatalkan jadwal outfit tertentu. |
| **4. Conscious Shopping Reminder & Authentication** | **Hasya Azzahra Rangkuti** | Mengelola wishlist dan membantu pembelian lebih sadar dengan mendeteksi kemiripan dasar (kategori dan warna) terhadap item Closet. Mendukung penambahan item Wishlist dari pakaian yang di-tag dalam Community, kemudian melakukan pengecekan kemiripan terhadap Closet pengguna yang menyimpan item. Mencakup autentikasi pengguna untuk akses fitur mobile. | Membuat item wishlist secara manual atau dari detail pakaian yang di-tag pada post Community, dengan atribut tersedia seperti nama, foto, kategori, warna, material, style, harga, dan tautan pembelian (pengguna dapat melengkapi informasi yang belum tersedia). Menyediakan alur login (dan registrasi apabila diputuskan dalam alur autentikasi final). | Menampilkan daftar/detail wishlist, pencarian dan filter, hasil kecocokan item Closet milik pengguna yang sedang login, serta **Conscious Alert** ketika ada barang serupa, termasuk setelah menambahkan item dari Community. | Mengedit atribut item wishlist, termasuk foto dan informasi pembelian. | Menghapus item wishlist. **Logout** mengakhiri sesi, bukan menghapus akun. |
| **5. Fashion Community** | **Salsabilla Hasan** | Menyediakan feed inspirasi fashion, post dengan foto dan tag pakaian dari Closet, detail item yang di-tag, aksi Add to Wishlist, komentar, like, saved posts, follow/unfollow, serta profil pengguna. | Membuat post teks dengan foto dan menandai item milik sendiri dari Digital Closet; menambahkan komentar, melakukan like, menyimpan post, dan mengikuti pengguna lain. Aksi Add to Wishlist dari tag disediakan pada detail item dan diproses modul Wishlist. | Menampilkan feed, detail post dan komentar, foto dan detail item Closet yang di-tag (termasuk atribut yang diizinkan untuk publik), jumlah/status like, daftar *saved posts*, profil pengguna, serta daftar followers/following. | Mengedit post dan komentar milik sendiri; memperbarui status like, saved, dan follow melalui aksi toggle sesuai desain API. | Menghapus post dan komentar milik sendiri; membatalkan like (*unlike*), menyimpan (*unsave*), serta mengikuti (*unfollow*). |

**Catatan aturan akses:** backend harus memverifikasi pengguna yang terautentikasi dan kepemilikan data untuk aksi yang bersifat pribadi. Misalnya, pengguna tidak boleh mengedit atau menghapus post milik pengguna lain. Nama endpoint dan HTTP method final mengikuti hasil implementasi DRF tiap modul.

### 3.2 Prioritas Implementasi dan Fitur di Luar Scope Utama

**Target utama pengumpulan akhir:** seluruh kemampuan yang dituliskan pada tabel 3.1 beserta layout/input Flutter, event handling, pengambilan data asinkron, pengolahan respons JSON, dan integrasi antarhalaman.

**Fitur pengembangan lanjutan, jika waktu memungkinkan:**

- **Digital Closet:** kombinasi filter yang lebih rumit atau penyempurnaan UI di luar kategori, warna, dan style yang sudah menjadi scope utama.
- **Mix & Match:** berbagi outfit langsung ke Community dan rekomendasi otomatis yang memerlukan integrasi tambahan. Fitur **shuffle dan reset termasuk scope utama**, bukan fitur tambahan.
- **Planner:** rekomendasi outfit berbasis cuaca yang lebih canggih dan pengaturan lokasi lanjutan di luar penyajian cuaca dan jadwal mingguan.
- **Conscious Shopping:** animasi lanjutan maskot dan *deep-link* kompleks ke item spesifik Closet. **Add to Wishlist dari item Community, pencocokan kategori/warna, Conscious Alert, dan navigasi untuk melihat item serupa di Closet termasuk scope utama.**
- **Fashion Community:** notifikasi, mention `@username`, foto pada balasan, dan interaksi reply bertingkat yang kompleks. **Tag item Closet pada post, melihat detail item yang di-tag, Add to Wishlist dari tag, Saved Posts, Follow/Unfollow, profil, followers/following, serta edit/hapus komentar termasuk scope utama.**

**Admin Panel/moderasi:** masih direncanakan berjalan melalui website Django PTS, **menunggu konfirmasi asisten dosen** bahwa panel khusus Flutter tidak diwajibkan. Akun admin tetap menjadi aktor dalam ekosistem RE:STYLE, tetapi tidak dihitung sebagai modul Flutter keenam pada scope yang disepakati.

### 3.3 Ketergantungan Antarmodul

- **Closet → Mix & Match:** pemilihan pakaian untuk menyusun outfit.
- **Mix & Match → Planner:** pemilihan outfit yang akan dijadwalkan.
- **Closet → Conscious Shopping:** perbandingan kategori dan warna dengan item wishlist.
- **Closet → Community:** penulis post dapat menandai item dari Closet miliknya. Pengunjung post dapat melihat atribut item yang diizinkan, tanpa memperoleh akses untuk mengubah Closet pemilik post.
- **Community → Wishlist:** ketika pengunjung memilih **Add to Wishlist** pada item yang di-tag, aplikasi mengirim data yang relevan ke endpoint Wishlist. Backend kemudian memeriksa kemiripan dengan **Closet milik pengunjung yang sedang login**, bukan Closet pemilik post.
- **Wishlist → Closet:** hasil *Conscious Shopping Alert* dapat mengarahkan pengguna untuk melihat item miliknya yang serupa, sesuai navigasi dan izin akses yang disepakati.
- **Authentication → seluruh modul:** identitas dan hak akses pengguna pada operasi yang memerlukan login.

Untuk mengurangi konflik integrasi, tiap anggota perlu menyepakati bentuk data JSON, nama field, endpoint, dan autentikasi **sebelum** menggantungkan implementasi Flutter pada modul lain. Implementasi API mandiri dapat dilakukan secara paralel.

### 3.4 Batasan Pekerjaan Checkpoint 1

**Deadline: Jumat, 20 November 2026, pukul 23.59 WIB.** Untuk Checkpoint 1, kelompok menargetkan: (1) repositori dan README yang sesuai ketentuan; (2) pembagian modul final; (3) **endpoint Django REST Framework untuk setiap modul sudah tersedia dan berjalan**; (4) **minimal satu halaman Flutter untuk setiap modul**; serta (5) **navigasi antarhalaman sudah berfungsi**. Fitur CRUD Flutter lengkap, integrasi JSON menyeluruh, dan APK baru menjadi target pengumpulan akhir. 

## 4. Jenis dan Peran Pengguna

1. Pengguna (Mahasiswa)

Pengguna utama RE:STYLE adalah mahasiswa yang ingin mengelola pakaian pribadi dan menerapkan gaya hidup yang lebih berkelanjutan. Pengguna dapat:

* Mengelola koleksi pakaian pribadi melalui Digital Closet.
* Membuat dan menyimpan kombinasi outfit melalui Mix & Match Outfit Builder.
* Merencanakan penggunaan pakaian melalui Weekly Outfit Planner.
* Mendapatkan pengingat saat mempertimbangkan pembelian pakaian yang serupa dengan koleksi yang sudah dimiliki.
* Membagikan serta melihat inspirasi styling dari pengguna lain melalui Fashion Community.
* Melihat informasi cuaca untuk membantu menentukan pakaian yang sesuai.

2. Admin (rencana melalui situs web Django PTS, menunggu konfirmasi asdos)

Admin bertugas mengelola dan menjaga konten serta data yang terdapat pada platform. Admin dapat:

* Mengelola data dan konten yang dibagikan dalam Fashion Community.
* Memoderasi konten atau postingan pengguna.
* Mengelola data yang diperlukan agar fitur-fitur RE:STYLE dapat berjalan dengan baik.

## 5. Teknologi yang Digunakan

| Komponen | Teknologi |
|---|---|
| Aplikasi mobile | Flutter dan Dart |
| Backend situs web PTS | Django |
| Web service / REST API | Django REST Framework |
| Pengelolaan kode | Git dan GitHub |
| Desain antarmuka | Figma |
| Layanan cuaca yang digunakan pada PTS | Open-Meteo API |
| Informasi lokasi yang digunakan pada PTS | OpenStreetMap melalui Nominatim |
| Distribusi aplikasi Android (tahap akhir) | APK melalui GitHub Releases dan Bitrise |

## 6. Alur Integrasi Data Flutter dan Django

```text
Pengguna
   │
   ▼
Aplikasi RE:STYLE Mobile (Flutter)
   │  HTTP request (GET / POST / PUT / PATCH / DELETE, sesuai endpoint)
   ▼
Django REST Framework (API pada proyek Django PTS)
   │
   ▼
Model Django dan database situs web RE:STYLE
   │
   ▼
Response JSON dari API
   │
   ▼
Flutter mengolah JSON dan memperbarui tampilan
```

**Penjelasan alur:**

1. Pengguna melakukan interaksi di aplikasi Flutter, seperti membuka daftar pakaian atau postingan komunitas.
2. Flutter mengirim permintaan HTTP secara asinkron ke endpoint Django REST Framework sesuai modul.
3. Django memvalidasi permintaan dan mengakses data pada database situs web PTS; autentikasi dan CSRF disesuaikan dengan rancangan API kelompok.
4. API mengembalikan respons (umumnya JSON) yang diolah Flutter menjadi data dan tampilan aplikasi.
5. Untuk operasi yang mengubah data, perubahan disimpan melalui backend yang sama sehingga dapat digunakan oleh situs web maupun aplikasi mobile.

## 7. Dokumentasi Endpoint REST API

**Checkpoint 1 mensyaratkan endpoint DRF setiap modul sudah tersedia dan berjalan.** Tabel ini diisi setelah masing-masing penanggung jawab membagikan endpoint yang sudah diuji. Jangan menandai endpoint sebagai selesai sebelum berhasil diuji.

| Modul | Endpoint yang telah diuji | Method | Status |
|---|---|---|---|
| Digital Closet | Belum dicantumkan | — | Perlu konfirmasi |
| Mix & Match | Belum dicantumkan | — | Perlu konfirmasi |
| Weekly Outfit Planner | Belum dicantumkan | — | Perlu konfirmasi |
| Conscious Shopping & Autentikasi | Belum dicantumkan | — | Perlu konfirmasi |
| Fashion Community | Belum dicantumkan | — | Perlu konfirmasi |

**Format dokumentasi per endpoint yang disarankan:** method, path, tujuan, kebutuhan autentikasi, contoh respons JSON, dan hasil pengujian.

## 8. Struktur Direktori Flutter

Rancangan struktur berikut berasal dari diskusi kelompok dan dapat berubah mengikuti proses integrasi. Struktur ini **bukan pernyataan bahwa seluruh direktori telah tersedia pada branch `main`**.

```text
lib/
├── main.dart
├── app.dart
├── core/
│   ├── constants/
│   ├── theme/
│   ├── network/
│   ├── utils/
│   └── widgets/
└── features/
    ├── auth/
    ├── landing/
    ├── closet/
    ├── mixmatch/
    ├── planner/
    └── community/
        ├── models/
        ├── services/
        ├── screens/
        └── widgets/

assets/
└── img/
```

Folder `core/` berisi komponen bersama, sedangkan `features/` memisahkan implementasi setiap modul agar pengerjaan kelompok lebih terstruktur.

## 9. Cara Menjalankan Aplikasi

**Prasyarat:** Git, Flutter SDK, dan perangkat atau browser untuk pengembangan. Untuk build APK dibutuhkan Android SDK.

1. Clone repositori Flutter:

   ```bash
   git clone https://github.com/pbp-kelompok-a12/RESTYLE-mobile.git
   cd RESTYLE-mobile
   ```

2. Pasang dependensi:

   ```bash
   flutter pub get
   ```

3. Jalankan aplikasi di Chrome untuk pengembangan awal:

   ```bash
   flutter run -d chrome
   ```

4. Untuk pengujian Android, siapkan Android SDK dan emulator atau perangkat Android, lalu jalankan `flutter run`.

**Catatan:** Fitur yang memakai data backend membutuhkan endpoint Django yang aktif dan dapat diakses dari perangkat pengujian. Konfigurasi URL API mengikuti kesepakatan kelompok.

## 10. Desain Aplikasi dan Referensi

- **Figma desain mobile:** [Tambahkan tautan final desain Flutter; wajib dirancang, tautan boleh menyusul CP1]
- **Situs web RE:STYLE (PTS):** https://pws.cs.ui.ac.id/web/project/aulia.nur51/restyle
- **Repositori Django PTS:** [Tambahkan tautan repositori Django kelompok]
- **Repositori Flutter:** https://github.com/pbp-kelompok-a12/RESTYLE-mobile

Desain mobile wajib dibuat. Tim berupaya menjaga konsistensi tema, warna, dan identitas visual antara situs web dengan aplikasi Flutter.

## 11. Progres Pengerjaan

### Checkpoint 1 — Jumat, 20 November 2026, 23.59 WIB

- [x] Repositori GitHub Flutter dibuat.
- [x] Codebase awal Flutter tersedia.
- [x] Scoping lima modul utama dan pembagian kerja inti disepakati kelompok.
- [ ] README berisi semua informasi terbaru, termasuk status endpoint, dan sudah ditinjau kelompok.
- [ ] Endpoint DRF setiap modul telah berjalan dan didokumentasikan.
- [ ] Halaman Flutter minimal untuk setiap modul telah tersedia.
- [ ] Navigasi antarmodul telah berfungsi.

**Submisi CP1:** Tautan repositori Flutter dikumpulkan melalui SCELE. Status checklist perlu diperbarui berdasarkan bukti implementasi sebelum tenggat.

### Pengumpulan Akhir — Rabu, 9 Desember 2026, 23.59 WIB

- [ ] Seluruh modul Flutter diimplementasikan dan terintegrasi.
- [ ] Layout, input, dan event handling setiap modul telah berfungsi.
- [ ] Integrasi asinkron dengan endpoint DRF dan pengolahan JSON selesai.
- [ ] Aplikasi sesuai rancangan desain yang disepakati.
- [ ] APK dirilis melalui GitHub Releases dan Bitrise.
- [ ] Tautan APK ditambahkan ke README.
- [ ] Video promosi aplikasi dan situs web (opsional/bonus).

## 12. Tautan APK dan Video Promosi

- **APK Release:** [Ditambahkan pada tahap akhir]
- **Bitrise:** [Ditambahkan pada tahap akhir]
- **Video promosi (opsional):** [Ditambahkan apabila mengerjakan bonus]

---

Scoping lima modul dan integrasi Closet–Community–Wishlist pada dokumen ini menjadi acuan kerja kelompok 12-A. Status implementasi, endpoint, tautan desain, dan keputusan Admin Panel akan diperbarui setelah diverifikasi.
