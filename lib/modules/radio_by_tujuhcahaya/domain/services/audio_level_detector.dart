import 'dart:async';
import 'dart:math';
import 'package:quran_app/modules/radio_by_tujuhcahaya/presentation/blocs/state/radio_state.dart';

/// Service for detecting audio levels and determining if content is live or off-air
class AudioLevelDetector {
  AudioLevelDetector({
    required this.liveContentThreshold,
    required this.noiseThreshold,
    required this.analysisInterval,
    required this.offAirDetectionDuration,
  });

  final double liveContentThreshold; // dB threshold for actual live content (not noise)
  final double noiseThreshold; // dB threshold below which is considered noise/silence
  final int analysisInterval; // milliseconds between analysis
  final int offAirDetectionDuration; // milliseconds of noise before marking off-air

  final StreamController<AudioQuality> _audioQualityController =
      StreamController<AudioQuality>.broadcast();
  final StreamController<double> _audioLevelController =
      StreamController<double>.broadcast();

  Timer? _analysisTimer;
  DateTime? _lowAudioStartTime;
  AudioQuality _currentQuality = AudioQuality.unknown;
  double _currentAudioLevel = 0;
  bool _isMonitoring = false;

  Stream<AudioQuality> get audioQualityStream => _audioQualityController.stream;
  Stream<double> get audioLevelStream => _audioLevelController.stream;

  AudioQuality get currentQuality => _currentQuality;
  double get currentAudioLevel => _currentAudioLevel;

  /// Start monitoring audio levels
  void startMonitoring() {
    if (_isMonitoring) return;
    
    _isMonitoring = true;
    _analysisTimer?.cancel();
    _analysisTimer = Timer.periodic(
      Duration(milliseconds: analysisInterval),
      (_) => _analyzeAudioLevel(),
    );
  }

  /// Stop monitoring audio levels
  void stopMonitoring() {
    if (!_isMonitoring) return;
    
    _isMonitoring = false;
    _analysisTimer?.cancel();
    _analysisTimer = null;
    _lowAudioStartTime = null;
    _currentQuality = AudioQuality.unknown;
    _currentAudioLevel = 0.0;
    
    // Emit the reset state
    _audioLevelController.add(0);
    _audioQualityController.add(AudioQuality.unknown);
  }

  /// Simulate audio level detection
  /// In a real implementation, this would interface with system audio APIs
  void _analyzeAudioLevel() {
    // Only analyze if monitoring is active
    if (!_isMonitoring) return;
    
    // Simulate audio level detection
    // In practice, this would use platform-specific audio analysis
    final simulatedLevel = _simulateAudioLevel();
    
    _currentAudioLevel = simulatedLevel;
    _audioLevelController.add(simulatedLevel);

    // Determine audio quality based on thresholds
    if (simulatedLevel > liveContentThreshold) {
      // Audio level is above live content threshold - actual content is playing
      _lowAudioStartTime = null;
      if (_currentQuality != AudioQuality.live) {
        _currentQuality = AudioQuality.live;
        _audioQualityController.add(_currentQuality);
      }
    } else if (simulatedLevel > noiseThreshold) {
      // Audio level is between thresholds - this is noise/off-air
      _lowAudioStartTime ??= DateTime.now();
      
      final noiseDuration = DateTime.now().difference(_lowAudioStartTime!).inMilliseconds;
      
      if (noiseDuration >= offAirDetectionDuration && _currentQuality != AudioQuality.offAir) {
        _currentQuality = AudioQuality.offAir;
        _audioQualityController.add(_currentQuality);
      }
    } else {
      // Audio level is below noise threshold - this is silence
      _lowAudioStartTime ??= DateTime.now();
      
      final silenceDuration = DateTime.now().difference(_lowAudioStartTime!).inMilliseconds;
      
      if (silenceDuration >= offAirDetectionDuration && _currentQuality != AudioQuality.offAir) {
        _currentQuality = AudioQuality.offAir;
        _audioQualityController.add(_currentQuality);
      }
    }
  }

