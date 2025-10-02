import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_id.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('id')];

  /// No description provided for @appName.
  ///
  /// In id, this message translates to:
  /// **'Eeman'**
  String get appName;

  /// No description provided for @appInfo.
  ///
  /// In id, this message translates to:
  /// **'Eeman - Aplikasi Islami dengan fitur doa sehari-hari, Quran offline, jadwal sholat, tasbih digital, dan alarm sholat.\n\nbuilt with <3 by Wafastarz.'**
  String get appInfo;

  /// No description provided for @back.
  ///
  /// In id, this message translates to:
  /// **'Kembali'**
  String get back;

  /// No description provided for @next.
  ///
  /// In id, this message translates to:
  /// **'Lanjut'**
  String get next;

  /// No description provided for @surahListPageAppBarTitle.
  ///
  /// In id, this message translates to:
  /// **'Kumpulan Surah'**
  String get surahListPageAppBarTitle;

  /// No description provided for @doaSehariHari.
  ///
  /// In id, this message translates to:
  /// **'Do\'a\nSehari-hari'**
  String get doaSehariHari;

  /// No description provided for @quranOffline.
  ///
  /// In id, this message translates to:
  /// **'Quran\n(Offline)'**
  String get quranOffline;

  /// No description provided for @shalatTime.
  ///
  /// In id, this message translates to:
  /// **'Jadwal\nShalat'**
  String get shalatTime;

  /// No description provided for @tasbihDigital.
  ///
  /// In id, this message translates to:
  /// **'Tasbih\nDigital'**
  String get tasbihDigital;

  /// No description provided for @qiblaDirection.
  ///
  /// In id, this message translates to:
  /// **'Arah\nKiblat'**
  String get qiblaDirection;

  /// No description provided for @errorNoSurahFound.
  ///
  /// In id, this message translates to:
  /// **'Tidak ada surah yang cocok dengan pencarian.\nCoba ulangi ketik surah yang kamu cari.'**
  String get errorNoSurahFound;

  /// No description provided for @findSurah.
  ///
  /// In id, this message translates to:
  /// **'Cari Surah'**
  String get findSurah;

  /// No description provided for @dontForgetPray.
  ///
  /// In id, this message translates to:
  /// **'Jangan lupa sholat nya yaa <3'**
  String get dontForgetPray;

  /// No description provided for @hour.
  ///
  /// In id, this message translates to:
  /// **'jam'**
  String get hour;

  /// No description provided for @minute.
  ///
  /// In id, this message translates to:
  /// **'menit'**
  String get minute;

  /// No description provided for @to.
  ///
  /// In id, this message translates to:
  /// **'menuju'**
  String get to;

  /// No description provided for @more.
  ///
  /// In id, this message translates to:
  /// **'lebih banyak'**
  String get more;

  /// No description provided for @explore.
  ///
  /// In id, this message translates to:
  /// **'Eksplor'**
  String get explore;

  /// No description provided for @nightMode.
  ///
  /// In id, this message translates to:
  /// **'Mode Malam'**
  String get nightMode;

  /// No description provided for @internetNeeded.
  ///
  /// In id, this message translates to:
  /// **'Internet Dibutuhkan'**
  String get internetNeeded;

  /// No description provided for @internetNeededDesc.
  ///
  /// In id, this message translates to:
  /// **'Untuk memutar audio quran membutuhkan koneksi internet, mohon periksa kembali koneksi internet kamu.'**
  String get internetNeededDesc;

  /// No description provided for @tafsirSource.
  ///
  /// In id, this message translates to:
  /// **'Sumber = Kementrian Agama Republik Indonesia'**
  String get tafsirSource;

  /// No description provided for @tafsirBottomSheetTitle.
  ///
  /// In id, this message translates to:
  /// **'Tafsir surah {surahName} ayat {ayah}'**
  String tafsirBottomSheetTitle(String surahName, String ayah);

  /// No description provided for @lastRead.
  ///
  /// In id, this message translates to:
  /// **'Terakhir Baca'**
  String get lastRead;

  /// No description provided for @alFatiha.
  ///
  /// In id, this message translates to:
  /// **'Al-Fatiha'**
  String get alFatiha;

  /// No description provided for @close.
  ///
  /// In id, this message translates to:
  /// **'Tutup'**
  String get close;

  /// No description provided for @refresh.
  ///
  /// In id, this message translates to:
  /// **'Muat Ulang'**
  String get refresh;

  /// No description provided for @lastReadError.
  ///
  /// In id, this message translates to:
  /// **'Maaf, kamu belum menentukan terakhir baca kamu,\nMari mulai dari surah pertama, Al-Fatiha'**
  String get lastReadError;

  /// No description provided for @find.
  ///
  /// In id, this message translates to:
  /// **'Cari'**
  String get find;

  /// No description provided for @findAyah.
  ///
  /// In id, this message translates to:
  /// **'Cari Ayat'**
  String get findAyah;

  /// No description provided for @whatAyah.
  ///
  /// In id, this message translates to:
  /// **'Ayat ke berapa?'**
  String get whatAyah;

  /// No description provided for @setLastReadInfo.
  ///
  /// In id, this message translates to:
  /// **'Berhasil menandai ayat {i} sebagai terakhir dibaca.'**
  String setLastReadInfo(String i);

  /// No description provided for @noInternetConnection.
  ///
  /// In id, this message translates to:
  /// **'Koneksi Internet Terputus'**
  String get noInternetConnection;

  /// No description provided for @featureNeedInternet.
  ///
  /// In id, this message translates to:
  /// **'Fitur ini membutuhkan akses internet\nperiksa koneksi internet kamu.'**
  String get featureNeedInternet;

  /// No description provided for @filterList.
  ///
  /// In id, this message translates to:
  /// **'Filter List'**
  String get filterList;

  /// No description provided for @apply.
  ///
  /// In id, this message translates to:
  /// **'Terapkan'**
  String get apply;

  /// No description provided for @totalAyat.
  ///
  /// In id, this message translates to:
  /// **'Jumlah Ayat = {i}'**
  String totalAyat(String i);

  /// No description provided for @feedbackAndReport.
  ///
  /// In id, this message translates to:
  /// **'Request Fitur / Laporkan Bug'**
  String get feedbackAndReport;

  /// No description provided for @feedbackInfo.
  ///
  /// In id, this message translates to:
  /// **'Menemukan bug? atau mau request fitur lain? kirim saran dan feedback kalian ke email dengan cara klik button dibawah, Termimakasih.'**
  String get feedbackInfo;

  /// No description provided for @emailFeedbackSubject.
  ///
  /// In id, this message translates to:
  /// **'Eeman App Feedback'**
  String get emailFeedbackSubject;

  /// No description provided for @feedbackOrFeature.
  ///
  /// In id, this message translates to:
  /// **'Mau kasih feedback atau request fitur?'**
  String get feedbackOrFeature;

  /// No description provided for @writeYourFeedback.
  ///
  /// In id, this message translates to:
  /// **'Masukkan feedback kamu dibawah ya'**
  String get writeYourFeedback;

  /// No description provided for @wdyt.
  ///
  /// In id, this message translates to:
  /// **'Bagaimana pendapatmu tentang ini?'**
  String get wdyt;

  /// No description provided for @send.
  ///
  /// In id, this message translates to:
  /// **'Kirim'**
  String get send;

  /// No description provided for @settings.
  ///
  /// In id, this message translates to:
  /// **'Pengaturan'**
  String get settings;

  /// No description provided for @retry.
  ///
  /// In id, this message translates to:
  /// **'Coba Lagi'**
  String get retry;

  /// No description provided for @locationNotEnabledErrorMesage.
  ///
  /// In id, this message translates to:
  /// **'Hidupkan Lokasi GPS untuk mengakses\nfitur ini.'**
  String get locationNotEnabledErrorMesage;

  /// No description provided for @locationDeniedErrorMesage.
  ///
  /// In id, this message translates to:
  /// **'Akses Lokasi ponsel ini ditolak\nIzinkan akses Lokasi terlebih dahului'**
  String get locationDeniedErrorMesage;

  /// No description provided for @sensorNotSupported.
  ///
  /// In id, this message translates to:
  /// **'Sensor tidak didukung'**
  String get sensorNotSupported;

  /// No description provided for @xFontSize.
  ///
  /// In id, this message translates to:
  /// **'Ukuran Font {type}'**
  String xFontSize(String type);

  /// No description provided for @showX.
  ///
  /// In id, this message translates to:
  /// **'Tampilkan {type}'**
  String showX(String type);

  /// No description provided for @setAppearance.
  ///
  /// In id, this message translates to:
  /// **'Atur tampilan'**
  String get setAppearance;

  /// No description provided for @turnOnLocation.
  ///
  /// In id, this message translates to:
  /// **'Aktifkan Layanan Lokasi'**
  String get turnOnLocation;

  /// No description provided for @needLocationServiceWantToEnable.
  ///
  /// In id, this message translates to:
  /// **'Aplikasi ini memerlukan layanan lokasi untuk mengakses fitur tertentu.\nApakah Anda ingin mengaktifkannya?'**
  String get needLocationServiceWantToEnable;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['id'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'id':
      return AppLocalizationsId();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
