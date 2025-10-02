class RadioConfig {
  const RadioConfig({
    required this.streamingUrl,
    required this.title,
    required this.name,
    required this.nowPlayingStatus,
    required this.defaultStatus,
    required this.imagePath,
  });

  final String streamingUrl;
  final String title;
  final String name;
  final String nowPlayingStatus;
  final String defaultStatus;
  final String imagePath;

  static const RadioConfig defaultConfig = RadioConfig(
    streamingUrl: 'https://stream.zeno.fm/your-radio-stream-url',
    title: 'Radio Tujuh Cahaya',
    name: 'Tujuh Cahaya Radio',
    nowPlayingStatus: 'Now Playing',
    defaultStatus: 'Radio',
    imagePath: 'assets/icons/ic_radio_logo.png',
  );

  RadioConfig copyWith({
    String? streamingUrl,
    String? title,
    String? name,
    String? nowPlayingStatus,
    String? defaultStatus,
    String? imagePath,
  }) {
    return RadioConfig(
      streamingUrl: streamingUrl ?? this.streamingUrl,
      title: title ?? this.title,
      name: name ?? this.name,
      nowPlayingStatus: nowPlayingStatus ?? this.nowPlayingStatus,
      defaultStatus: defaultStatus ?? this.defaultStatus,
      imagePath: imagePath ?? this.imagePath,
    );
  }
}