  /// Simulate audio level detection
  /// This is a placeholder - in reality, you would use platform-specific audio analysis
  double _simulateAudioLevel() {
    // Simulate realistic radio audio levels
    // Most radio stations have consistent audio levels with occasional variations
    
    final random = Random();
    
    // 85% chance of live content, 12% chance of off-air noise, 3% chance of silence
    final scenario = random.nextDouble();
    
    if (scenario < 0.85) {
      // Live content - audio levels above live content threshold (-30)
      return -25.0 + random.nextDouble() * 10.0; // -25 to -15 dB
    } else if (scenario < 0.97) {
      // Off-air noise - audio levels between thresholds (below -30, above -50)
      return -45.0 + random.nextDouble() * 10.0; // -45 to -35 dB
    } else {
      // Silence - very low audio levels (below -50)
      return -65.0 + random.nextDouble() * 10.0; // -65 to -55 dB
    }
  }

  /// Manually set audio level (for testing or external audio analysis)
  void setAudioLevel(double level) {
    _currentAudioLevel = level;
    _audioLevelController.add(level);

    // Determine audio quality based on thresholds
    if (level > liveContentThreshold) {
      // Audio level is above live content threshold - actual content is playing
      _lowAudioStartTime = null;
      if (_currentQuality != AudioQuality.live) {
        _currentQuality = AudioQuality.live;
        _audioQualityController.add(_currentQuality);
      }
    } else if (level > noiseThreshold) {
      // Audio level is between thresholds - this is noise/off-air
      _lowAudioStartTime ??= DateTime.now();
      
      final noiseDuration = DateTime.now().difference(_lowAudioStartTime!).inMilliseconds;
      
      if (noiseDuration >= offAirDetectionDuration && _currentQuality != AudioQuality.offAir) {
        _currentQuality = AudioQuality.offAir;
        _audioQualityController.add(_currentQuality);
      }
    } else {
      // Audio level is below noise threshold - this is silence
      _lowAudioStartTime ??= DateTime.now();
      
      final silenceDuration = DateTime.now().difference(_lowAudioStartTime!).inMilliseconds;
      
      if (silenceDuration >= offAirDetectionDuration && _currentQuality != AudioQuality.offAir) {
        _currentQuality = AudioQuality.offAir;
        _audioQualityController.add(_currentQuality);
      }
    }
  }

  /// Force immediate analysis of current audio level
  void analyzeCurrentLevel() {
    // Determine audio quality based on thresholds
    if (_currentAudioLevel > liveContentThreshold) {
      // Audio level is above live content threshold - actual content is playing
      _lowAudioStartTime = null;
      if (_currentQuality != AudioQuality.live) {
        _currentQuality = AudioQuality.live;
        _audioQualityController.add(_currentQuality);
      }
    } else if (_currentAudioLevel > noiseThreshold) {
      // Audio level is between thresholds - this is noise/off-air
      _lowAudioStartTime ??= DateTime.now();
      
      final noiseDuration = DateTime.now().difference(_lowAudioStartTime!).inMilliseconds;
      
      if (noiseDuration >= offAirDetectionDuration && _currentQuality != AudioQuality.offAir) {
        _currentQuality = AudioQuality.offAir;
        _audioQualityController.add(_currentQuality);
      }
    } else {
      // Audio level is below noise threshold - this is silence
      _lowAudioStartTime ??= DateTime.now();
      
      final silenceDuration = DateTime.now().difference(_lowAudioStartTime!).inMilliseconds;
      
      if (silenceDuration >= offAirDetectionDuration && _currentQuality != AudioQuality.offAir) {
        _currentQuality = AudioQuality.offAir;
        _audioQualityController.add(_currentQuality);
      }
    }
  }

  void dispose() {
    stopMonitoring();
    _audioQualityController.close();
    _audioLevelController.close();
  }
}
