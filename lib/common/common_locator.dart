import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:quran_app/common/common.dart';
import 'package:quran_app/common/global_variable.dart';
import 'package:quran_app/modules/radio_by_tujuhcahaya/domain/services/radio_config_service.dart';

void setupLocatorCommon() {
  // *LocalDataService
  locator
    ..registerLazySingleton(
      () => LocalDataServiceImpl(storage: locator<FlutterSecureStorage>()),
    )
    // *LocalData
    ..registerLazySingleton(LastReadAyahLocalData.new)
    // *LocalData
    ..registerLazySingleton(AlarmListLocalData.new)
    // *LocalData
    ..registerLazySingleton(ThemeLocalData.new)
    // *LocalData
    ..registerLazySingleton(PrayerTimeFilterListLocalData.new)
    // *LocalData
    ..registerLazySingleton(PreferencesLocalData.new)
    // *LocationService
    ..registerLazySingleton(LocationService.new)
    // *GlobalAudioManager
    ..registerLazySingleton(GlobalAudioManager.new)
    // *RadioConfigService
    ..registerLazySingleton(RadioConfigService.new);
}
