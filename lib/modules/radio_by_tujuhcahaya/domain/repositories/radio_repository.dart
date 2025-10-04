import 'package:quran_app/modules/radio_by_tujuhcahaya/domain/entities/radio_station.dart';
import 'package:quran_app/modules/radio_by_tujuhcahaya/presentation/blocs/state/radio_state.dart';

abstract class RadioRepository {
  Future<void> playRadio(RadioStation station);
  Future<void> pauseRadio();
  Future<void> stopRadio();
  Future<void> setVolume(double volume);
  Stream<bool> get isPlayingStream;
  Stream<RadioStation> get currentStationStream;
  Stream<double> get volumeStream;
  Stream<AudioQuality> get audioQualityStream;
  Stream<double> get audioLevelStream;
  RadioStation? get currentStation;
  bool get isPlaying;
  double get volume;
  AudioQuality get audioQuality;
  double get audioLevel;
}
