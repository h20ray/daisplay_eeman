import 'package:equatable/equatable.dart';
import 'package:quran_app/modules/radio_by_tujuhcahaya/domain/entities/radio_station.dart';

abstract class RadioState extends Equatable {
  const RadioState();

  @override
  List<Object?> get props => [];
}

class RadioInitial extends RadioState {
  const RadioInitial();
}

class RadioLoading extends RadioState {
  const RadioLoading();
}

class RadioLoaded extends RadioState {
  const RadioLoaded({
    required this.currentStation,
    required this.isPlaying,
    required this.volume,
    this.metadata,
    this.artwork,
  });

  final RadioStation? currentStation;
  final bool isPlaying;
  final double volume;
  final List<String>? metadata;
  final String? artwork;

  @override
  List<Object?> get props =>
      [currentStation, isPlaying, volume, metadata, artwork];

  RadioLoaded copyWith({
    RadioStation? currentStation,
    bool? isPlaying,
    double? volume,
    List<String>? metadata,
    String? artwork,
  }) {
    return RadioLoaded(
      currentStation: currentStation ?? this.currentStation,
      isPlaying: isPlaying ?? this.isPlaying,
      volume: volume ?? this.volume,
      metadata: metadata ?? this.metadata,
      artwork: artwork ?? this.artwork,
    );
  }
}

class RadioError extends RadioState {
  const RadioError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}
