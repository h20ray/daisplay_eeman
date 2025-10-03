// ignore_for_file: omit_local_variable_types

import 'dart:async';

import 'package:quran_app/common/global_variable.dart';
import 'package:quran_app/common/services/global_audio_manager.dart';
import 'package:quran_app/modules/radio_by_tujuhcahaya/config/radio_config.dart';
import 'package:quran_app/modules/radio_by_tujuhcahaya/domain/entities/radio_station.dart';
import 'package:quran_app/modules/radio_by_tujuhcahaya/domain/repositories/radio_repository.dart';
import 'package:radio_player/radio_player.dart';

class RadioRepositoryImpl implements RadioRepository {
  RadioRepositoryImpl() {
    _initializeRadioPlayer();
  }

  final GlobalAudioManager _audioManager = locator<GlobalAudioManager>();
  final RadioConfigService _configService = locator<RadioConfigService>();
  final StreamController<bool> _isPlayingController =
      StreamController<bool>.broadcast();
  final StreamController<RadioStation> _currentStationController =
      StreamController<RadioStation>.broadcast();
  final StreamController<double> _volumeController =
      StreamController<double>.broadcast();

  RadioStation? _currentStation;
  bool _isPlaying = false;
  double _volume = 50;

  StreamSubscription<PlaybackState>? _playbackStateSubscription;
  StreamSubscription<Metadata>? _metadataSubscription;

  void _initializeRadioPlayer() {
    // Register radio stop callback so GlobalAudioManager can stop radio if needed
    _audioManager.stopRadioCallback = () async {
      try {
        await RadioPlayer.reset();
      } catch (e) {
        // Log error but don't throw to prevent callback failures
      }
    };

    // Note: Some plugins support disabling ICY metadata parsing.
    // The current radio_player in use does not expose that API here.
    // We enforce static notification text via the metadata listener below.

    _playbackStateSubscription = RadioPlayer.playbackStateStream.listen(
      (playbackState) {
        try {
          final playing = playbackState == PlaybackState.playing;
          _isPlaying = playing;
          if (!_isPlayingController.isClosed) {
            _isPlayingController.add(playing);
          }
          _audioManager.isRadioPlaying = playing;
        } catch (e) {
          // Handle playback state error silently
        }
      },
      onError: (Object error) {
        // Handle playback state stream error
        if (!_isPlayingController.isClosed) {
          _isPlayingController.add(false);
        }
      },
    );

    // Respect config: allow stream metadata in notification or keep static
    _metadataSubscription = RadioPlayer.metadataStream.listen(
      (metadata) async {
        try {
          final bool allowMetadata =
              _configService.currentConfig.showMetadataInNotification;
          if (allowMetadata) return;
          if (!_isPlaying) return;
          final String title = _configService.currentConfig.notificationTitle;
          final String subtitle =
              _configService.currentConfig.notificationSubtitle;
          final String composedTitle =
              subtitle.isNotEmpty ? '$title • $subtitle' : title;
          final String url = _currentStation?.url ?? '';
          final bool hasLogo = _currentStation?.imagePath.isNotEmpty ?? false;
          final String? logo = hasLogo ? _currentStation!.imagePath : null;
          if (url.isEmpty) return;
          await RadioPlayer.setStation(
            title: composedTitle,
            url: url,
            logoAssetPath: logo,
          );
        } catch (e) {
          // Handle metadata error silently
        }
      },
      onError: (Object error) {
        // Handle metadata stream error silently
      },
    );
  }

  @override
  Future<void> playRadio(RadioStation station) async {
    try {
      // Stop any existing audio from just_audio
      await _audioManager.stopAllJustAudioPlayers();
      await Future<void>.delayed(const Duration(milliseconds: 200));

      _currentStation = station;
      if (!_currentStationController.isClosed) {
        _currentStationController.add(station);
      }

      final bool allowMetadata =
          _configService.currentConfig.showMetadataInNotification;
      final String title = _configService.currentConfig.notificationTitle;
      final String subtitle = _configService.currentConfig.notificationSubtitle;
      final String composedTitle =
          subtitle.isNotEmpty ? '$title • $subtitle' : title;

      await RadioPlayer.setStation(
        title: allowMetadata ? station.title : composedTitle,
        url: station.url,
        logoAssetPath: station.imagePath.isNotEmpty ? station.imagePath : null,
      );
      await RadioPlayer.play();
    } catch (e) {
      // Re-throw error to be handled by caller
      rethrow;
    }
  }

  @override
  Future<void> pauseRadio() async {
    try {
      await RadioPlayer.pause();
    } catch (e) {
      // Re-throw error to be handled by caller
      rethrow;
    }
  }

  @override
  Future<void> stopRadio() async {
    try {
      await RadioPlayer.reset();
      _currentStation = null;
      _audioManager.isRadioPlaying = false;
    } catch (e) {
      // Re-throw error to be handled by caller
      rethrow;
    }
  }

  @override
  Future<void> setVolume(double volume) async {
    _volume = volume;
    if (!_volumeController.isClosed) {
      _volumeController.add(volume);
    }
    // radio_player API controls system volume via a separate plugin; keep value for UI only.
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

  void dispose() {
    _audioManager.unregisterStopRadioCallback();
    _playbackStateSubscription?.cancel();
    _metadataSubscription?.cancel();
    _isPlayingController.close();
    _currentStationController.close();
    _volumeController.close();
  }
}
