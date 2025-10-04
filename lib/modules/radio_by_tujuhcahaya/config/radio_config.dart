// Radio Configuration
// Edit these values to customize your radio settings

class RadioConfigValues {
  // Radio streaming URL - Replace with your actual radio stream URL
  static const String streamingUrl = 'https://i.klikhost.com/8260/;radio.mp3';

  // Radio title - This appears in the floating toolbar
  static const String title = 'RADIO DAKWAH ISLAM 107.9 FM';

  // Radio name - This can be used for display purposes
  static const String name = 'RADIO DAKWAH ISLAM';

  // Status text when radio is playing
  static const String nowPlayingStatus = 'Anda Sedang mendengarkan';

  // Status text when radio is not playing
  static const String defaultStatus = 'Radio';

  // Path to radio logo/icon image
  static const String imagePath = 'assets/icons/ic_radio_logo.png';

  // Static notification title to display in system notification
  static const String notificationTitle = 'RADIO DAKWAH ISLAM - 107.9 FM';

  // Static notification subtitle/status to display in system notification
  static const String notificationSubtitle = 'Anda Sedang mendengarkan';

  // Whether to show stream metadata (artist/title) in system notification
  static const bool showMetadataInNotification = false;

  // UI Text Constants
  static const String radioStreamingSubtitle = 'Radio Streaming';
  static const String liveStatusText = 'LIVE';
  static const String stoppedStatusText = 'STOPPED';
  static const String offAirStatusText = 'OFF-AIR';
  static const String volumeLabelText = 'Volume';

  // Audio Detection Configuration
  static const double liveContentThreshold = -30; // dB threshold for actual live content (not noise)
  static const double noiseThreshold = -50; // dB threshold below which is considered noise/silence
  static const int audioAnalysisInterval = 3000; // milliseconds between analysis
  static const int offAirDetectionDuration = 10000; // milliseconds of noise before marking off-air
  
  // Auto-Resume Configuration
  static const bool autoResumeOnAppStart = true; // Whether to automatically resume radio when app starts
}

// Radio Configuration Entity
class RadioConfig {
  const RadioConfig({
    required this.streamingUrl,
    required this.title,
    required this.name,
    required this.nowPlayingStatus,
    required this.defaultStatus,
    required this.imagePath,
    required this.notificationTitle,
    required this.notificationSubtitle,
    required this.showMetadataInNotification,
    required this.radioStreamingSubtitle,
    required this.liveStatusText,
    required this.stoppedStatusText,
    required this.offAirStatusText,
    required this.volumeLabelText,
    required this.liveContentThreshold,
    required this.noiseThreshold,
    required this.audioAnalysisInterval,
    required this.offAirDetectionDuration,
    required this.autoResumeOnAppStart,
  });

  final String streamingUrl;
  final String title;
  final String name;
  final String nowPlayingStatus;
  final String defaultStatus;
  final String imagePath;
  final String notificationTitle;
  final String notificationSubtitle;
  final bool showMetadataInNotification;
  final String radioStreamingSubtitle;
  final String liveStatusText;
  final String stoppedStatusText;
  final String offAirStatusText;
  final String volumeLabelText;
  final double liveContentThreshold;
  final double noiseThreshold;
  final int audioAnalysisInterval;
  final int offAirDetectionDuration;
  final bool autoResumeOnAppStart;

  static const RadioConfig defaultConfig = RadioConfig(
    streamingUrl: RadioConfigValues.streamingUrl,
    title: RadioConfigValues.title,
    name: RadioConfigValues.name,
    nowPlayingStatus: RadioConfigValues.nowPlayingStatus,
    defaultStatus: RadioConfigValues.defaultStatus,
    imagePath: RadioConfigValues.imagePath,
    notificationTitle: RadioConfigValues.notificationTitle,
    notificationSubtitle: RadioConfigValues.notificationSubtitle,
    showMetadataInNotification: RadioConfigValues.showMetadataInNotification,
    radioStreamingSubtitle: RadioConfigValues.radioStreamingSubtitle,
    liveStatusText: RadioConfigValues.liveStatusText,
    stoppedStatusText: RadioConfigValues.stoppedStatusText,
    offAirStatusText: RadioConfigValues.offAirStatusText,
    volumeLabelText: RadioConfigValues.volumeLabelText,
    liveContentThreshold: RadioConfigValues.liveContentThreshold,
    noiseThreshold: RadioConfigValues.noiseThreshold,
    audioAnalysisInterval: RadioConfigValues.audioAnalysisInterval,
    offAirDetectionDuration: RadioConfigValues.offAirDetectionDuration,
    autoResumeOnAppStart: RadioConfigValues.autoResumeOnAppStart,
  );

