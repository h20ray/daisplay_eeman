import 'package:equatable/equatable.dart';

class RadioStation extends Equatable {
  const RadioStation({
    required this.id,
    required this.title,
    required this.url,
    required this.imagePath,
    this.artist,
    this.track,
  });

  final String id;
  final String title;
  final String url;
  final String imagePath;
  final String? artist;
  final String? track;

  @override
  List<Object?> get props => [id, title, url, imagePath, artist, track];

  RadioStation copyWith({
    String? id,
    String? title,
    String? url,
    String? imagePath,
    String? artist,
    String? track,
  }) {
    return RadioStation(
      id: id ?? this.id,
      title: title ?? this.title,
      url: url ?? this.url,
      imagePath: imagePath ?? this.imagePath,
      artist: artist ?? this.artist,
      track: track ?? this.track,
    );
  }
}
