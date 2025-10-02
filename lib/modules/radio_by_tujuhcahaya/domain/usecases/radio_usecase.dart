import 'package:quran_app/modules/radio_by_tujuhcahaya/domain/entities/radio_station.dart';
import 'package:quran_app/modules/radio_by_tujuhcahaya/domain/repositories/radio_repository.dart';

class RadioUseCase {
  const RadioUseCase(this._repository);

  final RadioRepository _repository;

  Future<void> playRadio(RadioStation station) =>
      _repository.playRadio(station);
  Future<void> pauseRadio() => _repository.pauseRadio();
  Future<void> stopRadio() => _repository.stopRadio();
  Future<void> setVolume(double volume) => _repository.setVolume(volume);
  Stream<bool> get isPlayingStream => _repository.isPlayingStream;
  Stream<RadioStation> get currentStationStream =>
      _repository.currentStationStream;
  Stream<double> get volumeStream => _repository.volumeStream;
  RadioStation? get currentStation => _repository.currentStation;
  bool get isPlaying => _repository.isPlaying;
  double get volume => _repository.volume;
  bool get wasPlayingBeforeJustAudio => _repository.wasPlayingBeforeJustAudio;
  Future<void> restartIfWasPlaying() => _repository.restartIfWasPlaying();
}
