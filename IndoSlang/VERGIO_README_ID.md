# Vergio (TP079623) — Bagian Saya di IndoSlang
## Penjelasan dari awal untuk persiapan Q&A dengan dosen

---

## Apa itu IndoSlang?

IndoSlang adalah aplikasi web yang mengajarkan pengguna kata-kata slang bahasa Indonesia. Ada tiga jenis pengguna:
- **Member** — pelajar biasa
- **Buddy** — tutor/pembantu
- **Admin** — mengelola seluruh platform

Project ini dibangun menggunakan **ASP.NET Web Forms** (bahasa pemrograman C#) dengan database **SQL Server**.

---

## Halaman-Halaman Saya dan Fungsinya

---

### 1. SlangDictionary.aspx
**Siapa yang pakai:** Member dan Buddy  
**Fungsinya:** Menampilkan daftar semua kata slang Indonesia yang ada di sistem. Pengguna bisa mencari kata dan memfilter berdasarkan tingkat kesulitan.

**Peran CRUD:** READ saja  
Halaman ini membaca data dari tabel `SlangWord` di database dan menampilkannya dalam bentuk daftar.

**Fungsi-fungsi di SlangDictionary.aspx.cs:**
- `Page_Load` — dijalankan setiap kali halaman dibuka. Mengecek apakah pengguna sudah login, lalu memanggil `LoadWords()`
- `LoadWords()` — menghubungkan ke database, menjalankan perintah SQL `SELECT * FROM SlangWord`, dan menyimpan hasilnya ke dalam list yang ditampilkan di halaman
- `GetLevelClass()` — fungsi pembantu yang mengembalikan nama class CSS (contoh: "level-beginner") supaya badge tingkat kesulitan menampilkan warna yang benar

---

### 2. SlangDetail.aspx
**Siapa yang pakai:** Member dan Buddy  
**Fungsinya:** Menampilkan detail lengkap satu kata slang — termasuk pengucapan, arti, penjelasan lengkap, contoh kalimat, dan terjemahannya.

**Peran CRUD:** READ saja  
Ketika pengguna mengklik sebuah kata di halaman kamus, mereka diarahkan ke halaman ini dengan ID kata tersebut di URL (contoh: `SlangDetail.aspx?id=5`). Halaman membaca ID itu dan mengambil data kata tersebut dari database.

**Fungsi-fungsi di SlangDetail.aspx.cs:**
- `Page_Load` — mengecek login, membaca `id` dari URL, lalu memanggil `LoadWord()`
- `LoadWord()` — menjalankan SQL `SELECT ... FROM SlangWord WHERE SlangID = @SlangID` untuk mengambil data kata spesifik tersebut. Setiap field (Kata, Pengucapan, Arti, dll.) disimpan sebagai variabel yang ditampilkan di halaman ASPX

---

### 3. Module3.aspx
**Siapa yang pakai:** Member dan Buddy (hanya setelah menyelesaikan Module 2)  
**Fungsinya:** Modul kuis interaktif tingkat Elementary. Pengguna menjawab pertanyaan (pilihan ganda, isi kosong, benar/salah, terjemahan) tentang slang Indonesia, dan hasilnya disimpan ke database.

**Peran CRUD:** READ (memuat soal) + CREATE (menyimpan hasil)  
Soal-soal dibaca dari database. Setelah pengguna selesai, skor dan jawaban mereka disimpan.

**Fungsi-fungsi di Module3.aspx.cs:**
- `Page_Load` — mengecek login, mengatur link sidebar, memanggil `CheckModuleAccess()` dan `LoadQuestionsFromDatabase()`
- `CheckModuleAccess()` — mengecek apakah pengguna sudah lulus Module 2. Kalau belum, mereka diarahkan ke halaman Modules (tidak bisa skip)
- `LoadQuestionsFromDatabase()` — mengambil semua soal Module 3 dari tabel `Question` di database, lalu mengubahnya menjadi format JSON agar mesin kuis di JavaScript bisa menggunakannya
- `btnSaveResult_Click` — dijalankan saat pengguna submit jawaban. Memanggil `CreateProgressAttempt()` dan `SaveQuestionAnswers()`, lalu mengarahkan ke Module 4 jika lulus, atau ke halaman Modules jika gagal
- `CreateProgressAttempt()` — menyimpan satu baris data ke tabel `UserModuleProgress` (mencatat bahwa pengguna ini sudah mencoba modul ini, beserta skor dan apakah lulus)
- `SaveQuestionAnswers()` — menyimpan setiap jawaban pengguna ke tabel `UserQuestionAnswer` (mencatat soal mana, jawaban apa, dan apakah benar)
- `HasCompletedModule()` — mengecek apakah pengguna sudah punya catatan kelulusan untuk modul tertentu
- `GetNextAttemptNumber()` — menentukan ini percobaan keberapa pengguna (percobaan ke-1, ke-2, dst.)

---

### 4. Module4.aspx
**Siapa yang pakai:** Member dan Buddy (hanya setelah menyelesaikan Module 3)  
**Fungsinya:** Sama persis strukturnya dengan Module 3, tapi ini adalah modul Elementary terakhir. Menggunakan soal-soal berbasis skenario chat WhatsApp. Jika lulus, diarahkan ke Module 5.

**Peran CRUD:** READ (soal) + CREATE (hasil)  
Fungsi-fungsinya sama dengan Module 3, hanya berbeda di `ModuleOrder = 4` dan `PassingScore = 8`.

---

### 5. SuggestSlang.aspx
**Siapa yang pakai:** Member dan Buddy saja (Admin tidak bisa mengakses halaman ini)  
**Fungsinya:** Memungkinkan pengguna untuk mengusulkan kata slang baru untuk ditambahkan ke kamus. Usulan masuk ke antrian "Pending" dan admin akan meninjaunya. Halaman ini juga menampilkan riwayat usulan pengguna beserta statusnya (Pending / Approved / Rejected).

**Peran CRUD:** CREATE (kirim usulan) + READ (lihat usulan sendiri)

**Fungsi-fungsi di SuggestSlang.aspx.cs:**
- `Page_Load` — mengecek login dan juga mengecek Role. Jika pengguna adalah Admin (RoleID = 1), mereka langsung diarahkan keluar — Admin tidak boleh mengusulkan slang
- `btnSubmit_Click` — mengambil semua isi form (Kata, Pengucapan, Jenis Kata, Arti, Contoh, dll.) dan menjalankan SQL `INSERT INTO SlangSuggestion`. Status otomatis diset ke `'Pending'`
- `LoadMySuggestions()` — menjalankan SQL `SELECT ... FROM SlangSuggestion WHERE UserID = @UID` untuk menampilkan hanya usulan milik pengguna ini sendiri
- `ClearForm()` — mengosongkan semua field form setelah usulan berhasil dikirim
- `GetStatusCss()` — mengembalikan class CSS yang sesuai untuk badge status (hijau = Approved, merah = Rejected, oranye = Pending)
- `FormatDate()` — memformat tanggal pengiriman dengan rapi (contoh: "19 May 2026")

---

### 6. CommunityChat.aspx
**Siapa yang pakai:** Member, Buddy, DAN Admin (semua pengguna yang sudah login)  
**Fungsinya:** Ruang chat grup untuk semua anggota platform. Pengguna bisa mengirim pesan dan melihat pesan dari semua orang. Halaman otomatis refresh setiap 10 detik untuk menampilkan pesan baru.

**Peran CRUD:** CREATE (kirim pesan) + READ (lihat pesan)

**Fungsi-fungsi di CommunityChat.aspx.cs:**
- `Page_Load` — mengecek login, lalu mengatur tampilan sidebar berbeda berdasarkan role (Admin melihat link admin, Member/Buddy melihat link member). Memanggil `LoadMessages()` saat pertama kali dibuka
- `btnSend_Click` — mengambil teks dari kotak input, menjalankan SQL `INSERT INTO ChatMessage (ChannelID, UserID, Content, SentAt)`, lalu memuat ulang pesan
- `LoadMessages()` — menjalankan query `SELECT TOP 50` yang menggabungkan tabel `ChatMessage` dengan tabel `User` (untuk mendapatkan nama pengirim), membalik urutannya agar pesan terlama tampil di atas, lalu menampilkannya
- `GetDefaultChannelId()` — mencari channel chat default di database. Jika belum ada channel sama sekali, otomatis membuat channel baru bernama "General"
- `GetInitial()` — mengembalikan huruf pertama nama pengguna, digunakan untuk lingkaran avatar (contoh: "A" untuk "Ahmad")
- `GetWrapCss()`, `GetBubbleCss()`, `GetAvatarCss()` — fungsi pembantu yang mengecek apakah pesan dari pengguna saat ini. Jika ya, bubble muncul di KANAN (latar coklat). Jika dari orang lain, muncul di KIRI (latar putih)
- `FormatTime()` — menampilkan "HH:mm" untuk pesan hari ini, atau "dd MMM, HH:mm" untuk pesan lama

**Cara auto-refresh bekerja:** JavaScript menjalankan timer (`setInterval`) setiap 10 detik dan memanggil `location.reload()` untuk menyegarkan halaman. Timer berhenti sementara jika pengguna sedang mengetik (supaya pesannya tidak terhapus di tengah jalan).

---

### 7. ManageContent.aspx
**Siapa yang pakai:** Admin saja  
**Fungsinya:** Panel kontrol admin untuk mengelola konten platform. Punya dua tab:
- **Tab Dictionary** — Admin bisa Tambah, Edit, dan Hapus kata di kamus slang
- **Tab Module Questions** — Admin bisa memilih modul (2–8) dan Tambah, Edit, atau Hapus soal kuisnya. Module 1 hanya berisi flashcard sehingga tidak ada soal yang perlu dikelola di sini.

**Peran CRUD:** CRUD penuh — Create, Read, Update, Delete (untuk tabel SlangWord dan Question)

**Fungsi-fungsi di ManageContent.aspx.cs:**

*Bagian Dictionary:*
- `LoadDictionary()` — membaca semua kata dari tabel `SlangWord` dan menampilkannya di tabel
- `btnShowAddWord_Click` — menampilkan form kata (kosong, siap untuk kata baru)
- `btnSaveWord_Click` — jika `hfSlangID` (hidden field) bernilai 0, jalankan INSERT (tambah baru). Jika punya ID nyata, jalankan UPDATE (edit yang sudah ada). Lalu sembunyikan form dan refresh daftar
- `rptDictionary_ItemCommand` — dijalankan saat tombol Edit atau Delete diklik pada sebuah baris. Edit: ambil data kata dari DB dan isi form. Delete: jalankan `DELETE FROM SlangWord WHERE SlangID = @ID`
- `AddWordParams()` — fungsi pembantu bersama yang menambahkan semua field form kata sebagai parameter SQL (menghindari penulisan kode berulang untuk INSERT dan UPDATE)
- `ClearWordForm()` — mengosongkan field-field form kata

*Bagian Module Questions:*
- `PopulateModuleDropdown()` — mengisi dropdown pemilih modul dengan "Module 1" hingga "Module 8"
- `ddlModule_SelectedIndexChanged` — dijalankan saat admin memilih modul. Module 1 menampilkan catatan ("hanya flashcard, tidak ada soal"). Module 2–8 menampilkan daftar soal dan tombol Tambah Soal
- `LoadModuleQuestions()` — membaca soal-soal untuk modul yang dipilih dari tabel `Question`
- `btnSaveQuestion_Click` — menyimpan soal baru atau yang diedit. Data soal (teks pertanyaan, pilihan jawaban, penjelasan) disimpan sebagai string JSON di database
- `rptQuestions_ItemCommand` — menangani Edit (isi form) dan Delete. Delete menghapus dari `UserQuestionAnswer` terlebih dahulu (untuk menghindari error foreign key), baru kemudian hapus dari `Question`
- `SerializeQuestionData()` — mengubah isi form menjadi string JSON sebelum disimpan (MCQ menyertakan array pilihan; fill/truefalse tidak)
- `GetQuestionText()` — membaca JSON dari database untuk menampilkan hanya teks pertanyaan di tabel (dipotong maksimal 80 karakter)
- `GetTypeBadge()` — mengubah "mcq" → "MCQ", "fill" → "Fill", "truefalse" → "T/F" untuk tampilan

**Cara tab tetap aktif setelah postback:** Saat pengguna menyimpan kata dan halaman reload (postback), normalnya akan kembali ke tab Dictionary. Sebuah hidden field (`hfActiveTab`) menyimpan tab mana yang aktif, dan JavaScript membacanya saat halaman dimuat ulang untuk mengaktifkan tab yang benar.

---

### 8. ManageUsers.aspx
**Siapa yang pakai:** Admin saja  
**Fungsinya:** Menampilkan daftar lengkap semua Member dan Buddy (Admin tidak ditampilkan). Admin bisa mencari berdasarkan nama/username/email, memfilter berdasarkan role, dan melakukan Ban atau Unban pengguna.

**Peran CRUD:** READ + UPDATE (tidak ada Create — pengguna daftar sendiri; tidak ada Delete — kita ban bukan hapus agar data tetap tersimpan)

**Fungsi-fungsi di ManageUsers.aspx.cs:**
- `Page_Load` — memastikan hanya Admin yang bisa mengakses; memanggil `LoadUsers()` setiap saat (bukan hanya pertama kali, agar hasil pencarian selalu tampil benar)
- `LoadUsers()` — membangun query SQL secara dinamis: selalu mengecualikan Admin (RoleID ≠ 1), menambahkan klausa pencarian `LIKE` jika admin mengetik nama, dan menambahkan filter role jika dipilih
- `rptUsers_ItemCommand` — dijalankan saat tombol Ban/Unban diklik. Mengambil status pengguna saat ini, membaliknya (Active → Banned atau Banned → Active), dan menjalankan `UPDATE [User] SET Status = @Status WHERE UserID = @UID`
- `GetCurrentStatus()` — mengquery database untuk mendapatkan Status pengguna saat ini sebelum dibalik
- `GetRoleName()` — mengubah angka RoleID (2 atau 3) menjadi teks yang bisa dibaca ("Member" atau "Buddy")
- `GetBanButtonText()` — menampilkan "Ban" jika pengguna Active, "Unban" jika Banned
- `GetBanButtonCss()` — menampilkan tombol dengan gaya merah untuk Ban, gaya normal untuk Unban
- `GetBanConfirm()` — menghasilkan teks popup konfirmasi JavaScript ("Apakah kamu yakin ingin ban @username?")

---

## Konsep Teknis Penting yang Perlu Diketahui

### Session
Saat pengguna login, informasi mereka disimpan di `Session` — memori sementara yang bertahan selama mereka ada di situs. Setiap halaman mengecek `Session["UserID"]` untuk memastikan pengguna sudah login, dan `Session["RoleID"]` untuk mengecek apakah mereka Member (2), Buddy (3), atau Admin (1).

### DBHelper.GetConnection()
Setiap halaman menggunakan ini untuk terhubung ke database SQL Server. Ini adalah class pembantu bersama agar string koneksi tidak perlu ditulis berulang-ulang di setiap halaman.

### Postback
Di ASP.NET Web Forms, mengklik tombol di halaman akan mengirim form kembali ke server (disebut "postback"). Server menjalankan kode C#, memperbarui data, dan mengirim kembali HTML-nya. Begitulah cara menyimpan, menghapus, dan mengedit bekerja tanpa perlu API JavaScript.

### Repeater
Kontrol server yang mengulang daftar data dan merender HTML untuk setiap baris. Digunakan di daftar pesan chat, tabel kamus, tabel soal, tabel pengguna, dan tabel usulan slang.

### Hidden Fields (HiddenField)
Field form yang tidak terlihat yang menyimpan nilai antar postback. Digunakan untuk mengingat hal-hal seperti "kata mana yang sedang diedit" (`hfSlangID`), "tab mana yang aktif" (`hfActiveTab`), dan jawaban kuis (`hfAnswersJson`).

### Tabel Ringkasan CRUD

| Halaman | Create | Read | Update | Delete |
|---------|--------|------|--------|--------|
| SlangDictionary | ✗ | ✓ SlangWord | ✗ | ✗ |
| SlangDetail | ✗ | ✓ SlangWord | ✗ | ✗ |
| Module3 | ✓ UserModuleProgress, UserQuestionAnswer | ✓ Question | ✗ | ✗ |
| Module4 | ✓ UserModuleProgress, UserQuestionAnswer | ✓ Question | ✗ | ✗ |
| SuggestSlang | ✓ SlangSuggestion | ✓ SlangSuggestion | ✗ | ✗ |
| CommunityChat | ✓ ChatMessage | ✓ ChatMessage, User | ✗ | ✗ |
| ManageContent | ✓ SlangWord, Question | ✓ SlangWord, Question | ✓ SlangWord, Question | ✓ SlangWord, Question |
| ManageUsers | ✗ | ✓ User | ✓ User (ban/unban) | ✗ |

---

## Kalau Dosen Bertanya "Bagaimana X Bekerja?"

**"Bagaimana kamus bekerja?"**  
Halaman terhubung ke database dan menjalankan query SELECT pada tabel SlangWord. Hasilnya disimpan dalam list C# dan ditampilkan menggunakan perulangan di HTML. Tidak ada data yang hardcode — semuanya berasal dari database.

**"Bagaimana kuis menyimpan hasil?"**  
Saat pengguna selesai kuis, JavaScript mengumpulkan semua jawaban mereka dalam format JSON dan memasukkannya ke hidden field. Saat mereka klik Submit, halaman mengirimkan itu ke server, yang mem-parse JSON tersebut dan menyimpan satu baris per jawaban ke tabel UserQuestionAnswer, ditambah satu baris keseluruhan di UserModuleProgress.

**"Bagaimana chat auto-refresh bekerja?"**  
JavaScript menjalankan timer (`setInterval`) yang memuat ulang halaman setiap 10 detik. Halaman mengecek apakah pengguna sedang mengetik terlebih dahulu — jika mereka mengetik dalam 4 detik terakhir, timer menunggu agar pesan mereka tidak terhapus.

**"Bagaimana fitur ban bekerja?"**  
Tidak ada penghapusan data sama sekali. Tabel User memiliki kolom `Status` yang bernilai "Active" atau "Banned". Mengklik Ban hanya mengubah kolom tersebut menjadi "Banned". Halaman login mengecek status ini dan memblokir pengguna yang di-ban dari masuk.

**"Kenapa Admin tidak bisa mengusulkan slang?"**  
Halaman SuggestSlang mengecek `Session["RoleID"]`. Jika rolenya adalah 1 (Admin), halaman langsung mengarahkan ke halaman login. Hanya role 2 (Member) dan 3 (Buddy) yang diizinkan masuk.

**"Bagaimana fitur edit di ManageContent bekerja?"**  
Saat tombol Edit diklik, ini memicu event di server yang membaca data kata tersebut dari database dan mengisi form dengannya. ID kata disimpan di hidden field. Saat Save diklik, kode mengecek apakah hidden field punya ID — jika ya, jalankan UPDATE; jika nilainya 0, jalankan INSERT.

**"Apa perbedaan READ-only dan CRUD penuh?"**  
READ-only artinya halaman hanya menampilkan data (seperti SlangDictionary). CRUD penuh artinya pengguna bisa membuat data baru (Create), melihat data (Read), mengubah data yang ada (Update), dan menghapus data (Delete) — seperti di ManageContent untuk Admin.

**"Kenapa ManageUsers tidak punya Delete?"**  
Menghapus akun pengguna akan merusak data lain yang terhubung (riwayat sesi, jawaban kuis, dll.) karena ada foreign key di database. Solusinya adalah fitur Ban — status pengguna diubah menjadi "Banned" sehingga mereka tidak bisa login, tapi data mereka tetap aman di database.
