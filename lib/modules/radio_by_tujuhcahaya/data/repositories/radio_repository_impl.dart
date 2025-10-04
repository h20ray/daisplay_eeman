// ignore_for_file: omit_local_variable_types

import 'dart:async';
import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:quran_app/common/global_variable.dart';
import 'package:quran_app/common/services/global_audio_manager.dart';
import 'package:quran_app/modules/radio_by_tujuhcahaya/config/radio_config.dart';
import 'package:quran_app/modules/radio_by_tujuhcahaya/domain/entities/radio_station.dart';
import 'package:quran_app/modules/radio_by_tujuhcahaya/domain/repositories/radio_repository.dart';
import 'package:radio_player/radio_player.dart';
import 'package:volume_regulator/volume_regulator.dart';

class RadioRepositoryImpl implements RadioRepository {
  RadioRepositoryImpl() {
    _initializeRadioPlayer();
  }

  final GlobalAudioManager _audioManager = locator<GlobalAudioManager>();
  final RadioConfigService _configService = locator<RadioConfigService>();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  final StreamController<bool> _isPlayingController =
      StreamController<bool>.broadcast();
  final StreamController<RadioStation> _currentStationController =
      StreamController<RadioStation>.broadcast();
  final StreamController<double> _volumeController =
      StreamController<double>.broadcast();

  RadioStation? _currentStation;
  bool _isPlaying = false;
  double _volume = 0; // Will be updated with system volume
  Timer? _debounceTimer;
  bool _isProcessingPlaybackState = false;
  StreamSubscription<int>? _volumeSubscription;

  StreamSubscription<PlaybackState>? _playbackStateSubscription;
  StreamSubscription<Metadata>? _metadataSubscription;

  void _initializeRadioPlayer() {
    // Initialize system volume
    _initializeVolume();

    // Check current playback state on initialization
    _checkCurrentPlaybackState();

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

          // Prevent processing if already processing
          if (_isProcessingPlaybackState) {
            return;
          }

          // Only process if state actually changed
          if (_isPlaying == playing) {
            return;
          }

          _isProcessingPlaybackState = true;

          // Debounce rapid state changes with longer delay
          _debounceTimer?.cancel();
          _debounceTimer = Timer(const Duration(milliseconds: 300), () {
            if (_isPlaying != playing) {
              _isPlaying = playing;
              if (!_isPlayingController.isClosed) {
                _isPlayingController.add(playing);
              }
              _audioManager.isRadioPlaying = playing;

              // Save or clear state based on playing status
              if (playing) {
                _saveRadioState();
              } else {
                _clearRadioState();
              }
            }
            _isProcessingPlaybackState = false;
          });
        } catch (e) {
          _isProcessingPlaybackState = false;
          // Handle playback state error silently
        }
      },
      onError: (Object error) {
        _isProcessingPlaybackState = false;
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

  void _initializeVolume() {
    // Get current system volume immediately
    VolumeRegulator.getVolume().then((value) {
      _volume = value.toDouble();
      if (!_volumeController.isClosed) {
        _volumeController.add(_volume);
      }
    }).catchError((error) {
      // If getting system volume fails, don't set any fallback
      // The volume will remain 0 until system volume is available
    });

    // Listen to system volume changes
    _volumeSubscription = VolumeRegulator.volumeStream.listen((value) {
      _volume = value.toDouble();
      if (!_volumeController.isClosed) {
        _volumeController.add(_volume);
      }
    });
  }

  void _checkCurrentPlaybackState() {
    // Restore state from persistent storage when app reopens
    _restoreRadioState();
  }

  Future<void> _restoreRadioState() async {
    try {
      // Get saved radio state from secure storage
      final savedIsPlaying = await _secureStorage.read(key: 'radio_is_playing');
      final savedStationJson =
          await _secureStorage.read(key: 'radio_current_station');

      if (savedIsPlaying == 'true' && savedStationJson != null) {
        // Radio was playing when app was closed, restore the state
        final stationMap = jsonDecode(savedStationJson) as Map<String, dynamic>;
        final restoredStation = RadioStation(
          id: stationMap['id'] as String,
          title: stationMap['title'] as String,
          url: stationMap['url'] as String,
          imagePath: stationMap['imagePath'] as String,
        );

        // Update internal state
        _isPlaying = true;
        _currentStation = restoredStation;
        _audioManager.isRadioPlaying = true;

        // Emit restored state
        if (!_isPlayingController.isClosed) {
          _isPlayingController.add(true);
        }
        if (!_currentStationController.isClosed) {
          _currentStationController.add(restoredStation);
        }
      }
    } catch (e) {
      // If restoration fails, clear any corrupted data
      await _clearRadioState();
    }
  }

  Future<void> _saveRadioState() async {
    try {
      if (_isPlaying && _currentStation != null) {
        // Save current state to persistent storage
        await _secureStorage.write(key: 'radio_is_playing', value: 'true');
        final stationJson = jsonEncode({
          'id': _currentStation!.id,
          'title': _currentStation!.title,
          'url': _currentStation!.url,
          'imagePath': _currentStation!.imagePath,
        });
        await _secureStorage.write(
            key: 'radio_current_station', value: stationJson,);
      } else {
        // Clear state if not playing
        await _clearRadioState();
      }
    } catch (e) {
      // Handle storage errors silently
    }
  }

  Future<void> _clearRadioState() async {
    try {
      await _secureStorage.delete(key: 'radio_is_playing');
      await _secureStorage.delete(key: 'radio_current_station');
    } catch (e) {
      // Handle storage errors silently
    }
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

      // Save state to persistent storage
      await _saveRadioState();
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

      // Clear state from persistent storage
      await _clearRadioState();
    } catch (e) {
      // Re-throw error to be handled by caller
      rethrow;
    }
  }

  @override
  Future<void> setVolume(double volume) async {
    try {
      // Set system volume using volume_regulator
      await VolumeRegulator.setVolume(volume.toInt());
      _volume = volume;
      if (!_volumeController.isClosed) {
        _volumeController.add(volume);
      }
    } catch (e) {
      // If setting system volume fails, still update local state for UI consistency
      _volume = volume;
      if (!_volumeController.isClosed) {
        _volumeController.add(volume);
      }
      rethrow;
    }
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
    _debounceTimer?.cancel();
    _playbackStateSubscription?.cancel();
    _metadataSubscription?.cancel();
    _volumeSubscription?.cancel();
    _isPlayingController.close();
    _currentStationController.close();
    _volumeController.close();
  }
}
