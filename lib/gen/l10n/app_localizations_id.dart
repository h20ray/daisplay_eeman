// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get appName => 'Dais Play';

  @override
  String get appInfo =>
      'Dais Play - 107.9 FM - Aplikasi Islami dengan fitur doa sehari-hari, Quran offline, jadwal sholat, tasbih digital, dan radio online.\n\nbuilt with <3 by Tujuhcahaya. \nCredit to Wafastarz.';

  @override
  String get back => 'Kembali';

  @override
  String get next => 'Lanjut';

  @override
  String get surahListPageAppBarTitle => 'Kumpulan Surah';

  @override
  String get doaSehariHari => 'Do\'a\nSehari-hari';

  @override
  String get quranOffline => 'Quran\n(Offline)';

  @override
  String get shalatTime => 'Jadwal\nShalat';

  @override
  String get tasbihDigital => 'Tasbih\nDigital';

  @override
  String get qiblaDirection => 'Arah\nKiblat';

  @override
  String get errorNoSurahFound =>
      'Tidak ada surah yang cocok dengan pencarian.\nCoba ulangi ketik surah yang kamu cari.';

  @override
  String get findSurah => 'Cari Surah';

  @override
  String get dontForgetPray => 'Jangan lupa sholat nya yaa <3';

  @override
  String get hour => 'jam';

  @override
  String get minute => 'menit';

  @override
  String get to => 'menuju';

  @override
  String get more => 'lebih banyak';

  @override
  String get explore => 'Eksplor';

  @override
  String get nightMode => 'Mode Malam';

  @override
  String get internetNeeded => 'Internet Dibutuhkan';

  @override
  String get internetNeededDesc =>
      'Untuk memutar audio quran membutuhkan koneksi internet, mohon periksa kembali koneksi internet kamu.';

  @override
  String get tafsirSource => 'Sumber = Kementrian Agama Republik Indonesia';

  @override
  String tafsirBottomSheetTitle(String surahName, String ayah) {
    return 'Tafsir surah $surahName ayat $ayah';
  }

  @override
  String get lastRead => 'Terakhir Baca';

  @override
  String get alFatiha => 'Al-Fatiha';

  @override
  String get close => 'Tutup';

  @override
  String get refresh => 'Muat Ulang';

  @override
  String get lastReadError =>
      'Maaf, kamu belum menentukan terakhir baca kamu,\nMari mulai dari surah pertama, Al-Fatiha';

  @override
  String get find => 'Cari';

  @override
  String get findAyah => 'Cari Ayat';

  @override
  String get whatAyah => 'Ayat ke berapa?';

  @override
  String setLastReadInfo(String i) {
    return 'Berhasil menandai ayat $i sebagai terakhir dibaca.';
  }

  @override
  String get noInternetConnection => 'Koneksi Internet Terputus';

  @override
  String get featureNeedInternet =>
      'Fitur ini membutuhkan akses internet\nperiksa koneksi internet kamu.';

  @override
  String get filterList => 'Filter List';

  @override
  String get apply => 'Terapkan';

  @override
  String totalAyat(String i) {
    return 'Jumlah Ayat = $i';
  }

  @override
  String get feedbackAndReport => 'Request Fitur / Laporkan Bug';

  @override
  String get feedbackInfo =>
      'Menemukan bug? atau mau request fitur lain? kirim saran dan feedback kalian ke email dengan cara klik button dibawah, Termimakasih.';

  @override
  String get emailFeedbackSubject => 'Eeman App Feedback';

  @override
  String get feedbackOrFeature => 'Mau kasih feedback atau request fitur?';

  @override
  String get writeYourFeedback => 'Masukkan feedback kamu dibawah ya';

  @override
  String get wdyt => 'Bagaimana pendapatmu tentang ini?';

  @override
  String get send => 'Kirim';

  @override
  String get settings => 'Pengaturan';

  @override
  String get retry => 'Coba Lagi';

  @override
  String get locationNotEnabledErrorMesage =>
      'Hidupkan Lokasi GPS untuk mengakses\nfitur ini.';

  @override
  String get locationDeniedErrorMesage =>
      'Akses Lokasi ponsel ini ditolak\nIzinkan akses Lokasi terlebih dahului';

  @override
  String get sensorNotSupported => 'Sensor tidak didukung';

  @override
  String xFontSize(String type) {
    return 'Ukuran Font $type';
  }

  @override
  String showX(String type) {
    return 'Tampilkan $type';
  }

  @override
  String get setAppearance => 'Atur tampilan';

  @override
  String get turnOnLocation => 'Aktifkan Layanan Lokasi';

  @override
  String get needLocationServiceWantToEnable =>
      'Aplikasi ini memerlukan layanan lokasi untuk mengakses fitur tertentu.\nApakah Anda ingin mengaktifkannya?';
}
