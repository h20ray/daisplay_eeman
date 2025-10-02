import 'package:quran_app/modules/radio_by_tujuhcahaya/config/radio_config.dart';
import 'package:quran_app/modules/radio_by_tujuhcahaya/domain/entities/radio_config.dart';

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
    _currentConfig = const RadioConfig(
      streamingUrl: RadioConfigValues.streamingUrl,
      title: RadioConfigValues.title,
      name: RadioConfigValues.name,
      nowPlayingStatus: RadioConfigValues.nowPlayingStatus,
      defaultStatus: RadioConfigValues.defaultStatus,
      imagePath: RadioConfigValues.imagePath,
    );
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
}
