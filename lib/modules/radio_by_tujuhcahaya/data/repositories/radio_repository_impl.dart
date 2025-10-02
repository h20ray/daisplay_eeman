import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:quran_app/common/global_variable.dart';
import 'package:quran_app/common/services/global_audio_manager.dart';
import 'package:quran_app/modules/radio_by_tujuhcahaya/domain/entities/radio_station.dart';
import 'package:quran_app/modules/radio_by_tujuhcahaya/domain/repositories/radio_repository.dart';

class RadioRepositoryImpl implements RadioRepository {
  RadioRepositoryImpl() {
    _initializeRadioPlayer();
  }

  final AudioPlayer _audioPlayer = AudioPlayer();
  final GlobalAudioManager _audioManager = locator<GlobalAudioManager>();
  final StreamController<bool> _isPlayingController =
      StreamController<bool>.broadcast();
  final StreamController<RadioStation> _currentStationController =
      StreamController<RadioStation>.broadcast();
  final StreamController<double> _volumeController =
      StreamController<double>.broadcast();

  RadioStation? _currentStation;
  bool _isPlaying = false;
  double _volume = 50;
  Timer? _debounceTimer;
  Timer? _playingDebounceTimer;
  bool _wasPlayingBeforeJustAudio = false;

  void _initializeRadioPlayer() {
    // Register radio player with global audio manager
    _audioManager.radioPlayer = _audioPlayer;

    _audioPlayer.playerStateStream.listen((playerState) {
      final isPlaying = playerState.playing;
      _isPlaying = isPlaying;

      // Debounce playing state changes to prevent blinking
      _playingDebounceTimer?.cancel();
      _playingDebounceTimer = Timer(const Duration(milliseconds: 50), () {
        _isPlayingController.add(isPlaying);
      });
    });

    _audioPlayer.sequenceStateStream.listen((sequenceState) {
      if (_currentStation != null && sequenceState.currentIndex != null) {
        final metadata =
            sequenceState.currentSource?.tag as Map<String, dynamic>?;
        if (metadata != null) {
          final updatedStation = _currentStation!.copyWith(
            artist: metadata['artist']?.toString(),
            track: metadata['title']?.toString(),
          );
          _currentStation = updatedStation;

          // Debounce rapid state changes to prevent blinking
          _debounceTimer?.cancel();
          _debounceTimer = Timer(const Duration(milliseconds: 100), () {
            _currentStationController.add(updatedStation);
          });
        }
      }
    });
  }

  @override
  Future<void> playRadio(RadioStation station) async {
    try {
      // Stop any existing audio from just_audio
      await _audioManager.stopAllJustAudioPlayers();

      // Add a delay to ensure audio session is completely released
      await Future<void>.delayed(
          const Duration(milliseconds: 300)); // Reduced from 500ms

      _currentStation = station;
      _currentStationController.add(station);
      _wasPlayingBeforeJustAudio = true;

      // Create audio source with metadata
      final audioSource = AudioSource.uri(
        Uri.parse(station.url),
        tag: {
          'title': station.title,
          'artist': station.artist ?? '',
          'imagePath': station.imagePath,
        },
      );

      await _audioPlayer.setAudioSource(audioSource);

      // Add a small delay after setting source
      await Future<void>.delayed(
          const Duration(milliseconds: 100)); // Reduced from 200ms

      await _audioManager.startWithFadeIn(_audioPlayer);
      await _audioManager.setRadioPlaying(isPlaying: true);
    } catch (e) {
      debugPrint('Error playing radio: $e');
      rethrow;
    }
  }

  @override
  Future<void> pauseRadio() async {
    try {
      await _audioPlayer.pause();
      await _audioManager.setRadioPlaying(isPlaying: false);
    } catch (e) {
      debugPrint('Error pausing radio: $e');
      rethrow;
    }
  }

  @override
  Future<void> stopRadio() async {
    try {
      await _audioPlayer.stop();
      _currentStation = null;
      _wasPlayingBeforeJustAudio = false;
      await _audioManager.setRadioPlaying(isPlaying: false);
    } catch (e) {
      debugPrint('Error stopping radio: $e');
      rethrow;
    }
  }

  @override
  Future<void> setVolume(double volume) async {
    _volume = volume;
    _volumeController.add(volume);
    await _audioPlayer.setVolume(volume / 100.0); // Convert to 0.0-1.0 range
  }

  @override
  Stream<bool> get isPlayingStream => _isPlayingController.stream;

  @override
  Stream<RadioStation> get currentStationStream =>
      _currentStationController.stream;

  @override
  Stream<double> get volumeStream => _volumeController.stream;

  @override
  RadioStation? get currentStation => _currentStation;

  @override
  bool get isPlaying => _isPlaying;

  @override
  double get volume => _volume;

  @override
  bool get wasPlayingBeforeJustAudio => _wasPlayingBeforeJustAudio;

  @override
  Future<void> restartIfWasPlaying() async {
    if (_wasPlayingBeforeJustAudio && _currentStation != null) {
      await playRadio(_currentStation!);
    }
  }

  void dispose() {
    _debounceTimer?.cancel();
    _playingDebounceTimer?.cancel();
    _audioPlayer.dispose();
    _isPlayingController.close();
    _currentStationController.close();
    _volumeController.close();
  }
}
