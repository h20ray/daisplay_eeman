import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';

class GlobalAudioManager {
  factory GlobalAudioManager() => _instance;

  GlobalAudioManager._internal();
  static final GlobalAudioManager _instance = GlobalAudioManager._internal();

  final List<AudioPlayer> _justAudioPlayers = [];
  final StreamController<bool> _radioPlayingController =
      StreamController<bool>.broadcast();
  final StreamController<bool> _justAudioPlayingController =
      StreamController<bool>.broadcast();

  bool _isRadioPlaying = false;
  bool _isJustAudioPlaying = false;
  AudioPlayer? _currentPlayingPlayer;
  AudioPlayer? radioPlayer;
  bool _isDisposed = false;

  bool get isRadioPlaying => _isRadioPlaying;
  bool get isJustAudioPlaying => _isJustAudioPlaying;

  Stream<bool> get radioPlayingStream => _radioPlayingController.stream;
  Stream<bool> get justAudioPlayingStream => _justAudioPlayingController.stream;

  void registerJustAudioPlayer(AudioPlayer player) {
    if (_isDisposed) return;

    if (!_justAudioPlayers.contains(player)) {
      _justAudioPlayers.add(player);
      _setupPlayerListener(player);
    }
  }

  void unregisterJustAudioPlayer(AudioPlayer player) {
    if (_isDisposed) return;

    _justAudioPlayers.remove(player);
    if (_currentPlayingPlayer == player) {
      _currentPlayingPlayer = null;
    }
  }

  void _setupPlayerListener(AudioPlayer player) {
    player.playerStateStream.listen((state) {
      if (_isDisposed) return;

      final isPlaying = state.playing;
      if (isPlaying && !_isJustAudioPlaying) {
        _currentPlayingPlayer = player;
        _handleJustAudioStarted();
      } else if (!isPlaying &&
          _isJustAudioPlaying &&
          _currentPlayingPlayer == player) {
        _currentPlayingPlayer = null;
        _handleJustAudioStopped();
      }
    });
  }

  Future<void> _handleJustAudioStarted() async {
    if (_isDisposed) return;

    if (_isRadioPlaying) {
      // Stop radio when just_audio starts
      await _stopRadioInternal();
    }

    // Stop all other just_audio players when a new one starts
    await _stopOtherJustAudioPlayers();

    _isJustAudioPlaying = true;
    if (!_isDisposed) {
      _justAudioPlayingController.add(true);
    }
  }

  void _handleJustAudioStopped() {
    if (_isDisposed) return;

    _isJustAudioPlaying = false;
    _justAudioPlayingController.add(false);
  }

  Future<void> stopAllJustAudioPlayers() async {
    if (_isDisposed) return;

    final futures = _justAudioPlayers.map(_fadeOutAndStop);
    await Future.wait(futures);
    _isJustAudioPlaying = false;
    if (!_isDisposed) {
      _justAudioPlayingController.add(false);
    }
  }

  Future<void> pauseAllJustAudioPlayers() async {
    if (_isDisposed) return;

    final futures = _justAudioPlayers.map((player) => player.pause());
    await Future.wait(futures);
    _isJustAudioPlaying = false;
    if (!_isDisposed) {
      _justAudioPlayingController.add(false);
    }
  }

  Future<void> setRadioPlaying({required bool isPlaying}) async {
    if (_isDisposed) return;

    if (isPlaying && _isJustAudioPlaying) {
      // Stop just_audio when radio starts
      await stopAllJustAudioPlayers();
      // Add a small delay to ensure clean transition
      await Future<void>.delayed(const Duration(milliseconds: 100));
    }
    _isRadioPlaying = isPlaying;
    if (!_isDisposed) {
      _radioPlayingController.add(isPlaying);
    }
  }

  Future<void> stopRadioIfPlaying() async {
    if (_isDisposed) return;

    if (_isRadioPlaying) {
      await _stopRadioInternal();
    }
  }

  Future<void> _stopRadioInternal() async {
    if (_isDisposed) return;

    if (radioPlayer != null) {
      await _fadeOutAndStop(radioPlayer!);
    }
    _isRadioPlaying = false;
    if (!_isDisposed) {
      _radioPlayingController.add(false);
    }
  }

  Future<void> _stopOtherJustAudioPlayers() async {
    if (_isDisposed || _currentPlayingPlayer == null) return;

    final otherPlayers = _justAudioPlayers
        .where((player) => player != _currentPlayingPlayer)
        .toList();

    if (otherPlayers.isNotEmpty) {
      final futures = otherPlayers.map(_fadeOutAndStop);
      await Future.wait(futures);
    }
  }

  Future<void> _fadeOutAndStop(AudioPlayer player) async {
    if (_isDisposed || !player.playing) return;

    try {
      const fadeSteps = 10; // Reduced from 20 to 10 for better performance
      const stepDuration =
          Duration(milliseconds: 50); // Increased from 25ms to 50ms

      final currentVolume = player.volume;
      final volumeStep = currentVolume / fadeSteps;

      // Fade out
      for (var i = fadeSteps; i > 0; i--) {
        if (_isDisposed) break;

        final newVolume = volumeStep * i;
        await player.setVolume(newVolume);
        await Future<void>.delayed(stepDuration);
      }

      // Stop the player
      await player.stop();

      // Reset volume to original level for future use
      await player.setVolume(currentVolume);
    } catch (e) {
      debugPrint('Error fading out audio player: $e');
    }
  }

  Future<void> _fadeIn(AudioPlayer player) async {
    if (_isDisposed) return;

    try {
      const fadeSteps = 10; // Reduced from 20 to 10 for better performance
      const stepDuration =
          Duration(milliseconds: 50); // Increased from 25ms to 50ms

      final targetVolume = player.volume;
      final volumeStep = targetVolume / fadeSteps;

      // Start with volume 0
      await player.setVolume(0);

      // Fade in
      for (var i = 1; i <= fadeSteps; i++) {
        if (_isDisposed) break;

        final newVolume = volumeStep * i;
        await player.setVolume(newVolume);
        await Future<void>.delayed(stepDuration);
      }
    } catch (e) {
      debugPrint('Error fading in audio player: $e');
    }
  }

  Future<void> startWithFadeIn(AudioPlayer player) async {
    if (_isDisposed) return;

    try {
      await player.play();
      await _fadeIn(player);
    } catch (e) {
      debugPrint('Error starting audio with fade in: $e');
    }
  }

  /// Safely stop all audio and clean up resources
  Future<void> stopAllAudio() async {
    if (_isDisposed) return;

    try {
      // Stop radio first
      if (_isRadioPlaying) {
        await _stopRadioInternal();
      }

      // Then stop all just_audio players
      await stopAllJustAudioPlayers();

      // Add a delay to ensure all audio sessions are released
      await Future<void>.delayed(
          const Duration(milliseconds: 200)); // Reduced from 300ms
    } catch (e) {
      debugPrint('Error stopping all audio: $e');
    }
  }

  /// Clean up unused audio players to free memory
  void cleanupUnusedPlayers() {
    if (_isDisposed) return;

    try {
      // Remove any players that are no longer valid
      _justAudioPlayers.removeWhere((player) {
        try {
          // Check if player is still valid
          return player.processingState == ProcessingState.idle;
        } catch (e) {
          // If we can't check the state, assume it's invalid
          return true;
        }
      });
    } catch (e) {
      debugPrint('Error cleaning up unused players: $e');
    }
  }

  void dispose() {
    _isDisposed = true;
    _radioPlayingController.close();
    _justAudioPlayingController.close();
  }
}
