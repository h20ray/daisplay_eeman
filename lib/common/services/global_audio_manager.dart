import 'dart:async';
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
  Future<void> Function()? _stopRadioCallback;

  bool get isRadioPlaying => _isRadioPlaying;
  bool get isJustAudioPlaying => _isJustAudioPlaying;

  Stream<bool> get radioPlayingStream => _radioPlayingController.stream;
  Stream<bool> get justAudioPlayingStream => _justAudioPlayingController.stream;

  // ignore: unnecessary_getters_setters
  Future<void> Function()? get stopRadioCallback => _stopRadioCallback;

  void registerJustAudioPlayer(AudioPlayer player) {
    if (!_justAudioPlayers.contains(player)) {
      _justAudioPlayers.add(player);
      _setupPlayerListener(player);
    }
  }

  void unregisterJustAudioPlayer(AudioPlayer player) {
    _justAudioPlayers.remove(player);
    if (_currentPlayingPlayer == player) {
      _currentPlayingPlayer = null;
    }
  }

  set stopRadioCallback(Future<void> Function()? callback) {
    _stopRadioCallback = callback;
  }

  void unregisterStopRadioCallback() {
    _stopRadioCallback = null;
  }

  void _setupPlayerListener(AudioPlayer player) {
    player.playerStateStream.listen((state) {
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
    if (_isRadioPlaying) {
      // Stop radio when just_audio starts
      await _stopRadioInternal();
    }

    // Stop all other just_audio players when a new one starts
    await _stopOtherJustAudioPlayers();

    _isJustAudioPlaying = true;
    _justAudioPlayingController.add(true);
  }

  void _handleJustAudioStopped() {
    _isJustAudioPlaying = false;
    _justAudioPlayingController.add(false);
  }

  Future<void> stopAllJustAudioPlayers() async {
    final futures = _justAudioPlayers.map((player) => player.stop());
    await Future.wait(futures);
    _isJustAudioPlaying = false;
    _justAudioPlayingController.add(false);
  }

  Future<void> pauseAllJustAudioPlayers() async {
    final futures = _justAudioPlayers.map((player) => player.pause());
    await Future.wait(futures);
    _isJustAudioPlaying = false;
    _justAudioPlayingController.add(false);
  }

  set isRadioPlaying(bool isPlaying) {
    if (isPlaying && _isJustAudioPlaying) {
      // Stop just_audio when radio starts
      stopAllJustAudioPlayers();
    }
    _isRadioPlaying = isPlaying;
    _radioPlayingController.add(isPlaying);
  }

  Future<void> stopRadioIfPlaying() async {
    if (_isRadioPlaying) {
      await _stopRadioInternal();
    }
  }

  Future<void> _stopRadioInternal() async {
    if (_stopRadioCallback != null) {
      await _stopRadioCallback!.call();
    }
    _isRadioPlaying = false;
    _radioPlayingController.add(false);
  }

  Future<void> _stopOtherJustAudioPlayers() async {
    if (_currentPlayingPlayer == null) return;

    final otherPlayers = _justAudioPlayers
        .where((player) => player != _currentPlayingPlayer)
        .toList();

    if (otherPlayers.isNotEmpty) {
      final futures = otherPlayers.map((player) => player.stop());
      await Future.wait(futures);
    }
  }

  void dispose() {
    _radioPlayingController.close();
    _justAudioPlayingController.close();
  }
}
