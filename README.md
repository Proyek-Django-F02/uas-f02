# Proyek Akhir Semester F02

**Anggota Kelompok F02 :**
- Zidan Kharisma Adidarma (2006463881)
- Shabrina Taqiyya (2006464341)
- Fathan Muhammad (2006486090)
- Muhammad Fauzul Akbar (2006473876)
- Reyza Abyan Gerrit Caloh (2006463534)
- Nasywa Kamila (2006486885)
- Isyah Auliarahmani Rafifa (2006464221)

### [Link Download APK](https://github.com/Proyek-Django-F02/uas-f02/raw/master/build/app/outputs/flutter-apk/app.apk)

## Tema
Kelompok kami mengangkat tema aplikasi Productivity.

## Latar Belakang
Pandemi Covid-19 yang masih berlangsung hingga saat ini memaksa sebagian besar dari kita untuk beraktivitas dari rumah hingga bermunculan berbagai istilah baru seperti PJJ dan WFH. Kegiatan yang monoton dan hanya bisa dilakukan melalui rumah tanpa bertemu dengan orang lain secara langsung menyulitkan kita untuk mengatur dan memantau aktivitas sehari-hari maupun pekerjaan kita. Oleh karena itu, dibutuhkan sebuah productivity app yang dapat membantu kita dalam mengatur aktivitas sehari-hari, baik untuk menyusun jadwal kegiatan kuliah maupun memantau pekerjaan yang harus diselesaikan.  

## Tujuan dan Manfaat
Aplikasi ini bertujuan untuk meningkatkan produktivitas dari para penggunanya dengan menawarkan berbagai fitur untuk mengorganisasi kegiatan pengguna dalam sebuah aplikasi web. Fitur-fitur yang dapat digunakan oleh pengguna adalah schedule untuk menyusun jadwal, to-do list untuk mendata aktivitas yang harus dilakukan selanjutnya, dan notes untuk mencatat. Tidak hanya itu, pengguna dapat bersosialisasi dengan pengguna lainnya untuk saling berbincang terkait topik produktivitas melalui fitur community forum dan saling mengirimkan pesan secara personal melalui Direct Message maupun secara anonimus melalui fitur Anonymous Message. Pengguna juga dapat membaca berita, artikel, atau blog melalui halaman News atau mengajukan permintaan untuk mempublikasikan berita/artikel/blognya sendiri.

## Persona
User persona dari website ini hanya ada dua, yaitu:
- **User yang belum login**. User belum dapat mengakses fitur apa pun dan akan diminta untuk login terlebih dahulu.
- **User yang sudah login**. User ini akan diberikan akses untuk menikmati semua fitur yang ada di web untuk mengatur kegiatan sehari-harinya dan meningkatkan produktivitas. 

## Modul dan Pembagiannya
|No |Modul            |Deskripsi                                                                                  |PJ Modul|
|---|-----------------|-------------------------------------------------------------------------------------------|--------|
|1  |User             |User dapat membuat akun baru, meng-update profile, autentikasi pengguna dengan fitur login kemudian membuat navigasi.                                               |Zidan   |
|2  |To-do List       |User dapat memasukkan list hal-hal yang akan dilakukan yang dilengkapi dengan tenggat waktu, deskripsi, dan checklist untuk menandai hal yang telah dilakukan.                                                 |Shabrina|
|3  |Notes            |User dapat menambahkan dan menghapus catatan berupa memo singkat.                          |Reyza   |
|4  |Schedule         |User dapat menambahkan dan menghapus aktivitas dengan keterangan waktu, tipe aktivitas, dan deskripsi aktivitas pada kalender. Aktivitas ditampilkan per                                                                |Isyah   |
|5  |Community Forum  |Berbentuk forum untuk seluruh user yang telah login. User dapat mengirimkan post berupa teks ke dalam forum serta mengomentari post user lain.                                                                          |Fauzul  |
|   |                 |User dapat mengirimkan berupa teks ke dalam forum.                              |        |
|6  |Anonymous Message|User dapat mengirimkan pertanyaan anonim secara privat ke user lain berupa teks.           |Fathan  |
|7  |News             |User dapat request untuk publish blog/news lewat page news, lalu admin web yang verifikasi.|Nasywa  |

## Integrasi dengan Web Service
Kami melakukan integrasi dengan web service sebelumnya yang dibangun menggunakan framework Django dengan cara membuat views yang mengembalikan response data dalam bentuk json. Sehingga, response berupa json tersebut dapat diproses untuk ditampilkan pada aplikasi flutter kami.