  RadioConfig copyWith({
    String? streamingUrl,
    String? title,
    String? name,
    String? nowPlayingStatus,
    String? defaultStatus,
    String? imagePath,
    String? notificationTitle,
    String? notificationSubtitle,
    bool? showMetadataInNotification,
    String? radioStreamingSubtitle,
    String? liveStatusText,
    String? stoppedStatusText,
    String? offAirStatusText,
    String? volumeLabelText,
    double? liveContentThreshold,
    double? noiseThreshold,
    int? audioAnalysisInterval,
    int? offAirDetectionDuration,
    bool? autoResumeOnAppStart,
  }) {
    return RadioConfig(
      streamingUrl: streamingUrl ?? this.streamingUrl,
      title: title ?? this.title,
      name: name ?? this.name,
      nowPlayingStatus: nowPlayingStatus ?? this.nowPlayingStatus,
      defaultStatus: defaultStatus ?? this.defaultStatus,
      imagePath: imagePath ?? this.imagePath,
      notificationTitle: notificationTitle ?? this.notificationTitle,
      notificationSubtitle: notificationSubtitle ?? this.notificationSubtitle,
      showMetadataInNotification:
          showMetadataInNotification ?? this.showMetadataInNotification,
      radioStreamingSubtitle: radioStreamingSubtitle ?? this.radioStreamingSubtitle,
      liveStatusText: liveStatusText ?? this.liveStatusText,
      stoppedStatusText: stoppedStatusText ?? this.stoppedStatusText,
      offAirStatusText: offAirStatusText ?? this.offAirStatusText,
      volumeLabelText: volumeLabelText ?? this.volumeLabelText,
      liveContentThreshold: liveContentThreshold ?? this.liveContentThreshold,
      noiseThreshold: noiseThreshold ?? this.noiseThreshold,
      audioAnalysisInterval: audioAnalysisInterval ?? this.audioAnalysisInterval,
      offAirDetectionDuration: offAirDetectionDuration ?? this.offAirDetectionDuration,
      autoResumeOnAppStart: autoResumeOnAppStart ?? this.autoResumeOnAppStart,
    );
  }
}

// Radio Configuration Service
class RadioConfigService {
  RadioConfigService() {
    _loadConfig();
  }

  RadioConfig _currentConfig = RadioConfig.defaultConfig;

  RadioConfig get currentConfig => _currentConfig;

  void updateConfig(RadioConfig newConfig) {
    _currentConfig = newConfig;
    _saveConfig();
  }

  void _loadConfig() {
    // Load from the configuration file
    _currentConfig = RadioConfig.defaultConfig;
  }

  void _saveConfig() {
    // For now, do nothing
    // In a real app, you would save to SharedPreferences or similar
  }

  // Convenience methods for easy updates
  void updateStreamingUrl(String url) {
    _currentConfig = _currentConfig.copyWith(streamingUrl: url);
    _saveConfig();
  }

  void updateTitle(String title) {
    _currentConfig = _currentConfig.copyWith(title: title);
    _saveConfig();
  }

  void updateName(String name) {
    _currentConfig = _currentConfig.copyWith(name: name);
    _saveConfig();
  }

  void updateNowPlayingStatus(String status) {
    _currentConfig = _currentConfig.copyWith(nowPlayingStatus: status);
    _saveConfig();
  }

  void updateDefaultStatus(String status) {
    _currentConfig = _currentConfig.copyWith(defaultStatus: status);
    _saveConfig();
  }

  void updateImagePath(String imagePath) {
    _currentConfig = _currentConfig.copyWith(imagePath: imagePath);
    _saveConfig();
  }

  void updateNotificationTitle(String title) {
    _currentConfig = _currentConfig.copyWith(notificationTitle: title);
    _saveConfig();
  }

  void updateNotificationSubtitle(String subtitle) {
    _currentConfig = _currentConfig.copyWith(notificationSubtitle: subtitle);
    _saveConfig();
  }

  void updateShowMetadataInNotification({required bool show}) {
    _currentConfig = _currentConfig.copyWith(showMetadataInNotification: show);
    _saveConfig();
  }

  void updateRadioStreamingSubtitle(String subtitle) {
    _currentConfig = _currentConfig.copyWith(radioStreamingSubtitle: subtitle);
    _saveConfig();
  }

  void updateLiveStatusText(String text) {
    _currentConfig = _currentConfig.copyWith(liveStatusText: text);
    _saveConfig();
  }

  void updateStoppedStatusText(String text) {
    _currentConfig = _currentConfig.copyWith(stoppedStatusText: text);
    _saveConfig();
  }

  void updateVolumeLabelText(String text) {
    _currentConfig = _currentConfig.copyWith(volumeLabelText: text);
    _saveConfig();
  }

  void updateOffAirStatusText(String text) {
    _currentConfig = _currentConfig.copyWith(offAirStatusText: text);
    _saveConfig();
  }

  void updateLiveContentThreshold(double threshold) {
    _currentConfig = _currentConfig.copyWith(liveContentThreshold: threshold);
    _saveConfig();
  }

  void updateNoiseThreshold(double threshold) {
    _currentConfig = _currentConfig.copyWith(noiseThreshold: threshold);
    _saveConfig();
  }

  void updateAudioAnalysisInterval(int interval) {
    _currentConfig = _currentConfig.copyWith(audioAnalysisInterval: interval);
    _saveConfig();
  }

  void updateOffAirDetectionDuration(int duration) {
    _currentConfig = _currentConfig.copyWith(offAirDetectionDuration: duration);
    _saveConfig();
  }
}

// Instructions:
// 1. Replace 'streamingUrl' with your actual radio stream URL
// 2. Update 'title' to your radio station name
// 3. Update 'name' if you want a different display name
// 4. Customize status messages if needed
// 5. Update 'imagePath' to point to your radio logo
// 6. Update 'notificationTitle' and 'notificationSubtitle' for notification text
// 7. Toggle 'showMetadataInNotification' to control metadata in notification
// 8. Customize UI text: 'radioStreamingSubtitle', 'liveStatusText', 'stoppedStatusText', 'volumeLabelText'
// 9. Save the file and restart the app
