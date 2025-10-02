import 'package:quran_app/modules/radio_by_tujuhcahaya/domain/entities/radio_station.dart';

abstract class RadioRepository {
  Future<void> playRadio(RadioStation station);
  Future<void> pauseRadio();
  Future<void> stopRadio();
  Future<void> setVolume(double volume);
  Stream<bool> get isPlayingStream;
  Stream<RadioStation> get currentStationStream;
  Stream<double> get volumeStream;
  RadioStation? get currentStation;
  bool get isPlaying;
  double get volume;
  bool get wasPlayingBeforeJustAudio;
  Future<void> restartIfWasPlaying();
}
